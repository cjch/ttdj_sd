<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/com/com_head.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/tags/epg" prefix="epg" %>
<%@ taglib tagdir="/WEB-INF/tags/epg" prefix="e" %>
<title>剧集详细</title>
<%

	UserStore store = new UserStore(request, response);
	String userid = store.getUserid();	
	
	String seriesCode = HttpUtils.getString(request,"code","");
	String source = HttpUtils.getString(request,"source","seriesDetail");
	String COLUMN_CODE = "seriesDetail";//剧集详细
	String CURRENT_URI = BASE_PATH + "seriesDetail.jsp?code="+seriesCode;//当前页面访问地址
	imagePath = BASE_IMAGE_PATH + "com/seriesDetail/";//修正图片路径
	String comImagePath = BASE_IMAGE_PATH + "/com/";//修正图片路径

	//根据剧集code获取剧集详细信息 里面有剧集海报 文字说明 战对名称 剧集名称
	GetSeriesInfoRequest getSeriesInfoRequest = new GetSeriesInfoRequest();
	getSeriesInfoRequest.setSeriesCode(seriesCode);
	GetSeriesInfoResponse getSeriesInfoResponse = new SeriesExecutor(API_URL).getSeriesInfo(getSeriesInfoRequest);
	
	
	
	int p = HttpUtils.getInt(request,"p",-1);
	int idx = 0;
	if(p==-1){
		//说明用户第一次进来
		//获取上一次观看到哪一集
		GetWatchRecordRequest getWatchRecordRequest = new GetWatchRecordRequest();
		getWatchRecordRequest.setUserid(userid);
		getWatchRecordRequest.setSeriesCode(seriesCode);
		GetWatchRecordResponse getWatchRecordResponse = new WatchRecordExecutor(API_URL).getWatchRecord(getWatchRecordRequest);
		//用户已经观看到idx集
		idx = getWatchRecordResponse.getPosition();
		System.out.println("xxxxxxxx:"+idx);
		//计算该集在第几页
		p = (idx / 5) + 1;
	}
	
	//根据剧集code获取剧集所有子集信息
	GetVideoListRequest req = new GetVideoListRequest();
	req.setSeriesCode(seriesCode);
	req.setCurrent(p);
	req.setPageSize(5);
	req.setAppVersion(APP_VERSION);
	req.setPlatform(PLATFORM);
	req.setFormat(FORMAT);
	GetVideoListResponse rsp = new VideoExecutor(API_URL).list(req);

	//查看用户是否收藏了当前剧集
	IsCollectedRequest isCollectedRequest = new IsCollectedRequest();
	isCollectedRequest.setUserid(userid);
	isCollectedRequest.setType("series");
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
		"seriesInfo",getSeriesInfoResponse,
		"pb",rsp.getPb(),
		"idx",idx,
		"isCollected",isCollected
	);
	
%> 
<style type="text/css">
	body{
		margin:0;
		padding:0;
		color:#FFFFFF;
		background: transparent url('${comImagePath}bg.jpg') no-repeat;
	}
	#video_0_div{ position:absolute;left:60px; top:465px;width:233px;height:133px;}
	#video_1_div{ position:absolute;left:291px; top:465px;width:233px;height:133px;}
	#video_2_div{ position:absolute;left:522px; top:465px;width:233px;height:133px;}
	#video_3_div{ position:absolute;left:753px; top:465px;width:233px;height:133px;}
	#video_4_div{ position:absolute;left:984px; top:465px;width:233px;height:133px;}

	#video_0{position:absolute;left:40px;top:445px;width:240px;height:183px;}
	#video_1{position:absolute;left:271px;top:445px;width:240px;height:183px;}
	#video_2{position:absolute;left:502px;top:445px;width:240px;height:183px;}
	#video_3{position:absolute;left:733px;top:445px;width:240px;height:183px;}
	#video_4{position:absolute;left:964px;top:445px;width:240px;height:183px;}

	
