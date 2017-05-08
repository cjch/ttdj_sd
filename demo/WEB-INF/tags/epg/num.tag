<%@tag import="java.util.Map"%>
<%@tag import="java.util.HashMap"%>
<%@tag import="com.lutongnet.iptv.util.HttpUtil"%>
<%@ tag pageEncoding="UTF-8" description="“数字转图片”标签库"%>
<%@ attribute name="value" required="true" description="数值，当value为int时最好用EL表达式，直接用Java代码总是喜欢有点问题" %>
<%@ attribute name="left" required="true" description="整体left" %>
<%@ attribute name="top" required="true" description="整体top" %>
<%@ attribute name="width" required="true" description="整体宽度" %>
<%@ attribute name="height" required="false" description="整体高度，不设置时取imageHeight的值" %>
<%@ attribute name="imageWidth" required="true" description="图片宽度" %>
<%@ attribute name="imageHeight" required="true" description="图片高度" %>
<%@ attribute name="imagePath" required="true" description="图片路径" %>
<%@ attribute name="imageFormat" required="false" description="图片格式" %>
<%@ attribute name="gap" required="false" description="间隙" %>
<%@ attribute name="id" required="false" description="div的ID" %>

<%-- 
	标签库名称：数字转图片
	使用说明：要求所有图片都在一个文件夹、所有图片尺寸必须一样、value只能出现以下字符：0-9数字、%、月、日、小数点
	创建日期：2014年7月5日
	最后编辑：2014年7月5日
--%>

<%
	
	char[] values = value.toCharArray();
	
	int gapInt = getValueInt(gap, 0);
	int imageWidthInt = getValueInt(imageWidth);
	int imageHeightInt = getValueInt(imageHeight);
	int leftInt = getValueInt(left);
	int topInt = getValueInt(top);
	int widthInt = getValueInt(width);
	int heightInt = getValueInt(height, imageHeightInt);//div的默认高度为图片的高度
	int totalWidth = values.length*(imageWidthInt+gapInt)-gapInt;//最终真正的宽度
	int leftStart = (widthInt-totalWidth)/2;//img的起始left
	int topStart = (heightInt-imageHeightInt)/2;//img的起始top
	
	imageFormat = getValue(imageFormat, ".png");
	if(id!=null && !"".equals(id))
		id = " id=\""+id+"\" ";
	
	Map<String, String> map = new HashMap<String, String>();//文字到图片映射
	map.put("%", "percent");
	map.put("月", "month");
	map.put("日", "date");
	map.put("-", "split");
	map.put(".","dot");
%>
	<div <%=id%> style="position:absolute; left:<%=left%>px;top:<%=top%>px;width:<%=widthInt%>px;height:<%=heightInt%>px;">
		<%for(int i=0; i<values.length; i++)
		{
		%>
		<img src="<%=imagePath + getMapString(map, values[i]+"") + imageFormat%>" style="position:absolute;left:<%=leftStart+i*(imageWidthInt+gapInt)%>px;top:<%=topStart%>px;width:<%=imageWidthInt%>px;height:<%=imageHeightInt%>px;"/>
		<%
		}%>
		
	</div>
<%!
	
	/**
	 * 从Map中获取对应的值，找不到返回key本身
	 */
	private String getMapString(Map<String, String> map, String key)
	{
		String value = map.get(key);
		if(value==null || "".equals(value))
			value = key;
		return value;
	}

	/**
	 * 获取某个值，当值不存在时返回默认值
	 */
	private String getValue(String value,String defalutValue)
	{
		if(value==null||"".equals(value))
			return defalutValue;
		return value;
	}

	/**
	 * 获取某个int类型的值，当值不存在时返回默认值
	 */
	private int getValueInt(String value,Integer defaultValue)
	{
		if(value==null||"".equals(value))
			return defaultValue;
		return Integer.parseInt(value);
	}
	
	/**
	 * 获取某个int类型的值
	 */
	private int getValueInt(String value)
	{
		return getValueInt(value, null);
	}
%>