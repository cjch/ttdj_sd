<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="org.apache.log4j.xml.DOMConfigurator"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>重新加载Log4j XML 文件</title>
</head>
<body>
<%
DOMConfigurator.configure(getClass().getResource("/log4j.properties"));
%>
重新加载Log4j XML文件成功！
</body>
</html>