<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.lutong.util.*" %>
<%@ include file="/config.jsp" %>

<!-- 鉴权接口 WYL20140902 引入jsxw20120525.jar-->
<%
String spCode = "hefeitelcom";
String serviceCode = "service_yxsj";
String key = "76b07f7cb62c3ed0";
String productCode = request.getParameter("productCode") == null?"product_yxsjbyzn":request.getParameter("productCode");

Date date = new Date();
double aa = Math.random()*100;
aa = Math.ceil(aa);
int randomNum = new Double(aa).intValue();

String tranId=date.getTime()+"";
tranId=tranId+randomNum;
String successURL = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/column/order/common_auth_result.jsp?return_url="+java.net.URLEncoder.encode(request.getParameter("return_url"), "utf-8");
String errorURL = successURL;
String sign = "";
String split = "#";

String stbCode = "";//IPTV用户业务号

CookieStore cookie = new CookieStore(request, response);
stbCode = cookie.get("user_id");
if(null==stbCode||"".equals(stbCode)){
	UserStore store = new UserStore(request, response);
	stbCode = store.getUserid();
}

String str = stbCode+split+spCode+split+serviceCode+split+tranId;
try{
	byte[] keys = CryptoUtils.hexStr(key);
	byte[] results = CryptoUtils.encrypt(str.getBytes(), keys);
	sign = CryptoUtils.MD5(results);
}catch(Exception exception){
	exception.printStackTrace();
}

String platform = PLATFORM;
if("hw-20".equals(platform)){
	platform="HW2X";
}else{
	platform="ZTE2X";
}

///////////判断是否添加包年,包季关键字 wyl20140702 start
if(!"".equals(productCode)){
	serviceCode = serviceCode + "&productCode="+productCode;
}else{
	serviceCode = serviceCode + "&productCode="+serviceCode;
}
///////////判断是否添加包年,包季关键字 wyl20140702 end

String url = "http://61.191.44.220:8080/AAAServer/singleAuth.do?stbCode="+stbCode+"&spCode="+spCode+"&serviceCode="+serviceCode+"&tranId="+tranId+"&successURL="+successURL+"&errorURL="+errorURL+"&sign="+sign+"&platform=HW2X&hd=1";

System.out.println("-----------------------------");
System.out.println("查询鉴权---AAAServer = " + url);
System.out.println("-----------------------------");

response.sendRedirect(url);
%>	