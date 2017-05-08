
var kbHTML=
'<div id="kb" style="position:absolute; left:918px; top:192px;display:none;" >'
+'	<div style="position:absolute; left:0px; top:0px;">' 
+'		<img  src="../kbimages/kb_index.png" border="0"  /> '
+'	</div>'
+'	<div style="position:absolute; left:33px; top:17px;">'
+'		<img id="num1" src="../kbimages/spacer.gif" border="0"  /> '
+'	</div>'
+'	<div style="position:absolute; left:127px; top:17px;">'
+'		<img id="num2" src="../kbimages/spacer.gif" border="0"  /> '
+'	</div>'
+'	<div style="position:absolute; left:221px; top:17px;">'
+'		<img id="num3" src="../kbimages/spacer.gif" border="0"  /> '
+'	</div>'
+'	<div style="position:absolute; left:33px; top:93px;">'
+'		<img id="num4" src="../kbimages/spacer.gif" border="0"  /> '
+'	</div>'
+'	<div style="position:absolute; left:127px; top:93px;">'
+'		<img id="num5" src="../kbimages/spacer.gif" border="0"  /> '
+'	</div>'
+'	<div style="position:absolute; left:221px; top:93px;">'
+'		<img id="num6" src="../kbimages/spacer.gif" border="0"  />' 
+'	</div>'
+'	<div style="position:absolute; left:33px; top:169px;">'
+'		<img id="num7" src="../kbimages/spacer.gif" border="0"  /> '
+'	</div>'
+'	<div style="position:absolute; left:127px; top:169px;">'
+'		<img id="num8" src="../kbimages/spacer.gif" border="0"  /> '
+'	</div>'
+'	<div style="position:absolute; left:221px; top:169px;">'
+'		<img id="num9" src="../kbimages/spacer.gif" border="0"  /> '
+'	</div>'
+'	<div style="position:absolute; left:33px; top:247px;">'
+'		<img id="CANCEL" src="../kbimages/spacer.gif" border="0"  /> '
+'	</div>'
+'	<div style="position:absolute; left:127px; top:247px;">'
+'		<img id="num0" src="../kbimages/spacer.gif" border="0"  /> '
+'	</div>'
+'	<div style="position:absolute; left:221px; top:247px;">'
+'		<img id="OK" src="../kbimages/spacer.gif" border="0"  /> '
+'	</div>'
+'</div>'


var phonenumText = "";
var inputBorderPhone = "";
var NumKeyBorder = {
	currentStatus : false,//当前状态是不是打开
	init:function(x,y){
		var oDiv = document.createElement('div');
		oDiv.innerHTML = kbHTML;
		document.getElementsByTagName("body").item(0).appendChild(oDiv);
		G("kb").style.left = x+"px";
		G("kb").style.top = y+"px";
		buttons = buttons.concat(NumKeyBorder.kbbuttons);
	},
	
	setPhoneNumText:function(id){
		phonenumText = G(id);
	},
	
	setInputBorder:function(id){
		inputBorderPhone = id;
	},
	
	show:function(){
		currentStatus = true;
		G("kb").style.display = "block";
		//Epg.btn.init(['num5'],buttons,'',true);
		Epg.btn.set('num5');
	},
	
	ok:function(){
		currentStatus = false;
		G("kb").style.display = "none";
		//Epg.btn.init([inputBorderPhone],buttons,'',true);
		Epg.btn.set(inputBorderPhone);
	},
	
	cancel:function(){
		var phone = phonenumText.innerHTML ; 
		//alert(phone);
		if(phone=="" || phone.indexOf('请输入')>=0){
			currentStatus = false;
			G("kb").style.display="none";
			//Epg.btn.init([inputBorderPhone],buttons,'',true);
			Epg.btn.set(inputBorderPhone);
		}else{
			phonenumText.innerHTML = phone.substring(0,phone.length-1);
		}
	},
	
	inputNum:function(button){
		var phone = phonenumText.innerHTML ; 
		if(phone.indexOf('请输入')>=0){
			phone = "";
		}
		if(phone.length > 11){
			return;
		}
		phonenumText.innerHTML = phone + button.num;
	}
}

var kblinkImage = "../kbimages/spacer.gif";
NumKeyBorder.kbbuttons = [
{id:'num1', action:NumKeyBorder.inputNum, num:1, left:'', right:'num2', up:'', down:'num4', linkImage:kblinkImage, focusImage:"../kbimages/kb.png"},
{id:'num2', action:NumKeyBorder.inputNum, num:2,left:'num1', right:'num3', up:'', down:'num5', linkImage:kblinkImage, focusImage:"../kbimages/kb.png"},
{id:'num3', action:NumKeyBorder.inputNum, num:3,left:'num2', right:'', up:'', down:'num6', linkImage:kblinkImage, focusImage:"../kbimages/kb.png"},
{id:'num4', action:NumKeyBorder.inputNum, num:4,left:'', right:'num5', up:'num1', down:'num7', linkImage:kblinkImage, focusImage:"../kbimages/kb.png"},
{id:'num5', action:NumKeyBorder.inputNum, num:5,left:'num4', right:'num6', up:'num2', down:'num8', linkImage:kblinkImage, focusImage:"../kbimages/kb.png"},
{id:'num6', action:NumKeyBorder.inputNum, num:6,left:'num5', right:'', up:'num3', down:'num9', linkImage:kblinkImage, focusImage:"../kbimages/kb.png"},
{id:'num7', action:NumKeyBorder.inputNum, num:7,left:'', right:'num8', up:'num4', down:'CANCEL', linkImage:kblinkImage, focusImage:"../kbimages/kb.png"},
{id:'num8', action:NumKeyBorder.inputNum, num:8,left:'num7', right:'num9', up:'num5', down:'num0', linkImage:kblinkImage, focusImage:"../kbimages/kb.png"},
{id:'num9', action:NumKeyBorder.inputNum, num:9,left:'num8', right:'', up:'num6', down:'OK', linkImage:kblinkImage, focusImage:"../kbimages/kb.png"},
{id:'num0', action:NumKeyBorder.inputNum, num:0,left:'CANCEL', right:'OK', up:'num8', down:'', linkImage:kblinkImage, focusImage:"../kbimages/kb.png"},
{id:'OK', action:NumKeyBorder.ok, left:'num0', right:'', up:'num9', down:'', linkImage:kblinkImage, focusImage:"../kbimages/kb.png"},
{id:'CANCEL', action:NumKeyBorder.cancel, left:'', right:'num0', up:'num7', down:'', linkImage:kblinkImage, focusImage:"../kbimages/kb.png"}
];






