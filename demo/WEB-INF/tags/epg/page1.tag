<%@tag import="com.lutongnet.iptv.util.HttpUtil"%>
<%@ tag pageEncoding="UTF-8" %>
<%@ attribute name="left" required="true" description="分页整体left" %>
<%@ attribute name="top" required="true" description="分页整top" %>
<%@ attribute name="current" required="true" description="当前页" %>
<%@ attribute name="pageCount" required="true" description="总页数" %>
<%@ attribute name="up" required="false" description="当前页码的上面一个按钮" %>
<%@ attribute name="down" required="false" description="当前页码的下面一个按钮" %>
<%@ attribute name="width" required="false" description="不包括2边箭头的线宽度" %>
<%@ attribute name="imagePath" required="false" description="图片路径" %>
<%@ attribute name="pageId" required="false" description="页码ID，默认page" %>
<%@ attribute name="noDataTip" required="false" description="没有数据时的提示文字" %>

<%-- 
	标签库名称：EPG分页一 ，仅适用于新版果果乐园和健身团JS
	创建日期：2014年4月
	最后编辑：2014年6月16日
--%>
<%
	
	int _current=getValueInt(current);//当前页
	int _pageCount=getValueInt(pageCount);//总页数
	int _width=getValueInt(width, 300);//不包括2边箭头的线宽度
	imagePath=getValue(imagePath, request.getContextPath()+"/resources/sd/tag/page_skin/page1_skin/");//图片路径
	pageId=getValue(pageId, "page");//默认“页码”按钮ID
	noDataTip = getValue(noDataTip, "对不起，没有找到指定的数据哦！");//没有数据时的提示文字
	up = getValue(up, "");
	down = getValue(down, "");
	if(!up.startsWith("["))//如果不是数组，那么自动加上单引号
		up = "'" + up + "'";
	if(!down.startsWith("["))
		down = "'" + down + "'";
	
	int jt_width = 11;//箭头宽度
	int jt_height = 16;//箭头高度
	int line_height = 2;//线的高度
	int text_width =  40;//文本宽度
	int page_btn_width = 34;//分页按钮宽度
	int page_btn_height = 28;//分页按钮高度

	
	
	int pageLeft=0;//“页码”按钮的left坐标
	int min=jt_width+1;//页码left最小值
	int max=_width+jt_width-page_btn_width-1;//页码left最大值
	if(_pageCount>0)
	{
		if(_pageCount==1)
			pageLeft=min+(max-min)/2;
		else
			pageLeft=min+(max-min)*(_current-1)/(_pageCount-1);//先除后乘会带来一定的误差
	}
%>
<%
if(_pageCount<=0)//只有总页数大于0时才生成相关代码
{
%>
	<style type="text/css">
	div.epg_tag_page_no_data
	{
		position:absolute;
		left:<%=left%>px;
		top:<%=top%>px;
		width:<%=_width%>px;
		font-size: 20px;
		color: rgb(0, 126, 65);
		text-align:center;
	}
	</style>
	<!-- 如需修改文字效果，用户可以覆盖这个样式 -->
	<div class="epg_tag_page_no_data">
		<%=noDataTip%>
	</div>
<%
}
else
{
%>
	<script type="text/javascript">
	//移动完分页按钮后执行的方法
	function pageMoveHandler(prev, current, dir)
	{
		if(dir==='left')
		{
			if(typeof pageUp === 'function')
				pageUp();
			else
				alert('使用EPG分页标签库必须事先定义好pageUp和pageDown2个方法！');
		}
		if(dir==='right')
		{
			if(typeof pageDown === 'function')
				pageDown();
			else
				alert('使用EPG分页标签库必须事先定义好pageUp和pageDown2个方法！');
		}
	}
	var pageMoveObj={id:'<%=pageId%>',up:<%=up%>,down:<%=down%>,moveHandler:pageMoveHandler,autoPrefix:false, linkImage:'<%=imagePath%>page.png',focusImage:'<%=imagePath%>page_f.png'};
	buttons.push(pageMoveObj);//这个buttons必须在标签使用之前定义好！ 
	</script>
	
	<style type="text/css">
	#epg_tag_page div
	{
		position:absolute;
	}
	/*文本*/
	.epg_tag_page_text
	{
		top:-2px;
		text-align:center;
		font-size:20px;
		color:white;
	}
	/*当前页文本*/
	.epg_tag_page_current_text
	{
		left: 0px;
		top: 0px;
		text-align: center;
		color:white;
		font-size:20px;
		line-height:<%=page_btn_height%>px;
	}
	</style>
	
	<!-- EPG自动分页标签 -->
	<div id="epg_tag_page" style="position:absolute;left:<%=left%>px;top:<%=top%>px;width:<%=2*jt_width+_width%>px;height:<%=jt_height%>px;">
		<!-- 第一页 -->
		<div style="left:<%=-text_width%>px;width:<%=text_width%>px;" class="epg_tag_page_text">1</div>
		<!-- 背景箭头1 -->
		<div style="position:absolute;left:0px;top:0px;">
			<img src="<%=imagePath%>page_bg_left.png"/>
		</div>
		<!-- 背景箭头2 -->
		<div style="left:<%=jt_width%>px;top:<%=(jt_height-line_height)/2%>px;">
			<img src="<%=imagePath%>page_bg_line.png" width="<%=_width%>" height="2px;"/>
		</div>
		<!-- 背景箭头3 -->
		<div style="left:<%=jt_width+_width%>px;top:0px;">
			<img src="<%=imagePath%>page_bg_right.png"/>
		</div>
		<!-- 当前页 -->
		<div style="left:<%=pageLeft%>px;top:<%=-1*(page_btn_height-jt_height)/2%>px;width: <%=page_btn_width%>px;height: <%=page_btn_height%>px;">
			<div style="position:absolute;left:0px;top:0px;">
				<img id="<%=pageId%>" src="<%=imagePath%>page.png" width="<%=page_btn_width %>" height="<%=page_btn_height%>"/>
			</div>
			<div style="width: <%=page_btn_width%>px;height: <%=page_btn_height%>px;" class="epg_tag_page_current_text"><%=current %></div>
		</div>
		<!-- 最后一页 -->
		<div style="position:absolute;left:<%=2*jt_width+_width%>px;width:<%=text_width%>px;" class="epg_tag_page_text">
			<%=pageCount%>
		</div>
	</div>
	
<%}%>
<%!
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