<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/com/com_head.jsp" %>
<%
	String method=request.getParameter("method");
	String info=request.getParameter("info");
%>
	<title>ajax页面</title>
	<script type="text/javascript">

	var p=Epg.getParent();
<%
	if("fav".equals(method))//收藏
		out.print("p.Epg.tip('"+info+"');");
%>
	
	</script>
	
</head>
<body>

</body>	
</html>
	