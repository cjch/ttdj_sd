<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/com/common.jsp" %>
<%!
	
	//所有播放模式：
	//listCycleOnce：列表循环一次（顺序播放）
	//listCycleForever：列表永久循环（循环播放）
	//listRandomForever：列表永久随机（随机播放）
	//singleCycleForever：单曲循环（单集循环）
	//listRandomOnce：随机播放一遍
	//passive：被动结束
	//active：主动点播
	
	private static final String DEFAULT_MENU = BASE_PATH + "column/mp/menu.jsp";//默认菜单
	
	/** 添加视频到指定的播放器中 */
	public void addVideo(HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		MediaPlayerExecutor exec = new MediaPlayerExecutor(API_URL);
		MediaPlayerAddVideoRequest req = new MediaPlayerAddVideoRequest();
		UserStore store = new UserStore(request, response);
		String f = request.getParameter("f");													// 当前操作的焦点
		req.setUserid(store.getUserid());														// 用户业务账号
		req.setRole(store.getRole());															// 用户当前角色
		req.setCode(request.getParameter("code"));												// CP视频编号
		req.setIntegralStrategy(request.getParameter("integralStrategy"));						// 积分音乐币策略
		req.setSource(HttpUtils.getString(request, "source", ""));								// 点播来源，只统计大栏目的关键字，子栏目也用大栏目的关键字来统计
		req.setSourceType(HttpUtils.getString(request, "sourceType", ""));						// 点播来源类型，如栏目、专辑、活动、游戏等
		req.setPagePropSrc(HttpUtils.getString(request, "pagePropSrc", "0000000000000000"));	// 来源页面属性，比如推荐位、小视屏等
		req.setPageProp(HttpUtils.getString(request, "pageProp", "0000000000000000"));			// 当前页面属性
		req.setUserProp(HttpUtils.getString(request, "userProp", "0000000000000000"));			// 用户属性	
		
		req.setMetadataType(HttpUtils.getString(request, "metadataType", ""));								// 点播的歌曲所属元数据类型，如节目单、小视频、推荐位等
		String mp = HttpUtils.getString(request, "mp", "default");
		req.setMp(mp);																			// 播放器标识，播放器区分用户及其角色
		boolean andPlay = HttpUtils.getBoolean(request, "andPlay", false);
		req.setAndPlay(andPlay);																// 是否添加并播放
		req.setCharge(HttpUtils.getBoolean(request, "charge", true));							// 是否收费，默认为收费
		req.setDolog(HttpUtils.getBoolean(request, "dolog", true));								// 是否保存点播日志，默认保存
		req.setCachable(HttpUtils.getBoolean(request, "cachable", true));						// 是否缓存点播日志，默认缓存
		req.setSearchLogId(HttpUtils.getInt(request, "searchLogId", -1));					 	// 如果该歌曲是通过搜索找到的，指定此次搜索记录的ID
		req.setDisplay(HttpUtils.getString(request, "display", "fullscreen"));					// 播放器显示模式，默认为全屏
		req.setMode(HttpUtils.getString(request, "mode", "listCycleOnce"));						// 播放器播放模式，默认为列表顺序播放一次
		req.setMenu(HttpUtils.getString(request, "menu", DEFAULT_MENU)); 						// 全屏播放时加载的菜单，默认使用默认的菜单
		String display = HttpUtils.getString(request, "display", "fullscreen");
		req.setMenu(HttpUtils.getString(request, "menu", "fullscreen".equals(display)?DEFAULT_MENU:""));
		req.setLeft(request.getParameter("left"));												// 播放器距离屏幕左边大小
		req.setTop(request.getParameter("top"));												// 播放器距离屏幕右边大小
		req.setWidth(request.getParameter("width"));											// 播放器宽度
		req.setHeight(request.getParameter("height"));											// 播放器高度
		
		
		System.out.println("ABCD:"+mp);
		MediaPlayerAddVideoResponse rsp = exec.addVideo(req);
		if(andPlay)// 添加并播放
		{
			if("fullscreen".equals(req.getDisplay())){
				String playEndURI = request.getParameter("returnURI");
				if(StringUtils.isEmpty(playEndURI))
					playEndURI = HttpUtils.getMarkedURI(request, response, "returnURI", "f="+f);
				HttpUtils.setPlayEndURI(request, response, playEndURI);
			}
			redirect(request, response, "/media_player.jsp?method=play&mp="+mp+"&addAccessLog="+HttpUtils.getBoolean(request, "addAccessLog", false));
		}
		else// 只添加不播放
		{
			String returnURI = request.getParameter("returnURI");									// 如果需要，可以显式的传进返回地址
			String info = URLEncoder.encode(rsp.getText(), "utf-8");
			if(StringUtils.isNotEmpty(returnURI))
				returnURI = returnURI + "&info=" + info;
			else																				// 使用已经保存的返回地址	
				returnURI = HttpUtils.getMarkedURI(request, response, "returnURI", "f="+f, "info="+info);
			redirect(request, response, returnURI);
		}
	}
	
	
	
	
	
	/** 获取MP的key值 */
	private String getMPKey(HttpServletRequest request, HttpServletResponse response,String mp)
	{
		UserStore store = new UserStore(request, response);
		return "MP:" + store.getUserid() + ":" + store.getRole() + ":" + mp;
	}
	
	/** 从缓存中获取MP */
	private Map<String, String> getMP(String key)
	{
		MemoryStore memoryStore = new MemoryStore(API_URL);
		String json = memoryStore.get(key);
		if(json==null)
			return new HashMap<String, String>();
		else
			return JsonUtils.fromString(json, new TypeReference<Map<String,String>>(){});
	}
	
	/** 保存MP到缓存中去 */
	private void saveMP(String key, Map<String, String> cache)
	{
		new MemoryStore(API_URL).set(key, JsonUtils.toString(cache),1,TimeUnit.DAY);
	}
	
	/** 清除缓存中的MP，一般不需要调用本方法，测试用的  */
	private void clearMP(HttpServletRequest request, HttpServletResponse response,String mp)
	{
		new MemoryStore(API_URL).delete(getMPKey(request, response, mp));
	}
	
	/** 播放剧集，注意本方法暂不支持小视频方式播放 */
	public void playFromSeries(HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		String mp = "series";
		String key = getMPKey(request, response, mp);
		Map<String, String> cache = getMP(key);
		
		String idx = HttpUtils.getString(request, "idx", "");//集数
		String seriesCode = HttpUtils.getString(request, "seriesCode", "");//剧集code
		
		if(idx==null || "".equals(idx))//如果没有传idx，默认播放上次播放时的集数，上次没有记录则播放第 1 集
		{
			//获取观看记录，一来是获取上次观看的集数，二来是获取专辑的相关信息
			UserStore store = new UserStore(request, response);
			GetWatchRecordRequest req2 = new GetWatchRecordRequest();
			req2.setIsCalMark("no");
			req2.setUserid(store.getUserid());
			req2.setRole(store.getRole());
			req2.setSeriesCode(seriesCode);
			GetWatchRecordResponse watchRecord = new WatchRecordExecutor(API_URL).getWatchRecord(req2);
			if(watchRecord.getVideoCode()==null)//如果上次没有观看记录，默认第1集
				idx = "1";
			else
				idx = watchRecord.getPosition()+"";
		}
		cache.put("seriesCode", seriesCode);//剧集code
		cache.put("idx", idx);//集数
		cache.put("mode", HttpUtils.getString(request, "mode", "listCycleOnce"));//播放模式，默认顺序播放
		cache.put("menu", HttpUtils.getString(request, "menu", DEFAULT_MENU));//菜单
		cache.put("display", HttpUtils.getString(request, "display", "fullscreen"));//显示方式
		cache.put("dolog", HttpUtils.getString(request, "dolog", "true"));
		cache.put("cachable", HttpUtils.getString(request, "cachable", "true"));
		cache.put("metadataType", HttpUtils.getString(request, "metadataType", ""));
		cache.put("source", HttpUtils.getString(request, "source", ""));
		String sourceType = getParam(request, "sourceType", "");
		cache.put("sourceType", sourceType);
		cache.put("searchLogId",HttpUtils.getString(request, "searchLogId", "-1"));	
		
		saveMP(key, cache);
		
		String playEndURI = request.getParameter("returnURI");
		if(StringUtils.isNotEmpty(playEndURI))
			HttpUtils.setPlayEndURI(request, response, playEndURI);
		
		redirect(request, response, "/media_player.jsp?method=playSeriesVideo&mp="+mp+"&addAccessLog="+HttpUtils.getBoolean(request, "addAccessLog", false));
	}
	
	/** 播放专辑中的某一集视频 */
	public void playSeriesVideo(HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		String mp = "series";
		String method = HttpUtils.getString(request, "method", "");
		String key = getMPKey(request, response, mp);
		Map<String, String> cache = getMP(key);
		int idx = HttpUtils.getInt(request, "idx", Integer.parseInt(cache.get("idx")));
		int totalNum = 0;//总集数
		if(cache.get("totalNum")!=null)//如果缓存里面有总集数，取出来
			totalNum=Integer.parseInt(cache.get("totalNum"));
		String mode = cache.get("mode");//播放模式
		if("play".equals(method)||"playPrev".equals(method))//如果是上一集或者下一集
		{
			int _idx=idx;
			if("play".equals(method))
				idx++;
			else
				idx--;
			if("listCycleOnce".equals(mode))//顺序播放，不采取任何措施
			{
				
			}
			else if("listCycleForever".equals(mode))//专辑循环
			{
				if(idx>totalNum)
					idx=1;
				else if(idx<1)
					idx=totalNum;
			}
			else if("listRandomForever".equals(mode))//随机播放
			{
				idx=new Random().nextInt(totalNum)+1;
			}
			else if("singleCycleForever".equals(mode))//单集循环
			{
				idx=_idx;
			}
			if(idx<1||idx>totalNum)//专辑播放结束
			{
				UpdateLastVodLogRequest req = new UpdateLastVodLogRequest();
				UserStore store = new UserStore(request, response);
				req.setUserid(store.getUserid());
				LogExecutor exec = new LogExecutor(API_URL);
				exec.updateLastVodLog(req);
				if("passive".equals(request.getParameter("vodMode")))// 被动切视频，没有视频了，跳到推荐界面
					redirect(request, response, "/com/play_end_recommend.jsp");
				else // 主动切视频，没有视频了，退出播放界面
					redirect(request, response, "/com/play_end_handler.jsp");
				return;
			}
		}
		GetCodeByPositionRequest req = new GetCodeByPositionRequest();
		req.setSeriesCode(cache.get("seriesCode"));//专辑code
		req.setPosition(idx);//集数
		req.setAppVersion(APP_VERSION);
		req.setPlatform(PLATFORM);
		req.setFormat(FORMAT);
		req.setFlag("playPrev".equals(method)?"prev":"next");//如果没有找到指定集数，朝哪个方向找
		VideoExecutor exe = new VideoExecutor(API_URL);
		GetCodeByPositionResponse resp = exe.getCodeByPosition(req);
		
		if(resp.getTotalNum()==0)//总集数为0，说明专辑code无效！
		{
			redirect(request, response, HttpUtils.getPlayEndURI(request, response)+"&info="+encode("专辑code无效："+cache.get("seriesCode")));
			return;
		}
		cache.put("idx", resp.getPosition()+"");//注意这里不能用idx，因为返回的集数可能与请求的集数不相同
		cache.put("totalNum", resp.getTotalNum()+"");//总集数
		saveMP(key, cache);
		
		/*****************手工拼装MediaPlayer对象开始**************************/
		MediaPlayer player = new MediaPlayer();
		MediaPlayerVideo current = new MediaPlayerVideo();
		current.setCode(resp.getVideoCode());
		current.setName(resp.getVideoName());
		current.setMetadataType(cache.get("metadataType"));
		current.setSource(cache.get("source"));
		current.setSourceType(cache.get("sourceType"));
		current.setSearchLogId(Integer.parseInt(cache.get("searchLogId")));
		current.setCharge(true);//临时代码
		
		player.setCurrent(current);
		player.setMode(cache.get("mode"));
		player.setMenu(cache.get("menu"));
		player.setDisplay(cache.get("display"));
		/*****************手工拼装MediaPlayer对象结束**************************/
		
		
		boolean charge = current.isCharge();//是否收费
		boolean canVod = true;//是否能够点播
		String orderType = getOrderType(request,response);
		
		if(charge && !"month".equals(orderType) ) {
			canVod = false;
			
			String path = request.getContextPath();
			String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
			String currentPage = request.getServletPath();//那个页面
			String queryStr = request.getQueryString();
			String orderTargetUrl = basePath + currentPage.substring(1) + "?" + queryStr;//订购时的目标地址
			String orderBackUrl=HttpUtils.getPlayEndURI(request, response);
			request.getSession().setAttribute("orderTargetUrl", orderTargetUrl);//订购成功返回播放
			request.getSession().setAttribute("orderBackUrl", orderBackUrl);
			
			String orderUrl = BASE_PATH+"column/order/order.jsp?code="+resp.getVideoCode()+"&source="+cache.get("source")+"&sourceType="+cache.get("sourceType")+"&pagePropSrc="+cache.get("pagePropSrc")+"&addAccessLog=true";
			
			redirect(request, response, orderUrl);
			return;
		}
		
		/*****************添加点播日志开始**************************/
		UserStore store = new UserStore(request,response);
		if("true".equals(cache.get("dolog")))//添加点播日志
		{
			AddVodLogRequest req2 = new AddVodLogRequest();
			String metadata_type = current.getMetadataType();
			String source = current.getSource();
			String source_type = current.getSourceType();
			if(isEmpty(metadata_type)){
				metadata_type = "series";
			}
			if(isEmpty(source)){
				source = "game_home";
			}
			if(isEmpty(source_type)){
				source_type = "column";
			}
			
			req2.setCachable(Boolean.parseBoolean(cache.get("cachable")));
			req2.setVodMode(HttpUtils.getString(request, "vodMode", "active"));//主动播放
			req2.setCode(current.getCode());
			//req2.setIntegralStrategy(current.getIs());//积分策略，没用的东西
			req2.setMetadataType(metadata_type);
			req2.setSource(source);
			req2.setSourceType(source_type);
			req2.setSearchLogId(current.getSearchLogId());
			
			//req2.setSearchLogId(-1);
			req2.setCarrier(CARRIER);
			req2.setAppVersion(APP_VERSION);
			req2.setPlatform(PLATFORM);
			req2.setUserid(store.getUserid());
			req2.setRole(store.getRole());
			req2.setCity(store.getCity());
			req2.setOrderType(store.getOrderType());
			req2.setEntry(getCookie(request,"entry",""));	//入口字段
			
			new LogExecutor(API_URL).addVodLog(req2);
		}
		/*****************添加点播日志结束**************************/
		
		/***********************自动保存观看记录开始***************************/
		AddWatchRecordRequest req3 = new AddWatchRecordRequest();
		req3.setUserid(store.getUserid());
		req3.setRole(store.getRole());
		req3.setSeriesCode(cache.get("seriesCode"));
		req3.setPosition(Integer.parseInt(cache.get("idx")));
		req3.setVideoCode(resp.getVideoCode());
		req3.setIsCalMark("no");
		new WatchRecordExecutor(API_URL).addWatchRecord(req3);
		/***********************自动保存观看记录结束***************************/
		
		
		request.setAttribute("rtsp", resp.getPlayurl());//播放地址
		request.setAttribute("canVod", canVod);
		request.setAttribute("mp", player);//MediaPlayer对象
		request.setAttribute("MP", JsonUtils.toString(player));//MediaPlayer对象转json
		request.setAttribute("idx", idx);//当前页
		request.setAttribute("total", cache.get("totalNum"));//总集数
		request.setAttribute("seriesCode", cache.get("seriesCode"));//剧集code
		HttpUtils.forward(request, response, "/play.jsp?addAccessLog="+HttpUtils.getBoolean(request, "addAccessLog", false));
	}
	
	/** 播放节目单或小视频 */
	public void playFromProgram(HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		
		System.out.println("ABCD: "+request.getQueryString());
		UserStore store = new UserStore(request, response);
		MediaPlayerExecutor exec = new MediaPlayerExecutor(API_URL);
		MediaPlayerPlayFromProgramRequest req = new MediaPlayerPlayFromProgramRequest();

		req.setCode(HttpUtils.getString(request, "code", ""));
		
		req.setDolog(HttpUtils.getBoolean(request, "dolog", true));
		req.setCachable(HttpUtils.getBoolean(request, "cachable", true));
		req.setEnablePrevNext(HttpUtils.getBoolean(request, "enablePrevNext", false));
		String display = HttpUtils.getString(request, "display", "fullscreen");
		req.setDisplay(HttpUtils.getString(request, "display", "fullscreen"));
		req.setWidth(request.getParameter("width"));
		req.setHeight(request.getParameter("height"));
		req.setLeft(request.getParameter("left"));
		req.setTop(request.getParameter("top"));
		req.setIntegralStrategy(request.getParameter("integralStrategy"));
		//全屏播放时采用默认menu，小视频播放时默认不使用menu
		req.setMenu(HttpUtils.getString(request, "menu", "fullscreen".equals(display)?DEFAULT_MENU:""));
		req.setSource(request.getParameter("source"));
		String sourceType = getParam(request, "sourceType", "");
		req.setSourceType(sourceType);
		req.setMetadataType(request.getParameter("metadataType"));
		
		req.setMode(HttpUtils.getString(request, "mode", "listCycleOnce"));
		req.setMp(HttpUtils.getString(request, "mp", "default"));
		
		//req.setProgramId(HttpUtils.getInt(request, "programId", -1));
		req.setProgramId(HttpUtils.getInt(request, "mp", -1));
		req.setRole(store.getRole());
		req.setUserid(store.getUserid());
		MediaPlayerPlayResponse rsp = exec.playFromProgram(req);
		String playEndURI = request.getParameter("returnURI");
		if(StringUtils.isNotEmpty(playEndURI))
			HttpUtils.setPlayEndURI(request, response, playEndURI);
		postProcess(request, response, rsp);
	}


	/** 播放收藏的歌曲 */
	public void playFromFavorites(HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		UserStore store = new UserStore(request, response);
		MediaPlayerExecutor exec = new MediaPlayerExecutor(API_URL);
		MediaPlayerPlayFromFavoritesRequest req = new MediaPlayerPlayFromFavoritesRequest();
		req.setDolog(HttpUtils.getBoolean(request, "dolog", true));
		req.setCachable(HttpUtils.getBoolean(request, "cachable", true));
		req.setEnablePrevNext(HttpUtils.getBoolean(request, "enablePrevNext", false));
		req.setDisplay(HttpUtils.getString(request, "display", "fullscreen"));
		req.setWidth(request.getParameter("width"));
		req.setHeight(request.getParameter("height"));
		req.setLeft(request.getParameter("left"));
		req.setTop(request.getParameter("top"));
		req.setIntegralStrategy(request.getParameter("integralStrategy"));
		req.setMenu(HttpUtils.getString(request, "menu", DEFAULT_MENU));
		req.setSource("favorites");
		req.setSourceType("column");
		req.setMetadataType("program");
		req.setMode(HttpUtils.getString(request, "mode", "listCycleOnce"));//循环播放
		req.setMp(HttpUtils.getString(request, "mp", "default"));
		req.setLimit(HttpUtils.getInt(request, "limit", 100)); 		// 默认播放前100首s
		req.setRole(store.getRole());
		req.setUserid(store.getUserid());
		req.setAppVersion(APP_VERSION);
		req.setPlatform(PLATFORM);
		req.setFormat(FORMAT);
		MediaPlayerPlayResponse rsp = exec.playFromFavorites(req);
		String playEndURI = request.getParameter("returnURI");
		if(StringUtils.isNotEmpty(playEndURI))
			HttpUtils.setPlayEndURI(request, response, playEndURI);
		postProcess(request, response, rsp);
	}
	
	/** 从播放器中删除视频 */
	public void removeVideo(HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		MediaPlayerExecutor exec = new MediaPlayerExecutor(API_URL);
		MediaPlayerRemoveVideoRequest req = new MediaPlayerRemoveVideoRequest();
		UserStore store = new UserStore(request, response);
		String f = request.getParameter("f");
		req.setUserid(store.getUserid());
		req.setRole(store.getRole());
		req.setMp(HttpUtils.getString(request, "mp", "default"));
		req.setCode(request.getParameter("code"));
		MediaPlayerRemoveVideoResponse rsp = exec.removeVideo(req);
		String info = URLEncoder.encode(rsp.getText(), "utf-8");
		String returnURI = HttpUtils.getMarkedURI(request, response, "returnURI", "f="+f, "info="+info);
		redirect(request, response, returnURI);
	}

	/** 清空播放器 */
	public void clear(HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		MediaPlayerExecutor exec = new MediaPlayerExecutor(API_URL);
		ClearMediaPlayerRequest req = new ClearMediaPlayerRequest();
		UserStore store = new UserStore(request, response);
		String f = request.getParameter("f");
		req.setUserid(store.getUserid());
		req.setRole(store.getRole());
		req.setMp(HttpUtils.getString(request, "mp", "default"));
		exec.clear(req);
		String returnURI = HttpUtils.getMarkedURI(request, response, "returnURI", "f="+f);
		redirect(request, response, returnURI);
	}


	/** 添加收藏 */
	public void fav(HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		FavoritesExecutor exec = new FavoritesExecutor(API_URL);
		AddFavoritesRequest req = new AddFavoritesRequest();
		UserStore store = new UserStore(request, response);
		String f = request.getParameter("f");
		req.setAppVersion(APP_VERSION);
		req.setRole(store.getRole());
		req.setUserid(store.getUserid());
		req.setOrderType(store.getOrderType());
		req.setValue(request.getParameter("value"));
		req.setType(request.getParameter("type"));
		AddFavoritesResponse rsp = exec.add(req);
		String returnURI = request.getParameter("returnURI");
		String info = URLEncoder.encode(rsp.getText(), "utf-8");
		if(StringUtils.isNotEmpty(returnURI))
			returnURI = returnURI + "&info=" + info;
		else	// 使用已经保存的返回地址
			returnURI = HttpUtils.getMarkedURI(request, response, "returnURI", "f="+f, "info="+info);
		redirect(request, response, returnURI);
	}


	/** 删除收藏 */
	public void removeFav(HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		FavoritesExecutor exec = new FavoritesExecutor(API_URL);
		RemoveFavoritesRequest req = new RemoveFavoritesRequest();
		UserStore store = new UserStore(request, response);
		String f = request.getParameter("f");
		req.setAppVersion(APP_VERSION);
		req.setRole(store.getRole());
		req.setUserid(store.getUserid());
		req.setType(request.getParameter("type"));
		req.setValue(request.getParameter("value"));
		RemoveFavoritesResponse rsp = exec.remove(req);
		String returnURI = request.getParameter("returnURI");
		String info = URLEncoder.encode(rsp.getText(), "utf-8");
		if(StringUtils.isNotEmpty(returnURI))
			returnURI = returnURI + "&info=" + info;
		else	// 使用已经保存的返回地址	
			returnURI = HttpUtils.getMarkedURI(request, response, "returnURI", "f="+f, "info="+info);
		redirect(request, response, returnURI);
	}

	/** 播放已点视频 */
	public void playFromVideoList(HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		String playEndURI = request.getParameter("returnURI");
		String f = request.getParameter("f");
		String mp = HttpUtils.getString(request, "mp", "default");
		if(StringUtils.isEmpty(playEndURI))
			playEndURI = HttpUtils.getMarkedURI(request, response, "returnURI", "f="+f);
		HttpUtils.setPlayEndURI(request, response, playEndURI);
		redirect(request, response, "/media_player.jsp?method=play&mp="+mp);
	}

	/** 改变播放模式 */
	public void changeMode(HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		UserStore store = new UserStore(request, response);
		MediaPlayerExecutor exec = new MediaPlayerExecutor(API_URL);
		MediaPlayerChangeModeRequest req = new MediaPlayerChangeModeRequest();
		req.setMode(request.getParameter("mode"));
		req.setMp(request.getParameter("mp"));
		req.setUserid(store.getUserid());
		req.setRole(store.getRole());
		exec.changeMode(req);
		redirect(request, response, request.getParameter("returnURI"));
	}


	/** 重播 */
	public void replay(HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		MediaPlayerExecutor exec = new MediaPlayerExecutor(API_URL);
		MediaPlayerPlayRequest req = new MediaPlayerPlayRequest();
		UserStore store = new UserStore(request, response);
		req.setUserid(store.getUserid());
		req.setRole(store.getRole());
		req.setMp(request.getParameter("mp"));
		MediaPlayerPlayResponse rsp = exec.replay(req);
		postProcess(request, response, rsp);
	}

	/** 播放歌曲 */
	public void play(HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		String mp = HttpUtils.getString(request, "mp", "");
		System.out.println("ABCD:4"+mp);
		if("series".equals(mp))
		{
			playSeriesVideo(request, response);
			return;
		}
		MediaPlayerExecutor exec = new MediaPlayerExecutor(API_URL);
		MediaPlayerPlayRequest req = new MediaPlayerPlayRequest();
		UserStore store = new UserStore(request, response);
		req.setUserid(store.getUserid());
		req.setRole(store.getRole());
		req.setMp(mp);
		System.out.println("ABCD:"+mp);
		MediaPlayerPlayResponse rsp = exec.play(req);
		postProcess(request, response, rsp);
	}

	/** 播放上一首 */
	public void playPrev(HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		String mp = HttpUtils.getString(request, "mp", "");
		if("series".equals(mp))
		{
			playSeriesVideo(request, response);
			return;
		}
		UserStore store = new UserStore(request, response);
		MediaPlayerExecutor exec = new MediaPlayerExecutor(API_URL);
		MediaPlayerPlayRequest req = new MediaPlayerPlayRequest();
		req.setMp(mp);
		req.setRole(store.getRole());
		req.setUserid(store.getUserid());
		MediaPlayerPlayResponse rsp = exec.playPrev(req);
		postProcess(request, response, rsp);
	}


	/** 播放后处理 */
	public void postProcess(HttpServletRequest request, HttpServletResponse response, MediaPlayerPlayResponse playRsp) throws Exception
	{
		if(playRsp.getCode()==1)//播放器中没有视频了
		{
			UpdateLastVodLogRequest req = new UpdateLastVodLogRequest();
			UserStore store = new UserStore(request, response);
			req.setUserid(store.getUserid());
			LogExecutor exec = new LogExecutor(API_URL);
			exec.updateLastVodLog(req);
			if("passive".equals(request.getParameter("vodMode")))// 被动切视频，没有视频了，跳到推荐界面
				redirect(request, response, "/com/play_end_recommend.jsp");
			else // 主动切视频，没有视频了，退出播放界面
				redirect(request, response, "/com/play_end_handler.jsp");
		}
		else
		{
			// 开始播放
			MediaPlayer mp = playRsp.getMp();
			MediaPlayerVideo current = mp.getCurrent();
			UserStore store = new UserStore(request, response);
			MediaPlayerExecutor exec = new MediaPlayerExecutor(API_URL);
			GetPlayurlRequest req = new GetPlayurlRequest();
			req.setAppVersion(APP_VERSION);
			req.setPlatform(PLATFORM);
			req.setFormat(FORMAT);
			req.setCode(current.getCode());
			GetPlayurlResponse rsp = null;
			if("test".equals(current.getSource()))
			{
				rsp = exec.getPlayurlForTest(req);
				String rtsp = rsp.getPlayurl();
				request.setAttribute("rtsp", rtsp);
			}
			else
			{
				rsp = exec.getPlayurl(req);
				String rtsp = rsp.getPlayurl();
				request.setAttribute("rtsp", rtsp);
				//if(rtsp==null)//播放地址无效，跳转至视频下线页面
				//{
				//	redirect(request, response, "/com/video_offline.jsp");
				//	return;
				//}
			}
			
			//boolean charge = current.isCharge();//是否收费
			//修改小视频全屏时不能弹订购
			boolean charge = true;
			boolean canVod = true;
			String orderType = getOrderType(request,response);
			String display = mp.getDisplay();
			if("smallvod".equals(display)){
				charge = false;
			}
			
			if(charge && !"month".equals(orderType)){
				canVod = false;
				
				String path = request.getContextPath();
				String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
				String currentPage = request.getServletPath();//那个页面
				String queryStr = request.getQueryString();
				String orderTargetUrl = basePath + currentPage.substring(1) + "?" + queryStr;//订购时的目标地址
				String orderBackUrl=HttpUtils.getPlayEndURI(request, response);
				request.getSession().setAttribute("orderTargetUrl", orderTargetUrl);//订购成功返回播放
				request.getSession().setAttribute("orderBackUrl", orderBackUrl);
				
				String orderUrl = BASE_PATH+"column/order/order.jsp?code="+current.getCode()+"&source="+current.getSource()+"&sourceType="+current.getSourceType()+"&pagePropSrc="+current.getPagePropSrc()+"&addAccessLog=true";
				redirect(request, response, orderUrl);
				return;
			}
			
			if(mp.isDolog()||"smallvod".equals(display))//添加点播日志
			{
				AddVodLogRequest req2 = new AddVodLogRequest();
				String metadata_type = current.getMetadataType();
				String source = current.getSource();
				String source_type = current.getSourceType();
				if(isEmpty(metadata_type)){
					metadata_type = "series";
				}
				if(isEmpty(source)){
					source = "game_home";
				}
				if(isEmpty(source_type)){
					source_type = "column";
				}
				
				req2.setCachable(mp.isCachable());
				req2.setVodMode(HttpUtils.getString(request, "vodMode", "active"));//主动播放
				req2.setCode(current.getCode());
				req2.setIntegralStrategy(current.getIs());
				req2.setMetadataType(metadata_type);
				req2.setSource(source);
				req2.setSourceType(source_type);
				
				req2.setSearchLogId(current.getSearchLogId());
				req2.setCarrier(CARRIER);
				req2.setAppVersion(APP_VERSION);
				req2.setPlatform(PLATFORM);
				req2.setUserid(store.getUserid());
				req2.setRole(store.getRole());
				req2.setCity(store.getCity());
				req2.setOrderType(store.getOrderType());
				req2.setEntry(getCookie(request,"entry",""));	//入口字段
				LogExecutor exec2 = new LogExecutor(API_URL);
				exec2.addVodLog(req2);
			}
			
			request.setAttribute("canVod", canVod);
			request.setAttribute("mp", mp);
			request.setAttribute("MP", JsonUtils.toString(mp));
			HttpUtils.forward(request, response, "/play.jsp?addAccessLog="+HttpUtils.getBoolean(request, "addAccessLog", false));
		}
	}

%>

<%
	String method = request.getParameter("method");
	if("addVideo".equals(method))
		addVideo(request, response);
	else if("removeVideo".equals(method))
		removeVideo(request, response);
	else if("clear".equals(method))
		clear(request, response);
	else if("fav".equals(method))
		fav(request, response);
	else if("removeFav".equals(method))
		removeFav(request, response);
	else if("playFromVideoList".equals(method))
		playFromVideoList(request, response);
	else if("changeMode".equals(method))
		changeMode(request, response);
	else if("replay".equals(method))
		replay(request, response);
	else if("play".equals(method))
		play(request, response);
	else if("playPrev".equals(method))
		playPrev(request, response);
	else if("playFromProgram".equals(method))
		playFromProgram(request, response);
	else if("playFromFavorites".equals(method))
		playFromFavorites(request, response);
	else if("playFromSeries".equals(method))
		playFromSeries(request, response);
	else if("playSeriesVideo".equals(method))
		playSeriesVideo(request, response);
%>