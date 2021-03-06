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
		background: transparent url('${comImagePath}bg.jpg') no-repeat;
	}
	#video_0_div{ position:absolute;left:60px; top:465px;width:200px;height:128px;}
	#video_1_div{ position:absolute;left:291px; top:465px;width:200px;height:128px;}
	#video_2_div{ position:absolute;left:522px; top:465px;width:200px;height:128px;}
	#video_3_div{ position:absolute;left:753px; top:465px;width:200px;height:128px;}
	#video_4_div{ position:absolute;left:984px; top:465px;width:200px;height:128px;}

	#video_0{position:absolute;left:40px;top:445px;width:240px;height:183px;}
	#video_1{position:absolute;left:271px;top:445px;width:240px;height:183px;}
	#video_2{position:absolute;left:502px;top:445px;width:240px;height:183px;}
	#video_3{position:absolute;left:733px;top:445px;width:240px;height:183px;}
	#video_4{position:absolute;left:964px;top:445px;width:240px;height:183px;}

	.btn-group img.btn_focus_effect-focus{
		border-radius: 4px;
	}

	.btn-group{
		text-align: center;
	}
	/*按钮高亮的时候，给图片加边距、颜色*/
	.btn-group.focused{
		padding: 2px;
		background-color: #4599ff;
		border-radius: 10px;
	//border:solid 1px #4a9bff;
		border:solid 3px #f0f0f0;
		box-shadow: 0px 0px 2px 3px #1465C9;

	}
	.btn-group img{
		display: inline-block;
		vertical-align: middle;
		-moz-border-radius:4px;
		-webkit-border-radius:4px;
		border-radius:4px;
		width: 100%;
		height: 100%;
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

	//有放大的效果 所以需要设置z index，
	var currentZindex = 100;
	var originData = {};
	function setZIndex(button){
		currentZindex++;
		G(button.id+"_div").style.zIndex  =  currentZindex;
		G(button.id+"_div").className = "btn-group focused";

		var width = 0;
		var height = 0;
		var top = 0;
		var left = 0;
		if(!originData[button.id+"_div"]){
			width = digitPX(getComputedStyle(G(button.id+"_div")).width);
			height = digitPX(getComputedStyle(G(button.id+"_div")).height);
			top = digitPX(getComputedStyle(G(button.id+"_div")).top);
			left = digitPX(getComputedStyle(G(button.id+"_div")).left);
			originData[button.id+"_div"] = width+":"+height+":"+top+":"+left;
		}else{
			var data = originData[button.id+"_div"].split(":");
			width =  data[0];
			height =  data[1];
			top = data[2];
			left = data[3];
		}

		top = top - 0.05*height;
		left = left - 0.05*width;

		G(button.id+"_div").style.width = width*1.1+"px";
		G(button.id+"_div").style.height = height*1.1+"px";

		G(button.id+"_div").style.top = top+"px";
		G(button.id+"_div").style.left = left +"px";
	}

	//获取去除px后的数值
	function digitPX(px){
		if(isNaN(px)){//带了p
			var after_px = parseInt(px.substr(0,px.indexOf("p")));
			return after_px;
		}else{
			return parseInt(px);
		}
	}
	
	function blurChangeBtnClass(button){
		//if(button.id == currentNavi)return;
		G(button.id+"_div").className = "btn-group";

		if(originData[button.id+"_div"]){
			var data = originData[button.id+"_div"].split(":");
			G(button.id+"_div").style.width = data[0] + "px";
			G(button.id+"_div").style.height = data[1] + "px";
			G(button.id+"_div").style.top = data[2] + "px";
			G(button.id+"_div").style.left = data[3] + "px";
		}
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
	});
	
	window.onload=function()
	{

		var currentPage = parseInt('${pb.current}');
		var totalPage = parseInt('${pb.pageCount}');
		for(var i=0 ; i < totalPage ; i++){
			var html1 = "<div style='left:"+ 120*i +"px;top:0px;' ><img id='page_"+i+"' src='${comImagePath}album/btn_jishu_nor.png' /></div>";
			var html2 = "<div id='page_"+i+"_txt' style='left:"+ 120*i +"px;top:0px;width:111px;height:41px;text-align:center;font-size:21px;line-height:41px;' >"+(i*5+1)+"-"+(i*5+5)+"期</div>";
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
		Epg.btn.init(['${param.f}','fullcreen'],buttons,'${imagePath}',true);
	};
	
</script>
</head>
<body>
	
	<!-- 左上角 剧集海报 -->
	<div style="position:absolute;left:60px;top:60px;" ><img src="${basePath}${epg.thumb}" width="550" height="326" ></div>
	<!-- 播放图标 -->
	<div style="position:absolute;left:268px;top:185px;" ><img src="${comImagePath}album/icon_play.png" width="72" height="72" ></div>
	<!-- 剧集名称 -->
	<div style="position:absolute;left:668px;top:62px;font-size:33px;color:#f0f0f0;width:500px;text-align:left;" >${epg.title}</div>
	<!-- 剧集说明 -->
	<div style="position:absolute;left:665px;top:112px;font-size:21px;color:#f0f0f0;width:535px;height:218px;overflow:hidden;" >${epg.intro}</div>

	<!-- 全屏 -->
	<div style="position:absolute;left:48px;top:49px;" ><img id="fullcreenBig" src="${touming}" /></div>
	<div style="position:absolute;left:668px;top:345px;" ><img id="fullcreen" src="${comImagePath}album/btn_quanping_nor.png" /></div>
	<div style="position:absolute;left:668px;top:345px;" ><img src="${touming}" width="111px" height="41px" /></div>
	<!-- 收藏 -->
	<c:if test="${isCollected == 'true'}">
	<div style="position:absolute;left:795px;top:345px;" ><img id="fav" src="${comImagePath}album/btn_alsave_nor.png" /></div>
	</c:if>
	<c:if test="${isCollected == 'false'}">
	<div style="position:absolute;left:795px;top:345px;" ><img id="fav" src="${comImagePath}album/btn_save_nor.png" /></div>
	</c:if>
	<div style="position:absolute;left:795px;top:345px;" ><img src="${touming}" width="111px" height="41px" /></div>


	<!-- 往期列表 -->
	<div style="position:absolute;left:65px;top:410px;font-size:21px;color:#f0f0f0;width:200px;height:30px;" ><img src="${comImagePath}album/line.png" />&nbsp;&nbsp;往期列表</div>

	
	<c:forEach items="${pb.dataList}" var="p" varStatus="vs">
		<div id="video_${vs.index}_div" class="btn-group">
		<div style="left:0px;top:0px;" >
		<img src="${basePath}${p.thumbHD}" width="201px" height ="113px"/>
		</div>	
		<!-- <div id="video_${vs.index}_txt"  style="background-color: #505275; top:113px;left:0px;width:201px;height:30px;line-height:30px;padding-left:10px;" >${p.name}</div>-->
		</div>
	</c:forEach>
	<c:forEach items="${pb.dataList}" var="p" varStatus="vs">
		<img id="video_${vs.index}" src="${touming}" width="235px" height ="167px"/>
	</c:forEach>	
	<!-- 分期 -->
	<div id="page" style="position:absolute;left:60px;top:630px;"></div>

	
	<%@include file="/com/com_bottom.jsp"%>
	
	
</body>
</html>