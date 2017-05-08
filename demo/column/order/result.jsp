<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/com/com_head.jsp" %>
<%@ include file="/com/auth.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/tags/epg" prefix="epg" %>
<%@ taglib tagdir="/WEB-INF/tags/epg" prefix="e" %>
<%!
	public static final String COLUMN_NAME = "game_order_result";//当前栏目名称
	public static final String CURRENT_URI = BASE_PATH + "column/order/result.jsp?1=1";//当前页面访问地址
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

	UserStore store = new UserStore(request, response);
	Map<String, String> result = login(store.getUserid(), request);//订购之前重新鉴权
	int btnNumber = 2;//按钮个数，是只有一个“返回”按钮，还是“重新订购”和“取消”2个按钮
	String bg = "result_failed_bg.jpg";//背景图，默认订购失败
	boolean showInfo = true;//是否显示文字内容
	boolean success = false;//是否订购成功
	if("true".equals(result.get("success")))//如果鉴权成功
	{
		//result = order(store.getUserid(), result.get("user_token"), request);//开始订购
		String code = result.get("code");
		if("0".equals(code))//订购成功
		{
			bg = "result_success_bg.jpg";
			btnNumber = 1;
			showInfo = false;
			success = true;
			store.setOrderType("month");
		}
		else if("202".equals(code))//已关闭在线订购功能
		{
			bg = "result_closed_bg.jpg";
			btnNumber = 1;
			showInfo = false;
		}
		else if("104".equals(code))//重复订购
		{
			bg = "result_repeat_bg.jpg";
			btnNumber = 1;
			showInfo = false;
		}
	}
	
	String info = result.get("text");
	String sourceType = getParam(request, "sourceType", "");//来源页面类型，一般不需要传值
	String elementCode = getParam(request, "elementCode", "0000");//当前页面元素编码
	String elementCodeSrc = getParam(request, "elementCodeSrc", "0000");//来源页面元素编码
	
	
	AddOrderResponse resp = post
	(
		"order/add-"+(success?"successed":"failed"), AddOrderResponse.class,
		"userid", store.getUserid(),//用户ID
		"role", store.getRole(),//角色名
		"orderType", success?"month":store.getOrderType(),//订购类型，如果成功强制更改为month
		"source", getParam(request, "source", ""),//来源页
		"sourceType", sourceType,//来源页类型
		"city", store.getCity(),//城市code
		"carrier", CARRIER,//运营商
		"appVersion", APP_VERSION,//版本
		"platform", PLATFORM,//平台
		"code", getParam(request, "code", ""),//如果从视频播放页面跳转过来则为视频code，其它页面时为空
		"userProp", getParam(request, "userProp", getUserProp(request)),//用户属性编码
		"pagePropSrc", getParam(request, "pagePropSrc", getPageProp(sourceType, elementCodeSrc)),//来源页面属性
		"pageProp", getParam(request, "pageProp", getPageProp(targetType, elementCode)),//当前页面属性
		success?"":"description", info,//订购失败原因，订购成功不记录这个字段
		success?"entry":"", getCookie(request, "entry", "") //入口，记录失败不记录这个字段
	);

	setAttr
	(
		request,
		"bg", bg,//背景图
		"success", success,//是否订购成功
		"info", showInfo?info:"",//显示的文本
		"btnNumber", btnNumber//按钮个数
	);
	
%>
	<title>订购结果-果果乐园</title>

<%-------------------------- 与样式相关代码开始 ----------------------------%>
<!-- 如果是标清版 -->
<c:if test="${isSD}">
	<style type="text/css">
	div#info{position:absolute;left: 80px;top: 250px;font-size: 20px;color: white;width: 490px;text-align: center;overflow: hidden;height: 24px;}
	div#order_div{left:151px;top:299px;}
	img#order{width:148px;height:77px;}
	div#cancel_div{left:341px;top:299px;}
	img#cancel{width:148px;height:77px;}
	</style>
</c:if>
<!-- 如果是高清版 -->
<c:if test="${!isSD}">
	<style type="text/css">
	div#info{position:absolute;left: 80px;top: 250px;font-size: 20px;color: white;width: 490px;text-align: center;overflow: hidden;height: 24px;}
	div#order_div{left:361px;top:410px;}
	img#order{width:238px; height:98px}
	div#cancel_div{left:682px;top:410px;}
	img#cancel{width:238px; height:98px}
	</style>
</c:if>
<%-------------------------- 与样式相关代码结束----------------------------%>



	<script type="text/javascript">

	var buttons=
	[
		{id:'ok',name:'确定/返回',action:'back()',focusImage:'${touming}'},
		
		{id:'order',name:'订购',action:'order()',focusImage:'fail_order_f.png',right:'cancel'},
		{id:'cancel',name:'取消',action:'back()',focusImage:'fail_back_f.png',left:'order'}
	];
	
	//返回
	function back()
	{
		location.href = '${backURI}';
	}
	
	//订购
	function order()
	{
		location.href = '${basePath}column/order/result.jsp?code=${param.code}&source=${param.source}&sourceType=${param.sourceType}&pagePropSrc=${param.pagePropSrc}&addAccessLog=true';
	}
	
	window.onload=function()
	{
		Epg.tip('${param.info}');//显示info信息，3秒后自动隐藏，如果info为空将不会显示
		Epg.btn.init(['${btnNumber==1?"ok":"cancel"}'],buttons,'${imagePath}',true);	
	};

	</script>
	
</head>
<body style="background-image: url('${imagePath}${bg}')">
	
	<div id="info">${info}</div>
	
	<!-- 返回-->
	<div id="ok_div"><img id="ok" src="${touming}"/></div>
	
	<!-- 订购 -->
	<div id="order_div"><img id="order" src="${touming}"/></div>
	<!-- 取消订购 -->
	<div id="cancel_div"><img id="cancel" src="${touming}"/></div>
	
	<%@include file="/com/com_bottom.jsp"%>
	
</body>
</html>