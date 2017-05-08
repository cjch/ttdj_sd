<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/com/com_head.jsp" %>
<%!

	public static final String COLUMN_NAME = "health_exit";//栏目名称
	public static final String COLUMN_CODE = COLUMN_NAME;//栏目code，取数据用
	public static final String CURRENT_URI = BASE_PATH+"column/exit/exit.jsp?1=1";//当前页面访问地址

%>
<%
	//以下3个字段最好每个页面都需要设置
	setAttr
	(
		request,
		"backURI", getBackURI(request, response),//返回路径
		"currentURI", CURRENT_URI,//当前页面URL
		"target", COLUMN_NAME//记录日志用到的target
	);
%>

	<title>退出健身团-已订购用户</title>
	<!-- 如果是标清版本 -->
	<c:if test="${isSD }">
	<%
		
	%>
	<style type="text/css">
		div.back_div{left: 0px; top: 0px;}
	</style>
	</c:if>
	
	<!-- 如果是高清版本 -->
	<c:if test="${!isSD }">
	<%
		
	%>
	<style type="text/css">
		div.back_div{left: 0px; top: 0px;}
	</style>
	</c:if>
	
	<script type="text/javascript">

	var buttons=
	[
		{id:'back',name:'返回',action:'back()',focusImage:'${touming}'}
	];
	
	//返回
	function back()
	{
		<c:if test="${isOTT}">
			android.exitAPK();//如果是OTT版，直接调用方法退出APK
			return;
		</c:if>
		if('${back_epg_url}')//如果cookie里面设置了该参数，返回到改地址
			location.href = '${back_epg_url}';
		else
			goIptvPortal();
	}
	
	window.onload=function()
	{
		Epg.tip('${param.info}');//显示info信息，3秒后自动隐藏，如果info为空将不会显示
		Epg.btn.init(['${param.f}','back'],buttons,'',true);	
	};

	</script>
	
</head>
<body style="background-image: url('${imagePath}background_order.jpg')">
	
	<!-- 返回 -->
	<div class="back_div">
		<img id="back" src="${touming}"/>
	</div>
	
	<%@include file="/com/com_bottom.jsp"%>
	
</body>
</html>