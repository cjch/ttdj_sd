<%@ tag pageEncoding="UTF-8" %>
<%@ attribute name="left" required="true" %>
<%@ attribute name="top" required="true" %>
<%@ attribute name="current" required="true" %>
<%@ attribute name="pageCount" required="true" %>
<%@ attribute name="skin" required="false" %>
<%@ attribute name="up" required="false" %>
<%@ attribute name="down" required="false" %>
<%
	int _current=getValueInt(current);//当前页
	int _pageCount=getValueInt(pageCount);//总页数
	String _skin=getValue(skin, request.getContextPath()+"/resources/sd/tag/page_skin/page3_skin/");//默认皮肤
%>
<%
if(_pageCount>0)//只有总页数大于0时才生成相关代码
{
%>
	<script type="text/javascript">

	function pageUp()
	{
		if(<%=_current%>>1)
			page(<%=_current-1%>);
	}
	function pageDown()
	{
		if(<%=_current%><<%=_pageCount%>)
			page(<%=_current+1%>);
	}
	//这个buttons必须在标签使用之前定义好！
	buttons.push({id:'page_prev',up:'<%=up%>',down:'<%=down%>',left:'',right:'page_next',action:'pageUp()',linkImage:'<%=_skin%>page_prev.png',focusImage:'<%=_skin%>page_prev_focus.jpg'});
	buttons.push({id:'page_next',up:'<%=up%>',down:'<%=down%>',left:'page_prev',right:'page_input',action:'pageDown()',linkImage:'<%=_skin%>page_next.png',focusImage:'<%=_skin%>page_next_focus.jpg'}); 
	buttons.push({id:'page_input',up:'<%=up%>',down:'<%=down%>',left:'page_next',right:'page_go',linkImage:'<%=_skin%>page_input.png',focusImage:'<%=_skin%>page_input_focus.jpg'});
	buttons.push({id:'page_go',up:'<%=up%>',down:'<%=down%>',left:'page_input',right:'',linkImage:'<%=_skin%>page_go.png',focusImage:'<%=_skin%>page_go_focus.jpg'}); 
	</script>
	
	<link href="<%=_skin%>skin.css" rel="stylesheet" type="text/css" />
	
	<div style="position:absolute;left:<%=left%>px;top:<%=top%>px;">
		<div class="page_prev">
			<img id="page_prev" src="<%=_skin%>page_prev.png"/>
		</div>
		<div class="page_tip_txt"><%=_current%>/<%=_pageCount%></div>
		<div class="page_next">
			<img id="page_next" src="<%=_skin%>page_next.png"/>
		</div>
		<div class="page_input">
			<img id="page_input" src="<%=_skin%>page_input.png"/>
		</div>
		<div class="page_go">
			<img id="page_go" src="<%=_skin%>page_go.png"/>
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