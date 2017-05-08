<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/com/common.jsp" %>
<%!

	/**
	 * 保存访问日志<br>
	 * 必须传的3个参数：source、target、targetType<br>
	 * 关于姚东海3个参数，可以直接传userProp、pageProp、pagePropSrc等来指定<br>
	 * 也可以通过elementCode、和elementCodeSrc来自动生成，这2个参数均为4位数字<br>
	 * 具体生成规则，请参看common.jsp中的getPageProp方法
	 */
	public void access(HttpServletRequest request)
	{
		String sourceType = getParam(request, "sourceType", "");//来源页面类型，一般不需要传值
		String targetType = getParam(request, "targetType", "");//当前页面类型
		String elementCode = getParam(request, "elementCode", "0000");//当前页面元素编码
		String elementCodeSrc = getParam(request, "elementCodeSrc", "0000");//来源页面元素编码
		
		String pagePropSrc = getPageProp(sourceType, elementCodeSrc);
		//如果长度为1，把它看成columnIdx，因为最开始就是这样写的，格式定义不规范，索引这样判断完全是无奈之举，update by lxa 20140930
		if(elementCodeSrc.length()==1)
			pagePropSrc = "0" + elementCodeSrc + "00000000000000";
		
		
		post
		(
			"access/add", AddAccessLogResponse.class,//接口地址
			"userid", store.getUserid(),//用户ID
			"role", store.getRole(),//角色名
			"orderType", store.getOrderType(),//订购类型：free、day、month、year
			"city", store.getCity(),//城市code
			"carrier", CARRIER,//运营商
			"appVersion", APP_VERSION,//版本
			"platform", PLATFORM,//平台
			"integralStrategy", "",//积分策略，没用的字段
			"cachable", getParamBoolean(request, "cachable", true),//是否使用缓存，默认使用
			"entry", getCookie(request, "entry", ""),//入口字段，后来增加的
			//以下6个字段都是【可能】需要传值的
			"source", getParam(request, "source", ""),//来源页面
			"target", getParam(request, "target", ""),//目标，即当前页面
			"targetType", targetType,//当前页面类型
			"userProp", getParam(request, "userProp", getUserProp(request)),//用户属性编码，仅健身团中需要，果果乐园可以忽略不管
			"pagePropSrc", getParam(request, "pagePropSrc", pagePropSrc),//来源页面属性编码
			"pageProp", getParam(request, "pageProp", getPageProp(targetType, elementCode))//当前页面属性编码
		);
	}
	
	/**
	 * 更新最后一次点播日志
	 */
	public void updateLastVodLog()
	{
		post("vod/update-last", UpdateLastVodLogResponse.class, "userid", store.getUserid());
	}
	
	/**
	 * 保存游戏日志
	 */
	public void saveGameLog(HttpServletRequest request)throws Exception
	{
		post
		(
			"game/add-log", AddGameLogResponse.class,
			"userid", store.getUserid(),
			"role", store.getRole(),
			"orderType", store.getOrderType(),
			"city", store.getCity(),
			"carrier", CARRIER,
			"appVersion", APP_VERSION,
			"platform", PLATFORM,
			"code", getParam(request, "code", ""),//游戏关键字
			"level", getParamInt(request, "level", 1),//游戏当前关数 默认第一关
			"isPassed", getParam(request, "isPassed", "N")//玩家是否通过游戏当前关 默认没有通过 
		);
	}
	
	private UserStore store;
%>
<%
    store = new UserStore(request, response);
	String method = request.getParameter("method");
	if("access".equals(method))
		access(request);
	else if("updateLastVodLog".equals(method))
		updateLastVodLog();
	else if("saveGameLog".equals(method))
		saveGameLog(request);
%>