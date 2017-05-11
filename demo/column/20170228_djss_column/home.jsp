<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/com/com_head.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/tags/epg" prefix="epg" %>
<%@ taglib tagdir="/WEB-INF/tags/epg" prefix="e" %>
<title>顶级赛事</title>
<%!
	public static final String COLUMN_CODE = "20170228_djss_column";//首页栏目code
	public static final String CURRENT_URI = BASE_PATH + "column/20170228_djss_column/home.jsp?1=1";//当前页面访问地址
%>
<%
	UserStore store = new UserStore(request,response);
	String userid=store.getUserid();
	imagePath = BASE_IMAGE_PATH + "column/20170228_djss_column/";//修正图片路径
	String comImagePath = BASE_IMAGE_PATH + "/com/";//修正图片路径
	setAttr
	(
		request,
		"imagePath", imagePath,//图片路径
		"comImagePath", comImagePath,
		"backURI", getBackURI(request, response),//返回路径
		"currentURI", CURRENT_URI,//当前页面路径
		"target", COLUMN_CODE//记录日志用到的target
	);
	
	HttpUtils.clearMarkedURI(API_URL, new UserStore(request, response).getUserid(), "returnURI", "backURI", "menuBackURI");
	
	//根据栏目code取得首页Epg对象
	List<EpgMetadataGroup> groupList = getEpg(COLUMN_CODE).getGroups();
	setAttr
	(
		request,
		"smallvodId",groupList.get(0).getMetadatas().get(0).getValue() ,//首页四个小视频
		"rightRecommendList", groupList.get(1).getMetadatas(), //右侧推荐位
		"midRecommendList", groupList.get(2).getMetadatas(), //中间推荐位
		"bottomRecommendList", groupList.get(3).getMetadatas(),//底部推荐位
		"wordList",groupList.get(4).getMetadatas(), //5个文字说明
		"smallVodRecommendList",groupList.get(5).getMetadatas()
	);
	
	/*
	//根据小视频ID获取节目单
	String smallvodId = groupList.get(0).getMetadatas().get(0).getValue();
	int programId = Integer.parseInt(smallvodId);
	GetProgramRequest req = new GetProgramRequest();
	req.setId(programId);
	req.setType("video");
	req.setCurrent(1);
	req.setPageSize(5);
	GetProgramResponse resp = new ProgramExecutor(API_URL).get(req);
	request.setAttribute("pb",resp.getPb());	
	*/
	
