<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
	String resultCode = request.getParameter("resultCode");
	String message = request.getParameter("message");
	String newOrder = request.getParameter("newOrder");

	String code = request.getParameter("code");
	String source = request.getParameter("source");
	String sourceType = request.getParameter("sourceType");
	String pagePropSrc = request.getParameter("pagePropSrc");

	String return_url = request.getParameter("return_url");
	if("".equals(return_url)||return_url==null){
		return_url="../../com/auth.jsp?method=orderResult";
	}
	//if(return_url.indexOf("?")<0){//没带问号
		//return_url=return_url+"?resultCode="+resultCode+"&message="+message+"&newOrder="+newOrder+"&code="+code+"&source="+source+"&sourceType="+sourceType+"&pagePropSrc="+pagePropSrc;
	//}else{
		//return_url=return_url+"&resultCode="+resultCode+"&message="+message+"&newOrder="+newOrder+"&code="+code+"&source="+source+"&sourceType="+sourceType+"&pagePropSrc="+pagePropSrc;
	//}
	//System.out.println("=====return_url======"+return_url);
	
%>
<title>订购ott</title>
<script type="text/javascript">
		var resultStr=android.getOrderResult();
		var jsonO = eval("("+resultStr+")");  
		 window.location.href='<%=return_url%>'+'&resultCode='+jsonO["resultCode"];
</script>
	
</head>
<body>
	
</body>
</html>
