<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/com/com_head.jsp" %>
<%
	setAttr
	(
		request, 
		"source", "404",
		"info", getParam(request, "info", "您所请求的页面不存在！")
	);
%>
	<title>${source}</title>
	<style type="text/css">
	body
	{
		/*定义背景图*/
		background-image: url('${imagePath}${source}.png');
	}
	</style>
	
	<script type="text/javascript">
	
	var buttons=
	[
	 	{id:'back',name:'返回',action:'back()',focusImage:'back_f.png'}
	];
	
	//返回
	function back()
	{
		location.href='${basePath}column/exit/exit.jsp?source=${source}';
	}
	
	window.onload=function()
	{
		Epg.btn.init('back',buttons,'${imagePath}',true);
	};
	
	</script>
</head>
<body>

	<div class="back_img_div">
		<img id="back" alt="返回" src="${comImagePath}back.png">
	</div>
	
	<%@ include file="/com/com_bottom.jsp" %>

</body>
</html>