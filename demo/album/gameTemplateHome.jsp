<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/com/com_head.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/tags/epg" prefix="epg" %>
<%@ taglib tagdir="/WEB-INF/tags/epg" prefix="e" %>
<title>游戏专题</title>
<%
	String COLUMN_CODE = HttpUtils.getString(request,"code","20170311_LOL_album");
	String CURRENT_URI = BASE_PATH + "album/gameTemplate.jsp?code="+COLUMN_CODE;//当前页面访问地址
	UserStore store = new UserStore(request,response);
	String userid=store.getUserid();
	imagePath = BASE_IMAGE_PATH + "album/"+ COLUMN_CODE +"/";//修正图片路径
	String templateImagePath = BASE_PATH + "album/images/";//修正图片路径


	//查看用户是否收藏了当前剧集
	IsCollectedRequest isCollectedRequest = new IsCollectedRequest();
	isCollectedRequest.setUserid(userid);
	isCollectedRequest.setType("album");
	isCollectedRequest.setRole("guest");
	isCollectedRequest.setValue(COLUMN_CODE);
	isCollectedRequest.setAppVersion(APP_VERSION);
	IsCollectedResponse isCollectedResponse = new FavoritesExecutor(API_URL).isCollected(isCollectedRequest);
	boolean isCollected = false;
	if(isCollectedResponse.isCollected()){
		//说明已收藏
		isCollected = true;
	}

	setAttr
	(
		request,
		"imagePath", imagePath,//图片路径
		"templateImagePath", templateImagePath,
		"currentURI", CURRENT_URI,//当前页面路径
		"target", COLUMN_CODE,//记录日志用到的target
		"isCollected",isCollected
	);

%>
<style type="text/css">
	body{
		margin:0;
		padding:0;
		color:#FFFFFF;
		background: transparent url('${basePath}${epg.thumbBig}') no-repeat;
	}


#vedio_0_div{position:absolute;left:300px;top:378px;width:150px;height:85px;}
#vedio_1_div{position:absolute;left:538px;top:378px;width:150px;height:85px;}
#vedio_2_div{position:absolute;left:776px;top:378px;width:150px;height:85px;}
#vedio_3_div{position:absolute;left:1014px;top:378px;width:150px;height:85px;}

#vedio_4_div{position:absolute;left:300px;top:550px;width:150px;height:85px;}
#vedio_5_div{position:absolute;left:538px;top:550px;width:150px;height:85px;}
#vedio_6_div{position:absolute;left:776px;top:550px;width:150px;height:85px;}
#vedio_7_div{position:absolute;left:1014px;top:550px;width:150px;height:85px;}

#vedio_0{position:absolute;left:288px;top:370px;width:174px;height:101px;}
#vedio_1{position:absolute;left:526px;top:370px;width:174px;height:101px;}
#vedio_2{position:absolute;left:764px;top:370px;width:174px;height:101px;}
#vedio_3{position:absolute;left:1002px;top:370px;width:174px;height:101px;}

#vedio_4{position:absolute;left:288px;top:542px;width:174px;height:101px;}
#vedio_5{position:absolute;left:526px;top:542px;width:174px;height:101px;}
#vedio_6{position:absolute;left:764px;top:542px;width:174px;height:101px;}
#vedio_7{position:absolute;left:1002px;top:542px;width:174px;height:101px;}

