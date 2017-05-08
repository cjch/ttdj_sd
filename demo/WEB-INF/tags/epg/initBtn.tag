<%@tag import="java.util.Iterator"%>
<%@tag import="java.util.Set"%>
<%@ tag import="java.util.LinkedHashMap"%>
<%@ tag import="java.util.Comparator"%>
<%@ tag import="java.util.Collections"%>
<%@ tag import="java.util.TreeMap"%>
<%@ tag import="java.util.ArrayList"%>
<%@ tag import="java.util.List"%>
<%@ tag import="java.util.Arrays"%>
<%@ tag import="java.util.HashMap"%>
<%@ tag import="java.util.Map"%>
<%@ tag pageEncoding="UTF-8" %>
<%@ attribute name="defaultId" required="true" description="默认按钮ID，可以是字符串(如：defaultId=“btn”)，也可以是字符串数组(如：defaultId=“['btn1','btn2']”)" %>
<%@ attribute name="buttons" required="false" description="按钮数组的名字，默认buttons，特别是如果页面js已经有了buttons，最好设置一下此值" %>
<%@ attribute name="initKeys" required="false" description="是否自动初始化默认的遥控器按键配置，包括上、下、左、右、和确定，默认false" %>
<%!
	Map<String,Map<String,Object>> btns=new LinkedHashMap<String,Map<String,Object>>();//页面上所有按钮
	Map<String,Integer> lefts=new LinkedHashMap<String,Integer>();//所有按钮的left从小到大排序
	Map<String,Integer> tops=new LinkedHashMap<String,Integer>();//所有按钮的top从小到大排序
	Map<String,Integer> centerLefts=new LinkedHashMap<String,Integer>();//所有按钮的中心坐标left从小到大排序
	Map<String,Integer> centerTops=new LinkedHashMap<String,Integer>();//所有按钮的中心坐标top从小到大排序
%>
<%
	buttons=getValue(buttons, "buttons");//按钮数组的名字
	initKeys=getValue(initKeys, "false");//是否初始化按键
	
	Object obj=request.getAttribute("epgTagButtons");
	request.removeAttribute("epgTagButtons");
	if(obj!=null)
		btns=(Map<String,Map<String,Object>>)obj;
	for(String id:btns.keySet())//遍历所有按钮，取出各个按钮的left、top、以及中心坐标
	{
		Map<String,Object> button=btns.get(id);
		lefts.put(id, (Integer)button.get("left"));
		tops.put(id, (Integer)button.get("top"));
		centerLefts.put(id, (Integer)button.get("left")+(Integer)button.get("width")/2);
		centerTops.put(id, (Integer)button.get("top")+(Integer)button.get("height")/2);
	}
	//依次对几个map进行从小到大排序
	sortMap(lefts);
	sortMap(tops);
	sortMap(centerLefts);
	sortMap(centerTops);
