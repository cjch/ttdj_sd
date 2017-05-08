<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/com/common.jsp" %>
<%
	redirect(request, response, HttpUtils.getPlayEndURI(request, response)+"&info="+encode("视频播放结束"));
%>