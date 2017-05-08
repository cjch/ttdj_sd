<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.joda.time.DateTime" %>
<%@ include file="/com/com_head.jsp" %>
<%!
public static final String COLUMN_CODE = "20170308_AllVedio_column";//栏目code


public void list(HttpServletRequest request, HttpServletResponse response) throws Exception{
	
	UserStore store = new UserStore(request, response);
	
	String userid = store.getUserid();
	boolean addAccessLog = HttpUtils.getBoolean(request, "addAccessLog", false);
	// 点击播放、添加、收藏等按钮后返回本页的地址（已解码） 
	String returnURI = HttpUtils.markURI(request, response, "returnURI", "f", "info", "backURI", "dir", "source", "addAccessLog");
	// 从本页跳转到其它栏目后，再返回本页的地址
	String backURI = HttpUtils.markURIList(request, API_URL, userid, "backURI");
	request.setAttribute("backURI", backURI);
	String source = HttpUtils.getString(request,"source",COLUMN_CODE);
	
	
	int type = HttpUtils.getInt(request,"type",0);
	String f = HttpUtils.getString(request,"f","");
	//获取配置
	List<EpgMetadataGroup> groupList = getEpg(COLUMN_CODE).getGroups();
	List<EpgMetadata> emList = groupList.get(0).getMetadatas();
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
	HttpUtils.forward(request, response, "column/20170308_AllVedio_column/list.jsp?source="+source);
	return;
}
%>
<%
	list(request, response);
%>