%>
	<script type="text/javascript">
	var epg_tag_buttons=
	[
<%
	Iterator<String> iterator=btns.keySet().iterator();
	while(iterator.hasNext())//再次遍历页面每一个按钮，用这种方式的目的是为了能够判断是否hasNext，从而决定结尾是否要加“,”
	{
		String id=iterator.next();
		Map<String,Object> button=btns.get(id);//当前按钮
		Object name=button.get("name");
		Object action=button.get("action");
		Object focusHandler=button.get("focusHandler");
		Object blurHandler=button.get("blurHandler");
		Object moveHandler=button.get("moveHandler");
		Object data=button.get("data");//自定义属性
%>
		{id:'<%=id%>',<%=name==null?"":"name:'"+name+"',"%><%=getFn("action",action)%><%=getFn("focusHandler",focusHandler)%><%=getFn("blurHandler",blurHandler)%><%=getFn("moveHandler",moveHandler)%><%=getData(data)%>left:'<%=getBtn(id,"left")%>',right:'<%=getBtn(id,"right")%>',up:'<%=getBtn(id,"up")%>',down:'<%=getBtn(id,"down")%>',linkImage:'<%=button.get("linkImage")%>',focusImage:'<%=button.get("focusImage")%>'}<%=iterator.hasNext()?",":""%>
<%
	}
%>
	];
	if(typeof <%=buttons%>==='undefined')//如果buttons还没有定义
		window.<%=buttons%>=epg_tag_buttons;
	else	//如果已经定义了buttons，逐个push进去
	{
		for(var i=0;i<epg_tag_buttons.length;i++)
			<%=buttons%>.push(epg_tag_buttons[i]);
	}
	Epg.Button.init({defaultButtonId:<%=defaultId.startsWith("[")?defaultId:"'"+defaultId+"'"%>,buttons:<%=buttons%>});
	Epg.key=
	{
		keys: {},
		/**
		 * 逐个添加获取批量添加按键配置
		 */
		set: function(code, action)
		{
			if(typeof code==='object'&&action===undefined)//批量添加
			{
				var obj=code;
				for(var i in obj)
					this.keys[i]=obj[i];
			}
			else if(typeof code==='string')
			{
				this.keys[code]=action;
			}
			else if(typeof code==='number')
			{
				alert('添加按键映射时code不能为number类型！');
			}
			return this;
		},
		/** 和set方法一个意思 */
		add: function(code, action)
		{
			return this.set(code, action);
		},
		/**
		 * 逐个删除或者批量删除按键配置
		 */
		del: function(code)
		{
			if(!(code instanceof Array))
				code=[code];
			for(var i=0; i<code.length; i++)
			{
				if(this.keys[code[i]])
				{
					this.keys[code[i]]='Epg.key.emptyFn()';//标清机顶盒delete有问题
				}
			}
			return this;
		},
		/** 空方法，用于删除时 */
		emptyFn: function(){},
		/**
		 * 初始化eventHandler，随便什么时候调用、调用一次即可
		 */
		init: function()
		{
			Epg.eventHandler = function(code)
			{
				for(var i in Epg.key.keys)
					if(code===window[i])
						Epg.call(Epg.key.keys[i]);
			};
		}
	};
	if('<%=initKeys%>'==='true')
	{
		Epg.key.init();
		Epg.key.set(
		{
			KEY_LEFT:'Epg.Button.move("left")',
			KEY_RIGHT:'Epg.Button.move("right")',
			KEY_UP:'Epg.Button.move("up")',
			KEY_DOWN:'Epg.Button.move("down")',
			KEY_ENTER:'Epg.Button.click()'
		});
	}
	</script>
