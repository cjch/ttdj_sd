<%@ tag import="java.util.LinkedHashMap"%>
<%@ tag import="java.util.HashMap"%>
<%@ tag import="java.util.Map"%>
<%@ tag pageEncoding="UTF-8" description="EPG按钮标签库，一般还需配合epg:setBtn使用。" %>
<%@ attribute name="id" required="true" description="按钮ID" %>
<%@ attribute name="left" required="true" description="按钮left边距" %>
<%@ attribute name="top" required="true" description="按钮top边距" %>

<%@ attribute name="src" required="false" description="默认图片" %>
<%@ attribute name="focusImage" required="true" description="焦点图片" %>

<%@ attribute name="name" required="false" description="按钮的中文名称，将会出现在注释里面" %>
<%@ attribute name="action" required="false" description="点击按钮触发的动作或者将要跳转的地址" %>
<%@ attribute name="href" required="false" description="如果action是一个超链接地址而不是一个方法，请将此值设置为true" %>
<%
	String imagePath=getAttr(request, "epgTagImagePath", "");//图片路径
	String touming=getAttr(request, "epgTagTouming", "");//透明图片路径
	String defaultImage=getAttr(request, "epgTagDefaultImage", "");//默认图片
	src=getValue(src, defaultImage);//src默认透明图片
	href=getValue(href, "false");
	if(!src.startsWith("http"))
		src=imagePath+src;
	if(!focusImage.startsWith("http"))
		focusImage=imagePath+focusImage;
%>
	<%="<!-- "+(name==null?id:name)+" -->"%>
	<div style="position:absolute;left:<%=left%>px;top:<%=top%>px;">
		<img id="<%=id%>" src="<%=src%>"/>
	</div>
	<div style="position:absolute;left:<%=left%>px;top:<%=top%>px;">
		<a id="<%=id%>_a" href="<%="true".equals(href)?action:"javascript:"+action %>" onfocus="MM_swapImage('<%=id%>','','<%=focusImage %>',1);" onblur="MM_swapImgRestore();">
			<img src="<%=touming %>" width="1" height="1" border="0"/>
		</a>
	</div>
<%!
	private String getValue(String value,String defalutValue)
	{
		if((value==null||"".equals(value))&&defalutValue!=null)
			return defalutValue;
		return value;
	}
	private int getValueInt(String value,Integer defaultValue)
	{
		if((value==null||"".equals(value)))
			return defaultValue;
		return Integer.parseInt(value);
	}
	private int getValueInt(String value)
	{
		return getValueInt(value, null);
	}
	private String getAttr(HttpServletRequest request,String name,String defaultValue)
	{
		Object obj=request.getAttribute(name);
		if(obj!=null)
			return (String)obj;
		return defaultValue;
	}
%>