%>
	<style type="text/css">
	body{
		margin:0;
		padding:0;
		color:#f0f0f0;
		background: transparent url('${comImagePath}bg_new.jpg') no-repeat;
	}

	#search_div{position:absolute;left:438px;top:10px;}
	#personCenter_div{position:absolute;left:526px;top:10px;}
	#home_div{position:absolute;left:22px; top:94px; width: 60px;}
	#tszl_div{position:absolute;left:86px; top:94px;}
	#djss_div{position:absolute;left:190px; top:94px;}
	#twgz_div{position:absolute;left:294px; top:94px;}
	#yxlm_div{position:absolute;left:398px; top:94px;}
	#wzry_div{position:absolute;left:502px; top:94px;}
	.novi_nor{width:100px;height:40px;line-height:40px;text-align:center;color:#788195;font-size:18px;}
	.novi_focus{width:100px;height:40px;line-height:40px;text-align:center;color:#f0f0f0;font-size:18px;}
	.novi_sel{width:100px;height:40px;line-height:40px;text-align:center;color:#f0f0f0;font-size:18px;background-color: #4463e9; border-radius: 3px;}

	#rightRecommend_0_div{ position:absolute;left:515px; top:164px;width:104px;height:175px;}

	#midRecommend_0_div{ position:absolute;left:21px; top:354px;width:111px;height:66px;}
	#midRecommend_1_div{ position:absolute;left:142px; top:354px;width:111px;height:66px;}
	#midRecommend_2_div{ position:absolute;left:263px; top:354px;width:111px;height:66px;}
	#midRecommend_3_div{ position:absolute;left:384px; top:354px;width:111px;height:66px;}
	#midRecommend_4_div{ position:absolute;left:505px; top:354px;width:111px;height:66px;}
	#midRecommend_5_div{ position:absolute;left:505px; top:354px;width:111px;height:66px;}


	#bottomRecommend_0_div{ position:absolute;left:21px; top:434px;width:111px;height:46px;}
	#bottomRecommend_1_div{ position:absolute;left:142px; top:434px;width:111px;height:46px;}
	#bottomRecommend_2_div{ position:absolute;left:263px; top:434px;width:111px;height:46px;}
	#bottomRecommend_3_div{ position:absolute;left:384px; top:434px;width:111px;height:46px;}
	#bottomRecommend_4_div{ position:absolute;left:505px; top:434px;width:111px;height:46px;}
	#bottomRecommend_5_div{ position:absolute;left:505px; top:434px;width:111px;height:46px;}

	.wordRecommend_0_div{ position:absolute;left:291px; top:164px;width:214px;height:34px;}
	.wordRecommend_1_div{ position:absolute;left:291px; top:199px;width:214px;height:34px;}
	.wordRecommend_2_div{ position:absolute;left:291px; top:234px;width:214px;height:34px;}
	.wordRecommend_3_div{ position:absolute;left:291px; top:269px;width:214px;height:34px;}
	.wordRecommend_4_div{ position:absolute;left:291px; top:304px;width:214px;height:34px;}

	.btn-bottom-group{
		background-position: -253px 0px;
		background-repeat: no-repeat;
	}

	.bottom_btn_focus{
		background-position: 0px 0px;
		background-repeat: no-repeat;
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
	.btn-group img, .btn-bottom-group img{
		display: inline-block;
		vertical-align: middle;
		-moz-border-radius:4px;
		-webkit-border-radius:4px;
		border-radius:4px;
		width: 100%;
		height: 100%;
	}

	.wordBg_nor{left:0px;top:0px;width:209px;height:34px;font-size:16px;padding-left:5px;line-height:34px;overflow:hidden;}
	.wordBg_sel{background-image: url(${imagePath}tab_xuanzhong.png);left:0px;top:0px;width:209px;height:34px;font-size:16px;padding-left:5px;line-height:34px;overflow:hidden;}
	</style>
	<script type="text/javascript">	
	//当前导航
	var currentNavi = 'djss';
	
	
	var buttons = 
	[
        {id:'search',name:'搜索',action:goColumn,left:[''], right:['personCenter'], up:'', down:'home',linkImage:'${comImagePath}btn_search_nor.png', focusImage:'${comImagePath}btn_search_sel.png'},
        {id:'personCenter',name:'个人中心',action:goColumn,code:'person_center',left:['search'],down:'wzry',linkImage:'${comImagePath}btn_geren_nor.png', focusImage:'${comImagePath}btn_geren_sel.png'},
        {id:'home',name:'首页',action:goColumn,code:'home',left:['search'], right:['tszl'], up:'search', down:'smallvod',focusHandler:focusChangeClass,blurHandler:blurChangeClass},
        {id:'tszl',name:'特色专栏',action:goColumn,code:'20170228_tszl_column',left:['home'], right:['djss'], up:'search', down:'smallvod',focusHandler:focusChangeClass,blurHandler:blurChangeClass},
        {id:'djss',name:'顶级赛事',action:goColumn,code:'20170228_djss_column',left:['tszl'], right:['twgz'], up:'search', down:'smallvod',focusHandler:focusChangeClass,blurHandler:blurChangeClass},
        {id:'twgz',name:'叹为观止',action:goColumn,code:'20170228_twgz_column',left:['djss'], right:['yxlm'], up:'search', down:'wordRecommend_0',focusHandler:focusChangeClass,blurHandler:blurChangeClass},
        {id:'yxlm',name:'英雄联盟',action:goColumn,code:'20170311_LOL_album',left:['twgz'], right:['wzry'], up:'search', down:'wordRecommend_0',focusHandler:focusChangeClass,blurHandler:blurChangeClass},
        {id:'wzry',name:'王者荣耀',action:goColumn,code:'20170314_wzry_album',left:['yxlm'], right:['personCenter'], up:'personCenter', down:'rightRecommend_0',focusHandler:focusChangeClass,blurHandler:blurChangeClass},
        {id:'smallvod',name:'小视频',action:fullscreen,right:['wordRecommend_0'],down:'midRecommend_0',up:'djss',down:'wordRecommend_0',linkImage:'${touming}', focusImage:'${imagePath}fullscreen.png'},
		
		<c:forEach items="${rightRecommendList}" var="p" varStatus="vs">
		{id:'rightRecommend_${vs.index}',name:'右侧推荐${vs.index}',type:'${p.type}',code:'${p.value}',action:goRecommend,left:'wordRecommend_0',up:'wzry',down:'midRecommend_5',action:goRecommend,focusHandler:setZIndex,blurHandler:blurChangeBtnClass},
		</c:forEach>
		<c:forEach items="${midRecommendList}" var="p" varStatus="vs">
		{id:'midRecommend_${vs.index}',name:'中间推荐${vs.index}',type:'${p.type}',code:'${p.value}',left:'midRecommend_${vs.index-1}',right:'midRecommend_${vs.index+1}',down:'bottomRecommend_${vs.index}',up:'${vs.index < 3 ? 'smallvod':vs.index <5 ? 'wordRecommend_4':'rightRecommend_0'}',action:goRecommend,linkImage:'${basePath}${p.linkImageUri}', focusHandler:setZIndex,blurHandler:blurChangeBtnClass},
		</c:forEach>
		<c:forEach items="${bottomRecommendList}" var="p" varStatus="vs">
		{id:'bottomRecommend_${vs.index}',name:'底部推荐${vs.index}',type:'${p.type}',code:'${p.value}',left:'bottomRecommend_${vs.index-1}',right:'bottomRecommend_${vs.index+1}',up:'midRecommend_${vs.index}',action:goRecommend, focusHandler:setZIndex,blurHandler:blurChangeBtnClass},
		</c:forEach>
		
		<c:forEach items="${smallVodRecommendList}" var="p" varStatus="vs">
		{id:'wordRecommend_${vs.index}',name:'文字推荐${vs.index}',index:'${vs.index}',left:'smallvod',right:'rightRecommend_0',up:['wordRecommend_${vs.index-1}','djss'],down:['wordRecommend_${vs.index+1}','midRecommend_3'],action:changeSmallVod,linkImage:'${touming}', focusImage:'${imagePath}tab_sel.png',focusHandler:changeSmallVodImg,blurHandler:changeStopScroll},
		</c:forEach>
		
	];

	function marquess(button){		
		Epg.marquee.start(20,button.id+"_txt",7,50,'left','alternate');
	}
	
	function stopmarquess(button){
		Epg.marquee.stop();
	}
	
	function fullscreen(button){
		playVideo(smallVods[currentSmallVodIndex]);
	}
	
	//改变导航显示效果
	function focusChangeClass(button){
		G(button.id+"_div").className = "novi_sel";
	}
	function blurChangeClass(button){
		if(button.id == currentNavi){
			G(button.id+"_div").className = "novi_focus";
			return;
		}
		G(button.id+"_div").className = "novi_nor";
	}


	//有放大的效果 所以需要设置z index，
	var currentZindex = 100;
	var originData = {};
	function setZIndex(button){
		currentZindex++;
		G(button.id+"_div").style.zIndex  =  currentZindex;

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

		if(button.id.indexOf("bottom") != -1){
			G(button.id+"_div").className = "bottom_btn_focus";

			top = top - 25.5;
			left = left - 38;
			G(button.id + "_div").style.width = "253px";
			G(button.id + "_div").style.height = "122px";
			G(button.id + "_div").style.left = left+ "px";
			G(button.id + "_div").style.top = top + "px";
			//38 left
			//25.5 top
		}else {
			top = top - 0.04*height;
			left = left - 0.04*width;
			G(button.id + "_div").style.width = width * 1.08 + "px";
			G(button.id + "_div").style.height = height * 1.08 + "px";

			G(button.id + "_div").style.top = top + "px";
			G(button.id + "_div").style.left = left + "px";
			G(button.id+"_div").className = "btn-group focused";
		}

	}

	function blurChangeBtnClass(button){
		if(button.id == currentNavi)return;


		if(originData[button.id+"_div"]){
			var data = originData[button.id+"_div"].split(":");
			G(button.id+"_div").style.width = data[0] + "px";
			G(button.id+"_div").style.height = data[1] + "px";
			G(button.id+"_div").style.top = data[2] + "px";
			G(button.id+"_div").style.left = data[3] + "px";
		}

		if(button.id.indexOf("bottom") != -1){
			G(button.id+"_div").className = "btn-bottom-group";
		}else{
			G(button.id+"_div").className = "btn-group";
		}
	}
	
	function goSearch(){
		
	}
	
	function goOrder(button){
		location.href = "${basePath}com/auth.jsp?method=order";
	}
	 
	function goRecommend(button){
		var elementCodeSrc = '';//来源页面元素编码
		if(button.type == 'recommend_video')//如果是视频
		{
			playVideo(button.code, elementCodeSrc);
		}
		else if(button.type == 'recommend_series')//如果是剧集
		{
			//epg.go('column/content_list/home.jsp?code='+button.code+'&elementCodeSrc=${columnIdx}', button.code);
		}
		else if(button.type == 'album')//如果是专辑
		{
			var backURI = escape('${currentURI}&p=${pb.current}&f='+button.id+'&dir=fallback&source='+button.code);
			location.href='${basePath}recommend.jsp?source=${target}&type='+button.type+'&code='+button.code+'&backURI='+backURI;
		}
		else if(button.type == 'activity')//如果是活动
		{
			var backURI = escape('${currentURI}&p=${pb.current}&f='+button.id+'&dir=fallback&source='+button.code);
			location.href='${basePath}recommend.jsp?source=${target}&type='+button.type+'&code='+button.code+'&backURI='+backURI;
		}
		else if(button.type == 'column')//如果是栏目
		{
			var backURI = escape('${currentURI}&p=${pb.current}&f='+button.id+'&dir=fallback&source='+button.code);
			location.href='${basePath}recommend.jsp?source=${target}&type='+button.type+'&code='+button.code+'&backURI='+backURI;
		}		
	}
	
	/*跳转到栏目*/
	function goColumn(button)
	{
		var code = epg.btn.current.code;
		if(code == 'home'){
			epg.go('home.jsp', code);
			return;
		}

		if(code == 'person_center'){
			epg.go('column/person_center/index.jsp', code);
			return;
		}

		if(button.id == 'search'){
			epg.go('column/search/search.jsp', code);
			return;
		}

		if(button.id == 'yxlm'){
			epg.go('album/gameTemplate.jsp?code='+button.code, code);
			return;
		}
		
		if(button.id == 'wzry'){
			epg.go('album/gameTemplate.jsp?code='+button.code, code);
			return;
		}
		
		epg.go('column/'+code+'/home.jsp', code);
	}
	
	/*进入推荐位，可以是剧集、视频、专辑等*/
	function enterRecommend()
	{
		var btn = epg.btn.current;
		var elementCodeSrc = '';//来源页面元素编码
		
		if(btn.type == 'recommend_video')//如果是视频
		{
			playVideo(btn.code, elementCodeSrc);
		}
		else if(btn.type == 'recommend_series')//如果是剧集
		{
			epg.go('column/content_list/home.jsp?code='+btn.code+'&elementCodeSrc=${columnIdx}', btn.code);
			//playSeries(btn.code, '', elementCodeSrc);
		}
		else if(btn.type == 'album')//如果是专辑
		{
			var backURI = escape('${currentURI}&p=${pb.current}&f='+Epg.btn.current.id+'&dir=fallback&source='+Epg.btn.current.code);
			location.href='${basePath}recommend.jsp?source=${target}&type='+btn.type+'&code='+btn.code+'&backURI='+backURI;
		}
		else if(btn.type == 'activity')//如果是活动
		{
			var backURI = escape('${currentURI}&p=${pb.current}&f='+Epg.btn.current.id+'&dir=fallback&source='+Epg.btn.current.code);
			location.href='${basePath}recommend.jsp?source=${target}&type='+btn.type+'&code='+btn.code+'&backURI='+backURI;
		}
	}

	
	var currentSmallVodIndex = 0;
	var smallVods = [];
	var smallImgs = []; 
	<c:forEach items="${smallVodRecommendList}" var="p" varStatus="vs" >
		smallVods.push('${p.value}');
		smallImgs.push('${p.linkImageUri}');
	</c:forEach>	
	function changeSmallVodImg(button){
		currentSmallVodIndex = button.index;
		G("videoFrame").src = "";
		G("hbdiv").style.display = "block";
		G('hb').src = '${basePath}'+smallImgs[button.index];
		Epg.marquee.start(11,button.id+"_txt",7,80,'left','scroll');
	}

	function changeStopScroll(){
		Epg.marquee.stop();
	}

	function changeSmallVod(button){
		currentSmallVodIndex = button.index;
		fullscreen()
		//G("hbdiv").style.display = "none";
		//设置当前正在播放的视频
		//G("wordbg_"+currentSmallVodIndex).className = 'wordBg_nor';
		//G("wordRecommend_"+currentSmallVodIndex+"_txt").className = 'wordBg_nor';
		//currentSmallVodIndex = button.index;
		//G("wordbg_"+currentSmallVodIndex).className = 'wordBg_sel';
		//G("wordRecommend_"+currentSmallVodIndex+"_txt").className = 'wordBg_sel';
		//videoWindow.location.href = "${basePath}media_player.jsp?method=addVideo&code="+smallVods[currentSmallVodIndex]+"&andPlay=true&dolog=false&display=smallvod&left=62&top=157&width=481&height=282&source=${target}&sourceType=column&metadataType=smallvod";
	}	

	function pageDown(vodMode)
	{
		vodMode = vodMode||'active';
		//G("wordbg_"+currentSmallVodIndex).className = 'wordBg_nor';
		G("wordRecommend_"+currentSmallVodIndex+"_txt").className = 'wordBg_nor';
		wordRecommend_${vs.index}_txt
		currentSmallVodIndex = (currentSmallVodIndex+1)%5;
		//G("wordbg_"+currentSmallVodIndex).className = 'wordBg_sel';
		G("wordRecommend_"+currentSmallVodIndex+"_txt").className = 'wordBg_sel';
		videoWindow.location.href = "${basePath}media_player.jsp?method=addVideo&code="+smallVods[currentSmallVodIndex]+"&andPlay=true&dolog=false&display=smallvod&left=62&top=157&width=481&height=282&source=${target}&sourceType=column&metadataType=smallvod";
		 
	}	

	//返回
	function back(){
		location.href = "${backURI}";
	}

	Epg.key.set(
	{
		EVENT_MEDIA_END:'pageDown("passive")',
		EVENT_MEDIA_ERROR:'playError()'
	});
	
	function playError(){
		Epg.tip("视频播放错误!");	
		pageDown("passive");
	}
	
	window.onload=function()
	{
		//G("wordRecommend_0_txt").className = 'wordBg_sel';
		/*
		setTimeout(function(){
			G("videoFrame").src =  "${basePath}media_player.jsp?method=addVideo&code="+smallVods[0]+"&andPlay=true&dolog=false&display=smallvod&left=62&top=157&width=481&height=282&source=${target}&sourceType=column&metadataType=smallvod";
			//G("videoFrame").src = "${basePath}media_player.jsp?method=addVideo&code=CP0001qmqz000001&andPlay=true&dolog=false&display=smallvod&left=62&top=157&width=481&height=282&source=${target}&sourceType=column&metadataType=smallvod";
		},1000);
		*/
		G('hb').src = '${basePath}'+smallImgs[0] ;
		Epg.btn.init(['${param.f}','smallvod'],buttons,'${imagePath}',true);
	};

	//获取去除px后的数值
	function digitPX(px){
		if(isNaN(px)){//带了p
			var after_px = parseInt(px.substr(0,px.indexOf("p")));
			return after_px;
		}else{
			return parseInt(px);
		}
	}

	Epg.eventHandler = function(keyCode) {
		if (keyCode == KEY_LEFT) {
			Epg.Button.move('left');
		} else if (keyCode == KEY_RIGHT) {
			Epg.Button.move('right');
		} else if (keyCode == KEY_UP) {
			Epg.Button.move('up');
		} else if (keyCode == KEY_DOWN) {
			Epg.Button.move('down');
		} else if (keyCode == KEY_ENTER) {
			Epg.Button.click();
		}
	}

	</script>
	
</head>
<body>
	<div id="search_div">
		<img id="search" 	src="${comImagePath}btn_search_nor.png" />
	</div>
	<div id="personCenter_div">
		<img id="personCenter" 	src="${comImagePath}btn_geren_nor.png" />
	</div>

	<div id="home_div" class="novi_nor">首页</div>
	<div id="tszl_div" class="novi_nor">特色专栏</div>
	<div id="djss_div" class="novi_focus">顶级赛事</div>
	<div id="twgz_div" class="novi_nor">叹为观止</div>
	<div id="yxlm_div" class="novi_nor">英雄联盟</div>
	<div id="wzry_div" class="novi_nor">王者荣耀</div>

	<!-- 只是一个占位符 -->
	<div><img id="home" src="${touming}" /></div>
	<div><img id="tszl" src="${touming}" /></div>
	<div><img id="djss" src="${touming}" /></div>
	<div><img id="twgz" src="${touming}" /></div>
	<div><img id="yxlm" src="${touming}" /></div>
	<div><img id="wzry" src="${touming}" /></div>
	<!-- 只是一个占位符 -->
	
	
	
	<div style="position:absolute;left:291px;top:164px;" >
		<img src="${imagePath}tab_nor.png" width="214" height="176" />
	</div>
	
	<!-- 5个文字说明 -->
	<c:forEach items="${wordList}" var="p" varStatus="vs" >
		<div class='wordRecommend_${vs.index}_div'>
			<div id="wordRecommend_${vs.index}_txt" class="wordBg_nor" >${p.label}</div>
			<img id="wordRecommend_${vs.index}" src="${touming}" width="214" height="34" />
		</div>
	</c:forEach>
	
	<c:forEach items="${rightRecommendList}" var="p" varStatus="vs" >
		<div id='rightRecommend_${vs.index}_div' class="btn-group">
			<img id="rightRecommend_${vs.index}" src="${basePath}${p.linkImageUri}" />
		</div>
	</c:forEach>
	
	<c:forEach items="${midRecommendList}" var="p" varStatus="vs" >
		<div id='midRecommend_${vs.index}_div' class="btn-group">
			<img id="midRecommend_${vs.index}" src="${basePath}${p.linkImageUri}" />
		</div>
	</c:forEach>
	
	<c:forEach items="${bottomRecommendList}" var="p" varStatus="vs" >
		<div id='bottomRecommend_${vs.index}_div' style='background-image:url("${basePath}${p.linkImageUri}");' class = "btn-bottom-group">
			<img id="bottomRecommend_${vs.index}" src="" style="display: none;" />
		</div>
	</c:forEach>
 

	<!-- 小视频 -->
	<div id="hbdiv" style="position:absolute; left:21px; top:164px; width:270px; height:176px;display:block;">
		<img id="hb" src="" width="100%" height="100%" />
	</div>
	<div style="position:absolute; left:21px; top:164px; width:270px; height:176px;">
		<iframe id="videoFrame" name="videoFrame" src="" width="1" height="1" bgcolor="transparent" allowtransparency="true" frameborder="0" scrolling="no"></iframe>
	</div>
	<div style="position:absolute; left:5px; top:150px;">
		<img id="smallvod" src="${touming}" width="300" height="200" />
	</div>
	
	<%@include file="/com/com_bottom.jsp"%>
	<script>

	</script>
</body>
</html>