<%!
	/** 获取某个变量值，不存在则返回默认值 */
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
	
	/** 对map进行排序 */
	private void sortMap(Map<String,Integer> map)
	{
		List<Map.Entry<String,Integer>> list = new ArrayList<Map.Entry<String,Integer>>(map.entrySet()); 
		//通过比较器实现排序 
		Collections.sort(list, new Comparator<Map.Entry<String,Integer>>()
		{
			public int compare(Map.Entry<String,Integer> map1,Map.Entry<String,Integer> map2)
			{
				return map1.getValue().compareTo(map2.getValue());
			}
		});
		map.clear();
		for(Map.Entry<String,Integer> m:list)
			map.put(m.getKey(), m.getValue());
	}
	/** 
	 * 获取某个按钮某个方向上最合适的按钮，最终的调用方法 
	 */
	public String getBtn(String id,String dir)
	{
		Object temp=btns.get(id).get("left".equals(dir)?"leftBtn":dir);
		if(temp==null)//如果已经显示设置了这个方向的值，那么直接返回
		{
			String btn=getBtn(id, dir, false);//正常取第一遍
			if("".equals(btn))
				btn=getBtn(id, dir, true);//如果没有取到，放宽条件重新取一次
			if("".equals(btn))
				btn=getBtn(id, dir, false, -1, -1);//如果还没有找到，干脆没有任何范围限制任意去找
			return btn;//如果再没找到，会返回空字符串""。
		}
		else return (String)temp;
	}
	/** 获取某个按钮某个方向上最合适的按钮 */
	private String getBtn(String currentId,String dir,Boolean getMore)
	{
		return getBtn(currentId, dir, getMore, null, null);
	}
	/**
	 * 获取某个按钮某个方向上最合适的按钮
	 * @param currentId 当前按钮的ID
	 * @param dir 方向
	 * @param getMore 是否放宽匹配条件已获取更多可能的值，一般第二遍查找时才将此值设置为true
	 * @param start 匹配的最小值
	 * @param end 匹配的最大值
	 */
	private String getBtn(String currentId,String dir,Boolean getMore,Integer start,Integer end)
	{
		Map<String,Object> button=btns.get(currentId);//当前按钮
		int currentLeft=(Integer)button.get("left");
		int currentTop=(Integer)button.get("top");
		int currentWidth=(Integer)button.get("width");
		int currentHeight=(Integer)button.get("height");
		if(start==null||end==null)//如果这2个值没有设置，赋予默认值
		{
			if("left".equals(dir)||"right".equals(dir))
			{
				start=currentTop;
				end=currentTop+currentHeight;
			}
			else if("up".equals(dir)||"down".equals(dir))
			{
				start=currentLeft;
				end=currentLeft+currentWidth;
			}
		}
		int _start=start,_end=end;//保留最原始的start、end
		
		Map<String,Integer> center=null;//存放中心坐标的left或者top
		if("left".equals(dir)||"right".equals(dir))
			center=centerTops;
		else if("up".equals(dir)||"down".equals(dir))
			center=centerLefts;
		Map<String,Integer> temp=new LinkedHashMap<String,Integer>();//存放符合条件的临时按钮
		for(String id:center.keySet())
		{
			int nextLeft=lefts.get(id);
			int nextTop=tops.get(id);
			if(getMore)//如果放宽条件
			{
				int width=(Integer)btns.get(id).get("width");//下一个按钮的宽度
				int height=(Integer)btns.get(id).get("height");//下一个按钮的高度
				if("left".equals(dir)||"right".equals(dir))
				{
					start=_start-height/2;
					end=_end+height/2;
				}
				else if("up".equals(dir)||"down".equals(dir))
				{
					start=_start-width/2;
					end=_end+width/2;
				}
			}
			//如果( (完全不考虑start和end) 或者 (中心坐标满足指定范围) )
			if( (start<0&&end<0) || (center.get(id)>=start&&center.get(id)<=end) )
			{
				if("left".equals(dir)&&nextLeft<currentLeft)
					temp.put(id,nextLeft);
				else if("right".equals(dir)&&nextLeft>currentLeft)
					temp.put(id,nextLeft);
				else if("up".equals(dir)&&nextTop<currentTop)
					temp.put(id,nextTop);
				else if("down".equals(dir)&&nextTop>currentTop)
					temp.put(id,nextTop);
			}
		}
		sortMap(temp);//对符合条件的按钮进行排序
		String[] result=temp.keySet().toArray(new String[]{});//将最终结果转数组
		if(result.length>0)
		{
			if("left".equals(dir)||"up".equals(dir))//如果是“左”或者“上”，取最大值
				return result[result.length-1];
			else if("right".equals(dir)||"down".equals(dir))//如果是“右”或者“下”，取最小值
				return result[0];
		}
		return "";//没有找到符合条件的按钮时直接返回空字符串
	}
	/**
	 * 获取某个方法的字符串，如action，根据是否以“)”结尾来判断是否需要在最外边添加字符串包裹
	 */
	private String getFn(String name,Object fn)
	{
		if(fn==null)
			return "";
		String str=(String)fn;
		return name+":"+(str.endsWith(")")?"\""+str+"\"":str)+",";
	}
	/** 获取自定义属性 */
	private String getData(Object data)
	{
		return data==null?"":(((String)data).replaceAll("\\{","").replaceAll("\\}","")+",");
	}
	 
%>