</style>
<script src="${basePath}resources/js/jquery-v2.1.1.js"></script>
<script type="text/javascript">
	var idFav = ${isCollected};
	var naviList = [];
	var type = '${type}';
	<c:forEach items="${naviList}" var="p" varStatus="vs">
		naviList.push('${p}');
	</c:forEach>
	var currentNavi = naviList[parseInt(type)];

	var buttons = [
		{id:'intro',name:'游戏简介',action:goHome,left:[''], right:['vedio_0'], up:'search', down:'navi_0',linkImage:'${touming}', focusImage:'${templateImagePath}bg_belan_sel.png'},
		<c:if test="${isCollected}">
		{id:'fav',name:'收藏',type:'album',code:'${target}',action:goFav,left:['navi_0'], right:[''], up:'', down:'vedio_0',linkImage:'${templateImagePath}btn_alsave_nor.png', focusImage:'${templateImagePath}btn_alsave_sel.png'},
		</c:if>
		<c:if test="${!isCollected}">
		{id:'fav',name:'收藏',type:'album',code:'${target}',action:goFav,left:['navi_0'], right:[''], up:'', down:'vedio_0',linkImage:'${templateImagePath}btn_save_nor.png', focusImage:'${templateImagePath}btn_save_sel.png'},
		</c:if>

		<c:forEach items="${naviList}" var="p" varStatus="vs" begin="0" end="6">
		{id:'navi_${vs.index}',name:'导航${vs.index}',type:'${vs.index}',action:goList,left:[''], right:['vedio_0'], up:['navi_${vs.index-1}','sx'], down:'navi_${vs.index+1}',linkImage:'${touming}', focusImage:'${templateImagePath}bg_belan_sel.png'},
		</c:forEach>
		<c:forEach items="${pb.dataList}" var="p" varStatus="vs">
		{id:'vedio_${vs.index}',name:'列表${vs.index}',code:'${p.code}',index:'${vs.index}',action:goPlay,left:['${vs.index%4==0?'navi_0':''}','vedio_${vs.index-1}'], right:'vedio_${vs.index+1}', up:['vedio_${vs.index-4}','fav'], down:'vedio_${vs.index+4}',linkImage:'${touming}', focusImage:'${templateImagePath}button.png',focusHandler:marquess,blurHandler:stopmarquess,beforeMove:pn},
		</c:forEach>
	]


	function marquess(button){
		Epg.marquee.start(11,button.id+"_txt",7,80,'left','scroll');
	}

	function stopmarquess(button){

		Epg.marquee.stop();
	}

	function goFav(button){
		if(idFav){
			//如果已收藏，就取消收藏
			var param = "&type="+button.type+"&value="+button.code;
			$.ajax({
				url:'${basePath}fav.jsp?method=ajaxRemoveFav'+param,
				type:'GET',
				async:true,
				data:param,
				dataType:'json',
				success:function(data){
					//如果取消收藏成功
					idFav = false;
					G("fav").src = "${templateImagePath}btn_save_sel.png";
					button.linkImage = '${templateImagePath}btn_save_nor.png';
					button.focusImage = '${templateImagePath}btn_save_sel.png';
				},
				error:function(data){
					alert("收藏失败");
				}
			})
		}else{
			//如果未收藏就收藏
			var param = "&type="+button.type+"&value="+button.code;
			$.ajax({
				url:'${basePath}fav.jsp?method=ajaxFav'+param,
				type:'GET',
				async:true,
				data:param,
				dataType:'json',
				success:function(data){
					//如果收藏成功
					idFav = true;
					G("fav").src = "${templateImagePath}btn_alsave_sel.png";
					button.linkImage = '${templateImagePath}btn_alsave_nor.png';
					button.focusImage = '${templateImagePath}btn_alsave_sel.png';
				},
				error:function(data){
					alert("收藏失败");
				}
			})
		}
	}

	function goHome(button){

	}

	function goList(button){
		location.href = 'gameTemplate.jsp?method=list&code=${target}&f='+button.id+'&type='+button.type;
	}

	function goPlay(button){
		//playVideo(button.code, '');
		playProgram('${programId}',button.code,'');
	}

	//判断是否去上一页下一页
	function pn(dir,button){
		var currentPage = parseInt('${pb.current}');
		var pageCount = parseInt('${pb.pageCount}');
		if(button.index < 4){
			//说明是最上面一排
			if(dir == 'up'){
				//说明用户按了上
				if(currentPage > 1){
					//可以去上一页
					location.href = 'gameTemplate.jsp?method=list&code=${target}&type=${type}&p=${pb.current - 1}&f=vedio_0';
					return;
				}
			}
		}

		if(button.index > 7){
			//说明是最下面一排
			if(dir == 'down'){
				//说明用户按了下
				if(pageCount > currentPage){
					//说明还有下一页
					location.href = 'gameTemplate.jsp?method=list&code=${target}&type=${type}&p=${pb.current + 1}&f=vedio_0';
					return;
				}
			}
		}
	}

	function goColumn(button){
		if(button.id=="search"){
			var backURI  = escape("${currentURI}&f=search&dir=fallback");
			location.href = "${basePath}column/search/search.jsp?source=20170308_AllVedio_column&backURI="+backURI;
		}
	}

	function back(){
		location.href = "${backURI}";
	}

	Epg.key.set(
	{
		KEY_BACK:'back()',
	});

	window.onload=function()
	{
		Epg.btn.init(['${param.f}','vedio_0'],buttons,'${imagePath}',true);
	};
