<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 默认的提示，如果需要单独对某个页面的css进行设置，可以使用“defaultTipStyle”，如健身团“首页” -->
<div id="default_tip" class="default_tip" style="background-image:url('${comImagePath}tip_bg.png');${defaultTipStyle}"></div>

<!-- 遥控器提示文字 -->
<div id="ykq_tip" class="ykq_tip" style="background-image:url('${comImagePath}spacer.gif')"></div>

<!-- 默认A标签 -->
<a id="default_link" href="#"><img src="${touming}"/></a>

<script type="text/javascript">

	/**************************通用JS代码开始******************************/
	(function()
	{
		G('default_link').focus();//聚焦默认的A标签
		if('${param.p}' !== '' && '${param.excludeP}' !== 'true')//翻页时不记录访问日志 不是所有的翻页都不记录访问日志 比如在更多栏目中里面的栏目就是分页的 
			return;
		
		//记录访问日志
		Epg.Log.access
		(
			'${param.source}',//来源页面
			'${target}',//target和targetType必须有值才记录访问日志，所以不必担心页面重复记录
			'${targetType}',//当前页面类型
			'${elementCode}',//当前页面的元素编码，只有少数页面需要记录这个，如二级栏目页面的关键字搜索
			'${param.addAccessLog}',//只有这个参数为'false'时才不记录日志，其它情况均记录，也就是说默认是记录日志的
			'${param.pageProp}',//当前页面属性编码
			'${param.pagePropSrc}',//来源页面属性编码
			'${param.sourceType}',//来源页面类型，这个几乎都用不到
			'${param.elementCodeSrc}'||'${elementCodeSrc}'//来源页面元素编码，这个也几乎都用不到
		);
	})();
	
	/**
	 * 通用的多层级跳转方法，使用本方法前必须充分了解本方法的含义，否则切勿调用！
	 * 只有对于那种大的层级跳转才需要调用本方法，普通的翻页、普通的跳转不需要调用本方法
	 * 要求至少有的3个参数：￥{currentURI},￥{basePath},￥{target}
	 * @param url 要跳转的URL地址，必须从WebContent下一级目录开始，如：column/order/order.jsp
	 * @param source 要跳转的页面的关键字，主要是用在backURI当中，如：health_order
	 * @param isAddAccessLogWhenBack 返回时是否需要记录添加访问日志，默认记录
	 */
	Epg.go = function(href, source, isAddAccessLogWhenBack)
	{
		var addAccessLog = isAddAccessLogWhenBack === false ? '&addAccessLog=false' : '';//只有这个参数为false时才添加addAccessLog参数
		var backURI = escape('${currentURI}&p=${pb.current}&f='+Epg.btn.current.id+'&dir=fallback&source=' + source + addAccessLog);
		href += (href.indexOf('?')>0?'&':'?');
		location.href = '${basePath}' + href + 'source=${target}&backURI='+backURI;
	};

	/**
	 * 通用的播放电视剧方法，使用前需保证每个参数都正确！   
	 * @param seriesCode 电视剧code，不传默认读取当前按钮的code
	 * @param idx 开始播放的集数，不传时默认上次播放集数
	 * @param elementCodeSrc 来源页面元素编码，格式为4位数字，将出现在pagePropSrc参数的3-6位
	 */
	function playSeries(seriesCode, idx , elementCodeSrc)
	{
		seriesCode = seriesCode || Epg.btn.current.code;
		idx = idx || '';//集数不传时默认上次播放集数
		elementCodeSrc = elementCodeSrc || '';
		var returnURI = escape('${currentURI}&p=${pb.current}&source=mp&f='+Epg.btn.current.id);
		location.href = '${basePath}media_player.jsp?method=playFromSeries&seriesCode='+seriesCode+'&idx='+idx+'&source=${target}&sourceType=${targetType}&metadataType=series&elementCodeSrc='+elementCodeSrc+'&searchLogId=${param.searchLogId}&returnURI='+returnURI;
	}
	
	/**
	 * 通用的播放节目单或者小视频全屏播放方法，使用前需保证每个参数都正确！
	 * @param programId 节目单ID
	 * @param code 开始播放视频code，不传则默认从第一个视频开始播放
	 * @param elementCodeSrc 来源页面元素编码，格式为4位数字，将出现在pagePropSrc参数的3-6位
	 */
	function playProgram(programId, code, elementCodeSrc)
	{
		code = code || '';
		elementCodeSrc = elementCodeSrc || '';
		var returnURI = escape('${currentURI}&p=${pb.current}&source=mp&f='+Epg.btn.current.id);
		location.href = '${basePath}media_player.jsp?method=playFromProgram&programId='+programId+'&mp='+programId+'&code='+code+'&mode=listCycleOnce&source=${target}&sourceType=${targetType}&metadataType=program&elementCodeSrc='+elementCodeSrc+'&returnURI='+returnURI;
	}
	
	/**
	 * 通用的播放单个视频方法，使用前需保证每个参数都正确！
	 * @param code 视频code
	 * @param elementCodeSrc 来源页面元素编码，格式为4位数字，将出现在pagePropSrc参数的3-6位
	 */
	function playVideo(code, elementCodeSrc)
	{
		elementCodeSrc = elementCodeSrc || '';
		var returnURI = escape('${currentURI}&p=${pb.current}&source=mp&f='+Epg.btn.current.id);
		location.href = '${basePath}media_player.jsp?method=addVideo&andPlay=true&code='+code+'&mode=listCycleOnce&source=${target}&sourceType=${targetType}&metadataType=video&elementCodeSrc='+elementCodeSrc+'&returnURI='+returnURI;
	}
</script>