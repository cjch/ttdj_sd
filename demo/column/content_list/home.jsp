<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/com/com_head.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/tags/epg" prefix="epg" %>
<%@ taglib tagdir="/WEB-INF/tags/epg" prefix="e" %>
<title>内容列表</title>
<%!
	public static final String COLUMN_CODE = "content_list";//栏目名称
	public static final String CURRENT_URI = BASE_PATH + "column/content_list/home.jsp?1=1";//当前页面访问地址
%>
<%
	UserStore store = new UserStore(request,response);
	String seriesCode = getParam(request, "code", "1000443");//剧集code
	String elementCodeSrc = getParam(request, "elementCodeSrc", "0");//栏目索引，记录日志需要，如“01”
	String flag = getParam(request, "flag", "");//标记翻页，上翻页带参数pageUp，向下翻页pageDown，记录页面来源是内容列表还是栏目
	int p = getParamInt(request, "p", 1);//页码
	//以下3个字段一般每个页面都需要设置
	setAttr
	(
		request,
		"currentURI", CURRENT_URI+"&code="+seriesCode+"&elementCodeSrc="+elementCodeSrc,//当前页面URL
		"backURI", getBackURI(request, response),//返回路径
		"target", seriesCode,
		"targetType", "series"
	);
	
	//获取观看记录，一来是获取上次观看的集数，二来是获取专辑的相关信息
	GetWatchRecordResponse watchRecordResponse=post
	(
		"record/get-watch-record", GetWatchRecordResponse.class,
		"userid", store.getUserid(),
		"role", store.getRole(),
		"isCalMark", "no",
		"seriesCode", seriesCode
	);
	int lastPosition = watchRecordResponse.getPosition();
	String introduction = watchRecordResponse.getIntroduction();
	boolean isScroll = false;
	if(introduction.length()>40){
		//introduction = introduction.substring(0,38)+"...";
		isScroll = true;
	}
	String bottomMsg = "";
	if(lastPosition>0){
		bottomMsg = "上次观看到第"+lastPosition+"集";
	}
	
	//解决bug:上次播放剧集不是在第一页，进入剧情页面，翻页，不能翻到第一页
	if("".equals(flag) && p==1 && lastPosition>10)
		p = lastPosition/10 + (lastPosition%10>0?1:0);
	
	//判断是否收藏
	FavoritesExecutor exec3 = new FavoritesExecutor(API_URL);
	IsCollectedRequest req3 = new IsCollectedRequest();
	req3.setAppVersion(APP_VERSION);
	req3.setType("series");
	req3.setRole(store.getRole());
	req3.setUserid(store.getUserid());
	req3.setValue(seriesCode);
	IsCollectedResponse rsp3 = exec3.isCollected(req3);
	
	//获取视频列表
	GetVideoListResponse getVideoListResponse = post
	(
		"video/list", GetVideoListResponse.class,
		"seriesCode", seriesCode,
		"current", p,
		"pageSize", 10,
		"appVersion", APP_VERSION,
		"platform", PLATFORM,
		"format", FORMAT
	);
	List<VideoBean> videoList = getVideoListResponse.getPb().getDataList();
	
	//获取上次观看集数在界面的按钮ID
	String lastWatchVideoButtonId="";//上一次观看视频在界面的按钮ID
	for(int i=0; i<videoList.size(); i++)
	{
		if(videoList.get(i).getPosition() == lastPosition)
			lastWatchVideoButtonId = "video_" + i/10 + "_0";
	}

	if(!"".equals(flag))
		lastWatchVideoButtonId="";
	
	/** GetSameSeriesRequest req = new GetSameSeriesRequest();
	req.setSize(2);
	req.setTags(watchRecordResponse.getTags());
	req.setCode(seriesCode);
	SeriesExecutor exec = new SeriesExecutor(API_URL);
	GetSameSeriesResponse resp = exec.getSameSeries(req); **/
	
	List<EpgMetadataGroup> groupList = getEpg(COLUMN_CODE).getGroups();
	
	List<EpgMetadata> recommendList = groupList.get(0).getMetadatas();
	
	setAttr
	(
		request,
		"pb", getVideoListResponse.getPb(),//数据对象
		"seriesCode", seriesCode,//专辑code
		"isCollected",rsp3.isCollected(),
		"watchRecord", watchRecordResponse,//观看记录对象
		"introduction",introduction,
		"isScroll",isScroll,
		"lastWatchVideoButtonId", lastWatchVideoButtonId,//上一次观看视频在界面的按钮ID
		//"recommendList", resp.getSeries(),//取出中间推荐位
		"recommendList", recommendList,
		"flag", flag,
		"bottomMsg",bottomMsg
	);
