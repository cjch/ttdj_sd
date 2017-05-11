<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/com/com_head.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/tags/epg" prefix="epg" %>
<%@ taglib tagdir="/WEB-INF/tags/epg" prefix="e" %>
<title>个人中心-活动</title>
<%!
	public static final String COLUMN_CODE = "person_center";//首页栏目code
	public static final String CURRENT_URI = BASE_PATH + "column/person_center/index.jsp?method=help";//当前页面访问地址
%>

<%
	imagePath = BASE_IMAGE_PATH + "column/person_center/";//修正栏目图片路径
	String comImagePath = BASE_IMAGE_PATH + "/com/";//修正公共图片路径
	String testImagePaht = BASE_PATH+"column/person_center/images/";
	setAttr
	(
		request,
		"imagePath", imagePath,//图片路径
		"testImagePaht",testImagePaht,
		"comImagePath", comImagePath,
		"backURI", getBackURI(request, response),//返回路径
		"currentURI", CURRENT_URI,//当前页面路径
		"target", COLUMN_CODE//记录日志用到的target
	);
%>

<style type="text/css">
body{
	margin:0;
	padding:0;
	color:#f0f0f0;
	background: transparent url('${comImagePath}bg_splist.jpg') no-repeat;
}

#myacount_img{position:absolute;left:0;top:120px;font-size:12px;width:91px;height:41px;text-align:right;color:#788195;line-height:41px;}
#history_img{position:absolute;left:0;top:161px;font-size:14px;line-height:41px;width:101px;height:41px;}
#fav_img{position:absolute;left:0;top:202px;font-size:14px;line-height:41px;width:101px;height:41px;}
#activity_img{position:absolute;left:0;top:243px;font-size:14px;line-height:41px;width:101px;height:41px;}
#help_img{position:absolute;left:0;top:284px;font-size:14px;line-height:41px;width:101px;height:41px;}
.novi_nor{text-align:right;color:#788195;}
.novi_focus{text-align:right;color:#f0f0f0;}
.novi_sel{text-align:right;color:#f0f0f0;background-color: #0062eb; }
.intro{color:#f0f0f0;opacity:0.7;font-size:14px;line-height:20px;}

#history_0_img{position:absolute;left:130px;top:88px;width:150px;height:85px;}
#history_1_img{position:absolute;left:300px;top:88px;width:150px;height:85px;}
#history_2_img{position:absolute;left:470px;top:88px;width:150px;height:85px;}
#history_3_img{position:absolute;left:130px;top:183px;width:150px;height:85px;}
#history_4_img{position:absolute;left:300px;top:183px;width:150px;height:85px;}
#history_5_img{position:absolute;left:470px;top:183px;width:150px;height:85px;}
#history_6_img{position:absolute;left:130px;top:278px;width:150px;height:85px;}
#history_7_img{position:absolute;left:300px;top:278px;width:150px;height:85px;}
#history_8_img{position:absolute;left:470px;top:278px;width:150px;height:85px;}
#history_9_img{position:absolute;left:130px;top:373px;width:150px;height:85px;}
#history_10_img{position:absolute;left:300px;top:373px;width:150px;height:85px;}
#history_11_img{position:absolute;left:470px;top:373px;width:150px;height:85px;}

#history_0{position:absolute;left:118px;top:80px;width:173px;height:100px;}
#history_1{position:absolute;left:288px;top:80px;width:173px;height:100px;}
#history_2{position:absolute;left:458px;top:80px;width:173px;height:100px;}
#history_3{position:absolute;left:118px;top:175px;width:173px;height:100px;}
#history_4{position:absolute;left:288px;top:175px;width:173px;height:100px;}
#history_5{position:absolute;left:458px;top:175px;width:173px;height:100px;}
#history_6{position:absolute;left:118px;top:270px;width:173px;height:100px;}
#history_7{position:absolute;left:288px;top:270px;width:173px;height:100px;}
#history_8{position:absolute;left:458px;top:270px;width:173px;height:100px;}
#history_9{position:absolute;left:118px;top:365px;width:173px;height:100px;}
#history_10{position:absolute;left:288px;top:365px;width:173px;height:100px;}
#history_11{position:absolute;left:458px;top:365px;width:173px;height:100px;}


</style>
<script type="text/javascript">

	var currentNavi = "activity";

	var buttons = [
		{id:'history',name:'观看记录',action:goColumn,left:[''], right:['next'], up:'', down:'fav',linkImage:'${touming}', focusImage:'${touming}',focusHandler:focusChangClass,blurHandler:blurChangClass},
		{id:'fav',name:'我的收藏',action:goColumn,left:[''], right:['next'], up:'history', down:'activity',linkImage:'${touming}', focusImage:'${touming}',focusHandler:focusChangClass,blurHandler:blurChangClass},
		{id:'activity',name:'活动公告',action:goColumn,left:[''], right:['next'], up:'fav', down:'help',linkImage:'${touming}', focusImage:'${touming}',focusHandler:focusChangClass,blurHandler:blurChangClass},
		{id:'help',name:'帮助中心',action:goColumn,left:[''], right:['next'], up:'activity', down:'',linkImage:'${touming}', focusImage:'${touming}',focusHandler:focusChangClass,blurHandler:blurChangClass},

		<c:if test="${pageCount>currentPage}">
			{id:'next',name:'下一页',action:next,left:['help'], right:[''], up:'', down:'',linkImage:'${imagePath}btn_xiala_nor.png', focusImage:'${imagePath}btn_xiala_sel.png'}
		</c:if>
	];

	var savedClassName ;
	//导航样式切换
	function focusChangClass(button){
		savedClassName = G(button.id+"_img").className;
		G(button.id+"_img").className = "novi_sel";
	}
	function blurChangClass(button){
		G(button.id+"_img").className = savedClassName;
	}

	function goColumn(button){

		if(button.id == currentNavi){
			return;
		}
		var backURI = escape('${backURI}');
		location.href = "${basePath}column/person_center/index.jsp?method="+button.id+"&backURI="+backURI;
		return;
	}

	function next(button){
		location.href = "index.jsp?method=activity&p=${currentPage+1}&f="+button.id;
	}

	function goPlay(button){

	}

	function back(){
		location.href ="${backURI}" ;
	}

	window.onload=function()
	{
		Epg.tip('${param.info}');//显示info信息，3秒自动隐藏，如果info为空将不会显示
		Epg.btn.init(['${param.f}','activity'],buttons,'${imagePath}',true);
	};
</script>

<body>

<div  id="myacount_img">
ID:${userid}
</div>


<div  id="history_img" class="novi_nor">
观看记录&nbsp&nbsp;
<img id="history" src="${touming}" />
</div>
<div  id="fav_img" class="novi_nor">
我的收藏&nbsp&nbsp;
<img id="fav" src="${touming}" />
</div>
<div  id="activity_img" class="novi_focus">
活动公告&nbsp&nbsp;
<img id="activity" src="${touming}" />
</div>
<div  id="help_img" class="novi_nor">
帮助中心&nbsp&nbsp;
<img id="help" src="${touming}" />
</div>

<!-- 内容 -->
<div class="intro" style="position:absolute;left:130px;top:100px;width:480px;height:380px;overflow:hidden;text-align:left;" >
${md.label}
</div>


<c:if test="${pageCount>currentPage}">
<div style="position:absolute;left:354px;top:486px;"><img id="next" src="${imagePath}btn_xiala_nor.png" /></div>
</c:if>

<%@include file="/com/com_bottom.jsp"%>
</body>
