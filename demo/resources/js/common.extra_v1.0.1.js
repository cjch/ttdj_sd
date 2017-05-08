
/**
 * 显示一个元素，与S不同的是，修改的是display属性<br>
 * add by lxa 20140922
 * 修改visibility的最大缺点是：如果子元素是显示的话，即使父元素隐藏了子元素也不会隐藏
 * @param id
 */
function Show(id)
{
	var temp = G(id);
	if(temp)
		temp.style.display = 'block';
}
/**
 * 隐藏一个元素，与H不同的是，修改的是display属性<br>
 * add by lxa 20140922
 * 修改visibility的最大缺点是：如果子元素是显示的话，即使父元素隐藏了子元素也不会隐藏
 * @param id
 */
function Hide(id)
{
	var temp = G(id);
	if(temp)
		temp.style.display = 'none';
}

/**
 * 获取上下文路径，不带最后面的“斜杠”，形如：/health-sd
 * @returns {String}
 */
Epg.getBasePath = function()
{
	var contextPath = '/' + location.href.split('/')[3];
	return contextPath;
};

/**
 * 判断对象是否是数组，add by lxa 20140923
 * @param obj 要判断的对象
 */
Epg.isArray = function(obj)
{
	return (obj instanceof Array); 
};

/**
 * 默认提示方法
 * @param info 提示文字
 * @param second 显示的秒数，默认3秒，如果为0那么永久显示
 */
Epg.tip = function(info, second)
{
	/*
	if(info === undefined || info === '')//info为空时不产生任何效果
		return;
	second = second===undefined?3:second;
	G('default_tip').innerHTML=info;
	S('default_tip');
	if(second>0)
	{
		if(Epg._tip_timer)//如果上次执行过setTimeout，那么强行停止
			clearTimeout(Epg._tip_timer);
		Epg._tip_timer = setTimeout('H("default_tip")',second*1000);
	}
	*/
};

/**
 * 默认提示方法
 * @param info 提示文字
 * @param second 显示的秒数，默认3秒，如果为0那么永久显示
 */
Epg.ykqTip = function(info, second)
{
	second = second===undefined?3:second;
	G('ykq_tip').innerHTML = info;
	S('ykq_tip');
	if(second>0)
	{
		if(Epg._ykq_tip_timer)//如果上次执行过setTimeout，则强行停止计时器
			clearTimeout(Epg._ykq_tip_timer);
		Epg._ykq_tip_timer = setTimeout('H("ykq_tip")',second*1000);
	}
};

/**
 * 分页方法
 * @param url 要跳转的url，必须页码必须是最后一个参数，且“=”结尾
 * @param idx 要跳转的页码
 * @param pageCount 总页数，只有下一页时才用到
 */
Epg.page = function(url, idx, pageCount)
{
	idx = parseInt(idx);
	if(idx < 1)
		Epg.tip('已经是第一页了！');
	else if(pageCount !== undefined && idx > parseInt(pageCount))
		Epg.tip('已经是最后一页了！');
	else
	{
		url += idx;
		if(pageCount === undefined)//如果是上一页（一般上一页时不传此参数，当然这个判断不准确），修改OTT版的移动动画向右
			url += '&transition_animate_dir=false';
		Epg.jump(url);
	}
};

/**
 * 跳转
 * @param href 要跳转的url
 * @param f 焦点按钮，默认当前按钮ID
 * @deprecated 不建议使用本方法
 */
Epg.jump = function(href,f)
{
	if(f === undefined)
		f = Epg.btn.current.id;
	window.location.href = href+'&f='+f;
};

/**
 * 用于开发时控制台输出信息，上线后注释内部代码即可
 * @param info 
 */
Epg.debug = function(info)
{
	if(debug_mode && typeof console !== 'undefined' && console.log)
		console.log(info);
};

/**
 * 与遥控器按键相关的方法，不影响旧版代码
 */
