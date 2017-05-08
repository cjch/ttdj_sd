<%@page import="com.lutongnet.iptv.util.JsonUtils"%>
<%@page import="java.util.regex.Matcher"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="java.io.OutputStream"%>
<%@page import="java.io.OutputStreamWriter"%>
<%@page import="java.net.URLConnection"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.nio.charset.Charset"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.net.URL"%>
<%@page import="java.net.URI"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%!
	//文件说明：广东省鉴权订购需要的文件，其它省份可能不需要，只有有必要的时候才看本文件的代码！
	//本文件的目的：用作鉴权订购跳转时的return_url，电信会将参数以queryString的方式返回，这里将其收集并封装成json字符串
	
	//鉴权
	public void login(HttpServletRequest request,HttpServletResponse response,JspWriter out)
	{
		String result=getParam(request,"Result","");
		String user_id=getParam(request,"UserID","");
		Map<String,String> map=new HashMap<String, String>();
		map.put("success","0".equals(result)+"");//标识是否登录成功
		map.put("code",result);//返回的结果码
		map.put("user_id",user_id);
		map.put("user_token",getParam(request,"UserToken",""));
		map.put("text",getParam(request,"Description",""));//如果失败，失败的原因
		response.setContentType("application/json;charset=UTF-8");
		out(out,map);//输出
	}

	//包月订购
	public void monthOrder(HttpServletRequest request,HttpServletResponse response,JspWriter out)
	{
		String result=getParam(request,"Result","");
		//示例结果
		//Result=104&Description=The%20product%20is%20already%20ordered.&UserID=&UserToken=&ContentID=null&ServiceID=null&ProductID=&PurchaseType=0&Fee=0&SPID=null&TransactionID=&ExpiredTime=&OrderMode=0&AvailableIPTVRewardPoints=0&AvailableTeleRewardPoints=0&SerStartTime=&SerEndTime=
		Map<String,String> map=new HashMap<String, String>();
		map.put("success","0".equals(result)+"");//标识是否订购成功
		map.put("code",result);//返回的结果码
		map.put("text",getParam(request,"Description",""));//如果失败，失败的原因
		response.setContentType("application/json;charset=UTF-8");
		out(out,map);
	}
	
	/**
	 * 检查字符串是否为空
	 * @param str
	 * @return
	 */
	public static boolean isEmpty(String str)
	{
		return (null==str||"".equals(str));
	}

	//request.getParameter方法的封装，如果取到的值为空，则赋一个默认值
	public static String getParam(HttpServletRequest request,String name,String defaultValue)
	{
		String value=request.getParameter(name);
		if(isEmpty(value)&&defaultValue!=null)
			value=defaultValue;
		return value;
	}
	//从request中获取值
	public static String getParam(HttpServletRequest request,String name)
	{
		return getParam(request, name, null);
	}
	//输出对象，自动转json
	public void out(JspWriter out,Object obj)
	{
		out(out,JsonUtils.toString(obj));
	}
	//输出字符串
	public void out(JspWriter out,String str)
	{
		try
		{
			out.print(str);
		}
		catch(Exception e)
		{
		}
	}
%>
<%
	String method=getParam(request,"method","login");
	if("login".equals(method))
		login(request,response,out);
	else if("month_order".equals(method))
		monthOrder(request,response,out);
%>