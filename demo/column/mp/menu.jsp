<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/com/com_head.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/tags/epg" prefix="epg" %>
<%@ taglib tagdir="/WEB-INF/tags/epg" prefix="e" %>
<%
	setAttr
	(
		request,
		"is_series", getParam(request, "is_series", "false"),//是否是电视剧
		"menu_btn_txt",new String[]{"上一集","快退","暂停","快进","下一集"},//菜单按钮文字
		"playEndURI", HttpUtils.getPlayEndURI(request, response)//播放结束地址
	);
%>
	<title>视频播放页面</title>
<c:if test="${isSD}">	
	<%
	setAttr
	(
		request,
		"progress_width", 496,//进度条宽度
		"progress_left",30,//进度条left
		"progress_top",92,//进度条top
		"progress_height",2,//进度条高度
		"menu_point_width",6,//进度条点的宽度
		"menu_point_height",8,//进度条点的高度
		"btn_left_start",203,//底部按钮起始left
		"btn_left_add",43,//底部按钮递增距离
		"btn_top",26,//底部按钮top
		"btn_left_adjust",5,
		"btn_top_adjust",4
	);
	%>
	<style type="text/css">
		/*调试样式*/
		#console {
		.position(0, 0);
			color: red;
		//color: white;
		//background: green;
			z-index: 10;
			font-size: 20px;
		}

		/*底部菜单*/
		div#menu{left:0px;top:405px;background: transparent;}
		/*时间信息*/
		div#time_info{left:540px;top:82px;width:90px;color:white;font-size:14px;background: transparent;}
	</style>
</c:if>
<!-- 如果是高清版 -->
<c:if test="${!isSD}">
	<%
	setAttr
	(
		request,
		"progress_width", 989,//进度条宽度
		"progress_left",125,//进度条left
		"progress_top",128,//进度条top
		"progress_height",2,//进度条高度
		"menu_point_width",12,//进度条点的宽度
		"menu_point_height",12,//进度条点的高度
		"btn_left_start",447,//底部按钮起始left
		"btn_left_add",72,//底部按钮递增距离
		"btn_top",36,//底部按钮top
		"btn_left_adjust",10,
		"btn_top_adjust",5
	);
	%>
	<style type="text/css">
	/*底部菜单*/
	div#menu{left:0px;top:550px;}
	/*时间信息*/
	div#time_info{left:1140px;top:117px;width:120px;color:#f0f0f0;font-size:20px;}
	</style>
