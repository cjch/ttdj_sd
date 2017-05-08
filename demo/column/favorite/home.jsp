<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/com/com_head.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/tags/epg" prefix="epg" %>
<%@ taglib tagdir="/WEB-INF/tags/epg" prefix="e" %>
<title>首页</title>
<%!
	public static final String COLUMN_CODE = "favorite";//栏目code
	public static final String CURRENT_URI = BASE_PATH+ "column/"+COLUMN_CODE+ "/home.jsp?1=1";//当前页面访问地址
%>
<%
	imagePath = BASE_IMAGE_PATH + "column/"+COLUMN_CODE+"/";//修正图片路径
	String newComImages = BASE_IMAGE_PATH + "newCom/";
	setAttr
	(
		request,
		"imagePath", imagePath,//图片路径
		"newComImages",newComImages,
		"currentURI", CURRENT_URI,//当前页面URL
		"backURI", getBackURI(request, response),//返回路径
		"target", COLUMN_CODE//记录日志用到的target
	);
	
	/*
	int programId = getProgramId(COLUMN_CODE);//栏目code
	if(programId<=0)//programId小于0说明后台报错了，一般都是由于code不存在
	{
		redirect(request, response, "/com/500.jsp?info="+encode("获取节目单ID失败:"+COLUMN_CODE));
		return;
	}
	//获取内容
	GetProgramResponse resp = post
	(
		"program/get", GetProgramResponse.class,
		"id", programId,
		"current", getParamInt(request, "p", 1),
		"pageSize", 12
	);
	setAttr
	(
		request,
		"pb", resp.getPb()//数据对象
	);
	*/
	UserStore store = new UserStore(request,response);
	GetFavoritesRequest req = new GetFavoritesRequest();
	req.setUserid(store.getUserid());
	req.setRole(store.getRole());
	req.setType("series");
	req.setAppVersion(APP_VERSION);
	req.setCurrent(HttpUtils.getInt(request, "p", 1));
	req.setPageSize(10);
	GetFavoritesResponse resp = new FavoritesExecutor(API_URL).getFavorites(req);
	if(resp.getPb().getPageCount()>0){
		request.setAttribute("pb", resp.getPb());
	}else{
		int programId = getProgramId(COLUMN_CODE);//栏目code
		if(programId<=0)//programId小于0说明后台报错了，一般都是由于code不存在
		{
			redirect(request, response, "/com/500.jsp?info="+encode("获取节目单ID失败:"+COLUMN_CODE));
			return;
		}
		//获取内容
		GetProgramResponse resp2 = post
		(
			"program/get", GetProgramResponse.class,
			"id", programId,
			"current", getParamInt(request, "p", 1),
			"pageSize", 10
		);
		request.setAttribute("pb", resp2.getPb());
	}
%>