%>

<%-------------------------- 与样式相关代码开始 ----------------------------%>
<!-- 如果是标清版 -->
<c:if test="${isSD}">
	<%
		setAttr
		(
			request,
			"videoLeftStart", 191,//视频left起始
			"videoTopStart", 114,//视频top起始
			"videoLeftAdd", 0,//视频left递增
			"videoTopAdd", 34,//视频top递增
			"focusLeftAdjust", -9,//视频焦点图left调整
			"focusTopAdjust", -12//视频焦点图top调整
		);
	%>
	<style type="text/css">
	/*播放*/
	div#fav_div{left:472px; top:95px;}
	img#fav{width:35px; height:74px;}
	/*封面*/
	div#cover_div{left:37px; top:86px;}
	img#cover{width:136px; height:268px;}
	/*主演*/
	div.seriesActor{left:68px;top:366px;width: 106px;color: white;font-size: 14px;height:22px;overflow: hidden;color:#B3B3B3;}
	/*简介*/
	div.seriesDesc{left:68px;top:390px;width: 106px;color: white;font-size: 14px;height:92px;overflow: hidden;color:#B3B3B3;}
	/*剧集名称*/
	div.seriesName{color: #EEEEEE;left: 52px;top: 48px;width: 440px;color: white;font-size: 22px;height: 42px;overflow: hidden;}
	/*上次观看集数*/
	div.seriesPosition{left: 282px;top: 448px;color: #91766f;font-size:16px;font-weight:bold;}
	/*没有分页时的提示*/
	div#no_page_tip{left: 180px;top: 300px;font-size: 20px;color: rgb(0, 126, 65);}
	/*剧集相关*/
	img.video_f{width:276px;height:31px;}
	/*分页相关*/
	div.page_img_div{left:472px; top:212px;}
	/*页码信息*/
	div.page_info{
		color: #b2bdc4;
	    font-size: 16px;
	    height: 48px;
	    left: 480px;
	    line-height: 25px;
	    text-align: center;
	    top: 246px;
	    width: 20px
	}
	/*视频名称*/
	div.videoName{left: 6px;top: -5px;width: 265px;color:#ffffff;font-size: 16px;height: 19px;overflow: hidden;}
	/**推荐位*/
	div.album_0_div{left:523px; top:124px;}
	div.album_1_div{left:523px; top:310px;}
	img.album_img{position:absolute;left:-0px;top:-0px;width:83px; height:156px;}
	img.album_img_b{position:absolute;left:-5px;top:-7px;width:93px; height:170px;}
	img.album_f{position:absolute;left:-7px;top:-10px;width:97px; height:175px;}
	</style>
</c:if>
<!-- 如果是高清版 -->
<c:if test="${!isSD}">
	<%
		setAttr
		(
			request,
			"videoLeftStart", 383,//视频left起始 383
			"videoTopStart", 150,//视频top起始  150
			"videoLeftAdd", 0,//视频left递增
			"videoTopAdd", 46,//视频top递增
			"focusLeftAdjust", -9,//视频焦点图left调整
			"focusTopAdjust", -12//视频焦点图top调整
		);
	%>
	<style type="text/css">
	/*播放*/
	div#fav_div{left:939px; top:136px;}
	img#fav{width:67px; height:97px;}
	/*封面*/
	div#cover_div{left:74px; top:119px;}
	img#cover{width:271px; height:371px;}
	/*主演*/
	div.seriesActor{
		color: #b3b3b3;
	    font-size: 18px;
	    height: 22px;
	    left: 142px;
	    overflow: hidden;
	    top: 495px;
	    width: 204px;
	}
	/*简介*/
	div.seriesDesc{
		color: #b3b3b3;
	    font-size: 18px;
	    height: 128px;
	    left: 142px;
	    overflow: hidden;
	    top: 525px;
	    width: 204px;
	}
	/*剧集名称*/
	div.seriesName{
		color: #EEEEEE;
	    font-size: 32px;
	    height: 42px;
	    left: 112px;
	    overflow: hidden;
	    top: 64px;
	    width: 840px;
	}
	/*上次观看集数*/
	div.seriesPosition{left: 578px;top: 610px;color: #91766f;font-size:18px;font-weight:bold;}
	/*没有分页时的提示*/
	div#no_page_tip{left: 180px;top: 300px;font-size: 20px;color: rgb(0, 126, 65);}
	/*剧集相关*/
	img.video_f{width:552px;height:41px;}
	/*分页相关*/
	div.page_img_div{left:945px; top:288px;}
	/*页码信息*/
	div.page_info{
		color: #b2bdc4;
	    font-size: 26px;
	    height: 62px;
	    left: 960px;
	    line-height: 40px;
	    text-align: center;
	    top: 348px;
	    width: 35px;
	}
		/** ott页码 */
	div.page_img_div_up{left:945px; top:288px;}
	div.page_img_div_down{left:945px; top:388px;}
	/*页码信息*/
	div.page_info_ott{
		color: #b2bdc4;
	    font-size: 26px;
	    height: 62px;
	    left: 935px;
	    line-height: 40px;
	    text-align: center;
	    top: 448px;
	    width: 80px;
		
	}
	/*视频名称*/
	div.videoName{
		color: #ffffff;
	    font-size: 26px;
	    height: 32px;
	    left: 6px;
	    overflow: hidden;
	    top: -8px;
	    width: 540px;
	    text-align: left;
	}
	/**推荐位*/
	div.album_0_div{left:1045px; top:170px;}
	div.album_1_div{left:1045px; top:423px;}
	img.album_img{position:absolute;left:0px;top:0px;width:168px; height:210px;}
	img.album_img_b{position:absolute;left:-8px;top:-8px;width:185px; height:231px;}
	img.album_f{position:absolute;left:-10px;top:-10px;width:188px; height:236px;}
	</style>
</c:if>
<%-------------------------- 与样式相关代码结束----------------------------%>


	<script type="text/javascript">
	var pnFocus=false,pn='';
	var buttons = 
	[
		{id:'back',action:'back()',linkImage:'${comImagePath}back.png',focusImage:'${comImagePath}back_f.png',left:['fav','video_0_0'],down:'recommend_0'},
		{id:'fav',action:fav,linkImage:'${imagePath}${isCollected?"collected":"fav"}.png',focusImage:'${imagePath}${isCollected?"collected_f":"fav_f"}.png',left:'video_0_0',right:'recommend_0',down:['page_no','page_up'],up:'back'},
		<epg:forEach items="${pb.dataList }" var="p" column="1">
			{id:'video_${r}_${c}',idx:'${p.position}',animate:false,action:play,linkImage:'${toming}',focusImage:'${imagePath}video_f.png',left:'',right:['${r<2?"fav":"page_no"}','${r<6?"page_up":"page_down"}'],up:'video_${r-1}_${c}',down:'video_${r+1}_${c}',focusHandler: focusAlbum,blurHandler: blurAlbum},
		</epg:forEach>

		<c:choose>
		<c:when test="${isOTT }">
		{id:'page_up',action:pageChange,left:['video_4_0','video_3_0','video_2_0','video_1_0','video_0_0'], up:'fav',down:'page_down',right:'recommend_0',linkImage:'${imagePath}page_up.png', focusImage:'${imagePath}page_up_f.png'},
		{id:'page_down',action:pageChange,left:['video_4_0','video_3_0','video_2_0','video_1_0','video_0_0'], up:'page_up',down:'',right:'recommend_1',linkImage:'${imagePath}page_down.png', focusImage:'${imagePath}page_down_f.png',},
		 </c:when>
		 <c:otherwise>
		{id:'page_no',action:pageChange,left:['video_4_0','video_3_0','video_2_0','video_1_0','video_0_0'], up:'',down:'',right:'recommend_1',linkImage:'${imagePath}page_no.png', focusImage:'${imagePath}page_no_f.png',moveHandler:pageMoveHandler},
		 </c:otherwise>
		 </c:choose>
		 
		{id:'recommend_0',type:'${recommendList[0].type}',code:'${recommendList[0].value}',action:'enterRecommend()',focusImage:'${comImagePath}album_f.png',left:['page_up','fav'],down:'recommend_1',up:'back',focusHandler:showBigImage,blurHandler:showSmallImage},
		{id:'recommend_1',type:'${recommendList[1].type}',code:'${recommendList[1].value}',action:'enterRecommend()',focusImage:'${comImagePath}album_f.png',left:['video_9_0','video_8_0','video_7_0','page_no','page_down','fav'],up:'recommend_0',focusHandler:showBigImage,blurHandler:showSmallImage}
	];
	
	function getStrLength(str) {  
	    var cArr = str.match(/[^\x00-\xff]/ig);  
	    return str.length + (cArr == null ? 0 : cArr.length);  
	}  
	
	//聚焦到视频信息上时开始滚动字幕
	function focusAlbum(button)
	{
		console.log(333)
		Epg.marquee.start(11,button.id+"_txt",7,80,'left','scroll');
	}
	
	//焦点离开视频信息时停止字幕
	function blurAlbum()
	{
		Epg.marquee.stop();
	}
	
	/*进入推荐位*/
	function enterRecommend()
	{
		var btn = epg.btn.current;
		epg.go('column/content_list/home.jsp?code='+btn.code+'&elementCodeSrc=${columnIdx}', btn.code);
		
	}
	
	function showBigImage(current){
		G(current.id+'_image').className = "album_img_b";
	}
	
	function showSmallImage(previous){
		G(previous.id+'_image').className = "album_img";
	}
	
	/** 收藏*/
	function fav(button){
		if('${isCollected}'=='true'){
			location.href = '${basePath}media_player.jsp?method=removeFav&type=series&value=${seriesCode}&f=fav&returnURI='+escape('${currentURI}');
		}else{
			location.href = '${basePath}media_player.jsp?method=fav&type=series&value=${seriesCode}&f=fav&returnURI='+escape('${currentURI}');
		}
	}
	
	function pageMoveHandler(previous,current,dir){
		if((previous.id=='video_0_0'||previous.id=='page_no')&&dir=='up'&&'${pb.current}'!=1){
			pageUp();
		}else if((previous.id=='video_9_0'||previous.id=='page_no')&&dir=='down'){
			pageDown();
		}else if(previous.id=='video_0_0'&&dir=='up'&&'${pb.current}'==1){
			Epg.tip('已经是第一页了！');
			Epg.btn.set('back');
		}else if(previous.id=='page_no'&&dir=='up'&&'${pb.current}'==1){
			Epg.tip('已经是第一页了！');
			Epg.btn.set('fav');
		}
	}
	
	function pageChange(button){
		if(button.id==='page_up'){
			pageUp();
		}else if (button.id ==='page_down'){
			 pageDown();
		}else{
			var page = +G('pageNum').innerHTML;
			if(page){
				Epg.page('${currentURI}&flag=pageUp&p=',page);
			}
		}
	}
	//返回
	function back()
	{
		location.href = '${backURI}';
	}
	
	//从某一集开始播放视频，不传默认上次播放的集数
	function enterVideo(idx)
	{
		idx = idx||'${watchRecord.position}'||1;//不传idx默认上次播放的集数
		playSeries('${seriesCode}', idx, '${param.elementCodeSrc}');
	}
	
	//播放某一集视频
	function play(current)
	{
		enterVideo(current.idx);
	}
	
	//上一页
	function pageUp()
	{
		Epg.page('${currentURI}&flag=pageUp&p=','${pb.current-1}');
	}
	
	//下一页
	function pageDown()
	{
		Epg.page('${currentURI}&flag=pageDown&p=','${pb.current+1}','${pb.pageCount}');
	}
	
	//设置返回键事件
	Epg.key.set(
	{
		KEY_PAGE_UP:'pageUp()',
		KEY_PAGE_DOWN:'pageDown()'
	});
	
	window.onload=function()
	{
		Epg.tip('${param.info}');//显示info信息，3秒后自动隐藏，如果info为空将不会显示
		Epg.btn.init(['${param.f}','${lastWatchVideoButtonId}','video_0_0','fav','back'],buttons,'',true);
	};
		
	</script>
</head>
<body style="background-image: url('${imagePath}background.jpg')">
	<div class="back_img_div">
		<img id="back" alt="返回" src="${comImagePath}back.png">
	</div>
	<!-- 播放-->
	<div id="fav_div"><img id="fav" src="${imagePath}${isCollected?'collected':'fav'}.png"/></div>
	
	<!-- 封面-->
	<div id="cover_div">
		<img id="cover" src="${basePath}${isSD?watchRecord.posterSD:watchRecord.posterHD}"/>
	</div>
	<!-- 主演 -->
	<div class="seriesActor">${watchRecord.actor }</div>
	<div class="seriesDesc">
	<c:choose>
		<c:when test="${isScroll}">
			<marquee width="100%" height="100%" behavior="scroll" direction="up" scrollamount="1" scrolldelay="50">
				${introduction}
			</marquee>
		</c:when>
		<c:otherwise>
			${introduction}
		</c:otherwise>
	</c:choose>
	</div>
	<!-- 剧集名称 -->
	<div class="seriesName">${watchRecord.seriesName }</div>
	
	<!-- 上次观看集数-->
	<div class="seriesPosition">${bottomMsg }</div>
	
	<!-- 如果没有数据 -->
	<c:if test="${pb.pageCount<=0}">
		<div id="no_page_tip">对不起，没有找到指定的数据哦！</div>
	</c:if>
	
	<c:if test="${pb.pageCount>0 }">
		<!-- 视频列表 -->
		<epg:forEach items="${pb.dataList}" var="p" column="1">
			<div style="left:${videoLeftStart}px;top:${videoTopStart+r*videoTopAdd}px;" >
				<div id="video_${r}_${c}_txt" class="videoName">${p.position}.${p.name}</div>
			</div>
			<div style="left:${videoLeftStart}px;top:${videoTopStart+r*videoTopAdd+focusTopAdjust}px;z-index:100;">
				<img id="video_${r}_${c}" src="${touming}" class="video_f"/>
			</div>
		</epg:forEach>
		 <c:choose>
		 <c:when test="${isOTT }">
		 <!-- 上一页 -->
		<div class="page_img_div_up"><img id="page_up" src="${imagePath}page_up.png"/></div>
		 <!-- 下一页 -->
		<div class="page_img_div_down"><img id="page_down" src="${imagePath}page_down.png"/></div>
		<!-- 页码信息 -->
		<div class="page_info_ott">${pb.current}/${pb.pageCount}</div>
		 </c:when>
		 <c:otherwise>
			<!-- 上一页  -->
			<div class="page_img_div"><img id="page_no" src="${imagePath}page_no.png"/></div>
			<!-- 页码信息 -->
			<div class="page_info">${pb.current}<br/>${pb.pageCount}</div>
		 </c:otherwise>
		 </c:choose>
	</c:if>
	<div class="album_0_div">
		<img id="recommend_0_image" class="album_img" src="${basePath}${recommendList[0].linkImageUri}"/>
		<img id="recommend_0" class="album_f" src="${touming}"/>
	</div>
	<div class="album_1_div">
		<img id="recommend_1_image" class="album_img" src="${basePath}${recommendList[1].linkImageUri}"/>
		<img id="recommend_1" class="album_f" src="${touming}"/>
	</div>
	<%@include file="/com/com_bottom.jsp"%>
	
</body>
</html>