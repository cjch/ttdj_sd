<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/config.jsp" %>
<%!
	public void playAll(HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		MediaPlayerExecutor exec = new MediaPlayerExecutor(API_URL);
		MediaPlayerAddVideoRequest req = null;
		MediaPlayerAddVideoResponse rsp = null;
		UserStore store = new UserStore(request, response);
		String source = request.getParameter("source");
		String returnURI = request.getParameter("returnURI");
		String[] codes = request.getParameter("codes").split(",");
		
		for(int i=0; i<codes.length; ++i)
		{
			req = new MediaPlayerAddVideoRequest();
			req.setUserid(store.getUserid());
			req.setRole(store.getRole());
			req.setCode(codes[i]);					
			req.setSource(source);
			req.setSourceType("album");
			req.setMetadataType("program");
			req.setMp(source);
			req.setAndPlay(false);
			req.setCharge(true);
			req.setDolog(true);
			req.setCachable(true);
			req.setSearchLogId(-1);
			req.setDisplay("fullscreen");
			req.setMode("listCycleOnce");
			req.setMenu(BASE_PATH + "column/mp/menu.jsp");
			req.setLeft(null);
			req.setTop(null);
			req.setWidth(null);
			req.setHeight(null);
			if(i==codes.length-1)
				req.setAndPlay(true);
			rsp = exec.addVideo(req);
		}
		HttpUtils.setPlayEndURI(request, response, returnURI);
		HttpUtils.redirect(request, response, "/media_player.jsp?method=play&mp="+source+"&addAccessLog=true");
	}
	
	public void favAll(HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		UserStore store = new UserStore(request, response);
		String source = request.getParameter("source");
		String returnURI = request.getParameter("returnURI");
		String[] codes = request.getParameter("codes").split(",");
		FavoritesExecutor exec = new FavoritesExecutor(API_URL);
		AddFavoritesRequest req = null;
		AddFavoritesResponse rsp = null;
		for(int i=0; i<codes.length; ++i)
		{
			req = new AddFavoritesRequest();
			req.setAppVersion(APP_VERSION);
			req.setRole(store.getRole());
			req.setUserid(store.getUserid());
			req.setOrderType(store.getOrderType());
			req.setValue(codes[i]);
			req.setType("song");
			rsp = exec.add(req);
		}
		HttpUtils.redirect(request, response, returnURI+"&info="+URLEncoder.encode("收藏成功", "utf-8"));
	}
%>
<%
	String method = request.getParameter("method");
	if("playAll".equals(method))
		playAll(request, response);
	else if("favAll".equals(method))
		favAll(request, response);
%>