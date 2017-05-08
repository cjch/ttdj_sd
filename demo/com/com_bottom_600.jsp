<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 默认的提示，如果需要单独对某个页面的css进行设置，可以使用“defaultTipStyle”，如健身团“首页” -->
<div id="default_tip" class="default_tip" style="background-image:url('${comImagePath}tip_bg.png');${defaultTipStyle}"></div>

<!-- 遥控器提示文字 -->
<div id="ykq_tip" class="ykq_tip" style="background-image:url('${comImagePath}ykq_tip_bg.png')"></div>

<!-- 默认A标签 -->
<a id="default_link" href="#"><img src="${touming}"/></a>

<script type="text/javascript">

	/**************************通用JS代码开始******************************/
	(function()
	{
		G('default_link').focus();//聚焦默认的A标签
		if('${param.p}' !== '' && '${param.excludeP}' !== 'true')//翻页时不记录访问日志 不是所有的翻页都不记录访问日志 比如在更多栏目中里面的栏目就是分页的 
			return;
		
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

	
</script>