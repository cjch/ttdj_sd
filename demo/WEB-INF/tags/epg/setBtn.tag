<%@ tag pageEncoding="UTF-8" %>
<%@ attribute name="imagePath" required="false" description="所有按钮的图片路径，如果设置了该值，那么图片只需要写图片名称即可" %>
<%@ attribute name="touming" required="false" description="透明图片路径" %>
<%@ attribute name="defaultImage" required="false" description="没有设置src时的默认图片，默认值为透明图片地址" %>
<%
	request.setAttribute("epgTagImagePath", getValue(imagePath, ""));//名字取这么长的目的就是避免冲突
	touming=getValue(touming, "");
	request.setAttribute("epgTagTouming", touming);
	request.setAttribute("epgTagDefaultImage", getValue(defaultImage, touming));
%>

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
%>