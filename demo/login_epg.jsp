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
<%

	log.info("浏览器代理字符串(userAgent)：{}", request.getHeader("user-agent"));//记录浏览器ua
	log.info("上一个页面(referer)：{}", request.getHeader("referer"));//上一个页面
	log.info("浏览器请求参数(queryString)：{}", request.getQueryString());//参数列表
	log.info("客户端IP：{}", HttpUtil.getClientIP(request));//客户端IP
	
	String source = getParam(request, "source", "portal");//默认IPTV首页，如果从其它地方跳转过来，请配置source参数
	String user_id = getParam(request, "user_id", "test_28_hd");//用户账号，默认test账户
	//String epg_info = getParam(request, "epg_info", "test_28_hd");//退出时的地址
	String entry = getParam(request, "entry", "ott");  //入口
	
	//-----拦截参数进行验证是否含sql注入如果是的话跳转到自定义错误页面600.jsp------start
	/*
	if(ifSqlInjection(source)||ifSqlInjection(user_id)
			||ifSqlInjection(entry)||"test_28_hd".equals(user_id)){

		redirect( request,  response,  "com/600.jsp");
		return;
	}
	*/
	//----------------------------------------end
	
	String oss_user_id = "";//业务账号
	String userToken = "";
	String page_url = "";//返回地址
	String partner = "HUAWEI";//平台
	
	String areaCode = "0"+user_id.substring(1,4);
	
	String platform="hw-20"; // 平台
	
	CookieStore cookie = new CookieStore(request, response);
	cookie.set("PLATFORM",platform);
	cookie.set("user_id",user_id);
	session.setAttribute("PLATFORM",platform);
	
	//String Result ="0";//request.getParameter("resultCode");
	String gotoUrl = "";
	
	
	
	log.info("用户{}鉴权成功！", user_id);
	String user_token = "";
	//String city_code = getCityCodeByUserId(user_id);//用户所在城市code
	String city_code = HttpUtil.getClientIP(request);//使用用户ip地址，表示用户所在城市。
	String order_type = "free";//默认免费用户
	/* 鉴权 */
	/*
	String productId = "lt_yxsj";
	String providerId = "lutongnet";
	String secret = "9807dcf7823f42c1baa7843ace9dec57";
	
	String orderInfo = "itvAccount="+user_id+"|productId="+productId;
	
	Crypto.TripleDES ct = new Crypto.TripleDES();

	String orderInfoStr = ct.encrypt(orderInfo,secret); 	
	
	String encodeOrderInfoStr = java.net.URLEncoder.encode(orderInfoStr, "utf-8");
	
	
	String jianquanURL = "http://172.16.37.133:7002/itv-api/has_order?providerId=lutongnet&orderInfo="+encodeOrderInfoStr;
	System.out.println("jianquanURL:"+jianquanURL);
	HttpURLConnection conn = (HttpURLConnection)new URL(jianquanURL).openConnection();
	InputStream in = conn.getInputStream();
	String returnString = IOUtils.toString(in, "gbk");
	System.out.println("returnString:"+returnString);
	
	if(returnString.indexOf("\"ordered\":1")>=0){	
		//说明已订购
		order_type = "month";
	}else{
		//说明未订购
		order_type = "free";
	}
	
	*/

	// iflytek 鉴权
	//String productId = "kdxfttdjby020";


	order_type = getParam(request, "order_type", "free");
	//登录，调用我们自己的API接口
	
	System.out.println("ABCD:"+city_code);
	LoginResponse login_rsp=post
	(
		"account/login", LoginResponse.class,
		"userid", user_id,//账户ID
		"orderType", order_type,//包月
		"city", city_code,//城市
		"carrier", CARRIER,//运营商
		"appVersion", APP_VERSION,//版本
		"platform", PLATFORM,//平台
		"source", source//来源
	);
	String roleName = login_rsp.getRole();//角色名

	//清空用户最后一次点播和访问记录
	//post("log/clear-last", ClearLastLogResponse.class, "userid", user_id);
	
	
	/*************保存用户相关信息到cookie开始******************/
	UserStore store = new UserStore(request, response);
	store.setUserid(user_id);
	store.setRole(roleName);
	store.setOrderType(order_type);
	store.setCity(city_code);
	store.setToken(user_token);
	setCookie
	(
		request, response, 
		COOKIE_PLAY_TIME, "0",//累积播放时长，每次进入系统重新清零
		COOKIE_CITY_CODE, city_code,
		COOKIE_ORDER_TYPE, order_type,
		COOKIE_ROLE, roleName,
		COOKIE_USER_ID, user_id,
		COOKIE_USER_TOKEN, userToken,
		"entry", entry		//果果乐园入口
	);
	/*************保存用户相关信息到cookie结束******************/
	
	//保存到session
	session.setAttribute("user_id",user_id);
	session.setAttribute("order_type",order_type);
	session.setAttribute("city_code", city_code);
	session.setAttribute("role_name", roleName);

	//电信专区Launcher推荐入口
	boolean isTJW = false;
	if("Launcher_R1".equals(entry)){
		//专辑-20160128_lolzhzjl_album
		gotoUrl = "album/template.jsp?code=20160128_lolzhzjl_album&source="+source+"&addAccessLog=true&platform="+platform;
		isTJW = true;
		//推荐-游戏视界剧集植物大战僵尸解说
		//gotoUrl = "column/content_list/home.jsp?code=100011&source="+source+"&addAccessLog=true&platform="+platform;
		//gotoUrl = "column/mobile_game/home.jsp?source="+source+"&addAccessLog=true&platform="+platform;
	}else if("Launcher_R2".equals(entry)){
		//推荐剧集1
		gotoUrl = "column/content_list/home.jsp?code=100004&source="+source+"&addAccessLog=true&platform="+platform;
		isTJW = true;
	}else if("Launcher_R3".equals(entry)){
		//推荐剧集2
		gotoUrl = "column/content_list/home.jsp?code=100039&source="+source+"&addAccessLog=true&platform="+platform;
		isTJW = true;
	}else if("Launcher_R4".equals(entry)){
		//推荐剧集2
		gotoUrl = "album/template.jsp?code=20151103_wdsj_album&source="+source+"&addAccessLog=true&platform="+platform;
		isTJW = true;
	}else if("Launcher_R5".equals(entry)){
		//推荐剧集2
		//gotoUrl = "album/template.jsp?code=20160225_dmgbyx_album&source="+source+"&addAccessLog=true&platform="+platform;
		//20160811_wdsj_activity
		gotoUrl = "activity/20160811_wdsj_activity/index.jsp?source="+source+"&addAccessLog=true&platform="+platform;
		//20160128_lolzhzjl_album
		gotoUrl = "album/template.jsp?code=20161228_djzwzbs_album&source="+source+"&addAccessLog=true&platform="+platform;
		isTJW = true;
	}else if("Launcher_R6".equals(entry)){
		//推荐剧集2
		gotoUrl = "album/template.jsp?code=20160719_jpnjdjm_album&source="+source+"&addAccessLog=true&platform="+platform;
		isTJW = true;
	}else{
		gotoUrl = "home.jsp?source="+source+"&addAccessLog=true&platform="+platform;
	}

	/*
	if(!isTJW){
		Date d = new Date();
		int hours = d.getHours();
		System.out.println(hours); 
		System.out.println(24-hours);
		MemoryStore memoryStore = new MemoryStore(API_URL);
		String json = memoryStore.get("firstaccess_"+user_id);
		if(json == null || "".equals(json)){
			memoryStore.set("firstaccess_"+user_id, "1",24-hours, TimeUnit.HOUR);
			gotoUrl = "activity/20170118_lolxcspf_activity/index.jsp?source="+source+"&addAccessLog=true&platform="+platform;
		}
	}
	*/
		
	//if(notEmpty(Result))
	//{

	//}else {//去鉴权
	//	String appurl = BASE_PATH + "login.jsp?user_id=" + user_id+ "&source="+source + "&entry=" + entry;
	//	gotoUrl = BASE_PATH+"column/order/common_auth.jsp?return_url="+URLEncoder.encode(appurl, "utf-8");
	//}
%>
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
		window.location.href="<%=gotoUrl%>";
	</script>
</body>
</html>
