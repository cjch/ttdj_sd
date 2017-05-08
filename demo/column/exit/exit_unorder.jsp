<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/com/com_head.jsp" %>
<%!

	public static final String COLUMN_NAME = "health_exit";//栏目名称
	public static final String COLUMN_CODE = "ggly_exit_recommend";//栏目code，取数据用
	public static final String CURRENT_URI = BASE_PATH+"column/exit/exit.jsp?1=1";//当前页面访问地址

	public static final String ALBUM_IMAGE_PATH = BASE_PATH+"resources/upload/series/sd/thumb/";//专辑封面图片路径

%>
<%
	//以下3个字段最好每个页面都需要设置
	setAttr
	(
		request,
		"backURI", getBackURI(request, response),//返回路径
		"currentURI", CURRENT_URI,//当前页面URL
		"target", COLUMN_NAME//记录日志用到的target
	);

	UserStore store = new UserStore(request,response);
	
	GetEpgRequest req = new GetEpgRequest();
	req.setAppVersion(APP_VERSION);
	req.setCode(COLUMN_CODE);
	Epg epg = new EpgExecutor(API_URL).get(req);
	List<EpgMetadataGroup> groupList = epg.getGroups();
	
	//获得列表
	EpgMetadataGroup group0 = groupList.get(0);
	List<EpgMetadata> metadataList = group0.getMetadatas();

	
%>
	<title>退出健身团-未订购用户</title>
	<!-- 如果是标清版本 -->
	<c:if test="${isSD }">
	<%
	setAttr
	(
		request,
		"metadataList", metadataList,
		"lefts", new int[]{81,239,391,239,391},
		"tops", new int[]{105,105,105,248,248},
		"leftsAdd",6,
		"topsAdd",8,
		"linkImageWidth",154,
		"linkImageHeight0",293,
		"linkImageHeight",142,
		"albumTxtLeftsAdd",10,
		"albumTxtTops0",250,
		"albumTxtTops",112,
		"albumSpacerWidth",164,
		"albumSpacerHeight0",301,
		"albumSpacerHeight",156
	);
	%>
	<style type="text/css">
	/*页码信息*/
	.page_info{left: 270px;top: 461px;font-size: 20px;color: rgb(0, 88, 11);width: 95px;height: 27px;text-align: center;line-height: 27px;}
	div.album_txt_div{width: 140px;height: 28px;text-align: center;line-height: 28px;font-size: 16px;color: rgb(5, 63, 44);font-weight: bold;}
	/*下次再来*/
	div#ok_div{left:254px;top:424px;}
	</style>
	</c:if>
	
	<!-- 如果是高清版本 -->
	<c:if test="${!isSD }">
	<%
	setAttr
	(
		request,
		"metadataList", metadataList,
		"lefts", new int[]{81,239,391,239,391},
		"tops", new int[]{105,105,105,248,248},
		"leftsAdd",6,
		"topsAdd",8,
		"linkImageWidth",154,
		"linkImageHeight0",293,
		"linkImageHeight",142,
		"albumTxtLeftsAdd",10,
		"albumTxtTops0",250,
		"albumTxtTops",112,
		"albumSpacerWidth",164,
		"albumSpacerHeight0",301,
		"albumSpacerHeight",156
	);
	%>
	<style type="text/css">
	/*页码信息*/
	.page_info{left: 270px;top: 461px;font-size: 20px;color: rgb(0, 88, 11);width: 95px;height: 27px;text-align: center;line-height: 27px;}
	div.album_txt_div{width: 140px;height: 28px;text-align: center;line-height: 28px;font-size: 16px;color: rgb(5, 63, 44);font-weight: bold;}
	/*下次再来*/
	div#ok_div{left:254px;top:424px;}
	</style>
	</c:if>
	
	<script type="text/javascript">

	var buttons=
	[
		<c:forEach items="${metadataList}" var="p" varStatus="i">
		{id:'album_${i.index}',name:'专辑_${i.index}',code:'${p.value}',action:'goVideoList()',focusImage:'album${i.index==0?"_long":""}_f.png',left:['album_${(i.index==1||i.index==3)?0:(i.index-1)}'],right:['album_${i.index+1}'],up:['album_${i.index-2}'],down:['album_${i.index==0?"":(i.index+2)}','ok']},
		</c:forEach>
		{id:'ok',name:'下次再来',action:'back()',focusImage:'ok_f.png',up:'album_3'}
	];
	
	//返回
	function back()
	{
		<c:if test="${isOTT}">
			android.exitAPK();//如果是OTT版，直接调用方法退出APK
			return;
		</c:if>
		if('${back_epg_url}')//如果cookie里面设置了该参数，返回到该地址
			location.href = '${back_epg_url}';
		else
			goIptvPortal();
	}
	
	//跳转到视频列表页面
	function goVideoList()
	{
		epg.go('column/content_list/content_list.jsp?code='+Epg.btn.current.code, 'content_list');
	}
	
	//跳转到视频播放页面
	function goVideo()
	{
		playSeries();//调用定义在com_bottom.jsp中的通用播放电视剧方法
	}
	
	window.onload=function()
	{
		Epg.tip('${param.info}');//显示info信息，3秒后自动隐藏，如果info为空将不会显示
		Epg.btn.init(['${param.f}','album_11','ok'],buttons,'${imagePath}',true);	
	};

	</script>
	
</head>
<body style="background-image: url('${imagePath}background_unorder.jpg')">
	
	<c:forEach items="${metadataList}" var="p" varStatus="i">
		<div style="left:${lefts[i.index]+leftsAdd}px;top:${tops[i.index]+topsAdd}px;">
			<img src="${basePath}${p.linkImageUri}" width="${linkImageWidth }" height="${i.index==0? linkImageHeight0 : linkImageHeight}"/>
		</div>
		<div class="album_txt_div" style="left:${lefts[i.index]+albumTxtLeftsAdd}px;top:${tops[i.index]+(i.index==0?albumTxtTops0:albumTxtTops)}px;">
			${p.label}
		</div>
		<div style="left:${lefts[i.index]}px;top:${tops[i.index]}px;">
			<img id="album_${i.index}" src="<%=SPACER %>" width="${albumSpacerWidth }" height="${i.index==0? albumSpacerHeight0 : albumSpacerHeight}"/>
		</div>
	</c:forEach>
	
	<!-- 下次再来 -->
	<div id="ok_div">
		<img id="ok" src="<%=SPACER%>"/>
	</div>
	
	<%@include file="/com/com_bottom.jsp"%>
	
</body>
</html>