</style>
<script src="${basePath}resources/js/jquery-v2.1.1.js"></script>
<script type="text/javascript">	

	//是否收藏过
	var idFav = ${isCollected};
	var focusFavImg;
	var linkFavImg
	if(idFav){
		focusFavImg = '${imagePath}btn_alsave_sel.png';
		linkFavImg = '${imagePath}btn_alsave_nor.png';
	}else{
		focusFavImg = '${imagePath}btn_save_sel.png';
		linkFavImg = '${imagePath}btn_save_nor.png';		
	}
	var buttons = [
		{id:'fullcreen',name:'全屏',action:fullcreen,left:[''], right:['fav'], up:'', down:'video_0',linkImage:'${imagePath}btn_quanping_nor.png', focusImage:'${imagePath}btn_quanping_sel.png'},
		{id:'fav',name:'收藏',action:goFav,type:'series',code:'${seriesInfo.seriesCode}',left:['fullcreen'], right:[''], up:'', down:'video_0',linkImage:linkFavImg, focusImage:focusFavImg},
		<c:forEach items="${pb.dataList}" var="p" varStatus="vs">
		{id:'video_${vs.index}',name:'剧集子集',action:goPlay,index:${vs.index},code:'${p.code}',left:['video_${vs.index-1}'], right:['video_${vs.index+1}'], up:'fullcreen', down:'page_0',linkImage:'${touming}', focusImage:'${comImagePath}button.png'},		
		</c:forEach>	
		


	]


	function fullcreen(button){
		//alert('${idx}');
		playSeries('${seriesInfo.seriesCode}',${idx},'');
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
					G("fav").src = "${imagePath}btn_save_sel.png";
					button.linkImage = '${imagePath}btn_save_nor.png';
					button.focusImage = '${imagePath}btn_save_sel.png';
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
					G("fav").src = "${imagePath}btn_alsave_sel.png";
					button.linkImage = '${imagePath}btn_alsave_nor.png';
					button.focusImage = '${imagePath}btn_alsave_sel.png';
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
		playSeries('${seriesInfo.seriesCode}',currentIdx,'');
	}
	
	function goList(button){
		location.href = "seriesDetail.jsp?code=${seriesInfo.seriesCode}&p="+(button.index+1);
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
			var html1 = "<div style='left:"+ 120*i +"px;top:0px;' ><img id='page_"+i+"' src='${imagePath}btn_jishu_nor.png' /></div>";
			var html2 = "<div id='page_"+i+"_txt' style='left:"+ 120*i +"px;top:0px;width:111px;height:41px;text-align:center;font-size:21px;line-height:41px;' >"+(i*5+1)+"-"+(i*5+5)+"期</div>";
			G("page").innerHTML += html1+html2;
			var button = 
			{id:'page_'+i,
			index:i,
			name:'分页',
			action:goList,
			code:'${seriesInfo.seriesCode}',
			left:'page_'+(i-1), 
			right:'page_'+(i+1),
			up:'video_0', 
			down:'',
			linkImage:'${imagePath}btn_jishu_nor.png', 
			focusImage:'${imagePath}btn_jishu_sel.png'
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
	<div style="position:absolute;left:60px;top:60px;" ><img src="${basePath}${seriesInfo.posterHD}" width="550" height="326" ></div>
	<!-- 播放图标 -->
	<div style="position:absolute;left:268px;top:185px;" ><img src="${imagePath}icon_play.png" width="72" height="72" ></div>
	<!-- 剧集名称 -->
	<div style="position:absolute;left:668px;top:62px;font-size:33px;color:#f0f0f0;width:500px;text-align:left;" >${seriesInfo.seriesName}</div>
	<!-- 剧集说明 -->
	<div style="position:absolute;left:665px;top:112px;font-size:21px;color:#f0f0f0;width:535px;height:218px;overflow:hidden;" >${seriesInfo.introduction}</div>

	<!-- 全屏 -->
	<div style="position:absolute;left:668px;top:345px;" ><img id="fullcreen" src="${imagePath}btn_quanping_nor.png" /></div>
	<div style="position:absolute;left:668px;top:345px;" ><img src="${touming}" width="111px" height="41px" /></div>
	<!-- 收藏 -->
	<c:if test="${isCollected == 'true'}">
	<div style="position:absolute;left:795px;top:345px;" ><img id="fav" src="${imagePath}btn_alsave_nor.png" /></div>
	</c:if>
	<c:if test="${isCollected == 'false'}">
	<div style="position:absolute;left:795px;top:345px;" ><img id="fav" src="${imagePath}btn_save_nor.png" /></div>
	</c:if>
	<div style="position:absolute;left:795px;top:345px;" ><img src="${touming}" width="111px" height="41px" /></div>


	<!-- 往期列表 -->
	<div style="position:absolute;left:65px;top:410px;font-size:21px;color:#f0f0f0;width:200px;height:30px;" ><img src="${imagePath}line.png" />&nbsp;&nbsp;往期列表</div>

	
	<c:forEach items="${pb.dataList}" var="p" varStatus="vs">
		<div id="video_${vs.index}_div">
		<div style="left:0px;top:0px;">
		<img src="${basePath}${p.thumbHD}" width="201px" height ="113px"/>
		</div>	
		<div id="video_${vs.index}_txt"  style="background-color: #505275; top:113px;left:0px;width:201px;height:30px;line-height:30px;padding-left:10px;" >${p.name}</div>
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