</c:if>	
	<script type="text/javascript">

		var progress_width = parseInt('${progress_width}'),//进度条宽度
			menu_point_width = parseInt('${menu_point_width}'),//进度条点的宽度
			progress_left =  parseInt('${progress_left}');//进度条left
	
		var p = Epg.getParent();//父页面
		var menu_timer = undefined;//setTimeout返回的东西
		var menu_is_show = true;//标记底部菜单是否显示
		var before_hide_btn_id = 'btn_3';//在菜单隐藏之前的按钮ID
		
		var buttons=
		[
			<c:forEach begin="1" end="5" var="i">
			{id:'btn_${i}',name:'底部菜单按钮_${i}',eager:true,action: btnAction,beforeMove:'hideMenuAuto()',focusImage:'menu_${i}_f.png',left:'btn_${i-1}',right:'btn_${i+1}'},
			</c:forEach>
			{id:'menu_default',name:'菜单隐藏时的默认按钮',action:'showAndHideMenuAuto()',focusImage:'${touming}',beforeMove:'showAndHideMenuAuto()'}
		];

		
		//底部菜单按钮的动作
		function btnAction(current)
		{
			switch(current.id)
			{
				case 'btn_1':pageUp();break;//上一集
				case 'btn_2':fastRewind();break;//快退
				case 'btn_3':playOrPause();break;//暂停或播放
				case 'btn_4':fastForward();break;//快进
				case 'btn_5':pageDown();break;//下一集
			}
		}
		
		//上一集
		function pageUp(vodMode)
		{
			if('${is_series}'==='true'&&p.idx<=1)
			{
				Epg.tip('已经是第一集了！');
				return;
			}
			window.vodMode = vodMode||'active';//机顶盒上setTimeout内部所有变量必须是全局的
			p.location.href='${basePath}media_player.jsp?method=playPrev&mp='+p.mpid+'&vodMode='+window.vodMode;
		}
		
		//下一集，force表示强制下一集
		function pageDown(vodMode, force)
		{
			if(!force&&'${is_series}'==='true'&&p.idx>=p.total)
			{
				Epg.tip('已经是最后一集了！');
				return;
			}
			window.vodMode = vodMode||'active';//机顶盒上setTimeout内部所有变量必须是全局的
			p.location.href='${basePath}media_player.jsp?method=play&mp='+p.mpid+'&vodMode='+window.vodMode;
		}
		
		//真正的退出播放页面
		function exit()
		{
			Epg.Log.updateLastVodLog();//更新最后一次点播记录 
			p.location.href='${playEndURI}';
		}
		
		//快退
		function fastRewind()
		{
			p.epg.mp.fastRewind(function(state)
			{
				if(state === 'play')//快退到32或者先快进然后直接快退就会出现这种情况，update by lxa 20140812
				{
					changePlayBtnState('play');
					showAndHideMenuAuto('btn_3');
				}
				else if(state === 'fastRewind')
				{
					changePlayBtnState('pause');
					showAndHideMenuAuto('btn_2');
				}
			});
		}
		
		//快进
		function fastForward()
		{
			p.epg.mp.fastForward(function(state)
			{
				if(state === 'play')//快进到32或者先快退然后直接快进就会出现这种情况，update by lxa 20140812
				{
					changePlayBtnState('play');
					showAndHideMenuAuto('btn_3');
				}
				else
				{
					changePlayBtnState('pause');
					showAndHideMenuAuto('btn_4');
				}
			});
		}
		
		//播放或暂停
		function playOrPause()
		{
			p.epg.mp.playOrPause(function(state)
			{
				changePlayBtnState(state);
				showAndHideMenuAuto('btn_3');//主动把菜单显示出来，同时刷新焦点图
			});
		}
		
		//显示底部菜单，默认光标在上次隐藏之前的按钮，如果传了id，就显示id按钮
		function showMenu(id)
		{
			S('menu');
			menu_is_show = true;
			if(id!==undefined)
				before_hide_btn_id = id;
			if(before_hide_btn_id==='menu_default')//防止出现没有光标
				before_hide_btn_id = 'btn_3';//没有光标时光标默认在中间的“播放”按钮上面
			if(before_hide_btn_id)
				epg.btn.set(before_hide_btn_id);//设置上次隐藏之前的按钮
		}
		
		//隐藏底部菜单
		function hideMenu()
		{
			H('menu');
			menu_is_show = false;
			before_hide_btn_id = epg.btn.current.id;
			epg.btn.set('menu_default');
		}
		
		//定时自动隐藏菜单
		function hideMenuAuto()
		{
			if(menu_timer)
				clearTimeout(menu_timer);
			menu_timer = setTimeout(function()
			{
				if(p.epg.mp.speed==1)//注意快进、快退时菜单不隐藏
					hideMenu();
			},5000);//5秒钟后自动隐藏
		}
		
		//显示并且自动隐藏底部菜单
		function showAndHideMenuAuto(id)
		{
			showMenu(id);
			hideMenuAuto();
			return false;//这里是配合menu_default按钮的beforeMove方法
		}
		
		//更改播放按钮的状态
		function changePlayBtnState(state)
		{
			if(state === 'play')//如果当前状态是播放
			{
				var btn=epg.btn.get('btn_3');//中间的播放按钮
				btn.linkImage='${imagePath}menu_3.png';
				btn.focusImage='${imagePath}menu_3_f.png';
			}
			else if(state === 'pause')
			{
				var btn=epg.btn.get('btn_3');//中间的播放按钮
				btn.linkImage='${imagePath}menu_3_1.png';
				btn.focusImage='${imagePath}menu_3_1_f.png';
			}
			G('btn_3').src = epg.btn.get('btn_3').linkImage;//更改播放按钮的默认图片
		}
		
		//启动进度条
		function startProgress()
		{
			setTimeout(function()
			{
				if(!p.mp)//照顾电脑上不报错
					return;
				window.mp_progress_timer = setInterval(function()
				{
					var time_info = p.epg.mp.getPlayTimeInfo();
					G('time_info').innerHTML = time_info;//刷新底部时间
					var rate = p.epg.mp.getRate();//当前播放的比例，取值0-1
					var progress_length = rate*progress_width;//进度条的长度
					G('menu_point').style.left = (progress_length+progress_left-menu_point_width/2)+'px';
				},1000);//每1秒钟进度条刷新一次
			},500);//一进入页面时视频可能还没初始化完毕
		}
		
		//按返回按键的事件
		function back()
		{

			if(menu_is_show)//菜单是显示的
				hideMenu();
			else{
				exit();
			}
		}

		//视频播放结束后，显示结束菜单
		function afterVideoPlayEnd()
		{
			clearInterval(window.mp_progress_timer);//停止与进度条相关的东西
			hideMenu();
			pageDown('passive', true);//true表示强制下一集
		}
		
		//设置按键映射
		epg.key.set(
		{
			KEY_PAGE_UP:'pageUp()',
			KEY_PAGE_DOWN:'pageDown()',
			KEY_PLAY_PAUSE:'playOrPause()',
			KEY_FAST_FORWARD:'fastForward()',
			KEY_FAST_REWIND:'fastRewind()',
			KEY_VOL_UP:'p.Epg.Mp.volUp()',
			KEY_VOL_DOWN:'p.Epg.Mp.volDown()',
			KEY_MUTE:'p.Epg.Mp.toggleMuteFlag()',
			KEY_TRACK:'p.Epg.Mp.switchAudioChannel()',
			EVENT_MEDIA_END:'afterVideoPlayEnd()',
			EVENT_MEDIA_ERROR:'Epg.tip("视频播放错误!")'
		});
		
		window.onload=function()
		{
			console.log(<%=FREE_VOD_DURATION%>);
			p.menuWindow = this;//这句话不可少！
			epg.btn.init(['${param.f}','btn_3'],buttons,'${imagePath}',true);
			hideMenuAuto();//自动隐藏菜单
			startProgress();//开始进度条
		};
		
	</script>
