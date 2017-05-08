<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/com/common.jsp" %>
<%
	UserStore store = new UserStore(request, response);
	String url = "";
	//if("free".equals(store.getOrderType()))
	//	url = "exit_unorder.jsp";//如果未订购
	//else
		url = "exit_order.jsp";//如果已经订购
	String back_epg_url = decode(getCookie(request, COOKIE_BACK_EPG_URL, ""));
	request.setAttribute("back_epg_url", back_epg_url);//退出EPG地址
	//forward(request, response, "column/exit/"+url);
	redirect(request, response, back_epg_url);
%>