<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="org.codehaus.jackson.type.TypeReference"%>
<%@ include file="/config.jsp" %>
<%
class MonitorExecutor extends AbstractHttpMethodExecutor{
	public MonitorExecutor(String targetEndpoint){
		super(targetEndpoint);
	}
	public String status(){
		String rsp = post(targetEndpoint+"monitor/status", "");
		Map<String, String> rspMap = JsonUtils.fromString(rsp, new TypeReference<Map<String, String>>(){});
		return rspMap.get("result");
	}
}
String statusStr = "0";
try{
	statusStr = new MonitorExecutor(API_URL).status();
}catch(Exception e){
	statusStr = "-1";
}
out.print(statusStr);
out.flush();
%>