</head>

<body>
	<div id="console"></div>
	<!-- 菜单隐藏时默认的按钮 -->
	<div>
		<img id="menu_default" src="${touming}"/>
	</div>
	
	<!-- 底部菜单 -->
	<div id="menu">
		<!-- 菜单背景，中兴标清上半透明会变成完全不透明，华为正常-->
		<div style="left:0px;top:0px;">
			<img src="${imagePath}menu_bg.png"/>
		</div>
		
		<!-- 时间信息 -->
		<div id="time_info">00:00/00:00</div>
		
		<!-- 进度条 -->
		<div style="left:${progress_left}px;top:${progress_top}px;">
			<img id="menu_progress" src="${imagePath}menu_progress.png" />
		</div>
		
		<!-- 进度条上面的点 -->
		<div id="menu_point" style="left:${progress_left-menu_point_width/2+0}px;top:${progress_top-(menu_point_height-progress_height)/2}px">
			<img src="${imagePath}menu_point.png"/>
		</div>
		
		<!-- 遍历循环底部菜单按钮 -->
		<c:forEach begin="1" end="5" var="i">
			<div style="left:${btn_left_start+(i-1)*btn_left_add+(i>3?btn_left_adjust:0)}px;top:${i==3?(btn_top-btn_top_adjust):btn_top}px;">
				<img id="btn_${i}" src="${imagePath}menu_${i}.png"/>
			</div>
		</c:forEach>
		
	</div>
	<%@ include file="/com/com_bottom.jsp" %>
</body>
</html>