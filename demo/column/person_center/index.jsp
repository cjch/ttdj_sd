<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.joda.time.DateTime" %>
<%@ include file="/com/com_head.jsp" %>
<%!
public static final String COLUMN_CODE = "person_center";//栏目code


public void history(HttpServletRequest request, HttpServletResponse response) throws Exception{
	
	UserStore store = new UserStore(request, response);
	
	String userid = store.getUserid();
	boolean addAccessLog = HttpUtils.getBoolean(request, "addAccessLog", false);
	// 点击播放、添加、收藏等按钮后返回本页的地址（已解码） 
	String returnURI = HttpUtils.markURI(request, response, "returnURI", "f", "info", "backURI", "dir", "source", "addAccessLog");
	// 从本页跳转到其它栏目后，再返回本页的地址
	String backURI = HttpUtils.markURIList(request, API_URL, userid, "backURI");
	request.setAttribute("backURI", backURI);
	String source = HttpUtils.getString(request,"source",COLUMN_CODE);
	
	
	int p = HttpUtils.getInt(request,"p",1);
	//获取历史记录
	VodHistoryRequest vodHistoryRequest = new VodHistoryRequest();
	vodHistoryRequest.setUserid(userid);
	vodHistoryRequest.setCurrent(p);
	vodHistoryRequest.setAppVersion(APP_VERSION);
	//只查询4个月以内的点播日志,优化查询速度
	vodHistoryRequest.setStartDate(DateTime.now().plusMonths(-4));
	LogExecutor exec = new LogExecutor(API_URL);
	VodHistoryResponse vodHistoryResponse = exec.getVodHistory(vodHistoryRequest);
	
	request.setAttribute("userid",userid);
	request.setAttribute("pb",vodHistoryResponse.getPb());
	HttpUtils.forward(request, response, "column/person_center/history.jsp?source="+source);
	return;
}

public void fav(HttpServletRequest request, HttpServletResponse response) throws Exception{
	UserStore store = new UserStore(request, response);
	
	String userid = store.getUserid();
	request.setAttribute("backURI", request.getParameter("backURI"));
	String source = HttpUtils.getString(request,"source",COLUMN_CODE);
	//获取收藏记录
	GetFavoritesRequest req = new GetFavoritesRequest();
	req.setUserid(userid);
	req.setAppVersion(APP_VERSION);
	req.setRole("guest");
	req.setType("album"); 
	req.setCurrent(HttpUtils.getInt(request,"p",1));
	req.setPageSize(12);
	GetFavoritesResponse rsp = new FavoritesExecutor(API_URL).getFavorites(req);
	
	request.setAttribute("userid",userid);
	request.setAttribute("pb",rsp.getPb());
	HttpUtils.forward(request, response, "column/person_center/fav.jsp?source="+source);
	return;
}

public void activity(HttpServletRequest request, HttpServletResponse response) throws Exception{
	
	UserStore store = new UserStore(request, response);
	
	String userid = store.getUserid();	
	request.setAttribute("backURI", request.getParameter("backURI"));
	String source = HttpUtils.getString(request,"source",COLUMN_CODE);
	
	
	int currentPage = HttpUtils.getInt(request,"p",1);
	//获取公告信息
	List<EpgMetadataGroup> groupList = getEpg(COLUMN_CODE).getGroups();
	
	//获取当前页内容
	EpgMetadata md = groupList.get(0).getMetadatas().get(currentPage-1);
	//获取总共有多少页
	int pageCount = groupList.get(0).getMetadatas().size();
	
	request.setAttribute("userid",userid);
	request.setAttribute("md",md);
	request.setAttribute("pageCount",pageCount);
	request.setAttribute("currentPage",currentPage);
	HttpUtils.forward(request, response, "column/person_center/activity.jsp?source="+source);
	return;
}

public void help(HttpServletRequest request, HttpServletResponse response) throws Exception{
	UserStore store = new UserStore(request, response);
	String userid = store.getUserid();	
	request.setAttribute("backURI", request.getParameter("backURI"));
	String source = HttpUtils.getString(request,"source",COLUMN_CODE);
	
	int currentPage = HttpUtils.getInt(request,"p",1);
	//获取公告信息
	List<EpgMetadataGroup> groupList = getEpg(COLUMN_CODE).getGroups();
	
	//获取当前页内容
	EpgMetadata md = groupList.get(1).getMetadatas().get(currentPage-1);
	//获取总共有多少页
	int pageCount = groupList.get(1).getMetadatas().size();
	
	request.setAttribute("userid",userid);
	request.setAttribute("md",md);
	request.setAttribute("pageCount",pageCount);
	request.setAttribute("currentPage",currentPage);
	HttpUtils.forward(request, response, "column/person_center/help.jsp?source="+source);
	return;
}
%>
<%
String method = request.getParameter("method");
if("history".equals(method)){
	history(request, response);
}else if("fav".equals(method)){
	fav(request, response);
}else if("activity".equals(method)){
	activity(request, response);
}else if("help".equals(method)){
	help(request, response);
}else{	
	history(request, response);
}
%>