<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/com/com_head.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/tags/epg" prefix="epg" %>
<%@ taglib tagdir="/WEB-INF/tags/epg" prefix="e" %>
<title>剧集详细</title>
<%

	UserStore store = new UserStore(request, response);
	String userid = store.getUserid();

	String seriesCode = HttpUtils.getString(request,"code","20170323_wysdh_album");
	String source = HttpUtils.getString(request,"source","seriesDetail");
	String COLUMN_CODE = seriesCode;//剧集详细
	String CURRENT_URI = BASE_PATH + "album/seriesTemplate.jsp?code="+seriesCode;//当前页面访问地址
	imagePath = BASE_IMAGE_PATH + "album/"+seriesCode+"/";//修正图片路径
	String comImagePath = BASE_IMAGE_PATH + "/com/";//修正图片路径


	//根据CODE获取album信息
	Epg epg = getEpg(COLUMN_CODE);

	//获取节目单
	List<EpgMetadataGroup> groupList = epg.getGroups();
	int programId = Integer.parseInt(groupList.get(0).getMetadatas().get(0).getValue());
	GetProgramRequest req = new GetProgramRequest();
	req.setId(programId);
	req.setCurrent(HttpUtils.getInt(request, "p", 1));
	req.setPageSize(5);
	GetProgramResponse resp = new ProgramExecutor(API_URL).get(req);

	//查看用户是否收藏了当前剧集
	IsCollectedRequest isCollectedRequest = new IsCollectedRequest();
	isCollectedRequest.setUserid(userid);
	isCollectedRequest.setType("album");
	isCollectedRequest.setRole("guest");
	isCollectedRequest.setValue(seriesCode);
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
		"comImagePath", comImagePath,
		"backURI", getBackURI(request, response),//返回路径
		"currentURI", CURRENT_URI,//当前页面路径
		"target", COLUMN_CODE,//记录日志用到的target
		"epg",epg,
		"pb",resp.getPb(),
		"isCollected",isCollected,
		"programId",programId
	);

%>
<style type="text/css">
	body{
		margin:0;
		padding:0;
		color:#FFFFFF;
		/*background: transparent url('${comImagePath}album/bg2.png') no-repeat;*/
		background: #5E868A;
	}
	#video_0_div{ position:absolute;left:21px; top:393px;width:118px;height:84px;}
	#video_1_div{ position:absolute;left:159px; top:393px;width:118px;height:84px;}
	#video_2_div{ position:absolute;left:297px; top:393px;width:118px;height:84px;}
	#video_3_div{ position:absolute;left:435px; top:393px;width:118px;height:84px;}
	#video_4_div{ position:absolute;left:573px; top:393px;width:118px;height:84px;}

	#video_0{position:absolute;left:21px;top:393px;width:125px;height:95px;}
	#video_1{position:absolute;left:159px;top:393px;width:125px;height:95px;}
	#video_2{position:absolute;left:297px;top:393px;width:125px;height:95px;}
	#video_3{position:absolute;left:435px;top:393px;width:125px;height:95px;}
	#video_4{position:absolute;left:573px;top:393px;width:125px;height:95px;}

	.btn-group img.btn_focus_effect-focus{
		border-radius: 4px;
	}

	.btn-group{
		text-align: center;
		overflow:hidden;
		position: absolute;
		left: 21px;
		top: 353px;
		width: 118px;
		height: 84px;
	}
	/*按钮高亮的时候，给图片加边距、颜色*/
	.btn-group.focused{
		padding: 2px;
		background-color: #4599ff;
		border-radius: 10px;
	//border:solid 1px #4a9bff;
		border:solid 3px #f0f0f0;
		box-shadow: 0px 0px 2px 3px #1465C9;
		overflow: hidden;
	}
	.btn-group img{
		display: inline-block;
		vertical-align: middle;
		-moz-border-radius:4px;
		-webkit-border-radius:4px;
		border-radius:4px;
		/*width: 201px;
		height: 113px;*/
	}

