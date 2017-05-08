<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
String resultCode = request.getParameter("resultCode");
System.out.println("============resultCode============="+resultCode);
String message = request.getParameter("message");
String newOrder = request.getParameter("newOrder");
String return_url = request.getParameter("return_url");
String source = request.getParameter("source");
String entry = request.getParameter("entry");
if("".equals(return_url)||return_url==null){
	return_url="../../home.jsp";
}
if(return_url.indexOf("?")<0){//没带问号
	return_url=return_url+"?resultCode="+resultCode+"&message="+message+"&newOrder="+newOrder+"&source="+source+"&entry="+entry;
}else{
	return_url=return_url+"&resultCode="+resultCode+"&message="+message+"&newOrder="+newOrder+"&source="+source+"&entry="+entry;
}
 response.sendRedirect(return_url);
 return;
 
//if("0".equals(resultCode)){
//}else{
	//return_url="common_auth_tiyan.jsp?return_url="+return_url;
	//response.sendRedirect(return_url);
	//return;
//}
%>