Epg.key = 
{
	/**
	 * 所有与按键相关的方法都放在这里
	 */
	keys:
	{
		KEY_5: function(){if(debug_mode)location.reload();}//如果是开发模式，按5刷新
	},
	ids: {},
	/**
	 * 逐个添加或者批量添加按键配置
	 */
	set: function(code, action)
	{
		if(typeof code === 'string' && action !== undefined)//如果是单个添加
		{
			//注意不能这样写：code={code:action}
			var _code = code;
			code = {};
			code[_code] = action;
		}
		if(typeof code === 'object')//批量添加
		{
			var obj = code;
			for(var i in obj)
			{
				if(i.indexOf('KEY_') === 0 || i.indexOf('EVENT_') === 0)//如果是“KEY_”或者“EVENT_”开头，视作按键
					this.keys[i] = obj[i];
				else//否则，视作和按钮ID相关的方法
					this.ids[i] = obj[i];
			}
		}
		else if(typeof code === 'number')//根本不允许出现这种错误！
		{
			alert('错误：添加按键映射时code不能为number类型！');
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
			code = [code];
		for(var i=0; i<code.length; i++)
		{
			if(this.ids[code[i]])
				this.ids[code[i]] = 'Epg.key.emptyFn()';
			if(this.keys[code[i]])
				this.keys[code[i]] = 'Epg.key.emptyFn()';//标清机顶盒delete有问题
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
		if(!Epg.eventHandler)//避免重复定义
		{
			Epg.eventHandler = function(code)
			{
				for(var i in Epg.key.ids)//ID判断方法必须先执行，原因自己分析！
					if(Epg.Button.current.id === i)
						Epg.call(Epg.key.ids[i],code);
				for(var i in Epg.key.keys)
					if(code === window[i])
						Epg.call(Epg.key.keys[i],code);
			};
		}
	}
};

/**
 * JS操作cookie工具类，add by lxa 20140529
 */
Epg.cookie=
{
	/**
	 * 从js中获取cookie
	 * 由于标清机顶盒decodeURI有问题，所以获取cookie时不再自动URL解码
	 * 存cookie的时候，java代码里面存中文的话就URL编码一下，js获取时不做解码
	 * @param cookie_name cookie名字
	 * @param default_value 默认值
	 * @param parseNumber 是否强转数字
	 * @param unescape 是否使用unescape来解码，注意，这个一般只用来解码“:/”等之类的简单符号，对于中文，整个机顶盒都甭想
	 * @returns
	 */
	get: function(cookie_name, default_value, parseNumber, unescape)
	{
		var reg = '(/(^|;| )'+cookie_name+'=([^;]*)(;|$)/g)';
		var temp = eval(reg).exec(document.cookie);
		if(temp != null)
		{
			var value = temp[2];
			if(parseNumber == true)
				return parseFloat(value);
			if(unescape)
				return unescape(value);//URL解码，暂时用unescape代替，具体有没有问题有待日后观察
			return value;
		}
		return default_value;
	},
	/**
	 * 设置cookie
	 * @param name cookie名称
	 * @param value cookie内容，注意cookie内容不能有分号、逗号、等号、空格等特殊字符，中文就更不可以，所以注意使用escape
	 * @param day cookie失效天数，默认30天
	 * @param path cookie的作用范围，默认当前项目下
	 */
	set: function(name, value, day, path)
	{
		day = day==undefined?30:day;
		path = path==undefined?Epg.getBasePath():path;
		var str = name+'='+value+'; ';
		if(day)
		{
			var date = new Date(); 
			date.setTime(date.getTime()+day*24*3600*1000);
			str += 'expires='+date.toGMTString()+'; ';
		}
		if(path)
			str += 'path='+path;
		document.cookie = str;//注意，cookie这样设置并不会覆盖之前所有的cookie！除非同名同path
	},

	/**
	 * 删除cookie
	 * @param name cookie的名字
	 * @param path cookie所在的path，默认contextPath
	 */
	del: function(name, path)
	{
		this.set(name, null, -1, path);
	}
};

/**
 * 机顶盒不支持trim方法，故手动写一个
 * add by lxa 20140606
 */
Epg.trim = function(str)
{
	if(str) return str.replace(/^\s*(.*?)\s*$/g,'$1');
};

/** HTML操作 */
Epg.Html = Epg.Text = 
{
	rollStart: function(config)
	{
		var id = config.id;
		var amount = config.amount || 1;
		var delay = config.delay || 40;
		var dir = config.dir || 'left';
		if(!this.rollId)
		{
			this.rollId = id;
			this.innerHTML = G(id).innerHTML;
			G(id).innerHTML = '<marquee direction="'+dir+'" behavior="scroll" scrolldelay="'+delay+'" scrollamount="'+amount+'">'+this.innerHTML+'</marquee>';
		}
	},
	rollStop: function()
	{
		G(this.rollId).innerHTML = this.innerHTML;
		this.rollId = null;
	}
};

/**
 * 滚动字幕方法，与Epg.Html有些不同，故单独写一个
 * add by lxa 20140606
 */
Epg.marquee =
{
	/**
	 * 将div里面的某段静态文字变成滚动字幕，add by lxa 20140217
	 * @param id div的ID
	 * @param max_length 最长的文字个数，这里忽略英文、数字和中文之间的差别，统一按个数来算
	 * @param amount 时间
	 * @param delay 延时
	 * @param dir 方向，默认left
	 * @param behavior 滚动方式，alternate为左右来回滚动，scroll为循环滚动
	 */
	start: function(max_length,id,amount,delay,dir,behavior)
	{
		max_length = max_length || 7;
		id = id || Epg.Button.current.id+'_txt';
		amount = amount || 1;
		delay = delay || 50;
		dir = dir || 'left';
		behavior = behavior || 'alternate';
		if(!this.rollId)
		{
			var html = Epg.trim(G(id).innerHTML);
			//var escapehtml = escape(html);
			if(max_length!==undefined&&html.length>max_length)
			{
				this.rollId = id;
				this.innerHTML = html;
				G(id).innerHTML = '<marquee width="100%" height="100%" id="'+id+'_marquee'+'" behavior="'+behavior+'" direction="'+dir+'" scrollamount="'+amount+'" scrolldelay="'+delay+'">'+html+'</marquee>';
			}
		}
	},
	/**
	 * 停止滚动字幕
	 */
	stop: function()
	{
		if(this.rollId)
		{
			G(this.rollId).innerHTML = this.innerHTML;
			this.rollId = undefined;
		}
	}
};

/**
 * 使用JS将前端信息输出到后台，add by lxa 20140922
 */
Epg.Log.debug = function(info)
{
	var url = Epg.getContextPath() + 'com/log.jsp?method=debug&info='+escape(info);
	this.ajax(url, true);
};

/**
 * 使某张图片或者按钮闪烁，一个页面最多只能有一个按钮闪烁
 * add by lxa 20140922
 */
Epg.twinkle = 
{
	/**
	 * 开始闪烁，如果另一个按钮没有停止闪烁会强行停止
	 * @param id 图片或者某个按钮的ID
	 * @param time 多长时间闪烁一次，默认200毫秒
	 */
	start: function(id, time)
	{
		this.stop();//防止未停先起
		id = id || Epg.btn.current.id;
		time = (typeof time === 'number') ? time : 200;//默认200毫秒闪烁一次
		this._id = id;//之所以不直接用id是因为部分标清盒子要求这里的变量必须是全局的
		this._is_hide = false;//标记是否是隐藏的
		this._timer = setInterval(function()
		{
			if(Epg.twinkle._is_hide)
				S(Epg.twinkle._id);
			else
				H(Epg.twinkle._id);
			Epg.twinkle._is_hide = !Epg.twinkle._is_hide;//取反
		}, time);
	},
	/**
	 * 停止闪烁
	 */
	stop: function()
	{
		if(this._timer)
		{
			clearInterval(this._timer);
			this._timer = undefined;
			S(Epg.twinkle._id);//停止闪烁后恢复显示
		}
	}
};

/**
 * 字符串转驼峰形式，add by lxa 20140923
 * 示例一：$.toHump('get_param')，返回getParam
 * 示例二：$.toHump('font-size','-')，返回fontSize
 * @param str
 * @param 分割的标志，默认为“_”
 */
Epg.toHump = function(str, flag)
{
	flag = flag ? flag : '_';
	var temp = str.match(eval('(/'+flag+'(\\w)/g)'));
	for(var i=0; temp!=null&&i<temp.length; i++)
		str=str.replace(temp[i],temp[i].charAt(1).toUpperCase());
	return str;
	//以下写法标清机顶盒不支持
	/*return str.replace(eval('(/'+flag+'(\\w)/g)'),function(m,$1,idx,str)
	{
		return $1.toUpperCase();
	});*/
};

var curCSS;//模仿jQuery中读取css定义的对象，add by lxa 20140923
if(window.getComputedStyle)//如果是谷歌或火狐
{
	curCSS = function(elem, name) 
	{
		name = Epg.toHump(name,'-');//转驼峰形势
		var ret,
			computed=window.getComputedStyle(elem,null),
			style = elem.style;
		if(computed) 
			ret = computed[name];
		if(!ret)
			ret = style[name];
		return ret;
	};
}
else if(document.documentElement.currentStyle)//如果是IE
{
	curCSS = function(elem, name)
	{
		name = Epg.toHump(name,'-');//转驼峰形势
		var ret = elem.currentStyle&&elem.currentStyle[name],
			style = elem.style;
		if(!ret&&style&&style[name])
		{
			ret=style[name];
		}
		return ret === '' ? 'auto' : ret;
	};
}
else //否则，如果是垃圾机顶盒
{
	curCSS = function(elem,name)
	{
		name = Epg.toHump(name,'-');//转驼峰形势
		var style=elem.style;
		return style[name];
	};
}

/**
 * 检查某个css属性是不是属于包含px的那种
 * add by lxa 20140923
 * 示例一：Epg.isPxCss('left');//返回true
 * 示例二：Epg.isPxCss('opacity');//返回false
 * @param name
 * @returns {Boolean}
 */
Epg.isPxCss = function(name)
{
	var px_css=['left','top','right','bottom','width','height','line-height','font-size'];
	for(var i=0;i<px_css.length;i++)
		if(px_css[i]===name)
			return true;
	return false;
};

/**
 * 读取或修改元素的css属性，注意机顶盒支持的css很有限，请谨慎使用<br>
 * 直接修改或者读取obj.style.xxx时不能读取定义在css中的样式
 * add by lxa 20140923
 * @param obj 要读取或者设置的对象
 * @param name css名称
 * @param value 不传值代表获取，传值表示设置
 * @returns
 */
Epg.css = function(obj, name, value)
{
	if(value === undefined)//获取css属性
	{
		var temp = curCSS(obj, name);
		if(temp!=undefined && (temp==''||temp=='auto'))
			temp = 0;
		return temp;
	}
	else//设置css属性
	{
		value += '';//int转string
		//如果是以px为单位的样式，但又没有传px，主动加上去
		if(this.isPxCss(name) && value.indexOf('px')<0)
			value += 'px';
		obj.style[Epg.toHump(name)] = value;
	}
};


/**
 * 动画相关方法，add by lxa 20140923
 */
Epg.fx = 
{
	interval: 13,//动画执行的帧率，意思是多少毫秒执行一次，默认13毫秒，jQuery默认就是这个值
	tagIdx: 0,//用来给timer递增取名字的索引
	animates: {},//存储所有执行过的动画数据，执行完毕后数据会被清空
	/**
	 * 开始一个动画，不兼容标清机顶盒，具体可能表现在：标清setInterval必须使用全局变量，标清的delete有问题，等
	 * @param obj 需要执行动画的对象
	 * @param params 动画参数，obj类型，形如：{left:'200px',top:'300px'}
	 * 				或者：{left:['100px','200px'],top:['50px','300px']}
	 * @param speed 速度，可以是number类型，表示毫秒数，也可以是字符串，如：'fast','normal','slow'
	 * @param easing 动画效果，默认swing
	 * @param callback 动画执行完毕后的回调函数
	 * @param tag 给动画取标签，如果开始一个动画前已经存在一个正在运行的、且标签相同的动画，
	 * 				那么这个动画会被强行停止，并直接变成动画结束时的状态，默认'default'
	 */
	start: function(obj, params, speed, easing, callback, tag)
	{
		var speeds = {fast:200, normal:400, slow:600};//预设的3个速度级别，同jQuery一模一样
		speed = (typeof speed === 'string' ? speeds[speed] : speed) || speeds.normal;
		if(typeof easing === 'function')
		{
			tag = callback;
			callback = easing;
			easing = '';
		}
		easing = easing || 'swing';
		tag = tag || 'default';//默认标签
		
		//遍历正在执行的动画集合，存在相同tag的动画时强行停止
		for(var i in this.animates)			
		{
			if(i.indexOf(tag)>=0)
				this.stop(i);//结束动画
		}
		
		var oldParams = params;//旧的params数据
		params = {};//新的params数据
		var canContinue = false;//标记动画是否能够继续执行下去
		for(var i in oldParams)//处理旧数据
		{
			var p = oldParams[i];
			if(!Epg.isArray(p)) //如果不是数组，强行变成数组
				p = [Epg.css(obj, i), p];//[当前CSS,目标CSS]
			else
				Epg.css(obj, i, p[0]);//p[0]代表起始状态，立即将元素变为起始状态，防止一闪而过的现象
			params[i] = {start: parseFloat(p[0]), end: parseFloat(p[1])};
			if(params[i].start !== params[i].end)
				canContinue = true;
		}
		if(!canContinue) return;//如果params中所有参数起始结束状态都一样，动画就没必要执行下去了
		tag += '_' + (++this.tagIdx);//最终的tag名字
		this.animates[tag] = {obj:obj, params:params, speed:speed, easing:easing, callback:callback, startTime:Date.now(), idx:0, timer:undefined};
		this.animates[tag].timer = setInterval(function()
		{
			var animate = Epg.fx.animates[tag];
			animate.idx++;//动画已经执行的次数，这个参数暂时没用
			var n = Date.now()-animate.startTime;//从开始当现在已经过去的时间
			if( n > animate.speed )
			{
				Epg.fx.stop(tag);//结束动画
				return;
			}
			var percent = n/animate.speed;//根据时间差计算百分比
			var pos = Epg.fx.easing[animate.easing](percent, n, 0, 1, animate.speed);
			for( var i in animate.params )
			{
				var p = animate.params[i];
				Epg.css(animate.obj, i, p.start + (p.end - p.start) * pos);
			}
		}, this.interval);
	},
	/**
	 * 停止某个正在运行的动画
	 * @param tag 保存在Epg.fx.animates中的标签名
	 * @return 是否成功，不过这个貌似不重要
	 */
	stop: function(tag)
	{
		var animate = Epg.fx.animates[tag];
		if(!animate)
			return false;
		clearInterval(animate.timer);//结束正在运行的动画
		var ps = animate.params;
		for(var i in ps)//让对象直接变成动画结束时的状态
			Epg.css(animate.obj, i, ps[i].end);
		Epg.call(animate.callback);//执行回调函数
		delete Epg.fx.animates[tag];//注意直接“delete animate”无效
		return true;
	},
	/**
	 * 模仿jQuery的easing函数，动画效果方法，返回值是当前时刻运动的百分比<br>
	 * 按照常规思路，动画的实现方式是这样的：<br>
	 * 通过setInterval每隔一定时间给某个值增加特定数值，直到这个值达到限制值。这样做的主要问题是，<br>
	 * 不同浏览器的运行速度不同，从而导致动画速度有差异，一般是IE下比较慢，Firefox下比较快。<br>
	 * 而jQuery.animate是以当前时间来决定位移值，某个时刻的位移值总是固定的，因而动画速度不会有差异。<br>
	 * 参考自：http://heeroluo.net/Article/Detail/67
	 */
	easing:
	{
		/**
		 * 匀速线性变化，其实这里有效参数只有一个，那就是p
		 * @param p 运动的时间，其实这里传的值是运动的百分比，即percent
		 * @param n 运动的次数，貌似真正含义是从运动开始到此刻的时间差
		 * @param firstNum 起始值，这里一般默认0
		 * @param diff 速度，这里默认1
		 * @returns
		 */
		linear: function( p, n, firstNum, diff )
		{
			return firstNum + diff * p;//等同于：return p;
		},
		swing: function( p, n, firstNum, diff )
		{
			return 0.5 - Math.cos( p * Math.PI ) / 2;
		}
	}
};

/**
 * Epg.fx.start的快捷调用，add by lxa 20140923
 */
Epg.animate = function(obj, params, speed, easing, callback, tag)
{
	Epg.fx.start(obj, params, speed, easing, callback, tag);
};

/**
 * 判断对象是否具有某个class，仅保证高清盒子支持，标清盒子请勿使用！add by lxa 20150414
 */
Epg.hasClass = function(obj, cls)
{
	return obj.className.match(new RegExp('(\\s|^)' + cls + '(\\s|$)'));  
};

/**
 * 给dom对象添加class，仅保证高清盒子支持，标清盒子请勿使用！add by lxa 20150414
 */
Epg.addClass = function(obj, cls)
{
	if (!this.hasClass(obj, cls)) obj.className += " " + cls;  
};

/**
 * 给对象删除class，仅保证高清盒子支持，标清盒子请勿使用！add by lxa 20150414
 */
Epg.removeClass = function(obj, cls)
{
	if (this.hasClass(obj, cls)) obj.className = obj.className.replace(new RegExp('(\\s|^)' + cls + '(\\s|$)'), ' ');
};

/**
 * 播放按键声音，目前仅安卓支持，add by lxa 20150506
 * @param sound 按键声音名字，不知道传什么可以传default，所有可选的声音请参看对应的安卓项目
 */
Epg.playKeySound = function(sound)
{
	if(is_ott && sound)
	{
		//可以在这里设置默认的按键声音
		sound = (sound==='default') ? 'defaultClick' : sound;
		//sound = (sound==='defaultClick') ? 'type.wav' : sound;//默认click
		//sound = (sound==='defaultMove') ? 'biu.wav' : sound;//默认move
		sound = (sound==='defaultClick') ? 'ysj_click.wav' : sound;//默认click
		//sound = (sound==='defaultMove') ? 'ysj_move.wav' : sound;//默认move
		sound = (sound==='defaultMove') ? 'abcdefg.wav' : sound;//默认move

		try{android.playKeySound(sound);}catch(e){}
	}
};


/**
 * 触发按键事件，兼容IE、谷歌、火狐等常见浏览器，尚未在所有标清盒子测试，故仅限高清盒子调用，add by lxa 20150515
 * @param obj 事件对象，一般传document
 * @param eventType 事件类型，支持 keydown和keypress
 * @param keyCode 要触发的按键值，数字类型
 */
Epg.fireKeyEvent = function(obj, eventType, keyCode)
{
	//针对最近发现的部分盒子不支持Epg.fireKeyEvent()方法，现在改为主动调用Epg.eventHandler，update by lxa 20150609
	if(keyCode === 'EVENT_MEDIA_END' || keyCode === 'EVENT_MEDIA_ERROR')
	{
		if(typeof menuWindow === 'undefined' && Epg.eventHandler)
			Epg.eventHandler(keyCode);
		else if(menuWindow && menuWindow.Epg.eventHandler)
			menuWindow.Epg.eventHandler(keyCode);
		return;
	}
	var event;
	if(document.createEvent)//如果是Chrome、Opera、Safari、Firefox
	{
		if(window.KeyEvent)//如果是Firefox
		{
			event = document.createEvent('KeyEvents');
			event.initKeyEvent(eventType, true, true, window, false, false, false, false, keyCode, 0);
		}
		else//如果是Chrome、Opera、Safari
		{
			event = document.createEvent('UIEvents');
			event.initUIEvent(eventType, true, true, window, 1);
			delete event.keyCode;
			if(typeof event.keyCode === "undefined")//如果是Chrome、Opera
				Object.defineProperty(event, "keyCode", {value:keyCode});
			else//如果是Safari
				event.key = String.fromCharCode(keyCode);
		}
		obj.dispatchEvent(event);
	}
	else if(document.createEventObject)//如果是IE
	{
		event = document.createEventObject();
		event.keyCode = keyCode;
		obj.fireEvent('on'+eventType, event);
	}
};