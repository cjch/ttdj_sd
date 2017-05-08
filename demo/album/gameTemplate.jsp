<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.joda.time.DateTime" %>
<%@ include file="/com/com_head.jsp" %>
<%!

public void home(HttpServletRequest request, HttpServletResponse response) throws Exception{
	
	String COLUMN_CODE = HttpUtils.getString(request,"code","20170311_LOL_album");
	UserStore store = new UserStore(request, response);
	
	String userid = store.getUserid();
	boolean addAccessLog = HttpUtils.getBoolean(request, "addAccessLog", false);
	// 点击播放、添加、收藏等按钮后返回本页的地址（已解码） 
	String returnURI = HttpUtils.markURI(request, response, "returnURI", "f", "info", "backURI", "dir", "source", "addAccessLog");
	// 从本页跳转到其它栏目后，再返回本页的地址
	String backURI = HttpUtils.markURIList(request, API_URL, userid, "backURI");
	request.setAttribute("backURI", backURI);
	String source = HttpUtils.getString(request,"source",COLUMN_CODE);
	
	String f = HttpUtils.getString(request,"f","");

	//获取配置
	//epg里面有游戏简介  游戏名称
	Epg epg = getEpg(COLUMN_CODE);
	request.setAttribute("epg",epg);
	
	List<EpgMetadataGroup> groupList = epg.getGroups();
	List<EpgMetadata> emList = groupList.get(1).getMetadatas();
	List naviList = new ArrayList<String>();
	for(int i = 0 ; i < emList.size() ; i++){
		EpgMetadata em = emList.get(i);
		naviList.add(em.getLabel());
	}

	//获取游戏简介里面的热门视频 
	int programId = Integer.parseInt(groupList.get(0).getMetadatas().get(0).getValue());
	GetProgramRequest req = new GetProgramRequest();
	req.setId(programId);
	//req.setType("video");
	req.setCurrent(HttpUtils.getInt(request, "p", 1));
	req.setPageSize(8);
	GetProgramResponse resp = new ProgramExecutor(API_URL).get(req);
	request.setAttribute("pb",resp.getPb());

	request.setAttribute("programId",programId);
	request.setAttribute("code",COLUMN_CODE);
	request.setAttribute("f",f);
	request.setAttribute("naviList",naviList);	
	HttpUtils.forward(request, response, "album/gameTemplateHome.jsp");
	return;
}


public void list(HttpServletRequest request, HttpServletResponse response) throws Exception{
	
	String COLUMN_CODE = HttpUtils.getString(request,"code","20170311_LOL_album");
	UserStore store = new UserStore(request, response);
	
	String userid = store.getUserid();
	
	int type = HttpUtils.getInt(request,"type",0);
	String f = HttpUtils.getString(request,"f","");
	//获取配置
	//epg里面有游戏简介  游戏名称
	Epg epg = getEpg(COLUMN_CODE);
	request.setAttribute("epg",epg);
	
	List<EpgMetadataGroup> groupList = epg.getGroups();
	List<EpgMetadata> emList = groupList.get(1).getMetadatas();
	List naviList = new ArrayList<String>();
	for(int i = 0 ; i < emList.size() ; i++){
		EpgMetadata em = emList.get(i);
		naviList.add(em.getLabel());
		
		if(i == type){
			//当前选中导航
			int programId = Integer.parseInt(em.getValue());
			GetProgramRequest req = new GetProgramRequest();
			req.setId(programId);
			req.setType("video");
			req.setCurrent(HttpUtils.getInt(request, "p", 1));
			req.setPageSize(12);
			GetProgramResponse resp = new ProgramExecutor(API_URL).get(req);
			request.setAttribute("pb",resp.getPb());
		}
	}
	request.setAttribute("type",type);
	request.setAttribute("f",f);
	request.setAttribute("naviList",naviList);
	HttpUtils.forward(request, response, "album/gameTemplateList.jsp");
	return;
}
%>
<%
String method = request.getParameter("method");
if("list".equals(method)){
	list(request, response);
}else if("home".equals(method)){
	home(request, response);
}else{	
	home(request, response);
}
%>
