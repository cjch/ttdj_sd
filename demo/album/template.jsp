<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.commons.io.FileUtils"%>
<%@ page import="java.io.File"%>
<%@ include file="/com/com_head.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%!
	/**
	 * 将list转换为数组
	 */
	public String listToArray(List list)
	{
		if(list!=null)
		{
			String arrayString = "[";
			for(int j=0; j<list.size(); ++j)
			{
				if(j==0)
					arrayString += "'"+list.get(j)+"'";
				else
					arrayString += ",'"+list.get(j)+"'";
			}
			arrayString += "]";
			return arrayString;
		}
		return "''";
	}
%>
<%
	String code = getParam(request, "code", "");//专辑code
	String filePath = "/resources/"+APP_VERSION+"/album/"+code+"/config.json";
	String configString = FileUtils.readFileToString(new File(session.getServletContext().getRealPath(filePath)), "utf-8");
	configString = configString.replaceAll("resources/EpgDesigner/resources/images", "resources/"+APP_VERSION+"/album/"+code+"/upload");
	Map album = JsonUtil.toObject(configString, Map.class);//JSON转换后的对象
	List buttonList = (List)album.get("buttonList");//按钮集合
	String background = (String)album.get("background");//背景图片
	background = background!=null?"background-image:url('" + BASE_PATH + background + "');":"";
	
	setAttr
	(
		request,
		"basePath", BASE_PATH,//项目基路径
		"currentURI", BASE_PATH + "album/template.jsp?code="+code,//当前页面路径
		"backURI", getBackURI(request, response),//返回地址
		"code", code,//专辑code
		"background", background,//背景图片
		"buttonList", buttonList,//按钮集合
		"gstaId", (String)album.get("gstaId")
	);
%>
	<title>专辑-${code}</title>
	<script type="text/javascript">
		var buttons=[], button;
	<%
		List<String> songCodeList = new ArrayList<String>();
		for(int i=0; i<buttonList.size(); i++)
		{
			Map button = (Map)buttonList.get(i);
			String left = listToArray((List)button.get("left"));
			String right = listToArray((List)button.get("right"));
			String up = listToArray((List)button.get("up"));
			String down = listToArray((List)button.get("down"));
			String xtype = (String)button.get("xtype");
			String songCode = (String)button.get("code");
			if(songCode!=null)
				songCodeList.add(songCode);
	%>
			button = 
			{
				id:'<%=button.get("id")%>',action:<%=button.get("action")%>,code: '<%=songCode%>',
				left:<%=left%>,right:<%=right%>,up:<%=up%>,down:<%=down%>,
				linkImage:'<%=xtype.equals("textsongbutton")?SPACER:BASE_PATH+button.get("linkImage")%>',
				focusImage:'<%=BASE_PATH+button.get("focusImage")%>'
			};
			buttons.push(button);
	<%
		}
		songCodeList.add(songCodeList.get(0));//把第一个视频的code重新添加一遍
		request.setAttribute("codes", StringUtils.join(songCodeList, ','));//将所有视频code用逗号拼接
	%>
	
	/** 返回 */
	function doBack()
	{
		location.href = '${backURI}';
	}
	
	/** 返回 */
	function back()
	{
		doBack();
	}
	
	/** 播放单首歌曲 */
	function doPlay(button)
	{
		var returnURI = escape('${basePath}album/template.jsp?code=${code}&f='+button.id);
		location.href = '${basePath}media_player.jsp?method=addVideo&andPlay=true&source=${code}&sourceType=album&metadataType=program&code='+button.code+'&returnURI='+returnURI;
	}
	
	/** 全部播放 */
	function doPlayAll(button)
	{
		var returnURI = escape('${currentURI}&f='+button.id);
		location.href = '${basePath}album/template_action.jsp?method=playAll&source=${code}&codes=${codes}&returnURI='+returnURI;
	}
	
	/** 全部收藏 */
	function doFavAll()
	{
		var returnURI = escape('${currentURI}&f='+button.id);
		location.href = '${basePath}album/template_action.jsp?method=favAll&source=${code}&codes=${codes}&returnURI='+returnURI;
	}
	
	/** 订购  */
	function doOrder(button)
	{
		var backURI = escape('${currentURI}&dir=fallback&source=order&f='+button.id);
		location.href = '${basePath}column/order/order.jsp?source=${code}&sourceType=${album}&addAccessLog=true&backURI='+backURI;
	}
	
	Epg.eventHandler = function(keyCode)
	{
		if(keyCode==KEY_LEFT)
			Epg.Button.move('left');
		else if(keyCode==KEY_RIGHT)
			Epg.Button.move('right');
		else if(keyCode==KEY_UP)
			Epg.Button.move('up');
		else if(keyCode==KEY_DOWN)
			Epg.Button.move('down');
		else if(keyCode==KEY_ENTER)
			Epg.Button.click();
		else if(keyCode==KEY_BACK){
			back();
		}

	};
	</script>
</head>
<body style="${background}">

	<c:forEach items="${buttonList}" var="button">
		<c:choose>
			<c:when test="${button.xtype=='orderbutton'||button.xtype=='backbutton'||button.xtype=='playallbutton'||button.xtype=='favallbutton'||button.xtype=='imagesongbutton'}">
			<div style="position:absolute; left:${button.x}px; top:${button.y}px">
				<img id="${button.id}" src="${basePath}${button.linkImage}" width="${button.width}" height="${button.height}"/>
			</div>
			</c:when>
			<c:when test="${button.xtype=='textsongbutton'}">
			<div style="position:absolute; left:${button.x}px; top:${button.y}px">
				<img id="${button.id}" src="<%=SPACER %>" width="${button.width}" height="${button.height}"/>
			</div>
			<div style="position:absolute; left:${button.x+button.textX}px; top:${button.y+button.textY}px; font-size:${button.fontSize}px; color:${button.fontColor}">${button.text}</div>
			</c:when>
		</c:choose>
	</c:forEach>
	
	<%@ include file="/com/com_bottom.jsp" %>
	
	<script type="text/javascript">
		Epg.tip('${param.info}');//显示info信息，3秒自动隐藏，如果info为空将不会显示
		Epg.Button.init({defaultButtonId:'${param.f}'||<%=listToArray((List)album.get("defaultButtonId"))%>, buttons:buttons});
		<c:if test="${param.addAccessLog}">Epg.Log.access('${param.source}', '${code}', 'album');</c:if>
		<c:if test="${not empty gstaId}">Epg.Log.gsta("${cookie['userid'].value}", "${gstaId}");</c:if>
	</script>
	
</body>
</html>