<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/com/com_head.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/tags/epg" prefix="epg" %>
<%@ taglib tagdir="/WEB-INF/tags/epg" prefix="e" %>
<%!
	public static final String COLUMN_NAME = "game_order";//当前栏目名称
	public static final String CURRENT_URI = BASE_PATH + "column/order/order.jsp?1=1";//当前页面访问地址
%>
<%
	//以下7个字段一般每个页面都需要设置
	setAttr
	(
		request,
		"currentURI", CURRENT_URI,//当前页面URL
		"backURI", getBackURI(request, response),//返回地址
		"target", COLUMN_NAME//记录日志用到的target
	);
%>
<title>订购</title>
<%-------------------------- 与样式相关代码开始 ----------------------------%>
<!-- 如果是标清版 -->
<c:if test="${isSD}">
	<style type="text/css">
	div#order_div{left:259px;top:412px;}
	img#order{width:123px; height:65px}
	div#prize_div{left:455px;top:212px;font-size:24px;color:#ffffff;}
	</style>
</c:if>
<!-- 如果是高清版 -->
<c:if test="${!isSD}">
	<style type="text/css">

	</style>
</c:if>
<%-------------------------- 与样式相关代码结束----------------------------%>
	<script type="text/javascript">

	var buttons=
	[
		{id:'back1',name:'返回',action:'back()',autoPrefix:false,linkImage:'${imagePath}back.png',focusImage:'${imagePath}back_new.png',left:'order1',down:'order1'},
		{id:'order1',name:'订购',action:'order()',linkImage:'${touming}',focusImage:'${imagePath}order_new_button.jpg',right:'back1',up:'back1'}
	];
	
	//返回
	function back()
	{
		if('${orderBackUrl}'==''||'${orderBackUrl}'==null){
			location.href = "<%=BASE_PATH%>home.jsp?addAccessLog=true";
		}else {
			location.href = '${orderBackUrl}';
		}
	}
	
	//订购
	function order()
	{
		location.href='${basePath}com/auth.jsp?method=order&code=${param.code}&source=${param.source}&sourceType=${param.sourceType}&pagePropSrc=${param.pagePropSrc}&addAccessLog=true';
	}
	
	window.onload=function()
	{
		Epg.btn.init(['${param.f}','order1','back1'],buttons,'',true);	
	};

	</script>
	
</head>
<body style="background-image: url('${imagePath}order_bg_new.jpg')">

	<div style="position:absolute;left:362px;top:102px;"><img src="${imagePath}1.gif"/></div>
	<div style="position:absolute;left:401px;top:576px;"><img id="order1" src="${touming}"/></div>
	<div style="position:absolute;left:1110px;top:0px;"><img id="back1" src="${touming}"/></div>
	
	<%@include file="/com/com_bottom.jsp"%>
	
</body>
</html>