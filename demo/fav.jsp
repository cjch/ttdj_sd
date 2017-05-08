<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/com/common.jsp" %>
<%@page import="java.io.PrintWriter"%>
<%!
/**
  * 用于处理收藏功能的jsp
  */
	/**
	 * 收藏
	 */
	 public void ajaxFav(HttpServletRequest request,HttpServletResponse response) throws Exception{
		response.setContentType("application/json;charset=utf-8");
		String user_id = getUserId(request,response);
		String type = request.getParameter("type");
		String value = request.getParameter("value");
		AddFavoritesRequest addFavoritesRequest = new AddFavoritesRequest();
		addFavoritesRequest.setUserid(user_id);
		addFavoritesRequest.setType(type);
		addFavoritesRequest.setValue(value);
		addFavoritesRequest.setRole("guest");
		addFavoritesRequest.setAppVersion(APP_VERSION);
		AddFavoritesResponse addFavoritesResponse = new FavoritesExecutor(API_URL).add(addFavoritesRequest);
		PrintWriter pw = response.getWriter();
		pw.write(JsonUtil.toJson(addFavoritesResponse));
		pw.close();
		
	 }
	 
	/**
	 * 取消收藏
	 */
	 public void ajaxRemoveFav(HttpServletRequest request,HttpServletResponse response) throws Exception{
		response.setContentType("application/json;charset=utf-8");
		String user_id = getUserId(request,response);
		String type = request.getParameter("type");
		String value = request.getParameter("value");
		RemoveFavoritesRequest removeFavoritesRequest = new RemoveFavoritesRequest();
		removeFavoritesRequest.setUserid(user_id);
		removeFavoritesRequest.setType(type);
		removeFavoritesRequest.setValue(value);
		removeFavoritesRequest.setRole("guest");
		removeFavoritesRequest.setAppVersion(APP_VERSION);
		RemoveFavoritesResponse removeFavoritesResponse = new FavoritesExecutor(API_URL).remove(removeFavoritesRequest);	
		PrintWriter pw = response.getWriter();
		pw.write(JsonUtil.toJson(removeFavoritesResponse));
		pw.close();
	 }
%>

<%
String method = request.getParameter("method");
if("ajaxFav".equals(method))
	ajaxFav(request, response);
else if("ajaxRemoveFav".equals(method))
	ajaxRemoveFav(request, response);
%>