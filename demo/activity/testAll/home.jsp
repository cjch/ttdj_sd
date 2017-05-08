<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/com/com_head.jsp" %>
<%
UserStore store = new UserStore(request, response);
String userid = store.getUserid();
String ACTIVITY_NAME  = "testAll";
String activityImagePath = BASE_PATH + "activity/testAll/images/home/";//修正图片路径 
String fishImagePath = BASE_PATH + "activity/testAll/images/fish/";//修正图片路径

setAttr
(
	request,
	"addAccessLog", "true",
	"imagePath",activityImagePath,
	"fishImagePath",fishImagePath,
	"userid",userid
);
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>动画新势力 </title>
<style type="text/css">
body {margin:0;padding:0;background:url(${imagePath}index.jpg) no-repeat;color:#FFFFFF;}
</style>
<script type="text/javascript">
var linkImage = '${touming}',
    backImage = '${imagePath}back.png',
    ruleImage = '${imagePath}button.png',
    winImage = '${imagePath}button.png',
    startImage = '${imagePath}home_start.png';

var buttons = [
{id:'back', action:back, left:'test4', right:'', up:'',down:'test7', linkImage:linkImage, focusImage:backImage},
{id:'test1', action:goTest, name:'百灵Ｋ歌',left:'', right:'test4', up:'back', down:'test2',linkImage:linkImage, focusImage:startImage},
{id:'test2', action:goTest, name:'果果乐园',left:'', right:'test5', up:'test1', down:'test3', linkImage:linkImage, focusImage:startImage},
{id:'test3',action:goTest,  name:'健身团',left:'', right:'test6', up:'test2', down:'', linkImage:linkImage,focusImage:startImage},

{id:'test4', action:goTest, name:'动画',left:'test1', right:'test7', up:'back', down:'test5',linkImage:linkImage, focusImage:startImage},
{id:'test5', action:goTest, name:'国学',left:'test2', right:'test8', up:'test4', down:'test6', linkImage:linkImage, focusImage:startImage},
{id:'test6',action:goTest, name:'古典',left:'test3', right:'test9', up:'test5', down:'', linkImage:linkImage,focusImage:startImage},

{id:'test7', action:goTest, name:'游戏世界',left:'test4', right:'', up:'back', down:'test8',linkImage:linkImage, focusImage:startImage},
{id:'test8', action:goTest, name:'辣妈',left:'test5', right:'', up:'test7', down:'test9', linkImage:linkImage, focusImage:startImage},
{id:'test9',action:goTest, name:'瑜伽',left:'test6', right:'', up:'test8', down:'', linkImage:linkImage,focusImage:startImage},
];

var returnurl = escape('${backURI}');
function goTest(button){
	
	if(button.id=='test1'){
		location.href='http://61.191.46.230:8181/larko-epg/login.jsp?user_id=${userid}';
		return;
	}
	if(button.id=='test2'){
		location.href='http://61.191.45.195:8181/ggly-epg-ott-ah-test/login.jsp?user_id=${userid}';
		return;
	}	
	if(button.id=='test3'){
		location.href='http://61.191.46.230:8181/health-epg-v3.0-ott-test/login.jsp?user_id=${userid}';
		return;
	}	
	if(button.id=='test4'){
		location.href='http://61.191.45.198:8181/donghua-epg-ott-test/login.jsp?user_id=${userid}';
		return;
	}
	if(button.id=='test5'){
		location.href='http://61.191.45.198:8181/guoxue-epg-test/login.jsp?user_id=${userid}';
		return;
	}
	if(button.id=='test6'){
		location.href='http://61.191.45.198:8181/ott-classical-music-test/login.jsp?user_id=${userid}';
		return;
	}	
	if(button.id=='test7'){
		location.href='http://61.191.46.230:8282/game-video-ott-ah-test/login.jsp?user_id=${userid}';
		return;
	}

	if(button.id=='test8'){
		//location.href='http://61.191.46.230:8282/game-video-ott-ah-test/login.jsp?user_id=${userid}';
		alert("暂时没有测试平台");
		return;
	}	

	if(button.id=='test9'){
		//location.href='http://61.191.46.230:8282/game-video-ott-ah-test/login.jsp?user_id=${userid}';
		alert("暂时没有测试平台");
		return;
	}	
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


<font style="position:absolute; left:40px; top:280px; " color="yellow" size="6" >百灵K歌测试</font>
<div style="position:absolute; left:40px; top:280px; " >
		<img id="test1" src="<%=SPACER %>" width="290" height="80" border="0"/>
</div>

<font style="position:absolute; left:40px; top:380px; " color="yellow" size="6" >果果乐园测试</font>
<div style="position:absolute; left:40px; top:380px; " >
		<img id="test2" src="<%=SPACER %>" width="290" height="80" border="0"/>
</div>

<font style="position:absolute; left:40px; top:480px; " color="yellow" size="6" >健身团测试</font>
<div style="position:absolute; left:40px; top:480px; " >
		<img id="test3" src="<%=SPACER %>" width="290" height="80" border="0"/>
</div>


<font style="position:absolute; left:459px; top:280px; " color="yellow" size="6" >动画--测试</font>
<div style="position:absolute; left:459px; top:280px; " >
		<img id="test4" src="<%=SPACER %>" width="290" height="80" border="0"/>
</div>
<font style="position:absolute; left:459px; top:380px; " color="yellow" size="6" >国学--测试</font>
<div style="position:absolute; left:459px; top:380px; " >
		<img id="test5" src="<%=SPACER %>" width="290" height="80" border="0"/>
</div>
<font style="position:absolute; left:459px; top:480px; " color="yellow" size="6" >古典--测试</font>
<div style="position:absolute; left:459px; top:480px; " >
		<img id="test6" src="<%=SPACER %>" width="290" height="80" border="0"/>
</div>


<font style="position:absolute; left:850px; top:280px; " color="yellow" size="6" >游戏世界</font>
<div style="position:absolute; left:850px; top:280px; " >
		<img id="test7" src="<%=SPACER %>" width="290" height="80" border="0"/>
</div>
<font style="position:absolute; left:850px; top:380px; " color="yellow" size="6" >辣妈广场舞</font>
<div style="position:absolute; left:850px; top:380px; " >
		<img id="test8" src="<%=SPACER %>" width="290" height="80" border="0"/>
</div>
<font style="position:absolute; left:850px; top:480px; " color="yellow" size="6" >瑜伽--测试</font>
<div style="position:absolute; left:850px; top:480px; " >
		<img id="test9" src="<%=SPACER %>" width="290" height="80" border="0"/>
</div>

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