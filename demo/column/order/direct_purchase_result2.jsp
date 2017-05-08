<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ include file="/com/com_head.jsp" %>
<%
	String tradeInfo = request.getParameter("tradeInfo");
	String errorInfo = request.getParameter("errorInfo");

	String code = request.getParameter("code");
	String source = request.getParameter("source");
	String sourceType = request.getParameter("sourceType");
	String pagePropSrc = request.getParameter("pagePropSrc");
	
	String resultCode = "1";
	if("".equals(tradeInfo) || null == tradeInfo){
		resultCode = "1";
	}else{
		resultCode = "0";
	}
	
	String return_url = request.getParameter("return_url");
	
	if("".equals(return_url)||return_url==null){
		return_url="../../com/auth.jsp?method=orderResult";
	}
	if(return_url.indexOf("?")<0){//没带问号
		return_url=return_url+"?resultCode="+resultCode+"&code="+code+"&source="+source+"&sourceType="+sourceType+"&pagePropSrc="+pagePropSrc;
	}else{
		return_url=return_url+"&resultCode="+resultCode+"&code="+code+"&source="+source+"&sourceType="+sourceType+"&pagePropSrc="+pagePropSrc;
	}
%>
<title>订购ott果果</title>

<script type="text/javascript">
/*
		var resultStr=android.getOrderResult();
		var jsonO = eval("("+resultStr+")");  
		 window.location.href='<%=return_url%>'+'&resultCode='+jsonO["resultCode"];
*/

	//回收按键事件
	window.orderHandle.orderResult("0","xxx");
	window.location.href='<%=return_url%>';
</script>
	
</head>
<body>
	
</body>
</html>
