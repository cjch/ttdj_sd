<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.lutongnet.iptv.util.*" %>
<%@ include file="/config.jsp" %>



<!-- 鉴权接口 WYL20140902 引入jsxw20120525.jar-->
<%
UserStore store = new UserStore(request, response);
String providerId = "lutongnet";
String productId = "lt_yxsj";
String orderId = "OTTYXSJ#" + store.getUserid() + "#" + productId + "#" + store.getCity() + "#" + System.currentTimeMillis() ;
String price = "1500";
String itvAccount = store.getUserid();
//测试环境
//String secret = "31a9aece0c9c446db80bc24c269c62e2";
//正式环境
String secret = "9807dcf7823f42c1baa7843ace9dec57";
String orderInfo = "productId=" + productId + "|price=" + price + "|itvAccount=" + itvAccount + "|orderId=" + orderId;
String tradeInfo = "orderId=" + orderId + "|autoRenew=0";


Crypto.TripleDES ct = new Crypto.TripleDES();

String orderInfoStr = ct.encrypt(orderInfo,secret); 
String tradeInfoStr = ct.encrypt(tradeInfo,secret); 

String returnUrl = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/column/order/direct_purchase_result2.jsp?return_url="+java.net.URLEncoder.encode(request.getParameter("return_url"), "utf-8");
//String returnUrl = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/column/order/direct_purchase_result2.jsp";
//String notifyUrl = "http://61.191.45.195:8181/serviceSync-ff/notify";
//172.16.13.6
String notifyUrl = "http://172.16.13.23:8080/serviceSync-ff/notify";
//access(request,response);//用于统计用户最终进去成思订购的访问记录
%>	

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>资费订购</title>
<style type="text/css">

</style>
<script type="text/javascript">
</script>
</head>
<body>
<!-- 正式 http://61.191.45.118:7002/itv-api/order -->
	<form action="http://61.191.45.118:7002/itv-api/order" method="post" id="form">
		<input type="hidden" name="providerId" value="<%=providerId %>" />
		<input type="hidden" name="orderInfo" value="<%=orderInfoStr %>" />
		<input type="hidden" name="returnUrl" value="<%=returnUrl %>" />
		<input type="hidden" name="notifyUrl" value="<%=notifyUrl %>" />
		<input type="hidden" name="deviceType" value="hd" />
		
	</form>
</body>
<script type="text/javascript">

	var str={'url':'<%=returnUrl %>',
	   'up':'javascript:orderKeyHandle(19)',
	   'down':'javascript:orderKeyHandle(20)',
	   'left':'javascript:orderKeyHandle(21)',
	   'right':'javascript:orderKeyHandle(22)',
	   'ok':'javascript:orderKeyHandle(23)',
	   'back':'javascript:orderKeyHandle(4)',
	   'home':'',
	   'menu':''};		
	android.setKeyListener(JSON.stringify(str));
	
	document.getElementById("form").submit();
</script>
</html>
