<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/com/common.jsp" %>
<%
	String display = getParam(request, "display", "fullscreen");
	if("smallvod".equals(display))
	{
		
	}
	else if("fullscreen".equals(display))//如果是全屏播放
	{
		redirect(request, response, "com/500.jsp?1=1"+"&info="+encode("视频播放地址错误！"));
		//redirect(request, response, HttpUtils.getPlayEndURI(request, response)+"&info="+encode("视频播放地址错误！"));
	}
%>