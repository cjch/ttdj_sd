<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<title>${source}</title>
	<style type="text/css">
	body
	{
		/*定义背景图*/
		background-image: url('../resources/hd/com/500.png');
	}
	</style>
	
	<script type="text/javascript">
	

	//返回
	function back()
	{
		android.exitAPK();//如果是OTT版，直接调用方法退出APK
		return;
	}
	
	</script>
</head>
<body>

	<a id="back" style="position:absolute;top:28px;left:1158px;" onclick="back();">
		<img  alt="返回" src="../resources/hd/com/back_f.png">
	</a>
	
</body>
<script>
document.getElementById("back").focus();
</script>
</html>