</style>
<script src="${basePath}resources/js/jquery-v2.1.1.js"></script>
<script type="text/javascript">

	//是否收藏过
	var idFav = ${isCollected};
	var focusFavImg;
	var linkFavImg
	if(idFav){
		focusFavImg = '${comImagePath}album/btn_alsave_sel.png';
		linkFavImg = '${comImagePath}album/btn_alsave_nor.png';
	}else{
		focusFavImg = '${comImagePath}album/btn_save_sel.png';
		linkFavImg = '${comImagePath}album/btn_save_nor.png';
	}
	var buttons = [
		{id:'fullcreenBig',name:'全屏大',action:fullcreen,left:[''], right:['fullcreen'], up:'', down:'video_0',linkImage:'${touming}', focusImage:'${comImagePath}album/button.png'},
		{id:'fullcreen',name:'全屏小',action:fullcreen,left:['fullcreenBig'], right:['fav'], up:'', down:'video_0',linkImage:'${comImagePath}album/btn_quanping_nor.png', focusImage:'${comImagePath}album/btn_quanping_sel.png'},
		{id:'fav',name:'收藏',action:goFav,type:'album',code:'${epg.code}',left:['fullcreen'], right:[''], up:'', down:'video_0',linkImage:linkFavImg, focusImage:focusFavImg},
		<c:forEach items="${pb.dataList}" var="p" varStatus="vs">
		{id:'video_${vs.index}',name:'剧集子集',action:goPlay,index:${vs.index},code:'${p.code}',left:['video_${vs.index-1}'], right:['video_${vs.index+1}'], up:'fullcreen', down:'page_0',linkImage:'${touming}', focusHandler:setZIndex,blurHandler:blurChangeBtnClass},
		</c:forEach>
	]

	function pAndp(button){
		//暂停  播放
		videoWindow.Epg.Mp.playOrPause();
	}

	//有放大的效果 所以需要设置z index，
	var currentZindex = 100;
	function setZIndex(button){
		currentZindex++;
		G(button.id+"_div").style.zIndex  =  currentZindex;
		G(button.id+"_div").className = "btn-group focused";
	}

	function blurChangeBtnClass(button){
		//if(button.id == currentNavi)return;
		G(button.id+"_div").className = "btn-group";
	}

	function fullcreen(button){
		//alert('${idx}');
		//playSeries('${seriesInfo.seriesCode}');
		playProgram('${programId}');
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
					G("fav").src = "${comImagePath}album/btn_save_sel.png";
					button.linkImage = '${comImagePath}album/btn_save_nor.png';
					button.focusImage = '${comImagePath}album/btn_save_sel.png';
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
					G("fav").src = "${comImagePath}album/btn_alsave_sel.png";
					button.linkImage = '${comImagePath}album/btn_alsave_nor.png';
					button.focusImage = '${comImagePath}album/btn_alsave_sel.png';
				},
				error:function(data){
					alert("收藏失败");
				}
			})
		}
	}

	function goPlay(button){
		//计算当前按扭是哪一集 页码*5+button.index
		var currentPage = parseInt('${pb.current}');

		var currentIdx = (currentPage-1)*5 + button.index;
		//alert(currentIdx);
		//playSeries('${seriesInfo.seriesCode}',currentIdx,'');
		playProgram('${programId}',button.code);
	}

	function goList(button){
		location.href = "seriesTemplate.jsp?code=${epg.code}&p="+(button.index+1);
	}

	function back(){
		location.href = "${backURI}";
	}

	Epg.key.set(
	{
		KEY_BACK:'back()',
		KEY_PLAY_PAUSE:'videoWindow.Epg.Mp.playOrPause()',
		EVENT_MEDIA_END:'playNext()',
		EVENT_MEDIA_ERROR:'playNext()'
	});

	function playNext(){

		G("videoFrame").src = '${basePath}media_player.jsp?method=playFromProgram&mp=${programId}&programId=${programId}&mode=singleCycleForever&dolog=false&display=smallvod&left=60&top=55&width=330&height=186&source=${target}&sourceType=column&metadataType=smallvod';

	}

	window.onload=function()
	{

		var currentPage = parseInt('${pb.current}');
		var totalPage = parseInt('${pb.pageCount}');
		for(var i=0 ; i < totalPage ; i++){
			var html1 = "<div style='left:"+ 65*i +"px;top:-100px;' ><img id='page_"+i+"' src='${comImagePath}album/btn_jishu_nor.png' width='62px'; height='23px'; /></div>";
			var html2 = "<div id='page_"+i+"_txt' style='left:"+ 65*i +"px;top:-100px;width:62px;height:23px;text-align:center;font-size:14px;line-height:23px;' >"+(i*5+1)+"-"+(i*5+5)+"期</div>";
			G("page").innerHTML += html1+html2;
			var button =
			{id:'page_'+i,
			index:i,
			name:'分页',
			action:goList,
			code:'${epg.code}',
			left:'page_'+(i-1),
			right:'page_'+(i+1),
			up:'video_0',
			down:'',
			linkImage:'${comImagePath}album/btn_jishu_nor.png',
			focusImage:'${comImagePath}album/btn_jishu_sel.png'
			};
			buttons.push(button);
		}

		G("page_${pb.current - 1}_txt").style.color = "#6aa6ff";

		//暂停小视频
		setTimeout(function(){
			videoWindow.Epg.Mp.playOrPause();
		},3000);

		Epg.btn.init(['${param.f}','fullcreenBig'],buttons,'${imagePath}',true);
	};

