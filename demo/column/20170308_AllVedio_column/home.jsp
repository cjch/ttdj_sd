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
		"wordList",groupList.get(4).getMetadatas() //5个文字说明
	);
	
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
	
%>
	<style type="text/css">
	body{
		margin:0;
		padding:0;
		color:#f0f0f0;
		background: transparent url('${imagePath}bg.png') no-repeat;
	}

	#home_div{position:absolute;left:118px; top:62px;}
	#tszl_div{position:absolute;left:262px; top:62px;}
	#djss_div{position:absolute;left:406px; top:62px;}
	#twgz_div{position:absolute;left:550px; top:62px;}
	#yxlm_div{position:absolute;left:694px; top:62px;}
	#wzry_div{position:absolute;left:838px; top:62px;}
	.novi_nor{width:121px;height:47px;text-align:center;color:#788195;font-size:25px;}
	.novi_focus{width:121px;height:47px;text-align:center;color:#f0f0f0;font-size:25px;}
	
	#rightRecommend_0{ position:absolute;left:1004px; top:123px;width:245px;height:352px;}
	
	#midRecommend_0_div{ position:absolute;left:32px; top:444px;width:233px;height:133px;}
	#midRecommend_1_div{ position:absolute;left:229px; top:444px;width:233px;height:133px;}
	#midRecommend_2_div{ position:absolute;left:425px; top:444px;width:233px;height:133px;}
	#midRecommend_3_div{ position:absolute;left:622px; top:444px;width:233px;height:133px;}
	#midRecommend_4_div{ position:absolute;left:819px; top:444px;width:233px;height:133px;}
	#midRecommend_5_div{ position:absolute;left:1015px; top:444px;width:233px;height:133px;}
	
	
	#bottomRecommend_0_div{ position:absolute;left:25px; top:553px;width:248px;height:123px;}
	#bottomRecommend_1_div{ position:absolute;left:221px; top:553px;width:248px;height:123px;}
	#bottomRecommend_2_div{ position:absolute;left:417px; top:553px;width:248px;height:123px;}
	#bottomRecommend_3_div{ position:absolute;left:615px; top:553px;width:248px;height:123px;}
	#bottomRecommend_4_div{ position:absolute;left:812px; top:553px;width:248px;height:123px;}
	#bottomRecommend_5_div{ position:absolute;left:1008px; top:553px;width:248px;height:123px;}

	.wordRecommend_0_div{ position:absolute;left:555px; top:159px;width:450px;height:55px;}
	.wordRecommend_1_div{ position:absolute;left:555px; top:214px;width:450px;height:55px;}
	.wordRecommend_2_div{ position:absolute;left:555px; top:269px;width:450px;height:55px;}
	.wordRecommend_3_div{ position:absolute;left:555px; top:324px;width:450px;height:55px;}
	.wordRecommend_4_div{ position:absolute;left:555px; top:379px;width:450px;height:55px;}

	.wordBg_nor{left:0px;top:0px;width:450px;height:55px;font-size:24px;padding-left:20px;line-height:55px;overflow:hidden;}	
	.wordBg_sel{background-image: url(${imagePath}tab_xuanzhong.png);left:0px;top:0px;width:450px;height:55px;font-size:24px;padding-left:20px;line-height:55px;overflow:hidden;}
	</style>
	<script type="text/javascript">	
	//当前导航
	var currentNavi = 'djss';
	
	
	var buttons = 
	[
		{id:'search',name:'搜索',action:goSearch,left:[''], right:['home'], up:'', down:'smallvod',linkImage:'${touming}', focusImage:'${comImagePath}btn_sousuo_sel.png'},
		{id:'home',name:'首页',action:goColumn,code:'home',left:['search'], right:['tszl'], up:'', down:'smallvod',focusHandler:focusChangeClass,blurHandler:blurChangeClass},
		{id:'tszl',name:'特色专栏',action:goColumn,code:'20170228_tszl_column',left:['home'], right:['djss'], up:'', down:'smallvod',focusHandler:focusChangeClass,blurHandler:blurChangeClass},
		{id:'djss',name:'顶级赛事',action:goColumn,code:'20170228_djss_column',left:['tszl'], right:['twgz'], up:'', down:'smallvod',focusHandler:focusChangeClass,blurHandler:blurChangeClass},
		{id:'twgz',name:'叹为观止',action:goColumn,code:'20170228_twgz_column',left:['djss'], right:['yxlm'], up:'', down:'wordRecommend_0',focusHandler:focusChangeClass,blurHandler:blurChangeClass},
		{id:'yxlm',name:'英雄联盟',action:goColumn,code:'20170311_LOL_album',left:['twgz'], right:['wzry'], up:'', down:'recommend_2',focusHandler:focusChangeClass,blurHandler:blurChangeClass},
		{id:'wzry',name:'王者荣耀',action:goColumn,code:'20170314_wzry_album',left:['yxlm'], right:['personCenter'], up:'', down:'recommend_2',focusHandler:focusChangeClass,blurHandler:blurChangeClass},
		
		{id:'personCenter',name:'个人中心',code:'person_center',action:goColumn,left:['wzry'],down:'rightRecommend_0',linkImage:'${comImagePath}btn_geren_nor.png', focusImage:'${comImagePath}btn_geren_sel.png'},
		{id:'smallvod',name:'小视频',action:fullscreen,right:['wordRecommend_0'],down:'midRecommend_0',up:'home',down:'midRecommend_0',linkImage:'${touming}', focusImage:'${imagePath}fullscreen.png'},		
		
		<c:forEach items="${rightRecommendList}" var="p" varStatus="vs">
		{id:'rightRecommend_${vs.index}',name:'右侧推荐${vs.index}',type:'${p.type}',code:'${p.value}',action:goRecommend,left:'wordRecommend_0',up:'personCenter',down:'midRecommend_5',action:goRecommend,linkImage:'${basePath}${p.linkImageUri}', focusImage:'${basePath}${p.focusImageUri}',focusHandler:setZIndex},
		</c:forEach>
		<c:forEach items="${midRecommendList}" var="p" varStatus="vs">
		{id:'midRecommend_${vs.index}',name:'中间推荐${vs.index}',type:'${p.type}',code:'${p.value}',left:'midRecommend_${vs.index-1}',right:'midRecommend_${vs.index+1}',down:'bottomRecommend_${vs.index}',up:'${vs.index < 3 ? 'smallvod':vs.index <5 ? 'wordRecommend_4':'rightRecommend_0'}',action:goRecommend,linkImage:'${basePath}${p.linkImageUri}', focusImage:'${basePath}${p.focusImageUri}',focusHandler:setZIndex},
		</c:forEach>
		<c:forEach items="${bottomRecommendList}" var="p" varStatus="vs">
		{id:'bottomRecommend_${vs.index}',name:'底部推荐${vs.index}',type:'${p.type}',code:'${p.value}',left:'bottomRecommend_${vs.index-1}',right:'bottomRecommend_${vs.index+1}',up:'midRecommend_${vs.index}',action:goRecommend,linkImage:'${basePath}${p.linkImageUri}', focusImage:'${basePath}${p.focusImageUri}',focusHandler:setZIndex},
		</c:forEach>
		
		<c:forEach items="${wordList}" var="p" varStatus="vs">
		{id:'wordRecommend_${vs.index}',name:'文字推荐${vs.index}',index:'${vs.index}',left:'smallvod',right:'rightRecommend_0',up:['wordRecommend_${vs.index-1}','twgz'],down:['wordRecommend_${vs.index+1}','midRecommend_3'],action:changeSmallVod,linkImage:'${touming}', focusImage:'${imagePath}tab_sel.png',focusHandler:marquess,blurHandler:stopmarquess},
		</c:forEach>
		
	];

	function marquess(button){
		Epg.marquee.start(11,button.id+"_txt",7,80,'left','scroll');
	}
	
	function stopmarquess(button){

		Epg.marquee.stop();
	}
	
	function fullscreen(button){
	
	}
	
	//改变导航显示效果
	function focusChangeClass(button){
		G(button.id+"_div").className = "novi_focus";
	}
	function blurChangeClass(button){
		if(button.id == currentNavi)return;
		G(button.id+"_div").className = "novi_nor";
	}

	
	//有放大的效果 所以需要设置z index，
	var currentZindex = 100; 
	function setZIndex(button){
		currentZindex++;
		G(button.id+"_div").style.zIndex  =  currentZindex;
			
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
	<c:forEach items="${pb.dataList}" var="p" varStatus="vs" >
		smallVods.push('${p.code}');
	</c:forEach>	
	function changeSmallVod(button){
		//设置当前正在播放的视频
		//G("wordbg_"+currentSmallVodIndex).className = 'wordBg_nor';
		G("wordRecommend_"+currentSmallVodIndex+"_txt").className = 'wordBg_nor';
		currentSmallVodIndex = button.index;
		//G("wordbg_"+currentSmallVodIndex).className = 'wordBg_sel';
		G("wordRecommend_"+currentSmallVodIndex+"_txt").className = 'wordBg_sel';
		videoWindow.location.href = "${basePath}media_player.jsp?method=addVideo&code="+smallVods[currentSmallVodIndex]+"&andPlay=true&dolog=false&display=smallvod&left=62&top=157&width=481&height=282&source=${target}&sourceType=column&metadataType=smallvod";
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
		G("wordRecommend_0_txt").className = 'wordBg_sel';
		Epg.btn.init(['${param.f}','wordRecommend_0'],buttons,'${imagePath}',true);
	};
	
	</script>
	
</head>
<body>

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
	
	
	
	<div style="position:absolute;left:555px;top:159px;" >
		<img src="${imagePath}tab_nor.png" width="450" height="278" />
	</div>
	
	<!-- 5个文字说明 -->
	<c:forEach items="${wordList}" var="p" varStatus="vs" >
		<div class='wordRecommend_${vs.index}_div'>
			<div id="wordRecommend_${vs.index}_txt" class="wordBg_nor" >${p.label}</div>
			<img id="wordRecommend_${vs.index}" src="${touming}" width="450" height="55" />
		</div>
	</c:forEach>
	
		
	<div style="position:absolute;left:10px;top:38px;" >
		<img id="searchimg" 	src="${comImagePath}btn_sousuo_nor.png" />
	</div>
	
	<div style="position:absolute;left:10px;top:38px;" >
		<img id="search" 	src="${touming}" />
	</div>
	
	<div style="position:absolute;left:1074px;top:38px;" >
		<img id="personCenter" 	src="${comImagePath}btn_geren_nor.png" />
	</div>
	
	<c:forEach items="${rightRecommendList}" var="p" varStatus="vs" >
		<div id='rightRecommend_${vs.index}_div'>
			<img id="rightRecommend_${vs.index}" src="${basePath}${p.linkImageUri}" />
		</div>
	</c:forEach>
	
	<c:forEach items="${midRecommendList}" var="p" varStatus="vs" >
		<div id='midRecommend_${vs.index}_div'>
			<img id="midRecommend_${vs.index}" src="${basePath}${p.linkImageUri}" />
		</div>
	</c:forEach>
	
	<c:forEach items="${bottomRecommendList}" var="p" varStatus="vs" >
		<div id='bottomRecommend_${vs.index}_div'>
			<img id="bottomRecommend_${vs.index}" src="${basePath}${p.linkImageUri}" />
		</div>
	</c:forEach>
 

	<!-- 小视频 -->
	<div style="position:absolute; left:62px; top:157px; width:481px; height:282px;">
		<iframe id="videoFrame" name="videoFrame" src="${basePath}media_player.jsp?method=addVideo&code=CP2000000001&andPlay=true&dolog=false&display=smallvod&left=62&top=157&width=481&height=282&source=${target}&sourceType=column&metadataType=smallvod" width="1" height="1" bgcolor="transparent" allowtransparency="true" frameborder="0" scrolling="no"></iframe>
	</div>
	<div style="position:absolute; left:27px; top:124px;">
		<img id="smallvod" src="${touming}" width="551" height="349" />
	</div>
	
	<%@include file="/com/com_bottom.jsp"%>
	
</body>
</html>