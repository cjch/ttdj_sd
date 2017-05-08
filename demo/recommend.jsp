<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/com/common.jsp" %>
<%
	// 处理跳转到EPG的中间页面
	String code = request.getParameter("code");
	String source = request.getParameter("source");
	UserStore store = new UserStore(request, response);
	EpgExecutor exec = new EpgExecutor(API_URL);
	GetEpgRequest req = new GetEpgRequest();
	req.setAppVersion(APP_VERSION);
	req.setCode(code);
	req.setRole(store.getRole());
	Epg epg = exec.get(req);
	String path = epg.getPath();
	if(path.startsWith("http://"))// 外链
	{ 
		LogExecutor exec2 = new LogExecutor(API_URL);
		AddAccessLogRequest req2 = new AddAccessLogRequest();
		req2.setAppVersion(APP_VERSION);
		req2.setCarrier(CARRIER);
		req2.setPlatform(PLATFORM);
		req2.setCity(store.getCity());
		req2.setOrderType(store.getOrderType());
		req2.setRole(store.getRole());
		req2.setSource(source);
		req2.setTarget(code);
		req2.setUserid(store.getUserid());
		req2.setTargetType(epg.getEpgType());
		req2.setCachable(true);
		req2.setEntry(getCookie(request,"entry",""));	//入口字段
		exec2.addAccessLog(req2);
		// 预定义变量{userid}替换成实际用户ID，{orderType}替换成实际的订购类型
		path = path.replaceAll("\\{userid\\}", store.getUserid());
		path = path.replaceAll("\\{orderType\\}", store.getOrderType());
		response.sendRedirect(path);
	}
	else
	{
		String uri = BASE_PATH + path + (path.contains("?")?"&":"?") + "source="+source+"&addAccessLog=true&backURI="+URLEncoder.encode(request.getParameter("backURI"), "utf-8");
		//HttpUtils.forward(request, response, uri);
		response.sendRedirect(uri);
	}
%>
