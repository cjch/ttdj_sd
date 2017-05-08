<%@ tag pageEncoding="UTF-8" %>
<%@ attribute name="left" required="true" description="分页整体left" %>
<%@ attribute name="top" required="true" description="分页整体top" %>
<%@ attribute name="current" required="true" description="当前页" %>
<%@ attribute name="pageCount" required="true" description="总页数" %>
<%@ attribute name="width" required="false" description="整个分页的宽度" %>
<%@ attribute name="maxPage" required="false" description="最多显示的页数" %>
<%@ attribute name="skin" required="false" description="皮肤路径" %>
<%@ attribute name="pageId" required="false" description="页码ID，默认page" %>
<%@ attribute name="up" required="false" description="当前页码的上面一个按钮" %>
<%@ attribute name="down" required="false" description="当前页码的下面一个按钮" %>
<%@ attribute name="leftAdd" required="false" description="相邻2个分页按钮的距离（left递增值）" %>
<%
	int _current=getValueInt(current);//当前页
	int _pageCount=getValueInt(pageCount);//总页数
	int _maxPage=getValueInt(maxPage, 7);//最多显示的页数
	int pageStart=1;//开始页码
	int pageEnd=_pageCount;//结束页码
	int _leftAdd=getValueInt(leftAdd, 24);//相邻2个分页按钮的距离（left递增值）
	int _width=getValueInt(width, 640);//分页最大可能的宽度，默认页面宽度
	String _skin=getValue(skin, request.getContextPath()+"/resources/sd/tag/page_skin/page2_skin/");//默认皮肤
	String _pageId=getValue(pageId, "page");
	if(_pageCount>_maxPage)//如果总页数大于显示的上限
	{
		pageStart=_current-(_maxPage/2);
		pageStart=pageStart<1?1:pageStart;
		pageEnd=pageStart+_maxPage-1;
		if(pageEnd>_pageCount)
		{
			pageStart=pageStart-(pageEnd-_pageCount);
			pageEnd=_pageCount;
		}
	}	
%>
<%
if(_pageCount>0)//只有总页数大于0时才生成相关代码
{
%>
	<script type="text/javascript">
	//移动完分页按钮后执行的方法
	function pageMoveHandler(prev, current, dir)
	{
		if(dir==='left'&&<%=_current%>>1)
			page(<%=_current-1%>);
		if(dir==='right'&&<%=_current%><<%=_pageCount%>)
			page(<%=_current+1%>);
	}
	function pageFocusHandler(current)
	{
		document.getElementById('<%=_pageId%>_tip').style.visibility='visible';
		document.getElementById('<%=_pageId%>_txt').style.color='white';
	}
	function pageBlurHandler(prev)
	{
		document.getElementById('<%=_pageId%>_tip').style.visibility='hidden';
		document.getElementById('<%=_pageId%>_txt').style.color='black';
	}

	buttons.push({id:'<%=_pageId%>',up:'<%=up%>',down:'<%=down%>',blurHandler:pageBlurHandler,focusHandler:pageFocusHandler,moveHandler:pageMoveHandler,linkImage:'<%=_skin%>page.png',focusImage:'<%=_skin%>page_focus.png'});//这个buttons必须在标签使用之前定义好！ 
	</script>
	
	<link href="<%=_skin%>skin.css" rel="stylesheet" type="text/css" />
	<div class="page_big_div" style="left:<%=left%>px;top:<%=top%>px;width:<%=_width%>px;height:31px;">
		
		<div class="page_small_div" style="left:<%=(_width-(pageEnd-pageStart+1)*_leftAdd)/2 %>px;top:0px;width:<%=(pageEnd-pageStart+1)*_leftAdd%>px">
			<%
			for(int i=pageStart;i<=pageEnd;i++)
			{
			%>
			<div class="page_div" style="left:<%=(i-pageStart)*_leftAdd %>px;">
				<img <%=i==_current?"id=\""+_pageId+"\"":""%> src="<%=_skin%>page.png" >
			</div>
			<div class="page_txt" style="left:<%=(i-pageStart)*_leftAdd %>px;<%=i==_current?"color:black;":""%>" <%=i==_current?"id=\""+_pageId+"_txt\"":""%>>
				<%=i %>
			</div>
			<%}%>
			<!-- 翻页提示 -->
			<div id="<%=_pageId%>_tip" style="left:<%=(pageEnd-pageStart+1)*_leftAdd %>px;top:0px;visibility:hidden;">
				<img src="<%=_skin%>page_tip.png">
			</div>
		</div>
		
	</div>
	
<%}%>
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