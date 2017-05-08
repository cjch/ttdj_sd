<%@ page import="java.util.ArrayList"%>
<%@ page import="java.net.URL"%>
<%@ page import="java.net.URLConnection"%>
<%@ page import="java.io.OutputStream"%>
<%@ page import="java.io.OutputStreamWriter"%>
<%@ page import="java.net.HttpURLConnection"%>
<%@ page import="java.io.InputStream"%>
<%@ page import="com.lutongnet.iptv.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/com/auth.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</head>
<body background="resources/sd/com/loading.jpg" leftmargin="0" topmargin="0"  bgcolor="transparent">

	<table width="553" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td width="199" height="272">&nbsp;</td>
	    <td width="354">&nbsp;</td>
	  </tr>
	  <tr>
	    <td height="29">&nbsp;</td>
	    <td></td>
	  </tr>
	</table>
	<script>
		window.location.href="./login_epg.jsp?user_id="+"test_id"+"&entry=ott&order_type=month";
		//window.location.href="./login_epg.jsp?entry=ott&order_type=month";
		//var userId = iflytekMp.getUserId();

		//console.log(1111);
		//console.log("userid is "+userId);

		//var authInfo = '[{"productid":"kdxfttdjby020"}]';
		//iflytekMp.checkAuth(authInfo);


//		function onPayResult(result){
//			//window.location.href="./login_epg.jsp?user_id="+userId+"&entry=ott";
//			var resultInfo = JSON.parse(result);
//			//console.log(result);
//			if(resultInfo){
//				if(resultInfo.result){
//					window.location.href="./login_epg.jsp?user_id="+userId+"&entry=ott&order_type=month";
//				}else{
//					//console.log(222);
//					iflytekMp.exitApp();
//				}
//			}else{
//				//console.log(333);
//				iflytekMp.exitApp();
//			}
//		}

//		function onAuthResult(authResult){
//			if(authResult){
//				var authInfo = JSON.parse(authResult);
//				if(authInfo.authResult){
//					//console.log("success result "+authResult);
//					window.location.href="./login_epg.jsp?user_id="+userId+"&entry=ott&order_type=month";
//				}else{
//					//console.log(authResult);
//					//var payInfo = '[{"feeCodeId":"11_24_1","productid":"kdxfttdjby020","price":2000,"subject":"1个月畅玩包","isSub":true}]';
//					//iflytekMp.pay(payInfo);
//					window.location.href="./login_epg.jsp?user_id="+userId+"&entry=ott&order_type=free";
//				}
//			}else{
//				//console.log(444);
//				iflytekMp.exitApp();
//			}
//		}


		//console.log(userId);
		//console.log(iflytekMp.getUserId());
		//window.location.href="";
	</script>
</body>
</html>
