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
		"smallvod",groupList.get(0).getMetadatas() ,//首页四个小视频
		"rightRecommendList", groupList.get(1).getMetadatas(), //右侧推荐位
		"midRecommendList", groupList.get(2).getMetadatas(), //中间推荐位
		"bottomRecommendList", groupList.get(3).getMetadatas(),//底部推荐位
		"wordList",groupList.get(4).getMetadatas() //5个文字说明
	);
%>
	<style type="text/css">
	body{
		margin:0;
		padding:0;
		color:#FFFFFF;
		background: transparent url('${imagePath}bg.png') no-repeat;  
	}

	#home_div{position:absolute;left:118px; top:62px;}
	#tszl_div{position:absolute;left:262px; top:62px;}
	#djss_div{position:absolute;left:406px; top:62px;}
	#twgz_div{position:absolute;left:550px; top:62px;}
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

	#wordRecommend_0_div{ position:absolute;left:555px; top:159px;width:450;height:55;}
	#wordRecommend_1_div{ position:absolute;left:555px; top:214px;width:450;height:55;}
	#wordRecommend_2_div{ position:absolute;left:555px; top:269px;width:450;height:55;}
	#wordRecommend_3_div{ position:absolute;left:555px; top:324px;width:450;height:55;}
	#wordRecommend_4_div{ position:absolute;left:555px; top:379px;width:450;height:55;}
	
	</style>
	<script type="text/javascript">	
	//当前导航
	var currentNavi = 'djss';
	
	
	var buttons = 
	[
		{id:'search',name:'搜索',action:goSearch,left:[''], right:['home'], up:'', down:'recommend_0',linkImage:'${touming}', focusImage:'${comImagePath}btn_sousuo_sel.png'},
		{id:'home',name:'首页',action:goColumn,code:'home',left:['search'], right:['tszl'], up:'', down:'recommend_0',focusHandler:focusChangeClass,blurHandler:blurChangeClass},
		{id:'tszl',name:'特色专栏',action:goColumn,code:'20170228_tszl_column',left:['home'], right:['djss'], up:'', down:'recommend_0',focusHandler:focusChangeClass,blurHandler:blurChangeClass},
		{id:'djss',name:'顶级赛事',action:goColumn,code:'20170228_djss_column',left:['tszl'], right:['twgz'], up:'', down:'recommend_0',focusHandler:focusChangeClass,blurHandler:blurChangeClass},
		{id:'twgz',name:'叹为观止',action:goColumn,code:'20170228_twgz_column',left:['djss'], right:['personCenter'], up:'', down:'recommend_0',focusHandler:focusChangeClass,blurHandler:blurChangeClass},
		{id:'personCenter',name:'个人中心',code:'person_center',action:goColumn,left:['twgz'],down:'recommend_1',linkImage:'${comImagePath}btn_geren_nor.png', focusImage:'${comImagePath}btn_geren_sel.png'},
		
		
		<c:forEach items="${rightRecommendList}" var="p" varStatus="vs">
		{id:'rightRecommend_${vs.index}',name:'右侧推荐${vs.index}',action:goRecommend,linkImage:'${basePath}${p.linkImageUri}', focusImage:'${basePath}${p.focusImageUri}',focusHandler:setZIndex},
		</c:forEach>
		<c:forEach items="${midRecommendList}" var="p" varStatus="vs">
		{id:'midRecommend_${vs.index}',name:'中间推荐${vs.index}',action:goRecommend,linkImage:'${basePath}${p.linkImageUri}', focusImage:'${basePath}${p.focusImageUri}',focusHandler:setZIndex},
		</c:forEach>
		<c:forEach items="${bottomRecommendList}" var="p" varStatus="vs">
		{id:'bottomRecommend_${vs.index}',name:'底部推荐${vs.index}',action:goRecommend,linkImage:'${basePath}${p.linkImageUri}', focusImage:'${basePath}${p.focusImageUri}',focusHandler:setZIndex},
		</c:forEach>
		
		<c:forEach items="${wordList}" var="p" varStatus="vs">
		{id:'wordRecommend_${vs.index}',name:'文字推荐${vs.index}',action:goRecommend,linkImage:'${touming}', focusImage:'${imagePath}tab_xuanzhong.png',focusHandler:setZIndex},
		</c:forEach>
		
	];
	 
	
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

	//返回
	function back(){
		location.href = "${backURI}";
	}
	
	
	window.onload=function()
	{
		Epg.tip('${param.info}');//显示info信息，3秒自动隐藏，如果info为空将不会显示
		Epg.btn.init(['${param.f}','recommend_0'],buttons,'${imagePath}',true);
	};
	
	</script>
	
</head>
<body>

	<div id="home_div" class="novi_nor">首页</div>
	<div id="tszl_div" class="novi_nor">特色专栏</div>
	<div id="djss_div" class="novi_focus">顶级赛事</div>
	<div id="twgz_div" class="novi_nor">叹为观止</div>

	<!-- 只是一个占位符 -->
	<div><img id="home" src="${touming}" /></div>
	<div><img id="tszl" src="${touming}" /></div>
	<div><img id="djss" src="${touming}" /></div>
	<div><img id="twgz" src="${touming}" /></div>
	<!-- 只是一个占位符 -->
	
	
	
	<div style="position:absolute;left:555px;top:159px;" >
		<img src="${imagePath}tab_nor.png" width="450" height="278" />
	</div>
	
	<!-- 5个文字说明 -->
	<c:forEach items="${wordList}" var="p" varStatus="vs" >
		<div id='wordRecommend_${vs.index}_div'>
			<img id="wordRecommend_${vs.index}" src="${touming}" />
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


	<%@include file="/com/com_bottom.jsp"%>
	
</body>
</html>