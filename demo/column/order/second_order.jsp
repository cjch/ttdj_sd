<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/com/com_head.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/tags/epg" prefix="epg" %>
<%@ taglib tagdir="/WEB-INF/tags/epg" prefix="e" %>
<%!
	public static final String COLUMN_NAME = "game_second_order";//当前栏目名称
	public static final String CURRENT_URI = BASE_PATH + "column/order/second_order.jsp?1=1";//当前页面访问地址
%>
<%
	//以下7个字段一般每个页面都需要设置
	setAttr
	(
		request,
		"currentURI", CURRENT_URI,//当前页面URL
		"backURI", getBackURI(request, response)//返回地址
		//"target", COLUMN_NAME//记录日志用到的target
	);
%>
	<title>二次订购-果果乐园</title>

<%-------------------------- 与样式相关代码开始 ----------------------------%>
<!-- 如果是标清版 -->
<c:if test="${isSD}">
	<style type="text/css">
	div#order_div{left:155px;top:348px;}
	img#order{width:142px; height:72px}
	div#cancel_div{left:342px;top:346px;}
	img#cancel{width:148px; height:76px}
	div#prize_div{left:455px;top:212px;font-size:24px;color:#ffffff;}
	</style>
</c:if>
<!-- 如果是高清版 -->
<c:if test="${!isSD}">
	<style type="text/css">
	div#order_div{left:358px;top:470px;}
	img#order{width:242px; height:100px}
	div#cancel_div{left:682px;top:472px;}
	img#cancel{width:238px; height:98px}
	div#prize_div{left:875px;top:285px;font-size:34px;color:#ffffff;}
	</style>
</c:if>
<%-------------------------- 与样式相关代码结束----------------------------%>



	<script type="text/javascript">

	var buttons=
	[
		{id:'back',name:'返回',action:'back()',autoPrefix:false,focusImage:'${comImagePath}back_f.png',left:'cancel',down:'order'},
		{id:'order',name:'订购',action:'order()',focusImage:'second_order_f.png',right:'cancel',up:'back'},
		{id:'cancel',name:'取消订购',action:'back()',focusImage:'fail_back_f.png',left:'order',right:'back',up:'back'}
	];
	
	//返回
	function back()
	{
		location.href = '${backURI}';
	}
	
	//订购
	function order()
	{
		location.href = '${basePath}column/order/result.jsp?source=${param.source}&sourceType=${param.sourceType}&code=${param.code}&pagePropSrc=${param.pagePropSrc}';
	}
	
	window.onload=function()
	{
		Epg.btn.init(['${param.f}','cancel','back'],buttons,'${imagePath}',true);	
	};

	</script>
	
</head>
<body style="background-image: url('${imagePath}second_order_bg.jpg')">

	<div id="prize_div">19</div>
	
	<!-- 返回-->
	<div class="back_img_div"><img id="back" src="${comImagePath}back.png"/></div>
	
	<!-- 订购 -->
	<div id="order_div"><img id="order" src="${touming}"/></div>
	<!-- 取消订购 -->
	<div id="cancel_div"><img id="cancel" src="${touming}"/></div>
	
	<%@include file="/com/com_bottom.jsp"%>
	
</body>
</html>