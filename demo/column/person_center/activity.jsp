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
	color:#FFFFFF;
	background: transparent url('${comImagePath}bg.jpg') no-repeat;
}

#myacount_img{position:absolute;left:0;top:145px;font-size:18px;font-weight:500;width:150px;height:70px;text-align:center;color:#788195;font-size:18px;;line-height:30px;}
#history_img{position:absolute;left:0;top:190px;font-size:18px;font-weight:500;width:150px;height:70px;}
#fav_img{position:absolute;left:0;top:263px;font-size:18px;font-weight:500;width:150px;height:70px;}
#activity_img{position:absolute;left:0;top:336px;font-size:18px;font-weight:500;width:150px;height:70px;}
#help_img{position:absolute;left:0;top:409px;font-size:18px;font-weight:500;width:150px;height:70px;}
.novi_nor{width:121px;height:47px;text-align:right;color:#788195;font-size:25px;line-height:73px;}
.novi_focus{width:121px;height:47px;text-align:right;color:#f0f0f0;font-size:25px;;line-height:73px;}
.novi_sel{width:121px;height:47px;text-align:right;color:#f0f0f0;font-size:25px;line-height:73px;background-color: #0062eb; }
.intro{width:200px;height:44px;text-align:right;color:#788195;font-size:22px;line-height:44px;}
#history_0_img{position:absolute;left:300px;top:105px;width:201px;height:113px;}
#history_1_img{position:absolute;left:538px;top:105px;width:201px;height:113px;}
#history_2_img{position:absolute;left:776px;top:105px;width:201px;height:113px;}
#history_3_img{position:absolute;left:1014px;top:105px;width:201px;height:113px;}

#history_4_img{position:absolute;left:300px;top:304px;width:201px;height:113px;}
#history_5_img{position:absolute;left:538px;top:304px;width:201px;height:113px;}
#history_6_img{position:absolute;left:776px;top:304px;width:201px;height:113px;}
#history_7_img{position:absolute;left:1014px;top:304px;width:201px;height:113px;}

#history_8_img{position:absolute;left:300px;top:503px;width:201px;height:113px;}
#history_9_img{position:absolute;left:538px;top:503px;width:201px;height:113px;}
#history_10_img{position:absolute;left:776px;top:503px;width:201px;height:113px;}
#history_11_img{position:absolute;left:1014px;top:503px;width:201px;height:113px;}


#history_0{position:absolute;left:288px;top:97px;width:174px;height:100px;}
#history_1{position:absolute;left:526px;top:97px;width:174px;height:100px;}
#history_2{position:absolute;left:764px;top:97px;width:174px;height:100px;}
#history_3{position:absolute;left:1002px;top:97px;width:174px;height:100px;}

#history_4{position:absolute;left:288px;top:296px;width:174px;height:100px;}
#history_5{position:absolute;left:526px;top:296px;width:174px;height:100px;}
#history_6{position:absolute;left:764px;top:296px;width:174px;height:100px;}
#history_7{position:absolute;left:1002px;top:296px;width:174px;height:100px;}

#history_8{position:absolute;left:288px;top:495px;width:174px;height:100px;}
#history_9{position:absolute;left:526px;top:495px;width:174px;height:100px;}
#history_10{position:absolute;left:764px;top:495px;width:174px;height:100px;}
#history_11{position:absolute;left:1002px;top:495px;width:174px;height:100px;}

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


<div style="position:absolute;left:0px;top:0px;width:150px;height:720px;background-color: #0b0e34; "></div>
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

<!-- line -->
<%-- <div style="position:absolute;left:60px;top:190px;">
<img src="${imagePath}line.png" width="4px" height ="520px"/>
</div> --%>

<!-- 内容 -->
<div class="intro" style="position:absolute;left:290px;top:50px;width:900px;height:600px;overflow:hidden;text-align:left;" >
${md.label}
</div>


<c:if test="${pageCount>currentPage}">
<div style="position:absolute;left:650px;top:650px;"><img id="next" src="${imagePath}btn_xiala_nor.png" /></div>
</c:if>

<%@include file="/com/com_bottom.jsp"%>
</body>
