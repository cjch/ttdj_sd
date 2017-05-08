<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/com/com_head.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/tags/epg" prefix="epg" %>
<%@ taglib tagdir="/WEB-INF/tags/epg" prefix="e" %>
<%@page import="java.io.File"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%
	String path=this.getServletContext().getRealPath("/")+"activity/";
	File file=new File(path);
	File[] tempList = file.listFiles();
	List<String> activits =  new ArrayList<String>();
	for (int i = 0; i < tempList.length; i++) {
		if (tempList[i].isDirectory()) {
			//获取文件最后修改时间 
			long time = tempList[i].lastModified();
			//System.out.println("文件夹："+tempList[i].getName() + "最后修改时间："+ time);
			String name = tempList[i].getName();
			Date date=new Date();
			Calendar rightNow = Calendar.getInstance();
			rightNow.setTime(date);
			//两个星期内修改过的活动
			rightNow.add(Calendar.DAY_OF_YEAR,-14);
			//关键字都是2016xxxxx开头的
			if(name.indexOf("20") == 0 && time > rightNow.getTime().getTime()  )
			activits.add(name);
		}
	}
	
	request.setAttribute("activitys",activits);
	
	

	String activityImagePath = BASE_PATH + "activity/testAll/images/home/";//修正图片路径 
	String fishImagePath = BASE_PATH + "activity/testAll/images/fish/";//修正图片路径

	setAttr
	(
		request,
		"addAccessLog", "true",
		"imagePath",activityImagePath,
		"fishImagePath",fishImagePath
	);


