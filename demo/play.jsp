<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/com/com_head.jsp" %>
<%!
	public int idx = 0;//临时代码，视频idx
%>
	<title>播放器</title>
    <style>
		#console {
		.position(0, 0);
			color: red;
		//color: white;
		//background: green;
			z-index: 10;
			font-size: 20px;
		}
	</style>
</head>
<body onunload="Epg.Mp.destroy();">
    <div id="console"></div>
	<c:if test="${not empty mp.menu}">

		<!-- 菜单iframe -->
		<div style="position:absolute; left:0; top:0; width:${isSD?640:1280}px; height:${isSD?530:720}px;">
			<iframe id="menuFrame" name="menuFrame" src="${mp.menu}?idx=${idx}&total=${total}&series=${not empty seriesCode}" bgcolor="transparent" allowtransparency="true" width="${isSD?640:1280}" height="${isSD?530:720}" frameborder="0" scrolling="0"></iframe>
		</div>


		<!-- 无刷新操作的iframe -->
		<div style="position:absolute;position:absolute; left:0; top:0; width:0px; height:0px;">
			<iframe id="ajaxFrame" name="ajaxFrame" bgcolor="transparent" allowtransparency="true" width="0" height="0" frameborder="0" scrolling="0"></iframe>
		</div>

	</c:if>

	<script type="text/javascript">

	// 后退函数
	function back(){
		if(typeof menuWindow !== 'undefined'){
			menuWindow.back();
		}
	}

	//无刷新操作均调用本方法
	function ajax(src)
	{
		G('ajaxFrame').src = src;
	}

	//重写tip方法
	Epg.tip = function(info,second)
	{
		if(typeof menuWindow !== 'undefined')
			menuWindow.Epg.tip(info,second);
	};

	//重写ykqTip方法
	Epg.ykqTip = function(info,second)
	{
		if(typeof menuWindow !== 'undefined')
			menuWindow.Epg.ykqTip(info,second);
	};

	epg.key.set(
	{
		KEY_VIDEO_BACK:'back()'
	}
	);

	Epg.getParent().videoWindow = this;//标示当前iframe为视频窗口

	<c:if test="${isOTT}">
		mp = Epg.getParent().mp;//如果是OTT版，将父页面的mp赋值给当前页面，因为mp对象只能注入到顶级页面
	</c:if>

	var mpid = '${param.mp}';//播放器实例名
	var rtsp = '${rtsp}';//播放地址

	//rtsp = 'http://202.99.114.93/88888891/16/20170331/269090667/269090667.ts';

	/******************临时代码开始*******************/
	var rtsps=
	[
		//'http://liuxianan.cn/kanzouyan.ts',
		//'http://liuxianan.cn/xwlb.mp4',
		//'http://172.16.4.97/media/1.mp4',
		//'http://origin-kalaok-cdn-backup.lutongnet.com/ott_ggly/ts/dzg/878504006082.ts',
		//'http://origin-kalaok-cdn-backup.lutongnet.com/ott_ggly/ts/xjbhr/878504002475.ts'
		//'http://origin-kalaok-cdn-backup.lutongnet.com/ott_baseline_kalaok/ts/145804009161.ts',
		//'http://origin-kalaok-cdn-backup.lutongnet.com/ott_baseline_kalaok/ts/145804015994.ts',
		//'http://origin-kalaok-cdn-backup.lutongnet.com/ott_baseline_kalaok/ts/145803007446.ts',
		//'http://origin-kalaok-cdn-backup.lutongnet.com/ott_baseline_kalaok/ts/145804011866.ts',
		//'http://origin-kalaok-cdn-backup.lutongnet.com/ott_baseline_kalaok/ts/145802001356.ts',
		//'http://origin-kalaok-cdn-backup.lutongnet.com/ott_baseline_kalaok/ts/145801002548.ts',
		//'http://origin-kalaok-cdn-backup.lutongnet.com/ott_baseline_kalaok/ts/145802001666.ts',

		'http://113.108.110.61/media/juejiang.mp4',
		'http://113.108.110.61/media/145801014371.ts',
		'http://113.108.110.61/media/shijianzhuyu.ts',
		'http://113.108.110.61/media/kanzouyan.ts',
		'http://113.108.110.61/media/chengfa.mp4',
		'http://113.108.110.61/media/gongxigongxi.mp4',
		'http://113.108.110.61/media/henian.mp4',
		'http://113.108.110.61/media/1.mp4',
		'http://origin-kalaok-cdn-backup.lutongnet.com/ott_ggly/ts/dzg/878504006082.ts',
		'http://origin-kalaok-cdn-backup.lutongnet.com/ott_ggly/ts/xjbhr/878504002475.ts'
	];
	//rtsp = rtsps[<%=(++idx)%>%rtsps.length];
	/******************临时代码结束*******************/

	var MP = ${MP};//所有与视频相关的对象都在这里
	MP.current.seriesCode='${seriesCode}';//专辑code，没有的就让它没有

	var idx = parseInt('${idx}');//当前集数
	var total = parseInt('${total}');//总集数
	var series = '${seriesCode}'!=='';//是否是电视剧

	//如果不能点播，并且是全屏播放（小视频播放不需要弹订购提示），update by lxa 20140912
	if('${canVod}' === 'false' && MP.display === 'fullscreen')
	{
		setTimeout(function()
		{
			//注意，这里必须手工加上dir=fallback的参数，否则返回到视频列表页面会出现无法返回的问题，update by lxa 20140912
			Epg.Log.updateLastVodLog();
			var backURI = escape('<%=HttpUtils.getPlayEndURI(request, response)%>&dir=fallback');
			Epg.getParent().location.href = '${basePath}column/order/order.jsp?code=${mp.current.code}&source=${mp.current.source}'
					+'&sourceType=${mp.current.sourceType}&pagePropSrc=${mp.current.pagePropSrc}&addAccessLog=true&backURI='+backURI;
			Epg.Mp.destroy();
		}, <%=FREE_VOD_DURATION%>);
	}

	//视频播放结束后，显示结束菜单
	function playbackOnCompletion(){
		if(typeof menuWindow !== 'undefined'){
			menuWindow.playbackOnCompletion();
		}
	}

	setTimeout(function() {
		//window.is_ott=false;
		Epg.Mp.init(true);//true表示启用默认的遥控器提示功能
		if (MP.display === 'fullscreen')//如果是全屏
		{
			Epg.Mp.fullscreenPlay(rtsp);
		} else if(MP.display==='smallvod')//如果是小视频
		{
			//这个地方需注意，由于后台MediaPlayer的坐标都是string类型，所以转json后也是，
			//所以这里必须parseInt，否则在中兴上会出现小视频位置偏离的现象，update by lxa 20140610
			Epg.Mp.smallvodPlay(rtsp, parseInt(MP.left), parseInt(MP.top), parseInt(MP.width), parseInt(MP.height));
		}
	}, 500);

	/** 当作为小视频被嵌入到其它页面加载完成后，调用父页面定义的函数 */
	var videoWindowOnload = Epg.getParent().videoWindowOnload;
	if(typeof videoWindowOnload==="function")
		videoWindowOnload();

	//播放页面一般不记录访问日志，--- 用来记录推荐位访问情况
	<c:if test="${param.addAccessLog}">Epg.Log.access('${mp.current.source}', 'ggly_play_exit_recommend', 'column','${param.addAccessLog}',0,'${mp.current.pagePropSrc}');</c:if>
	</script>

</body>
</html>