<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.lutongnet.iptv.util.HttpUtils"%>
<%@ include file="/config.jsp" %>
<%!

	/**
	*对字符串进行是否属于sql注入攻击验证
	*如果其包含sql关键字或参数包含其他不符合规则的就返回true
	*
	*/
	public boolean ifSqlInjection(String sourceStr){
		String checkRegex = ".|/|'|and|exec|insert|select|delete|update|count|*|%|chr|mid|master|truncate|char|declare|;|or|-|+|,";
		String[] regexs = checkRegex.split("\\|");
	        System.out.println("******待验证参数*******"+sourceStr);
        	for(int i=0;i<regexs.length;i++){
			if(sourceStr.indexOf(regexs[i])>-1){
				return true;
			}
		}
		
		return false;
		
	}


	/**
	 * JSP太垃圾了不支持提示，所以手工写一个syso方法
	 * @param obj 要输出的对象
	 */
	public void syso(Object obj)
	{
		System.out.println(obj);
	}

	/**
	 * 根据code获取Epg
	 * @param code EPGcode
	 */
	public Epg getEpg(String code)
	{
		GetEpgResponse resp = post
		(
			"epg/get", GetEpgResponse.class,
			"code", code,
			"appVersion", APP_VERSION
		);
		return resp.getEpg();
	}

	/**
	 * 获取节目单ID
	 * @param programCode 节目单code
	 * @param groupIdx 组索引
	 * @param metadataIdx 元数据索引
	 */
	public int getProgramId(String programCode,int groupIdx,int metadataIdx)
	{
		try
		{
			EpgMetadata program = getEpg(programCode).getGroups().get(groupIdx).getMetadatas().get(metadataIdx);
			return Integer.parseInt(program.getValue());
		}
		catch(Exception e)
		{
			e.printStackTrace();
			return -1;
		}
	}

	/**
	 * 获取节目单ID，groupIdx和metadataIdx都默认为0
	 * @param programCode 节目单code
	 */
	public int getProgramId(String programCode)
	{
		return getProgramId(programCode, 0, 0);
	}
	
	/**
	 * 根据当前页面计算得出相应的图片路径，要求按照指定规则存放图片
	 * 如果碰到特殊情况返回的图片路径不正确，可以手动重新指定图片路径
	 * 如根据：http://localhost/health-sd/column/mp/menu.jsp
	 * 得出：http://localhost/health-sd/resources/sd/column/mp/
	 * @param request
	 * @return
	 */
	public String getImagePath(HttpServletRequest request)
	{
		String url=request.getRequestURI();//即使是转发，获取的url也是真正的地址
		String regex="(?<="+request.getContextPath()+"/).+?(?=[^/]*\\.jsp$)";
		Matcher matcher=Pattern.compile(regex).matcher(url);
		if(matcher.find())
			return BASE_IMAGE_PATH + matcher.group();
		return BASE_IMAGE_PATH;
	}

	/**
	 * 根据当前页面计算得出当前页面类型(targetType)
	 * 如果碰到特殊情况返回的值不正确，可以手动重新指定targetType
	 * 如根据：http://localhost/health-sd/column/mp/menu.jsp
	 * 得出：column
	 * @param request
	 * @return
	 */
	public String getTargetType(HttpServletRequest request)
	{
		String url=request.getRequestURI();//即使是转发，获取的url也是真正的地址
		String regex="(?<="+request.getContextPath()+"/)[^/]+?(?=/.*$)";
		Matcher matcher=Pattern.compile(regex).matcher(url);
		if(matcher.find())
			return matcher.group();
		return "";
	}

	/**
	 * 根据总数和行数计算行和列，主要是因为EL表达式中不能整除
	 * @param max 总个数
	 * @param column_num 每一行的个数
	 */
	@Deprecated
	public Map<Integer,Map<String,Integer>> countRC(int max,int column_num)
	{
		Map<Integer,Map<String,Integer>> rc=new HashMap<Integer,Map<String,Integer>>();//rcs意味row_columns
		for(int i=0; i<max; i++)
		{
			Map<String,Integer> entity=new HashMap<String,Integer>();
			entity.put("r",i/column_num);
			entity.put("c",i%column_num);
			rc.put(i, entity);
		}
		return rc;
	}
	
	/**
	 * 给request批量设置attr
	 * @param request
	 * @param objs
	 */
	public void setAttr(HttpServletRequest request,Object... objs)
	{
		if(objs.length%2==1)//参数个数为奇数则直接返回
		{
			System.err.println("警告：setAttr方法参数个数不是偶数个！");
			return;
		}
		for(int i=0;i<objs.length;i+=2)
			request.setAttribute((String)objs[i], objs[i+1]);
	}
	
	/**
	 * 解析最简单的XML，如解析“<div>abc</div>”
	 * @param xml 需要解析的xml字符串
	 * @param node 节点名称
	 * @return
	 */
	public String parseSimpleXML(String xml, String node)
	{
		 return StringUtil.parseSimpleXML(xml, node);
	}
	 
	/**
	 * 获取参数，不存在返回默认值
	 */
	public String getParam(HttpServletRequest request, String paramName, String defaultValue)
	{
		return HttpUtil.getParam(request, paramName, defaultValue);
	}
	
	/**
	 * 获取参数
	 */
	public String getParam(HttpServletRequest request, String paramName)
	{
		return HttpUtil.getParam(request, paramName);
	}
	
	/**
	 * 从request中获取一个参数并强转int，不存在时返回默认值
	 */
	public int getParamInt(HttpServletRequest request, String name, Integer defaultValue)
	{
		return HttpUtil.getParamInt(request, name, defaultValue);
	}
	
	/**
	 * 从request中获取一个参数并强转int
	 */
	public int getParamInt(HttpServletRequest request, String name)
	{
		return HttpUtil.getParamInt(request, name);
	}
	
	/**
	 * 从request中获取一个参数并强转boolean，不存在时返回默认值
	 */
	public boolean getParamBoolean(HttpServletRequest request, String name, Boolean defaultValue)
	{
		return HttpUtil.getParamBoolean(request, name, defaultValue);
	}
	
	/**
	 * 从request中获取一个参数并强转boolean
	 */
	public boolean getParamBoolean(HttpServletRequest request, String name)
	{
		return HttpUtil.getParamBoolean(request, name);
	}
	
	/**
	 * 重定向，path放在最后面是为了兼容以前的代码
	 */
	public void redirect(HttpServletRequest request, HttpServletResponse response, String path)
	{
		HttpUtil.redirect(path, request, response);
	}
	
	/**
	 * 请求转发，path放在最后面是为了兼容以前的代码
	 */
	public void forward(HttpServletRequest request, HttpServletResponse response, String path)
	{
		HttpUtil.forward(path, request, response);
	}
	
	/**
	 * 判断一个字符串是否为空
	 * @param str
	 * @return
	 */
	public static boolean isEmpty(String str)
	{
		return StringUtil.isEmpty(str);
	}
	
	/**
	 * 判断一个字符串是否不为空
	 * @param str
	 * @return
	 */
	public static boolean notEmpty(String str)
	{
		return StringUtil.notEmpty(str);
	}
	
	/**
	 * URL编码，主要是处理中文
	 * @param str
	 * @return
	 */
	public String encode(String str)
	{
		return URLUtil.encode(str);
	}
	
	/**
	 * URL解码，主要是处理中文
	 * @param str
	 * @return
	 */
	public String decode(String str)
	{
		return URLUtil.decode(str);
	}
	
	/**
	 * 获取cookie
	 * @param request
	 * @param name
	 * @param defaultValue
	 * @return
	 */
	public Map<String, String> getCookie(HttpServletRequest request, String... names)
	{
		return CookieUtil.get(request, names);
	}
	
	/**
	 * 获取cookie
	 * @param request
	 * @param name
	 * @param defaultValue
	 * @return
	 */
	public String getCookie(HttpServletRequest request, String name, String defaultValue)
	{
		return CookieUtil.get(request, name, defaultValue);
	}
	
	/**
	 * 批量设置cookie
	 * @param request
	 * @param response
	 * @param days
	 * @param params
	 * @return
	 */
	public boolean setCookie(HttpServletRequest request,HttpServletResponse response,Integer days,String... params)
	{
		return CookieUtil.set(request, response, days, params);
	}
	
	/**
	 * 批量设置cookie，默认30天
	 * @param request
	 * @param response
	 * @param params
	 * @return
	 */
	public boolean setCookie(HttpServletRequest request,HttpServletResponse response,String... params)
	{
		return CookieUtil.set(request, response, params);
	}
	
	/**
	 * 批量删除Cookie
	 * @param response
	 * @param cookieName
	 * @return
	 */
	public static boolean delCookie(HttpServletRequest request, HttpServletResponse response, String... names)
	{
		return CookieUtil.del(request, response, names);
	}
	
	/**
	 * 获取backURI参数
	 * @param request
	 * @param response
	 */
	public String getBackURI(HttpServletRequest request,HttpServletResponse response)
	{
		String userId = getCookie(request, "userid", "");
		return HttpUtils.markURIList(request, API_URL, userId, "backURI");
	}
	
	/**
	 * 获取项目基路径
	 * @param request
	 */
	public String getBasePath(HttpServletRequest request)
	{
		return HttpUtil.getBasePath(request);
	}
	
	/**
	 * POST提交调用接口，可结合api-client一起使用
	 * @param url API地址，无须写地址前缀
	 * @param cls 返回JSON强转的类型
	 * @param params 参数数组，奇数位置写参数名，偶数位置写参数值
	 */
	public <T> T post(String url, Class<T> cls, Object... params)
	{
		if(!url.startsWith("http"))
			url = API_URL + url;
		return HttpUtil.postJson(url, cls, params);
	}
	
	/**
	 * 根据节目单code获取dataList，并且从中随机取出不重复的maxSize个数据
	 * @param programCode 节目单code，即栏目code
	 * @param maxSize 最多取出的个数，默认4个
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public List getRandomDataList(String programCode, Integer maxSize)
	{
		maxSize = maxSize==null?4:maxSize;
	 	GetProgramResponse resp = post
		(
			"program/get", GetProgramResponse.class,
			"id", getProgramId(programCode),
			"current", 1,
			"pageSize", 100
		);
	 	PaginationBean pb = resp.getPb();
		List tempList = pb.getDataList();
		//随机取4个不重复的专辑
		Random random = new Random();
		Map<Integer,Object> map = new LinkedHashMap();
		while(true)
		{
			int randomNum = random.nextInt(tempList.size());
			if(map.containsKey(randomNum))
				continue;
			map.put(randomNum, tempList.get(randomNum));
			if(map.size()>=maxSize||map.size()==tempList.size())//防止不足maxSize个时陷于死循环
				break;
		}
		List dataList = new ArrayList(map.values());
		return dataList;
	}
	
	/**
	 * 根据节目单code获取dataList，并且从中随机取出不重复的4个数据
	 * @param programCode 节目单code，即栏目code
	 */
	@SuppressWarnings({"rawtypes"})
	public List getRandomDataList(String programCode)
	{
		return getRandomDataList(programCode, null);
	}
	
	/**
	 * 根据账户ID获取城市code
	 * @param user_id
	 */
	public static String getCityCodeByUserId(String user_id)
	{
		for(int i=0; i<CITYS.length; i++)
			if(user_id.startsWith(CITYS[i][0]))
				return CITYS[i][1];
		return DEFAULT_CITY_CODE;
	}
	
	/**
	 * 根据城市code获取城市中文名
	 * @param cityCode 城市code
	 */
	public String getCityNameByCode(String cityCode)
	{
		for(int i=0; i<CITYS.length; i++)
			if(CITYS[i][1].equals(cityCode))
				return CITYS[i][2];
		return DEFAULT_CITY_NAME;
	}
	
	/**
	 * 获取用户属性编码
	 */
	public String getUserProp(HttpServletRequest request)
	{
		String userProp = getCookie(request, COOKIE_USER_PROP, "00000000000000000");//17位
		String orderType = getCookie(request, "orderType", "free");
		String orderTypeCode = "0";//0：未知，1：免费，2：包天，3：包月，4：包年
		if("free".equals(orderType))
			orderTypeCode = "1";
		else if("day".equals(orderType))
			orderTypeCode = "2";
		else if("month".equals(orderType))
			orderTypeCode = "3";
		else if("year".equals(orderType))
			orderTypeCode = "4";
		userProp += orderTypeCode;//18位：用户订购类型
		userProp += "02";//19-20位：用户群体类型，01:个人,02:家庭,03:健身房,04:酒店，目前统一为02
		userProp += "000000000000";//剩余的12位补充0
		return userProp;
	}
	
	/**
	 * 获取当前页面属性，共16位
	 * @param targetType 页面类型
	 * @param elementCode 元素编码，不同项目含义不同，具体参见文档
	 */
	public String getPageProp(String targetType, String elementCode)
	{
		String pageProp = "1";//第1位：表示页面层级拓扑，目前统一为1
		String targetTypeCode = "0";//页面类型code
		if("column".equals(targetType))
			targetTypeCode = "1";
		else if("column".equals(targetType))
			targetTypeCode = "1";
		else if("album".equals(targetType))
			targetTypeCode = "2";
		else if("activity".equals(targetType))
			targetTypeCode = "3";
		else if("game".equals(targetType))
			targetTypeCode = "4";
		else if("other".equals(targetType))
			targetTypeCode = "5";
		pageProp += targetTypeCode;//第2位：页面类型：0：未知，1：栏目column，2：专辑album，3：活动activity，4：游戏game，5：其它other
		if(isEmpty(elementCode))
			elementCode = "0000";
		pageProp += elementCode;//第3-6位：元素编码，具体元素编码定义请参见文档
		pageProp += "0000000000";//剩余10位用0填充
		return pageProp;
	}
	
	/**
	 * 获取当前页面属性，共16位
	 * @param targetType 页面类型
	 */
	public String getPageProp(String targetType)
	{
		return getPageProp(targetType, null);
	}
	
	/**
	 * 从session,cookie中获取user_id
	 * @param request
	 * @return
	 */
	public String getUserId(HttpServletRequest request,HttpServletResponse response)
	{
		String user_id=(String)request.getSession().getAttribute("user_id");
        if("".equals(user_id)||user_id==null){//session中取不到则去cookie里取
        	user_id=getCookie(request,COOKIE_USER_ID, "");
        }
        return user_id;
	}
  	
	/**
	 * 从cookie中获取角色名
	 * @param request
	 * @return
	 */
	public String getRoleName(HttpServletRequest request,HttpServletResponse response)
	{
		String role_name=(String)request.getSession().getAttribute("role_name");
        if("".equals(role_name)||role_name==null){//session中取不到则去cookie里取
        	role_name=getCookie(request,COOKIE_ROLE, ""); 
        }
        return role_name;
	}
	
	/**
	 * 从Cookie中获取订购类型
	 */
	public String getOrderType(HttpServletRequest request,HttpServletResponse response)
	{
		String order_type=(String)request.getSession().getAttribute("order_type");
        if("".equals(order_type)||order_type==null){//session中取不到则去cookie里取
        	order_type=getCookie(request,COOKIE_ORDER_TYPE, ""); 
        }
        return order_type;
	}
	
	/**
	 * 从Cookie中获取城市code
	 */
	public String getCityCode(HttpServletRequest request,HttpServletResponse response)
	{
		String city_code=(String)request.getSession().getAttribute("city_code");
        if("".equals(city_code)||city_code==null){//session中取不到则去cookie里取
        	city_code=getCookie(request,COOKIE_CITY_CODE, ""); 
        }
        return city_code;
	}
	
	public String getUserToken(HttpServletRequest request,HttpServletResponse response){
        String userToken=(String)request.getSession().getAttribute("userToken");
        if("".equals(userToken)||userToken==null){//session中取不到则去cookie里取
            userToken=getCookie(request,COOKIE_USER_TOKEN, "");
        }
        return userToken;
    }
	
%>
<%
	//漏洞脚本注入问题处理
	String queryString = request.getQueryString() + "&1=1";
	if(queryString.indexOf("script")>-1 || queryString.indexOf("iframe")>-1 || queryString.indexOf("gezqyc")>-1 || queryString.indexOf(".js?")>-1 || queryString.indexOf("*")>-1){
		response.sendRedirect(request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/com/600.jsp");
		return;
	}else if(queryString.indexOf(")")>-1 || queryString.indexOf("(")>-1 || queryString.indexOf(";")>-1 || queryString.indexOf("src")>-1 || queryString.indexOf("<img")>-1 || queryString.indexOf("ehlzba")>-1){
		response.sendRedirect(request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/com/600.jsp");
		return;
	}else if(queryString.indexOf("ping")>-1 || queryString.indexOf("www")>-1){
		response.sendRedirect(request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/com/600.jsp");
		return;
	}
%>