</script>
</head>
<body>

	<!-- 小视频 -->
	<div style="position:absolute; left:21px; top:105px; width:330px; height:186px;background:yellow;">
		<iframe id="videoFrame" name="videoFrame" src="${basePath}media_player.jsp?method=playFromProgram&mp=${programId}&programId=${programId}&mode=listRandomForever&dolog=false&display=smallvod&left=60&top=55&width=330&height=186&source=${target}&sourceType=column&metadataType=smallvod" width="1" height="1" bgcolor="transparent" allowtransparency="true" frameborder="0" scrolling="no"></iframe>
	</div>
	<!-- 播放图标
	<div style="position:absolute;left:268px;top:185px;" ><img src="${comImagePath}album/icon_play.png" width="72" height="72" ></div>
	-->
	<!-- 剧集名称 -->
	<div style="position:absolute;left:365px;top:105px;font-size:18px;color:#f0f0f0;font-weight:500;width:400px;text-align:left;" >${epg.title}</div>
	<!-- 剧集说明 -->
	<div style="font-size14px;position:absolute;top:140px;left:365px;">
		<span style="padding-right:10px;">特色专栏</span>|
		<span style="padding-right:10px;padding-left:10px;">英雄联盟</span>|
		<span style="padding-left:10px;">总观看次数：64.5万</span>
	</div>
	<div style="position:absolute;left:365px;top:165px;font-size:14px;color:#f0f0f0;width:400px;height:218px;overflow:hidden;opacity:.5;" >${epg.intro}</div>

	<!-- 全屏 -->
	<div style="position:absolute;left:-5px;top:89px;" ><img id="fullcreenBig" src="${touming}" width="380px" height="220px" /></div>
	<div style="position:absolute;left:395px;top:250px;" ><img id="fullcreen" src="${comImagePath}album/btn_quanping_nor.png" /></div>
	<div style="position:absolute;left:395px;top:250px;" ><img src="${touming}" width="100px" height="40px" /></div>
	<!-- 收藏 -->
	<c:if test="${isCollected == 'true'}">
	<div style="position:absolute;left:515px;top:250px;" ><img id="fav" src="${comImagePath}album/btn_alsave_nor.png" /></div>
	</c:if>
	<c:if test="${isCollected == 'false'}">
	<div style="position:absolute;left:515px;top:250px;" ><img id="fav" src="${comImagePath}album/btn_save_nor.png" /></div>
	</c:if>
	<div style="position:absolute;left:515px;top:250px;" ><img src="${touming}" width="100px" height="40px" /></div>


	<!-- 往期列表 -->
	<div style="position:absolute;left:21px;top:355px;font-size:16px;opacity:.5;color:#f0f0f0;width:200px;height:30px;" >
		<img style="height:16px;vertical-align:-1px;" src="${comImagePath}album/line.png" />
		<span style="padding-left:10px;">往期列表</span></div>


	<c:forEach items="${pb.dataList}" var="p" varStatus="vs">
		<div id="video_${vs.index}_div" class="btn-group">
		<div style="left:0px;top:0px;width:122px;height:113px" >
		<img src="${basePath}${p.thumbHD}" width="122px" height ="88px"/>
		</div>
		<div id="video_${vs.index}_txt"  style="background-color: #505275; top:65px;left:-2px;width:145px;height:14px;line-height:14px;padding-top:4px;padding-bottom:2px;padding-left:5px;" >${p.name}</div>
		</div>
	</c:forEach>
	<c:forEach items="${pb.dataList}" var="p" varStatus="vs">
		<img id="video_${vs.index}" src="${touming}" width="122px" height ="88px" style="outine:1px solid red;"/>
	</c:forEach>
	<!-- 分期 -->
	<div id="page" style="position:absolute;left:21px;top:630px;"></div>


	<%@include file="/com/com_bottom.jsp"%>


</body>
</html>
