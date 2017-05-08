<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/com/com_head.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/tags/epg" prefix="epg" %>
<%@ taglib tagdir="/WEB-INF/tags/epg" prefix="e" %>
<title>首页</title>
<%!
	public static final String COLUMN_CODE = "home";//首页栏目code
	public static final String CURRENT_URI = BASE_PATH + "home.jsp?1=1";//当前页面访问地址
%>
<%
	UserStore store = new UserStore(request,response);
	String userid=store.getUserid();
	imagePath = BASE_IMAGE_PATH + "column/home/";//修正图片路径
	String comImagePath = BASE_IMAGE_PATH + "/com/";//修正图片路径
	setAttr
	(
		request,
		"imagePath", imagePath,//图片路径
		"comImagePath", comImagePath,
		"currentURI", CURRENT_URI,//当前页面路径
		"target", COLUMN_CODE//记录日志用到的target
	);
	
	HttpUtils.clearMarkedURI(API_URL, new UserStore(request, response).getUserid(), "returnURI", "backURI", "menuBackURI");
	
	//根据栏目code取得首页Epg对象
	List<EpgMetadataGroup> groupList = getEpg(COLUMN_CODE).getGroups();
	setAttr
	(
		request,
		"recommendList", groupList.get(0).getMetadatas(), //取出推荐位
		"smallVod", groupList.get(0).getMetadatas().get(1) // 获取正在播放的视频
	);