%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>动画新势力 </title>
<style type="text/css">
body {margin:0;padding:0;background:url(${imagePath}/index.jpg) no-repeat;color:#FFFFFF;}
</style>
<script type="text/javascript">
var linkImage = '${touming}',
    backImage = '${imagePath}back.png',
    ruleImage = '${imagePath}button.png',
    winImage = '${imagePath}button.png',
    startImage = '${imagePath}home_start.png';

var buttons = [
{id:'back', action:back, left:['test7','test4','test1'], right:'', up:'',down:['test7','test4','test1'], linkImage:linkImage, focusImage:backImage},

<c:forEach items="${activitys}"  var="activity" varStatus="i" >
{id:'test${i.index+1}', action:goTest,code:'${activity}', name:'百灵Ｋ歌',left:'test${i.index-2}', right:'test${i.index+4}', up:['test${i.index}','back'], down:'test${i.index+2}',linkImage:linkImage, focusImage:startImage},
</c:forEach>
{}
];

var returnurl = escape('${backURI}');
function goTest(button){
	
	location.href = "<%=BASE_PATH%>activity/"+button.code+"/index.jsp";
}


function back(button){
	android.exitAPK();
}


Epg.eventHandler = function(keyCode){
	if(keyCode==KEY_LEFT){
		Epg.Button.move('left');
	}else if(keyCode==KEY_RIGHT){
		Epg.Button.move('right');
	}else if(keyCode==KEY_UP){
		Epg.Button.move('up');
	}else if(keyCode==KEY_DOWN){
		Epg.Button.move('down');
	}else if(keyCode==KEY_ENTER){
		Epg.Button.click();
	}else if(keyCode==KEY_BACK){
		back();
	}
}



</script>
</head>
<body>
<div style="position:absolute; left:0px; top:480px; width:1280px;height:400px; overflow:hidden;" >
	<div id="xy" style="left:0px; top:0px;">
		<img id="xyimg" src="${fishImagePath}1.png" border="0"/>
	</div>
</div>

<div style="position:absolute; left:1135px; top:17px;" >
	<img id="back" src="<%=SPACER %>" border="0"/>
</div>

<c:forEach items="${activitys}"  var="activity" begin='0' end='0' >
<font style="position:absolute; left:40px; top:280px; " color="yellow" size="6" >${activity}</font>
<div style="position:absolute; left:40px; top:280px; " >
		<img id="test1" src="<%=SPACER %>" width="290" height="80" border="0"/>
</div>
</c:forEach>

<c:forEach items="${activitys}"  var="activity" begin='1' end='1' >
<font style="position:absolute; left:40px; top:380px; " color="yellow" size="6" >${activity}</font>
<div style="position:absolute; left:40px; top:380px; " >
		<img id="test2" src="<%=SPACER %>" width="290" height="80" border="0"/>
</div>
</c:forEach>

<c:forEach items="${activitys}"  var="activity" begin='2' end='2' >
<font style="position:absolute; left:40px; top:480px; " color="yellow" size="6" >${activity}</font>
<div style="position:absolute; left:40px; top:480px; " >
		<img id="test3" src="<%=SPACER %>" width="290" height="80" border="0"/>
</div>
</c:forEach>

<c:forEach items="${activitys}"  var="activity" begin='3' end='3' >
<font style="position:absolute; left:459px; top:280px; " color="yellow" size="6" >${activity}</font>
<div style="position:absolute; left:459px; top:280px; " >
		<img id="test4" src="<%=SPACER %>" width="290" height="80" border="0"/>
</div>
</c:forEach>

<c:forEach items="${activitys}"  var="activity" begin='4' end='4' >
<font style="position:absolute; left:459px; top:380px; " color="yellow" size="6" >${activity}</font>
<div style="position:absolute; left:459px; top:380px; " >
		<img id="test5" src="<%=SPACER %>" width="290" height="80" border="0"/>
</div>
</c:forEach>

<c:forEach items="${activitys}"  var="activity" begin='5' end='5' >
<font style="position:absolute; left:459px; top:480px; " color="yellow" size="6" >${activity}</font>
<div style="position:absolute; left:459px; top:480px; " >
		<img id="test6" src="<%=SPACER %>" width="290" height="80" border="0"/>
</div>
</c:forEach>

<c:forEach items="${activitys}"  var="activity" begin='6' end='6' >
<font style="position:absolute; left:850px; top:280px; " color="yellow" size="6" >${activity}</font>
<div style="position:absolute; left:850px; top:280px; " >
		<img id="test7" src="<%=SPACER %>" width="290" height="80" border="0"/>
</div>
</c:forEach>

<c:forEach items="${activitys}"  var="activity" begin='7' end='7' >
<font style="position:absolute; left:850px; top:380px; " color="yellow" size="6" >${activity}</font>
<div style="position:absolute; left:850px; top:380px; " >
		<img id="test8" src="<%=SPACER %>" width="290" height="80" border="0"/>
</div>
</c:forEach>

<c:forEach items="${activitys}"  var="activity" begin='8' end='8' >
<font style="position:absolute; left:850px; top:480px; " color="yellow" size="6" >${activity}</font>
<div style="position:absolute; left:850px; top:480px; " >
		<img id="test9" src="<%=SPACER %>" width="290" height="80" border="0"/>
</div>
</c:forEach>



	<script type="text/javascript">
	<c:if test="${addAccessLog}">Epg.Log.access('${param.source}', 'testAll', 'activity');</c:if>
	Epg.Button.init({defaultButtonId:['${param.f}','test1','test1','start'], buttons:buttons});
	
	

	
	
	var xyObj = G("xy");
	var step3 = 10;
	setInterval(function(){
		xyObj.style.left = (digitPX(xyObj.style.left) + step3) + "px";
		if(digitPX(xyObj.style.left) == 1280){
			var r = ranNum(1,14);
			G("xyimg").src = "${fishImagePath}"+r+".png";
			xyObj.style.left = "0px";
		}
	},80);
	
	
//获取去除px后的数值
function digitPX(px){
	if(isNaN(px)){//带了p
		var after_px = parseInt(px.substring(0,px.lastIndexOf("p")));	
		return after_px;
	}else{
		return px;
	}
}

//获取随机数的方法
function ranNum(min,max){
	var range = max-min;
	var rand = Math.random();
	var rn = min+Math.round(rand * range);
	return rn;
}
	</script>
</body>
</html>