</script>
</head>
<body>
	<div style="position:absolute;left:0px;top:0px;width:230px;height:720px;background-color: #0b0e34; "></div>
	<!-- line -->
	<div style="position:absolute;left:60px;top:145px;">
	<img src="${templateImagePath}line_blue.png" width="1px" height ="${720-145}px"/>
	</div>


	<div style="position:absolute;left:0px;top:40px;font-size:28px;line-height:80px;width:205px;text-align:right;">
	<b>${epg.title}</b>
	</div>

	<div style="position:absolute;left:60px;top:145px;font-size:24px;line-height:31px;width:150px;text-align:right;color:#6aa6ff;">
	游戏简介
	</div>
	<div style="position:absolute;left:60px;top:145px;font-size:24px;line-height:31px;width:150px;text-align:right;color:#6aa6ff;">
	<img id="intro" src="${touming}" width="170px" height="60px" />
	</div>


	<div id="navi" style="position:absolute;left:60px;top:200px;width:170px;height:515px;overflow:hidden;">
	<c:forEach items="${naviList}" var="p" varStatus="vs" begin="0" end="6" >
		<div style="position:absolute;left:0px;top:${vs.index*75}px;font-size:14px;line-height:31px;text-align:right;width:150px;">
		<img id="navi_${vs.index}" src="${touming}" width="170px" height="60px" />
		</div>
	</c:forEach>
	<c:forEach items="${naviList}" var="p" varStatus="vs">
		<div id="navi_txt_${vs.index}" style="position:absolute;left:0px;top:${18+vs.index*75}px;font-size:14px;line-height:31px;text-align:right;width:150px;">
		${p}
		</div>
	</c:forEach>
	</div>

	<div style="position:absolute;top:24px;left:300px;font-weight:500;font-size:20px;color:#f0f0f0;line-height:40px;text-align:left;">游戏简介</div>

	<!-- 游戏说明 -->
	<div style="position:absolute;top:100px;left:300px;font-size:16px;color:#f0f0f0;line-height:35px;text-align:left;width:770px;height:170px;overflow:hidden;">${epg.intro}</div>

	<!-- 收藏按扭 -->
	<c:if test="${isCollected}">
	<div style="position:absolute;top:273px;left:297px;" ><img id="fav" src="${templateImagePath}btn_alsave_nor.png" width="111" height="41" /></div>
	</c:if>
	<c:if test="${!isCollected}">
	<div style="position:absolute;top:273px;left:297px;" ><img id="fav" src="${templateImagePath}btn_save_nor.png" width="111" height="41" /></div>
	</c:if>

	<div style="position:absolute;top:330px;left:300px;font-size:20px;color:#788195;line-height:18px;text-align:left;"><img src="${templateImagePath}line.png" />&nbsp;&nbsp;热门视频(${pb.rowCount})</div>


	<c:forEach items="${pb.dataList}" var="p" varStatus="vs">
	<div id="vedio_${vs.index}_div" style="overflow:hidden;">
	<div style="left:0px;top:0px;">
	<img src="${basePath}${p.thumbHD}" style="width:150px;height:84px;"/>
	</div>
	<div style="background-color: #505275; bottom:18px;left:0px;width:90px;height:20px;opacity:0.50;font-size:14px;" >播放：${p.hits}</div>
	<div id="vedio_${vs.index}_txt"  style="background-color: #505275; top:66px;left:0px;width:150px;height:20px;line-height:20px;padding-left:20px;overflow:hidden;" >${p.name}</div>
	</div>
	</c:forEach>

	<c:forEach items="${pb.dataList}" var="p" varStatus="vs">
		<img id="vedio_${vs.index}" src="${touming}" width="235px" height ="167px"/>
	</c:forEach>
	<%@include file="/com/com_bottom.jsp"%>

</body>
</html>
