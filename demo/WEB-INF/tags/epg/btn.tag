<%@ tag import="java.util.LinkedHashMap"%>
<%@ tag import="java.util.HashMap"%>
<%@ tag import="java.util.Map"%>
<%@ tag pageEncoding="UTF-8" description="EPG按钮标签库，一般还需配合epg:setBtn和epg:initBtn使用。" %>
<%@ attribute name="id" required="true" description="按钮ID" %>
<%@ attribute name="left" required="true" description="按钮left边距" %>
<%@ attribute name="top" required="true" description="按钮top边距" %>
<%@ attribute name="width" required="true" description="按钮宽度" %>
<%@ attribute name="height" required="true" description="按钮高度" %>

<%@ attribute name="src" required="false" description="默认图片，注意src和linkImage属同一张图片" %>
<%@ attribute name="focusImage" required="true" description="焦点图片" %>

<%@ attribute name="leftBtn" required="false" description="左边的按钮，如果没有手动设置将会自动生成，注意和坐标left区分开来！" %>
<%@ attribute name="right" required="false" description="右边的按钮，如果没有手动设置将会自动生成" %>
<%@ attribute name="up" required="false" description="上边的按钮，如果没有手动设置将会自动生成" %>
<%@ attribute name="down" required="false" description="下边的按钮，如果没有手动设置将会自动生成" %>

<%@ attribute name="name" required="false" description="按钮的中文名称" %>
<%@ attribute name="data" required="false" description="自定义属性，所有自定义属性都写在data下面，如：data=“{a:1,b:'str'}”" %>
<%@ attribute name="action" required="false" description="按钮的动作，示例一(有括号的)：action=“alert('你好')”，示例二(无括号的，直接写方法名)：action=“alert”" %>
<%@ attribute name="focusHandler" required="false" description="按钮聚焦后触发的事件" %>
<%@ attribute name="blurHandler" required="false" description="按钮失去焦点时触发的事件" %>
<%@ attribute name="moveHandler" required="false" description="按钮移动后触发的事件" %>
<%
	Object obj=request.getAttribute("epgTagButtons");
	Map<String,Map<String,Object>> buttons=new LinkedHashMap<String,Map<String,Object>>();
	if(obj!=null)
		buttons=(Map<String,Map<String,Object>>)obj;
	Map<String,Object> map=new HashMap<String,Object>();
	String imagePath=getAttr(request, "epgTagImagePath", "");//图片路径
	String defaultImage=getAttr(request, "epgTagDefaultImage", "");//默认图片
	src=getValue(src, defaultImage);//src默认透明图片
	if(!src.startsWith("http"))
		src=imagePath+src;
	if(!focusImage.startsWith("http"))
		focusImage=imagePath+focusImage;
	
	map.put("left", Integer.parseInt(left));//注意这4个值必须先转int再放进去，下同
	map.put("top", Integer.parseInt(top));
	map.put("width", Integer.parseInt(width));
	map.put("height", Integer.parseInt(height));
	
	map.put("src", src);
	map.put("linkImage", src);
	map.put("focusImage", focusImage);
	
	map.put("leftBtn", leftBtn);
	map.put("right", right);
	map.put("up", up);
	map.put("down", down);
	
	map.put("name", name);
	map.put("data", data);
	map.put("action", action);
	map.put("focusHandler", focusHandler);
	map.put("blurHandler", blurHandler);
	map.put("moveHandler", moveHandler);

	buttons.put(id, map);
	request.setAttribute("epgTagButtons", buttons);//将修改完的buttons重新放入request中去
	
%>
	<%="<!-- "+(name==null?id:name)+" -->"%>
	<div style="position:absolute;left:<%=left%>px;top:<%=top%>px;">
		<img id="<%=id%>" src="<%=src%>" style="width:<%=width%>px;height:<%=height%>px;"/>
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