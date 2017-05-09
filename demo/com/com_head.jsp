<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/com/common.jsp" %>
<%


	String basePath = getBasePath(request);//这个basePath和config.jsp里面的BASE_PATH其实是一样的
	String imagePath = getImagePath(request);
	String targetType = getTargetType(request);
//	boolean isSD = "sd".equals(APP_VERSION);//是否是标清版
	boolean isSD = true;
	setAttr
	(
		request,
		"basePath", basePath,//项目基路径，以斜杠“/”结尾
		"imagePath", imagePath,//如果此处计算出来的图片路径不合胃口可以页面上重新修改
		"comImagePath", COM_IMAGE_PATH,
		"touming", SPACER,//透明图片路径
		"toumingNoBasePath", SPACER_NO_BASE_PATH,//没有前缀的透明图片地址，直接从basePath后面开始
		"targetType", targetType,//记录日志时用到的当前页面类型
		"isSD", isSD,//是否是标清版
		"isOTT", IS_OTT//是否是OTT版
	);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh">
<head>
	<meta name="page-view-size" content="${isSD?'640*530':'1280*720'}" />
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="<%=basePath%>resources/css/common_${isSD?'sd':'hd'}.css?req_time=<%=DEBUG_MODE?System.currentTimeMillis():""%>" rel="stylesheet" type="text/css" />
	
	<script type="text/javascript">
	var debug_mode = <%=DEBUG_MODE%>;//是否是开发模式，上线后请改为false
	var enable_animate = <%=ANIMATE%>;//是否启用动画，如果为false，将彻底禁用动画
	var is_ott = <%=IS_OTT%>;//是否是OTT版
	</script>
	
	<script type="text/javascript" src="<%=basePath%>resources/js/common.core_v1.0.1.js?req_time=<%=DEBUG_MODE?System.currentTimeMillis():""%>"></script>
	<script type="text/javascript" src="<%=basePath%>resources/js/common.extra_v1.0.1.js?req_time=<%=DEBUG_MODE?System.currentTimeMillis():""%>"></script>
	<style type="text/css">
	
	/*一些全局的、通用的css可以放这里*/

	</style>
	
	<script type="text/javascript">
	
	//一些全局的、通用的方法可以放这里，比如果果乐园的跳转到宝贝中心、跳转到搜索，健身团的订购和个人中心
	/*
	if(typeof(android) == "undefined"){ 
		var currenthref = location.href ;
		if(currenthref.indexOf("600.jsp") < 0)
			window.location.href = "<%=basePath%>com/600.jsp";
	}
	*/
	</script>