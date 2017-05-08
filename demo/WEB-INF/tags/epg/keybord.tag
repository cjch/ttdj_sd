<%@ tag pageEncoding="UTF-8" %>
<%@ attribute name="imagePath" required="false" description="皮肤路径" %>
<%
	imagePath=getValue(imagePath, request.getContextPath()+"/pages/test/tag/keybord_images/");
%>
<%
	String[] keys=new String[36];//A-Z、0-9一共36个字符
	for(int i=0;i<26;i++)
		keys[i]=(char)('A'+i)+"";
	for(int i=0;i<10;i++)
		keys[i+26]=(char)('0'+i)+"";
	request.setAttribute("keys",keys);
	String yellow="#F0F000";//黄色
	String gray="#CACACA";//灰色
%>
	<style type="text/css">
	div{position:absolute;}
	#keybord
	{
		visibility:hidden;
		left:66px;
		top:79px;
		width:508px;
		height:371px;
		background:transparent url(<%=imagePath%>keybord.gif) no-repeat;
	}
	#keybord_value
	{
		left: 36px;
		top: 61px;
		width: 336px;
		height: 54px;
		line-height:54px;
		font-size:42px;
		font-family:微软雅黑;
		color:#CACACA;
	}
	.keybord_key
	{
		left:0px;
		top:0px;
		width:32px;
		height:58px;
		color:black;
		font-size:28px;
		font-family:微软雅黑;
		text-align:center;
		line-height:58px;
	}
	</style>

	<div id="keybord">
		<div id="keybord_value">请输入拼音首字母</div>
		<%
			for(int i=0;i<keys.length;i++)//遍历输出A-Z、0-9这36个键
			{
		%>
			<div style="position:absolute;left:<%=i%13*35+29 %>px;top:<%=i/13*66+120%>px;">
				<div class="keybord_key"><img id="keybord_<%=i%>" src="<%=imagePath%>keybord_key.jpg"/></div>
				<div class="keybord_key" id="keybord_<%=i%>_txt"><%=keys[i]%></div>
			</div>
		<%
			} 
		%>
		<%
			for(int i=1;i<=2;i++)//遍历输出“搜索”、“删除”按钮
			{
		%>
			<div style="left:380px;top:<%=(i==1?60:252)%>px;">
				<img id="keybord_search_<%=i%>" src="<%=imagePath%>keybord_search.jpg"/>
			</div>
			<div style="left:447px;top:<%=(i==1?60:252)%>px;">
				<img id="keybord_delete_<%=i%>" src="<%=imagePath%>keybord_delete.jpg"/>
			</div>
		<%} %>
	</div>

			
	<script type="text/javascript">
	var key_link_image='<%=imagePath%>keybord_key.jpg';//按键默认图片
	var key_focus_image='<%=imagePath%>keybord_key_focus.jpg';//按键焦点图片
	//聚焦按键
	var focusKeybordKey=function(current)
	{
		G(current.id+'_txt').style.color='white';
	};
	//离开按键
	var blurKeybordKey=function(prev)
	{
		G(prev.id+'_txt').style.color='black';
	};

	Epg.keybord=
	{
		_value:'',//存放最终的结果值
		_last_btn_id:'keybord_0',//上次离开时的按钮，默认字母A
		is_show:false,//键盘是否是显示的,
		keys:
		[
			<%for(int i=0;i<keys.length;i++){%>
			{id:'keybord_<%=i%>',a:'a',action:'Epg.keybord.add("<%=keys[i]%>")',focusHandler:focusKeybordKey,blurHandler:blurKeybordKey,linkImage:key_link_image,focusImage:key_focus_image,left:['keybord_<%=i-1%>','keybord_delete_1'],right:['keybord_<%=i+1%>','keybord_search_2'],up:['keybord_<%=i-13%>','keybord_search_1'],down:['keybord_<%=i+13%>','keybord_search_2']},
			<%}%>
			{id:'keybord_search_1',action:'Epg.keybord._search()',linkImage:'<%=imagePath%>keybord_search.jpg',focusImage:'<%=imagePath%>keybord_search_focus.jpg',right:'keybord_delete_1',down:'keybord_12'},
			{id:'keybord_delete_1',action:'Epg.keybord.del()',linkImage:'<%=imagePath%>keybord_delete.jpg',focusImage:'<%=imagePath%>keybord_delete_focus.jpg',left:'keybord_search_1',right:'keybord_0',down:'keybord_12'},
			{id:'keybord_search_2',action:'Epg.keybord._search()',linkImage:'<%=imagePath%>keybord_search.jpg',focusImage:'<%=imagePath%>keybord_search_focus.jpg',left:'keybord_35',right:'keybord_delete_2',up:'keybord_23'},
			{id:'keybord_delete_2',action:'Epg.keybord.del()',linkImage:'<%=imagePath%>keybord_delete.jpg',focusImage:'<%=imagePath%>keybord_delete_focus.jpg',left:'keybord_search_2',up:'keybord_25'},
		],
		/**
		 * 获取键盘的最终值
		 */
		val:function()
		{
			return this._value;
		},
		/**
		 * 添加一个字符
		 */
		add:function(s)
		{
			if(this._value.length<=13)//搜索字符不能太长
			{
				this._value+=s;
				this.update();
			}
		},
		/**
		 * 删除一个字符
		 */
		del:function()
		{
			if(this._value.length>0)
			{
				this._value=this._value.substring(0,this._value.length-1);
				this.update();
			}
			if(this._value.length<=0)
				this.update('请输入拼音首字母','<%=gray%>');
		},
		/**
		 * 更新键盘的值和颜色
		 */
		update:function(str,color)
		{
			str=str==undefined?this._value:str;
			color=color==undefined?'<%=yellow%>':color;
			var temp=G('keybord_value');
			temp.innerHTML=str;
			temp.style.color=color;
		},
		/**
		 * 页面上初始化按钮前必须调用本方法，目的是将键盘的所有keys与buttos合并
		 */
		join:function(buttons)
		{
			for(var i=0; i<this.keys.length;i++)
				buttons.push(this.keys[i]);
		},
		/**
		 * 搜索
		 */
		_search:function()
		{
			this.search(this.val());
		},
		/**
		 * 点击键盘上的搜索
		 */
		search:function(val)
		{
			alert('搜索关键字为'+val+'，这里写搜索的方法，可以在其它地方覆盖本方法');
		},
		/**
		 * 显示键盘
		 */
		show:function()
		{
			var id=Epg.Button.current.id;//存储当前按钮id
			Epg.Button.set(this._last_btn_id);//默认键盘按钮
			this._last_btn_id=id;
			S('keybord');
			this.is_show=true;
		},
		/**
		 * 键盘是否显示
		 */
		isShow:function()
		{
			return this.is_show;
		},
		/**
		 * 隐藏键盘
		 */
		hide:function()
		{
			var id=Epg.Button.current.id;//存储当前按钮id
			H('keybord');
			this.is_show=false;
			Epg.Button.set(this._last_btn_id);//恢复离开前的按钮
			this._last_btn_id=id;
		}
	};
	</script>
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