%>
	<style type="text/css">
	body{
		margin:0;
		padding:0;
		color:#FFFFFF;
		background: transparent url('${comImagePath}bg_new.png') no-repeat;
	}

	.div_com{
		margin:2px;
		border-radius: 10px;
		border:solid 2px #47669f;
	}

	.div_com .post_img{
		display: inline-block;
		vertical-align: middle;
		width: 100%;
		height: 100%;
	}

	#home_div{position:absolute;left:113px; top:0px;}
	#tszl_div{position:absolute;left:255px; top:0px;}
	#djss_div{position:absolute;left:354px; top:0px;}
	#twgz_div{position:absolute;left:773px; top:0px;}
	#yxlm_div{position:absolute;left:872px; top:0px;}
	#wzry_div{position:absolute;left:973px; top:0px;}
	.novi_nor{width:136px;height:47px;line-height:47px;text-align:center;color:#788195;font-size:25px;}
	.novi_focus{width:136px;height:47px;line-height:47px;text-align:center;color:#f0f0f0;font-size:25px;}
	.novi_sel{width:136px;height:47px;line-height:47px;text-align:center;color:#f0f0f0;font-size:25px;background-image:url('${comImagePath}btn_ding_sel.png')}

	#recommend_0_div{ position:absolute;left:60px; top:133px;width:260px;height:162px;}
	#recommend_1_div{ position:absolute;left:336px; top:133px;width:606px;height:340px;}
	#recommend_2_div{ position:absolute;left:958px; top:133px;width:260px;height:340px;}
	#recommend_3_div{ position:absolute;left:60px; top:311px;width:260px;height:162px;}
	#recommend_4_div{ position:absolute;left:60px; top:489px;width:260px;height:162px;}
	#recommend_5_div{ position:absolute;left:336px; top:489px;width:295px;height:162px;}
	#recommend_6_div{ position:absolute;left:647px; top:489px;width:295px;height:162px;}
	#recommend_7_div{ position:absolute;left:958px; top:489px;width:260px;height:162px;}


	.btn-group img.btn_focus_effect-focus{
		border-radius: 4px;
	}

	.btn-group{
		text-align: center;
	}

	/*按钮高亮的时候，给图片加边距、颜色*/
	.div_com.focused{
		padding: 3px;
		background-color: #CFAC14;
		border-radius: 12px;
		/*border:solid 1px #4a9bff;*/
		border: 5px solid #6d6d35;
		/*box-shadow: 0px 0px 2px 4px #1465C9;*/

	}

	.div_com.video_focused{
		padding: 3px;
		/*background-color: #CFAC14;*/
		border-radius: 12px;
		/*border:solid 1px #4a9bff;*/
		border: 5px solid #6d6d35;
		/*box-shadow: 0px 0px 2px 4px #1465C9;*/

	}

	div.transformDiv{transition:all 0.5s;-webkit-transition:all 0.5s;}
	</style>
	<script type="text/javascript">	
	//当前导航
	var currentNavi = 'home';

	var buttons = 
	[
		{id:'search',name:'搜索',action:goColumn,left:[''], right:['home'], up:'', down:'recommend_0',linkImage:'${comImagePath}btn_search_nor.png', focusImage:'${comImagePath}btn_search_sel.png'},
		{id:'home',name:'首页',action:goColumn,code:'home',left:['search'], right:['tszl'], up:'', down:'recommend_0',linkImage:'${comImagePath}btn_shouye_click.png', focusImage:'${comImagePath}btn_shouye_sel.png'},
		{id:'tszl',name:'特色专栏',action:goColumn,code:'20170228_tszl_column',left:['home'], right:['djss'], up:'', down:'recommend_1',linkImage:'${comImagePath}btn_zhuanlan_nor.png', focusImage:'${comImagePath}btn_zhuanlan_sel.png'},
		{id:'djss',name:'顶级赛事',action:goColumn,code:'20170228_djss_column',left:['tszl'], right:['twgz'], up:'', down:'recommend_1',linkImage:'${comImagePath}btn_saishi_nor.png', focusImage:'${comImagePath}btn_saishi_sel.png'},
		{id:'twgz',name:'叹为观止',action:goColumn,code:'20170228_twgz_column',left:['djss'], right:['yxlm'], up:'', down:'recommend_1',linkImage:'${comImagePath}btn_zhanbang_nor.png', focusImage:'${comImagePath}btn_zhanbang_sel.png'},
		{id:'personCenter',name:'个人中心',code:'person_center',action:goColumn,code:'person_center',left:['wzry'],down:'recommend_3',linkImage:'${comImagePath}btn_mine_nor.png', focusImage:'${comImagePath}btn_mine_sel.png'},
		<c:forEach items="${recommendList}" var="p" varStatus="vs">
		<c:if test="${vs.index == 1}">
		{id:'recommend_${vs.index}',name:'推荐${vs.index}',type:'${p.type}',code:'${p.value}',action:pAndp,linkImage:'${touming}',focusHandler:focusChangeVodClass,blurHandler:blurChangeVodClass},
		</c:if>
		<c:if test="${vs.index != 1}">
		{id:'recommend_${vs.index}',name:'推荐${vs.index}',type:'${p.type}',code:'${p.value}',action:goRecommend,linkImage:'${basePath}${p.linkImageUri}',focusHandler:setZIndex,blurHandler:blurChangeBtnClass},
		</c:if>
		</c:forEach>
		<%--{id:'history',name:'观看历史',action:goColumn,up:'recommend_0',right:'recommend_5',linkImage:'${comImagePath}pic2_nor.png',focusHandler:setZIndex,blurHandler:blurChangeBtnClass},--%>
		{id:'yxlm',name:'英雄联盟',action:goColumn,code:'20170311_LOL_album',left:['twgz'], right:['wzry'], up:'', down:'recommend_2',linkImage:'${comImagePath}btn_dianjing_nor.png', focusImage:'${comImagePath}btn_dianjing_sel.png'},
		{id:'wzry',name:'王者荣耀',action:goColumn,code:'20170314_wzry_album',left:['yxlm'], right:['personCenter'], up:'', down:'recommend_2',linkImage:'${comImagePath}btn_wangzhelianm_nor.png', focusImage:'${comImagePath}btn_wangzhelianm_sel.png'},
		{id:'cancel',name:'返回',action:'cancle()',right:'exit',focusImage:'${imagePath}btn_quxiao_sel.png'},
		{id:'exit',name:'离开',action:'exit()',left:'cancel',focusImage:'${imagePath}btn_tuichu_sel.png'}
	];
	 
	//设置走位
	buttons[6].right='recommend_1';buttons[6].up='home';buttons[6].down='recommend_3';
	buttons[7].left='recommend_0';buttons[7].right='recommend_2';buttons[7].up='home';buttons[7].down='recommend_5';
	buttons[8].left='recommend_1';buttons[8].up='home';buttons[8].down='recommend_7';
	buttons[9].right='recommend_1';buttons[9].up='recommend_0';buttons[9].down='recommend_4';
	buttons[10].right='recommend_5';buttons[10].up='recommend_3';
	buttons[11].left='recommend_4';buttons[11].right='recommend_6';buttons[11].up='recommend_1';
	buttons[12].left='recommend_5';buttons[12].right='recommend_7';buttons[12].up='recommend_1';
	buttons[13].left='recommend_6';buttons[13].up='recommend_2';
	

	//改变导航显示效果
//	function focusChangeClass(button){
//		G(button.id+"_div").className = "novi_sel";
//		currentZindex++;
//		G(button.id+"_div").style.zIndex  =  currentZindex;
//	}
//	function blurChangeClass(button) {
//		if (button.id == currentNavi){
//			G(button.id+"_div").className = "novi_focus";
//			return;
//		}
//		G(button.id + "_div").className = "novi_nor";
//	}

	
	//有放大的效果 所以需要设置z index，
	var currentZindex = 100;
	var originData = {};

	function focusChangeVodClass(button){
		S(button.id+"_border_1");
		S(button.id+"_border_2");
		S(button.id+"_border_3");
		S(button.id+"_border_4");
		currentZindex++;
		G(button.id+"_div").style.zIndex  =  currentZindex;
		G(button.id+"_div").className = "div_com video_focused";
	}

	function blurChangeVodClass(button){
		H(button.id+"_border_1");
		H(button.id+"_border_2");
		H(button.id+"_border_3");
		H(button.id+"_border_4");
		G(button.id+"_div").className = "div_com";
	}

	function setZIndex(button){
		S(button.id+"_border_1");
		S(button.id+"_border_2");
		S(button.id+"_border_3");
		S(button.id+"_border_4");
		currentZindex++;
		G(button.id+"_div").style.zIndex  =  currentZindex;
		G(button.id+"_div").className = "div_com focused";
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
		H(button.id+"_border_1");
		H(button.id+"_border_2");
		H(button.id+"_border_3");
		H(button.id+"_border_4");
		G(button.id+"_div").className = "div_com";

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
		
		
		//如果是第一个推荐位 跳到活动公告
//		if(button.id == 'recommend_0'){
//			epg.go('column/person_center/index.jsp?method=activity&source=home', button.code);
//			return;
//		}
		if(button.type == 'recommend_video')//如果是视频
		{
			playVideo(button.code, elementCodeSrc);
		}
		else if(button.type == 'recommend_series')//如果是剧集
		{
			//epg.go('column/content_list/home.jsp?code='+button.code+'&elementCodeSrc=${columnIdx}', button.code);
			//如果是剧集，去视频详细页
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
	}
	
	/*跳转到栏目*/
	function goColumn(button)
	{
		var code = epg.btn.current.code;
		if(button.id == 'home'){
			epg.go('home.jsp', code);
			return;
		}
		if(button.id == 'personCenter'){
			epg.go('column/person_center/index.jsp', code);
			return;
		}
		
		if(button.id == 'search'){
			epg.go('column/search/search.jsp', code);
			return;
		}
		
		if(button.id == 'history'){
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

	Epg.key.set(
		{
			KEY_PLAY_PAUSE:'videoWindow.Epg.Mp.playOrPause()'
		});

	var state = "play";
	function pAndp(button){
		//暂停  播放
		if(state == "play"){
			S("play");
			state = "pause";
		}else{
			H("play");
			state = "play";
		}
		videoWindow.Epg.Mp.playOrPause();
	}

	var  currentBtnID,exit_dialog = false;//记录退出弹出框前的焦点按钮
 	//返回
	function back()
	{
		//currentZindex++;
		//G("exit_dialog_div").style.zIndex  =  currentZindex;
		if(!exit_dialog)
		{
			currentBtnID =  Epg.btn.current.id;
			S('exit_dialog_div');
			epg.btn.set('cancel');
			exit_dialog =true;
		}else
			cancle();
	}
 
	function cancle()
	{
		H('exit_dialog_div');
		epg.btn.set(currentBtnID);
		exit_dialog = false;
	}
	
	function exit()
	{
		if(is_ott) {
			iflytekMp.exitApp();
			return;//如果是OTT版，直接调用方法退出APK
		}else{
			window.location.href = Authentication.CTCGetConfig('EPGDomain');
		}
	}	
	
	window.onload=function()
	{
		setTimeout(function(){
			var playFrame = G('videoFrame');
			playFrame.src = "${basePath}media_player.jsp?method=addVideo&code=${smallVod.value}&andPlay=true&dolog=false&display=smallvod&left=340&top=137&width=606&height=340&source=${target}&sourceType=column&metadataType=smallvod";
		},0);
		Epg.btn.init(['${param.f}','recommend_1'],buttons,'${imagePath}',true);
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

	function playbackOnCompletion(){
		var playFrame = G('videoFrame');
		playFrame.src = "${basePath}media_player.jsp?method=addVideo&code=${smallVod.value}&andPlay=true&dolog=false&display=smallvod&left=340&top=137&width=606&height=340&source=${target}&sourceType=column&metadataType=smallvod";
	}

	</script>
	
</head>
<body>
	<div id="home_div" class="novi_focus"><img id="home" src="${comImagePath}btn_shouye_click.png"></div>
	<div id="tszl_div" class="novi_nor"><img id="tszl" src="${comImagePath}btn_zhuanlan_nor.png"></div>
	<div id="djss_div" class="novi_nor"><img id="djss" src="${comImagePath}btn_saishi_nor.png"></div>
	<div id="twgz_div" class="novi_nor"><img id="twgz" src="${comImagePath}btn_zhanbang_nor.png"></div>
	<div id="yxlm_div" class="novi_nor"><img id="yxlm" src="${comImagePath}btn_dianjing_nor.png"></div>
	<div id="wzry_div" class="novi_nor"><img id="wzry" src="${comImagePath}btn_wangzhelianm_nor.png"></div>

	<!-- 只是一个占位符 -->
	<%--<div><img id="home" src="${touming}" /></div>--%>
	<%--<div><img id="tszl" src="${touming}" /></div>--%>
	<%--<div><img id="djss" src="${touming}" /></div>--%>
	<%--<div><img id="twgz" src="${touming}" /></div>--%>
	<%--<div><img id="yxlm" src="${touming}" /></div>--%>
	<%--<div><img id="wzry" src="${touming}" /></div>--%>
	<!-- 只是一个占位符 -->
	
	<div style="position:absolute;left:15px;top:6px;" >
		<img id="searchimg" 	src="${comImagePath}btn_search_nor.png" />
	</div>
	
	<div style="position:absolute;left:15px;top:6px;" >
		<img id="search" 	src="${touming}" />
	</div>
	
	<div style="position:absolute;left:1164px;top:6px;" >
		<img id="personCenter" 	src="${comImagePath}btn_mine_nor.png" />
	</div>
	
	<%--<div id="history_div" style="position:absolute;left:62px;top:543px;width:235px;height: 111px;" >--%>
		<%--<img id="history" 	src="${comImagePath}pic2_nor.png?ver=1121" />--%>
	<%--</div>--%>

	<c:forEach items="${recommendList}" var="p" varStatus="vs" begin='0' end='0' >
		<div class="div_com" id='recommend_${vs.index}_div'>
			<img id="recommend_${vs.index}_border_1" style="position: absolute;left:-5px;top:-5px;width:20px;visibility:hidden" src="${comImagePath}pic_sel_1.png" alt="">
			<img id="recommend_${vs.index}_border_2" style="position: absolute;top: -5px;right:-5px;width:20px;visibility:hidden" src="${comImagePath}pic_sel_2.png" alt="">
			<img id="recommend_${vs.index}_border_3" style="position: absolute;bottom:-5px;left:-5px;width:20px;visibility:hidden" src="${comImagePath}pic_sel_3.png" alt="">
			<img id="recommend_${vs.index}_border_4" style="position: absolute;bottom:-5px;right:-5px;width:20px;visibility:hidden" src="${comImagePath}pic_sel_4.png" alt="">
			<img id="recommend_${vs.index}" class="post_img" src="${basePath}${p.linkImageUri}" />
		</div>
	</c:forEach>

	<c:forEach items="${recommendList}" var="p" varStatus="vs" begin='1' end='1' >
		<div class="div_com" id='recommend_${vs.index}_div'>
			<img id="recommend_${vs.index}_border_1" style="position: absolute;left:-5px;top:-5px;width:20px;visibility:hidden" src="${comImagePath}pic_sel_1.png" alt="">
			<img id="recommend_${vs.index}_border_2" style="position: absolute;top: -5px;right:-5px;width:20px;visibility:hidden" src="${comImagePath}pic_sel_2.png" alt="">
			<img id="recommend_${vs.index}_border_3" style="position: absolute;bottom:-5px;left:-5px;width:20px;visibility:hidden" src="${comImagePath}pic_sel_3.png" alt="">
			<img id="recommend_${vs.index}_border_4" style="position: absolute;bottom:-5px;right:-5px;width:20px;visibility:hidden" src="${comImagePath}pic_sel_4.png" alt="">
			<img id="recommend_${vs.index}" class="post_img" src="${touming}" />
			<img id="play" style="position:absolute;left:259px;top:126px;visibility:hidden" src="${comImagePath}ico_play.png" alt="">
		</div>
	</c:forEach>
	<div style="position:absolute; left:336px; top:133px; width:606px; height:340px;">
		<iframe id="videoFrame" name="videoFrame" src="" width="1" height="1" bgcolor="transparent" allowtransparency="true" frameborder="0" scrolling="no"></iframe>
	</div>
	
	<c:forEach items="${recommendList}" var="p" varStatus="vs" begin='2' end='2' >
		<div class="div_com" id='recommend_${vs.index}_div'>
			<img id="recommend_${vs.index}_border_1" style="position: absolute;left:-5px;top:-5px;width:20px;visibility:hidden" src="${comImagePath}pic_sel_1.png" alt="">
			<img id="recommend_${vs.index}_border_2" style="position: absolute;top: -5px;right:-5px;width:20px;visibility:hidden" src="${comImagePath}pic_sel_2.png" alt="">
			<img id="recommend_${vs.index}_border_3" style="position: absolute;bottom:-5px;left:-5px;width:20px;visibility:hidden" src="${comImagePath}pic_sel_3.png" alt="">
			<img id="recommend_${vs.index}_border_4" style="position: absolute;bottom:-5px;right:-5px;width:20px;visibility:hidden" src="${comImagePath}pic_sel_4.png" alt="">
			<img id="recommend_${vs.index}" class="post_img" src="${basePath}${p.linkImageUri}" />
		</div>
	</c:forEach>
	
	<c:forEach items="${recommendList}" var="p" varStatus="vs" begin='3' end='3' >
		<div class="div_com" id='recommend_${vs.index}_div'>
			<img id="recommend_${vs.index}_border_1" style="position: absolute;left:-5px;top:-5px;width:20px;visibility:hidden" src="${comImagePath}pic_sel_1.png" alt="">
			<img id="recommend_${vs.index}_border_2" style="position: absolute;top: -5px;right:-5px;width:20px;visibility:hidden" src="${comImagePath}pic_sel_2.png" alt="">
			<img id="recommend_${vs.index}_border_3" style="position: absolute;bottom:-5px;left:-5px;width:20px;visibility:hidden" src="${comImagePath}pic_sel_3.png" alt="">
			<img id="recommend_${vs.index}_border_4" style="position: absolute;bottom:-5px;right:-5px;width:20px;visibility:hidden" src="${comImagePath}pic_sel_4.png" alt="">
			<img id="recommend_${vs.index}" class="post_img" src="${basePath}${p.linkImageUri}" />
		</div>
	</c:forEach>
	
	<c:forEach items="${recommendList}" var="p" varStatus="vs" begin='4' end='4' >
		<div class="div_com" id='recommend_${vs.index}_div'>
			<img id="recommend_${vs.index}_border_1" style="position: absolute;left:-5px;top:-5px;width:20px;visibility:hidden" src="${comImagePath}pic_sel_1.png" alt="">
			<img id="recommend_${vs.index}_border_2" style="position: absolute;top: -5px;right:-5px;width:20px;visibility:hidden" src="${comImagePath}pic_sel_2.png" alt="">
			<img id="recommend_${vs.index}_border_3" style="position: absolute;bottom:-5px;left:-5px;width:20px;visibility:hidden" src="${comImagePath}pic_sel_3.png" alt="">
			<img id="recommend_${vs.index}_border_4" style="position: absolute;bottom:-5px;right:-5px;width:20px;visibility:hidden" src="${comImagePath}pic_sel_4.png" alt="">
			<img id="recommend_${vs.index}" class="post_img" src="${basePath}${p.linkImageUri}" />
		</div>
	</c:forEach>
	
	<c:forEach items="${recommendList}" var="p" varStatus="vs" begin='5' end='5' >
		<div class="div_com" id='recommend_${vs.index}_div'>
			<img id="recommend_${vs.index}_border_1" style="position: absolute;left:-5px;top:-5px;width:20px;visibility:hidden" src="${comImagePath}pic_sel_1.png" alt="">
			<img id="recommend_${vs.index}_border_2" style="position: absolute;top: -5px;right:-5px;width:20px;visibility:hidden" src="${comImagePath}pic_sel_2.png" alt="">
			<img id="recommend_${vs.index}_border_3" style="position: absolute;bottom:-5px;left:-5px;width:20px;visibility:hidden" src="${comImagePath}pic_sel_3.png" alt="">
			<img id="recommend_${vs.index}_border_4" style="position: absolute;bottom:-5px;right:-5px;width:20px;visibility:hidden" src="${comImagePath}pic_sel_4.png" alt="">
			<img id="recommend_${vs.index}" class="post_img" src="${basePath}${p.linkImageUri}" />
		</div>
	</c:forEach>
	
	<c:forEach items="${recommendList}" var="p" varStatus="vs" begin='6' end='6' >
		<div class="div_com" id='recommend_${vs.index}_div'>
			<img id="recommend_${vs.index}_border_1" style="position: absolute;left:-5px;top:-5px;width:20px;visibility:hidden" src="${comImagePath}pic_sel_1.png" alt="">
			<img id="recommend_${vs.index}_border_2" style="position: absolute;top: -5px;right:-5px;width:20px;visibility:hidden" src="${comImagePath}pic_sel_2.png" alt="">
			<img id="recommend_${vs.index}_border_3" style="position: absolute;bottom:-5px;left:-5px;width:20px;visibility:hidden" src="${comImagePath}pic_sel_3.png" alt="">
			<img id="recommend_${vs.index}_border_4" style="position: absolute;bottom:-5px;right:-5px;width:20px;visibility:hidden" src="${comImagePath}pic_sel_4.png" alt="">
			<img id="recommend_${vs.index}" class="post_img" src="${basePath}${p.linkImageUri}" />
		</div>
	</c:forEach>
	
	<c:forEach items="${recommendList}" var="p" varStatus="vs" begin='7' end='7' >
		<div class="div_com" id='recommend_${vs.index}_div'>
			<img id="recommend_${vs.index}_border_1" style="position: absolute;left:-5px;top:-5px;width:20px;visibility:hidden" src="${comImagePath}pic_sel_1.png" alt="">
			<img id="recommend_${vs.index}_border_2" style="position: absolute;top: -5px;right:-5px;width:20px;visibility:hidden" src="${comImagePath}pic_sel_2.png" alt="">
			<img id="recommend_${vs.index}_border_3" style="position: absolute;bottom:-5px;left:-5px;width:20px;visibility:hidden" src="${comImagePath}pic_sel_3.png" alt="">
			<img id="recommend_${vs.index}_border_4" style="position: absolute;bottom:-5px;right:-5px;width:20px;visibility:hidden" src="${comImagePath}pic_sel_4.png" alt="">
			<img id="recommend_${vs.index}" class="post_img" src="${basePath}${p.linkImageUri}" />
		</div>
	</c:forEach>

	
		<!-- 退出弹出框 -->

	<div id="exit_dialog_div"  style="position:absolute;left:457px;top:234px;width:367px;height:253px;background: url('${imagePath}bg_quit.png');visibility:hidden;z-index:300;" >
		<div style="left: 13px; top: 146px;background: url('${imagePath}btn_quxiao_nor.png');width:170px;height:77px;" ><img id="cancel" src="${touming}"></div>
		<div style="left: 187px; top: 146px;background: url('${imagePath}btn_tuichu_nor.png');width:170px;height:77px;" ><img id="exit" src="${touming}"/></div>
	</div>	

	<%@include file="/com/com_bottom.jsp"%>
	
</body>
</html>