<%-------------------------- 与样式相关代码开始 ----------------------------%>
<!-- 如果是标清版 -->
<c:if test="${isSD}">
	<%
		setAttr
		(
			request,
			"albumLeftStart", 52,//剧集left起始
			"albumLeftAdd", 112,//剧集left递增
			"albumTopStart", 85,//剧集top起始
			"albumTopAdd", 210,//剧集top递增
			"focusLeftAdjust", -7,//剧集焦点图left调整
			"focusTopAdjust", -10//剧集焦点图top调整
		);
	%>
	<style type="text/css">
	
	
	/*中间剧集*/
	div.album_img_div{left:0px; top:0px;}
	img.album_img{position:absolute;left:-0px;top:-0px;width:83px; height:156px;}
	img.album_img_b{position:absolute;left:-5px;top:-7px;width:93px; height:170px;}
	img.album_f{width:97px; height:175px;}
	div.album_vods_position{left:-2px;top:181px;font-size: 16px;text-align: left;color:#ffffff;overflow: hidden;line-height: 24px;width:85px;height: 24px;}
	div.album_txt_position{left:-7px;top:161px;}
	/*分页*/
	div.page_up_img_div{left:18px;top:280px;}
	div.page_down_img_div{left:598px;top:280px;}
	div.page_bg_img_div{left:588px;top:470px;}
	div.page_info{left: 588px;top: 470px;font-size: 13px;color: #ffffff;width:35px;height: 20px;text-align: center;line-height: 20px;z-index:100;}
	</style>
</c:if>
<!-- 如果是高清版 -->
<c:if test="${!isSD}">
	<%
		setAttr
		(
			request,
			"albumLeftStart", 85,//剧集left起始 
			"albumLeftAdd", 190,//剧集left递增328
			"albumTopStart", 102,//剧集top起始
			"albumTopAdd", 306,//剧集top递增 
			"focusLeftAdjust", -15,//剧集焦点图left调整 92
			"focusTopAdjust", -15//剧集焦点图top调整 146
		);
	%>
	<style type="text/css">
   	div#tjzq_div{left:536px; top:30px;}
   				/* 顶部推荐位*/
	div#column_btn_0_div{left: 84px;top: 54px;}
	div#column_btn_1_div{left: 169px;top: 39px;}
	div#column_btn_2_div{left: 350px;top: 54px;}
	div#column_btn_3_div{left: 501px;top: 54px;}
	div#column_btn_4_div{left: 653px;top: 52px;}
	div#column_btn_5_div{left: 803px;top: 54px;}
	div#column_btn_6_div{left: 954px;top: 54px;}
	div#column_btn_7_div{left: 1106px;top: 54px;}
	
		/*顶部推荐位图片大小*/
	img#column_btn_0{width:50px; height:27px;}
	img#column_btn_1{width:160px; height:60px;}
	img#column_btn_2{width:100px; height:27px;}
	img#column_btn_3{width:100px; height:27px;}
	img#column_btn_4{width:98px; height:28px;}
	img#column_btn_5{width:101px; height:27px;}
	img#column_btn_6{width:100px; height:27px;}
	img#column_btn_7{width:100px; height:27px;}


	/*中间剧集*/
	div.album_img_div{left:0px; top:0px;}
	img.album_img{position:absolute;left:0px;top:0px;width:168px; height:210px;}
	img.album_img_b{position:absolute;left:-8px;top:-8px;width:185px; height:231px;}
	img.album_f{width:198px; height:240px;}
	div.album_vods_position{left:3px;top:250px;font-size: 16px;text-align: left;color:#ffffff;overflow: hidden;line-height: 24px;width:165px;height: 24px;}
	div.album_txt_position{left:-4px;top:220px;}
	/*分页*/
	div.page_up_img_div{left:36px;top:378px;}
	div.page_down_img_div{left:1220px;top:378px;}
	div.page_up_img{left:541px;top:654px;}
	div.page_down_img{left:700px;top:654px;}
	div.page_bg_img_div{left:588px;top:654px;}
	.page_bg_img_div img{width:118px;height: 50px;}
	
	div.page_info{left:593px;top:665px;font-size: 24px;color: #ffffff;width:108px;height: 26px;text-align: center;line-height: 26px;z-index:100;}
	</style>
</c:if>
<%-------------------------- 与样式相关代码结束 ----------------------------%>

	<script type="text/javascript">
	var spacer = '<%=SPACER%>';
	focusImageCollection = '${newComImages}CollectionImage.png';
	focusImageOrder = '${newComImages}order_f.png';
	focusImageHotRank = '${newComImages}HotRankImage.png';
	
	var buttons = 
	[	   
		<c:choose>
		<c:when test="${!isSD }">
		//{id:'page_up',action:'pageUp()',linkImage:'${newComImages}page_up1.png',focusImage:'${newComImages}page_up_f1.png',left:['page_up'],right:'page_down',down:[''],up:['album_1_2','album_1_1','album_1_0','album_0_2','album_0_1','album_0_0']},
		//{id:'page_down',action:'pageDown()',linkImage:'${newComImages}page_down1.png',focusImage:'${newComImages}page_down_f1.png',left:['page_up'],down:[''],right:'',up:['album_1_2','album_1_1','album_1_0','album_0_2','album_0_1','album_0_0']},
		<epg:forEach items="${pb.dataList }" var="p" column="6">
			{id:'album_${r}_${c}',name:'剧集_${r}_${c}',animate:true,type:'${p.type}',code:'${p.code}',action:'goVideoList()',focusHandler: focusAlbum,blurHandler: blurAlbum, focusImage:'${newComImages}album_f.png',
				left:'album_${r}_${c-1}',
				right:'album_${r}_${c+1}',
				up:['album_${r-1}_${c}',${c==4?"'column_btn_6','column_btn_5',":(c==3?"'column_btn_5','column_btn_4',":(c==2?"'column_btn_4','column_btn_3',":(c==1?"'column_btn_2','column_btn_1',":"")))}'column_btn_0'],
				down:['album_${r+1}_${c}','album_${r+1}_${c-1}','album_${r+1}_${c-2}','album_${r+1}_${c-3}','album_${r+1}_${c-4}','${c<3?"page_up":"page_down"}','page_up','page_down'],
				focusHandler:showBigImage,blurHandler:showSmallImage,moveHandler:goPageHandler},
		</epg:forEach>
		</c:when>
		<c:otherwise>
		<epg:forEach items="${pb.dataList }" var="p" column="5" r="0">
			{id:'album_${r}_${c}',name:'剧集_${r}_${c}',animate:true,type:'${p.type}',code:'${p.code}',action:'goVideoList()',focusHandler: focusAlbum,blurHandler: blurAlbum, focusImage:'${newComImages}album_f.png',left:'album_${r}_${c-1}',right:'album_${r}_${c+1}',up:['album_${r-1}_${c}',${c==4?"'column_btn_6','column_btn_5',":(c==3?"'column_btn_5','column_btn_4',":(c==2?"'column_btn_4','column_btn_3',":(c==1?"'column_btn_2','column_btn_1',":"")))}'column_btn_0'],down:['album_${r+1}_${c}','album_${r+1}_${c-1}','album_${r+1}_${c-2}','album_${r+1}_${c-3}','album_${r+1}_${c-4}'],focusHandler:showBigImage,blurHandler:showSmallImage,moveHandler:goPageHandler},
		</epg:forEach>
		</c:otherwise>
		</c:choose>
	];
	
	function showBigImage(current){
		G(current.id+'_image').className = 'album_img';
		var maxLength = 8;
		Epg.marquee.start(maxLength,Epg.Button.current.id+'_txt',7,50,'left', 'alternate');
	}
	
	function showSmallImage(previous){
		G(previous.id+'_image').className = 'album_img';
		Epg.marquee.stop();
	}
	
	function goPageHandler(previous,current,dir){
		<c:choose>
		<c:when test="${!isSD}">
			if(previous.id=='album_0_0'&&dir=='left'){
				pageUp();
			}else if(previous.id=='album_0_5'&&dir=='right'){			
				pageDown();
			}else if(previous.id=='album_1_0'&&dir=='left'){
				pageUp();
			}else if(previous.id=='album_1_5'&&dir=='right'){			
				pageDown();
			}
		</c:when>
		<c:otherwise>
		if((previous.id=='album_0_0'||previous.id=='album_1_0')&&dir=='left'){
			pageUp();
		}else if((previous.id=='album_0_4'||previous.id=='album_1_4')&&dir=='right'){
			pageDown();
		}
		</c:otherwise>
		</c:choose>
	}
	
	/*跳转到栏目*/
	function goColumn()
	{
		var code = epg.btn.current.code;
		if('20160113_sy_column'==code){
			location.href = '${basePath}home.jsp?source=${target}';
		}else{
			location.href = '${basePath}column/'+code+'/home.jsp?source=${target}';
		}
	}
	
	
	function enterRecommend()
	{
		var btn = epg.btn.current;
		var elementCodeSrc = '';//来源页面元素编码

		epg.go('column/favorite/home.jsp?elementCodeSrc=${columnIdx}', btn.code);

	}
	
	
	//上一页
	function pageUp()
	{
		Epg.page('${currentURI}&f=album_0_0&p=','${pb.current-1}');
	}
	
	//下一页
	function pageDown()
	{
		Epg.page('${currentURI}&f=album_0_0&p=','${pb.current+1}','${pb.pageCount}');
	}
	
	//返回
	function back()
	{
		location.href='${backURI}';
	}
	//订购
	function goOrder(){
		location.href="${basePath}column/order/order.jsp?source=${target}";
	}
	
	function goVideoList()
	{
		epg.go('column/content_list/home.jsp?code='+Epg.btn.current.code+'&elementCodeSrc=${columnIdx}', Epg.btn.current.code);
	}
	function getStrLength(str) {  
	    var cArr = str.match(/[^\x00-\xff]/ig);  
	    return str.length + (cArr == null ? 0 : cArr.length);  
	}  
	//聚焦到专辑上时开始滚动字幕
	function focusAlbum()
	{
		
		Epg.marquee.start();
	}
	
	//焦点离开专辑时停止字幕
	function blurAlbum()
	{
		Epg.marquee.stop();
	}
	
	//设置返回键事件
	Epg.key.set(
	{
		KEY_PAGE_UP:'pageUp()',
		KEY_PAGE_DOWN:'pageDown()'
	});
	
	window.onload = function()
	{
		Epg.tip('${param.info}');//显示info信息，3秒后自动隐藏，如果info为空将不会显示
		Epg.btn.init(['${param.f}','album_0_0','search'],buttons,'',true);	
	};
	</script>
	
</head>
<body style="background-image: url('${newComImages}background.jpg')">
     
	 <div id="tjzq_div"> <img  src="${imagePath}tjzq.png"/></div>
	 
<c:if test="${pb.pageCount>0}">
		<!-- 列表 -->
	<c:choose>
		<c:when test="${isOTT }">
			<epg:forEach items="${pb.dataList }" var="p" column="6">
				<div style="left:${albumLeftStart+albumLeftAdd*c}px;top:${albumTopStart+albumTopAdd*r}px;">
					<div class="album_img_div"><img id="album_${r}_${c}_image" src="${basePath}${isSD?p.thumbSD:p.thumbHD}" class="album_img"/></div>
					<div id="album_${r}_${c}_txt" class="album_txt album_txt_position">${p.name}</div>
					<div class="album_vods_position"><div style="position:absolute;z-index:301;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${p.hits }</div><img src="${newComImages}playvods.jpg" /></div>
				</div>
				<div style="left:${albumLeftStart+albumLeftAdd*c+focusLeftAdjust}px;top:${albumTopStart+albumTopAdd*r+focusTopAdjust}px;z-index:100;">
					<img id="album_${r}_${c}" src="${touming}" class="album_f"/>
				</div>
			</epg:forEach>
			
			<epg:forEach items="${pb1.dataList }" var="p" column="5">
				<div style="left:${albumLeftStart+albumLeftAdd*c}px;top:${albumTopStart+albumTopAdd*1}px;">
					<div class="album_img_div"><img id="album_1_${c}_image" src="${basePath}${isSD?p.thumbSD:p.thumbHD}" class="album_img"/></div>
					<div id="album_1_${c}_txt" class="album_txt album_txt_position">${p.name}</div>
					<div class="album_vods_position"><img alt="播放" src="${newComImages}playvods.jpg"/>&nbsp;&nbsp;${p.hits }</div>
				</div>
				<div style="left:${albumLeftStart+albumLeftAdd*c+focusTopAdjust}px;top:${albumTopStart+albumTopAdd*1+focusTopAdjust}px;z-index:100;">
					<img id="album_1_${c}" src="${touming}" class="album_f"/>
				</div>
			</epg:forEach>
		</c:when>
			<c:otherwise>
			<epg:forEach items="${pb.dataList }" var="p" column="5">
				<div style="left:${albumLeftStart+albumLeftAdd*c}px;top:${albumTopStart+albumTopAdd*r}px;">
					<div class="album_img_div"><img id="album_${r}_${c}_image" src="${basePath}${isSD?p.thumbSD:p.thumbHD}" class="album_img"/></div>
					<div id="album_${r}_${c}_txt" class="album_txt album_txt_position">${p.name}</div>
					<div class="album_vods_position"><img alt="播放" src="${newComImages}playvods.jpg"/>&nbsp;&nbsp;${p.hits }</div>
				</div>
				<div style="left:${albumLeftStart+albumLeftAdd*c+focusLeftAdjust}px;top:${albumTopStart+albumTopAdd*r+focusTopAdjust}px;z-index:100;">
					<img id="album_${r}_${c}" src="${touming}" class="album_f"/>
				</div>
			</epg:forEach>
		</c:otherwise>
	</c:choose>
		
	</c:if>
	


	<!-- 上一页 -->
	<c:if test="${pb.current>1}">
		<div class="page_up_img_div"><img src="${newComImages}page_up.png"/></div>
	</c:if>
	<!-- 下一页 -->
	<c:if test="${pb.current<pb.pageCount}">
		<div class="page_down_img_div"><img src="${newComImages}page_down.png"/></div>
	</c:if>
<%--  
	<c:choose>
	<!-- 页码信息 -->
		<div class="page_bg_img_div"><img alt="页码" src="${newComImages}page_no.png"/> </div>
		<div class="page_info">${pb.current}/${pb.pageCount}</div>
	<c:when test="${isSD }">
	<!-- 上一页 -->
	<c:if test="${pb.current>1}">
		<div class="page_up_img_div"><img src="${newComImages}page_up.png"/></div>
	</c:if>
	<!-- 下一页 -->
	<c:if test="${pb.current<pb.pageCount}">
		<div class="page_down_img_div"><img src="${newComImages}page_down.png"/></div>
	</c:if>
	</c:when>
	<c:otherwise>
	<!-- 上一页 -->
	<c:if test="${pb.current>1}">
		<div class="page_up_img_div"><img src="${newComImages}page_up.png"/></div>
	</c:if>
	<div class="page_up_img"><img id="page_up" src="${newComImages}page_up1.png"/></div>

	<!-- 下一页 -->
	<c:if test="${pb.current<pb.pageCount}">
		<div class="page_down_img_div"><img src="${newComImages}page_down.png"/></div>
	</c:if>
	<div class="page_down_img"><img id="page_down" src="${newComImages}page_down1.png"/></div>
	
	</c:otherwise>
	</c:choose>
--%>
	<%@include file="/com/com_bottom.jsp"%>

</body>
</html>