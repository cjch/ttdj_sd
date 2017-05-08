<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/com/com_head.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/tags/epg" prefix="epg" %>
<%@ taglib tagdir="/WEB-INF/tags/epg" prefix="e" %>
<title>特色专栏</title>
<%!
	public static final String COLUMN_CODE = "20170228_tszl_column";//首页栏目code
	public static final String CURRENT_URI = BASE_PATH + "column/20170228_tszl_column/home.jsp?1=1";//当前页面访问地址
%>
<%
	UserStore store = new UserStore(request,response);
	String userid=store.getUserid();
	imagePath = BASE_IMAGE_PATH + "column/20170228_tszl_column/";//修正图片路径
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
		"recommendList", groupList.get(0).getMetadatas() //取出推荐位
	);
%>
	<style type="text/css">
	body{
		margin:0;
		padding:0;
		color:#FFFFFF;
		background: transparent url('${comImagePath}bg.jpg') no-repeat;
	}

	#home_div{position:absolute;left:118px; top:62px;}
	#tszl_div{position:absolute;left:262px; top:62px;}
	#djss_div{position:absolute;left:406px; top:62px;}
	#twgz_div{position:absolute;left:550px; top:62px;}
	#yxlm_div{position:absolute;left:694px; top:62px;}
	#wzry_div{position:absolute;left:838px; top:62px;}
	.novi_nor{width:121px;height:47px;text-align:center;color:#788195;font-size:25px;}
	.novi_focus{width:121px;height:47px;text-align:center;color:#f0f0f0;font-size:25px;}
	.novi_sel{width:121px;height:47px;text-align:center;color:#f0f0f0;font-size:25px;background-image:url('${comImagePath}nav_sel.png')}

	#recommend_0_div{ position:absolute;left:60px; top:159px;width:767px;height:238px;}
	#recommend_1_div{ position:absolute;left:847px; top:159px;width:373px;height:238px;}
	#recommend_2_div{ position:absolute;left:60px; top:417px;width:373px;height:236px;}
	#recommend_3_div{ position:absolute;left:453px; top:417px;width:373px;height:236px;}
	#recommend_4_div{ position:absolute;left:847px; top:417px;width:373px;height:236px;}

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
	<script type="text/javascript">	
	//当前导航
	var currentNavi = 'tszl';
	
	
	var buttons = 
	[
		{id:'search',name:'搜索',action:goColumn,left:[''], right:['home'], up:'', down:'recommend_0',linkImage:'${touming}', focusImage:'${comImagePath}btn_sousuo_sel.png'},
		{id:'home',name:'首页',action:goColumn,code:'home',left:['search'], right:['tszl'], up:'', down:'recommend_0',focusHandler:focusChangeClass,blurHandler:blurChangeClass},
		{id:'tszl',name:'特色专栏',action:goColumn,code:'20170228_tszl_column',left:['home'], right:['djss'], up:'', down:'recommend_0',focusHandler:focusChangeClass,blurHandler:blurChangeClass},
		{id:'djss',name:'顶级赛事',action:goColumn,code:'20170228_djss_column',left:['tszl'], right:['twgz'], up:'', down:'recommend_0',focusHandler:focusChangeClass,blurHandler:blurChangeClass},
		{id:'twgz',name:'叹为观止',action:goColumn,code:'20170228_twgz_column',left:['djss'], right:['yxlm'], up:'', down:'recommend_0',focusHandler:focusChangeClass,blurHandler:blurChangeClass},
		{id:'personCenter',name:'个人中心',code:'person_center',action:goColumn,left:['wzry'],down:'recommend_1',linkImage:'${comImagePath}btn_geren_nor.png', focusImage:'${comImagePath}btn_geren_sel.png'},
		<c:forEach items="${recommendList}" var="p" varStatus="vs">
		{id:'recommend_${vs.index}',name:'推荐${vs.index}',type:'${p.type}',code:'${p.value}',action:goRecommend,linkImage:'${basePath}${p.linkImageUri}',focusHandler:setZIndex,blurHandler:blurChangeBtnClass},
		</c:forEach>
		{id:'yxlm',name:'英雄联盟',action:goColumn,code:'20170311_LOL_album',left:['twgz'], right:['wzry'], up:'', down:'recommend_2',focusHandler:focusChangeClass,blurHandler:blurChangeClass},
		{id:'wzry',name:'王者荣耀',action:goColumn,code:'20170314_wzry_album',left:['yxlm'], right:['personCenter'], up:'', down:'recommend_2',focusHandler:focusChangeClass,blurHandler:blurChangeClass}

	];
	 
	//设置走位
	buttons[6].right='recommend_1';buttons[6].up='tszl';buttons[6].down='recommend_2';
	buttons[7].left='recommend_0';buttons[7].up='tszl';buttons[7].down='recommend_4';
	buttons[8].right='recommend_3';buttons[8].up='recommend_0';
	buttons[9].left='recommend_2';buttons[9].right='recommend_4';buttons[9].up='recommend_0';
	buttons[10].left='recommend_3';buttons[10].up='recommend_1';
	
	
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

//		console.log("width:"+width);
//		console.log("height:" + height);
//		console.log("top:"+top );
//		console.log("left:"+left);
//		console.log(button.id);
//		if(button.id == "history"){
//			console.log(originData);
//		}

		top = top - 0.05*height;
		left = left - 0.05*width;

		G(button.id+"_div").style.width = width*1.1+"px";
		G(button.id+"_div").style.height = height*1.1+"px";
		G(button.id+"_div").style.top = top+"px";
		G(button.id+"_div").style.left = left +"px";

	}

	function blurChangeBtnClass(button){
		G(button.id+"_div").className = "btn-group";

		if(originData[button.id+"_div"]){
			var data = originData[button.id+"_div"].split(":");

			G(button.id+"_div").style.width = data[0] + "px";
			G(button.id + "_div").style.height = data[1] + "px";
			G(button.id+"_div").style.top = data[2] + "px";
			G(button.id+"_div").style.left = data[3] + "px";
		}
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
			epg.go('seriesDetail.jsp?code='+button.code, button.code);
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

		if(button.id == 'search'){
			epg.go('column/search/search.jsp', code);
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

	function back(){
		console.log("back test");
		location.href = "${backURI}";
	}
	
	
	window.onload=function()
	{
		Epg.tip('${param.info}');//显示info信息，3秒自动隐藏，如果info为空将不会显示
		Epg.btn.init(['${param.f}','recommend_0'],buttons,'${imagePath}',true);
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
	
	</script>
	
</head>
<body>

	<div id="home_div" class="novi_nor">首页</div>
	<div id="tszl_div" class="novi_focus">特色专栏</div>
	<div id="djss_div" class="novi_nor">顶级赛事</div>
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
	
	<div style="position:absolute;left:10px;top:38px;" >
		<img id="searchimg" 	src="${comImagePath}btn_sousuo_nor.png" />
	</div>
	
	<div style="position:absolute;left:10px;top:38px;" >
		<img id="search" 	src="${touming}" />
	</div>
	
	<div style="position:absolute;left:1074px;top:38px;" >
		<img id="personCenter" 	src="${comImagePath}btn_geren_nor.png" />
	</div>
	

	<c:forEach items="${recommendList}" var="p" varStatus="vs" >
		<div id='recommend_${vs.index}_div'>
			<img id="recommend_${vs.index}" src="${basePath}${p.linkImageUri}" />
		</div>
	</c:forEach>



	<%@include file="/com/com_bottom.jsp"%>
	
</body>
</html>