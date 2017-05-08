<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/com/com_head.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/tags/epg" prefix="epg" %>
<%@ taglib tagdir="/WEB-INF/tags/epg" prefix="e" %>
<title>特辑专区</title>
<%!
    
	public static final String COLUMN_CODE = "20160113_tjzq_column";//栏目code
	
	%>
<%  
	String code = HttpUtils.getString(request, "code", "");
	String ALBUMN_CODE = code;//专辑code
	
	String sp = HttpUtils.getString(request, "p", "2");
	int p=Integer.parseInt(sp); //视频位置
	String CURRENT_URI = BASE_PATH+ "column/"+COLUMN_CODE+ "/template.jsp?1=1&code="+code;//当前页面访问地址
	imagePath = BASE_IMAGE_PATH + "column/"+COLUMN_CODE+"/";//修正图片路径
	setAttr
	(
		request,
		"ALBUMN_CODE",ALBUMN_CODE,
		"imagePath", imagePath,//图片路径
		"currentURI", CURRENT_URI,//当前页面路径
		"backURI", getBackURI(request, response),//返回路径
		"target", COLUMN_CODE//记录日志用到的target
	);
	
	//HttpUtils.clearMarkedURI(API_URL, new UserStore(request, response).getUserid(), "returnURI", "backURI", "menuBackURI");
	
	//根据栏目code取得首页Epg对象
	List<EpgMetadata> metadataList = getEpg(ALBUMN_CODE).getGroups().get(0).getMetadatas();
	EpgMetadata title = metadataList.get(0);
	EpgMetadata content = metadataList.get(1);
	EpgMetadata video = metadataList.get(p);
	String contentlength = content.getLabel();
	
	boolean isScroll = false;
	if( contentlength.length()>150){
		//introduction = introduction.substring(0,38)+"...";
		isScroll = true;
	}
	
	
	setAttr
	(
		request,
		"p",p,
		"video",video,
		"title",title,
		"content",content,
		"metadataList",metadataList,
		"metadatasize",metadataList.size()
		
		
	);
%>

<%-------------------------- 与样式相关代码开始 ----------------------------%>
<!-- 如果是高清版 -->
<c:if test="${!isSD}">

	
	
	<style type="text/css">

/*标题和内容和图片*/
	div#title{left:36px;top:56px;text-align:center;width:280px;height:100px;color:yellow;overflow:hidden;font-size:25px;}
	div#content{left:36px;top:170px;width:280px;height:340px;color:white;overflow:hidden;font-size:20px;}
	div#photo{left:450px;top:0px;}
	#photoimg{width:730px;height:720px;}

 
    /*分页*/
	div.page_up_img_div{left:393px;top:349px;}
	div.page_down_img_div{left:1210px;top:349px;}
	div.play_div{left:85px;top:581px;}
	div.playbg_div{left:95px;top:596px;}
	</style>
</c:if>
<%-------------------------- 与样式相关代码结束 ----------------------------%>

<script type="text/javascript">
	var spacer = '<%=SPACER%>';
		
	var buttons = 
	[	
        //{id:'page_up',action:'pageUp()',linkImage:'',focusImage:'${comImagePath}page_up_f1.png',left:'play',right:'page_down',down:'play',up:''},
        //{id:'page_down',action:'pageDown()',linkImage:'',focusImage:'${comImagePath}page_down_f1.png',left:['page_up','play'],right:'',down:'',up:''},
      
    
        {id:'play',action:'play()', code:'${video.value}',linkImage:'',focusImage:'${comImagePath}play.png',left:'',right:['page_up','page_down'],down:'',up:['page_up','page_down'],moveHandler:goPageHandler},
     
			
	];
	



	Epg.key.set(
	{
		KEY_PAGE_UP:'pageUp()',
		KEY_PAGE_DOWN:'pageDown()',
		KEY_PLAY_PAUSE:'videoWindow.Epg.Mp.playOrPause()',
		KEY_FAST_FORWARD:'videoWindow.Epg.Mp.fastForward()',
		KEY_FAST_REWIND:'videoWindow.Epg.Mp.fastRewind()',
		KEY_VOL_UP:'videoWindow.Epg.Mp.volUp()',
		KEY_VOL_DOWN:'videoWindow.Epg.Mp.volDown()',
		KEY_MUTE:'videoWindow.Epg.Mp.toggleMuteFlag()',
		KEY_TRACK:'videoWindow.Epg.Mp.switchAudioChannel()',
		EVENT_MEDIA_END:'pageDown("passive")',
		EVENT_MEDIA_ERROR:'Epg.tip("视频播放错误!")'
	});
	
	//上一页
	function pageUp()
	{
		location.href="${currentURI}&code=${ALBUMN_CODE}&f=page_up&p="+${p-1};
		
	}
	
	//下一页
	function pageDown()
	{		
		location.href="${currentURI}&code=${ALBUMN_CODE}&f=page_down&p="+${p+1};
	}
	
	
	//播放
	function play(){
		
		var btn = epg.btn.current;
		var elementCodeSrc = '';//来源页面元素编码
	
		playVideo(btn.code, elementCodeSrc);
      
	
	}
	
	
	function goPageHandler(previous,current,dir){

		if(previous.id=='play'&&${p>2}&&dir=='left'){
			
			pageUp();
		}else if(previous.id=='play'&&${p<metadatasize-1}&&dir=='right'){
			
			pageDown();
		}

	}
		
	
	//返回
	function back()
	{
		location.href='${backURI}';
	}
	
	window.onload=function()
	{   
		Epg.tip('${param.info}');//显示info信息，3秒自动隐藏，如果info为空将不会显示
		Epg.btn.init(['${param.f}','play'],buttons,'${imagePath}',true);
	
	
	};	
</script>
	
</head>
<body style="background-image: url('${imagePath}template_bg.jpg')">
	
	
	<!-- 标题 -->
	
		<div id="title"> ${title.label}</div>		
		
	
	<!-- 内容 -->	
		
		 <div id="content"> ${content.label}</div>		
		
		
	<!-- 视频图片 -->		
		<div id="photo" >
		   <img id="photoimg" src="${basePath}${video.linkImageUri}"/>	
		</div>
		
	<!-- 上一页 -->
	<c:if test="${p>2}">
		<div class="page_up_img_div"><img id="page_up" src="${comImagePath}page_up.png"/></div>
	</c:if>

	<!-- 下一页 -->
	<c:if test="${p<metadatasize-1}">
		<div class="page_down_img_div"><img  id="page_down" src="${comImagePath}page_down.png"/></div>
    </c:if>
     <!-- 播放 -->
	    <div class="playbg_div"><img  src="${imagePath}play_bg.png"/></div>
		<div class="play_div"><img  id="play" src="<%=SPACER%>"/></div>
	
	<%@include file="/com/com_bottom.jsp"%>
	
	
</body>
</html                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         >                            