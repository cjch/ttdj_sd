<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/com/common.jsp" %>
<%@page import="java.io.PrintWriter"%>
<%!
/**
  * 用于处理搜索功能的jsp
  */
	/**
	 * 收藏
	 */
	 public void ajaxSearch(HttpServletRequest request,HttpServletResponse response) throws Exception{
		UserStore store = new UserStore(request,response);
		String kw = request.getParameter("kw");
		GetSongByPinyinRequest req = new GetSongByPinyinRequest();
		req.setCarrier(CARRIER);
		req.setAppVersion(APP_VERSION);
		req.setPlatform(PLATFORM);
		req.setFormat(FORMAT);
		req.setUserid(store.getUserid());
		req.setRole(store.getRole());
		req.setOrderType(store.getOrderType());
		req.setAddSearchLog(false);
		req.setPinyin(kw);
		req.setCurrent(1);
		req.setPageSize(4);
		//req.setType("video");
		GetSongByPinyinResponse resp = new SearchExecutor(API_URL).getSongByPinyin(req);

		PrintWriter pw = response.getWriter();
		pw.write(JsonUtil.toJson(resp));
		pw.close();
		
	 }
	 
%>

<%
String method = request.getParameter("method");
if("ajaxSearch".equals(method))
	ajaxSearch(request, response);
%>