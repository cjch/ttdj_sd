<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/com/common.jsp" %>
<%!
	//文件说明：
	//鉴权、订购的文件，所有与鉴权、订购相关的代码都在这一个文件里面
	//分省部署是一般只需要修改这一个文件即可
	//这里是按广东电信的写法，如果别的省份有较大差别，请不要局限于这里的写法，只要保证返回指定格式的Entity对象即可
	/** 资费订购页面 */
	
	public void order(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String code = request.getParameter("code");
		String source = request.getParameter("source");
		String sourceType = request.getParameter("sourceType");
		String pagePropSrc = request.getParameter("pagePropSrc");
		
		String appurl = BASE_PATH + "com/auth.jsp?method=orderResult&code="+code+"&source="+source+"&sourceType="+sourceType+"&pagePropSrc="+pagePropSrc+"";
		String url = BASE_PATH + "column/order/direct_purchase2.jsp?return_url="+java.net.URLEncoder.encode(appurl, "utf-8");
		response.sendRedirect(url);
	}

	/** 订购结果 */
	private void orderResult(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String result = request.getParameter("resultCode");
		String newOrder = request.getParameter("newOrder");
		String description = request.getParameter("message");
		
        String user_id = getUserId(request,response);
        String orderBackUrl=(String) request.getSession().getAttribute("orderBackUrl");//上一个页面的返回地址
        if(isEmpty(orderBackUrl)){
        	orderBackUrl = BASE_PATH+"home.jsp?source=order&addAccessLog=true";
        }
        String source = getParam(request, "source", "health_home");
        String video_code = getParam(request, "code", "CP0634000001");
		String sourceType = getParam(request, "sourceType", "column");
		String pagePropSrc = getParam(request, "pagePropSrc", "0000000000000000");
		String userProp=HttpUtils.getString(request, "userProp", "");
		String pageProp=HttpUtils.getString(request, "pageProp", "");
        
		if("0".equals(result)) {//订购成功
        	request.getSession().setAttribute("order_type",MONTHLY);
            setCookie(request,response,COOKIE_ORDER_TYPE, MONTHLY);//修改cookie中的订购类型
         	// 保存用户相关信息到cookie中去
    		UserStore store = new UserStore(request, response);
    		store.setUserid(user_id);
    		store.setRole(getRoleName(request,response));
    		store.setOrderType(MONTHLY);
    		store.setCity(getCityCode(request,response));
    		store.setToken(getUserToken(request,response));
        
    		//保存订购记录
            AddOrderRequest req = new AddOrderRequest();
    		req.setUserid(getUserId(request,response));
    		req.setCity(getCityCode(request,response));
    		req.setRole(getRoleName(request,response));		
    		req.setAppVersion(APP_VERSION);
    		req.setCarrier(CARRIER);
    		req.setPlatform(PLATFORM);
    		req.setCode(video_code);
    		req.setSource(source);
    		req.setSourceType(sourceType);
    		req.setOrderType("month");
    		req.setPagePropSrc(pagePropSrc);
    		req.setUserProp(userProp);
    		req.setPageProp(pageProp);
    		
    		OrderExecutor executor = new OrderExecutor(API_URL);
    		req.setEntry(getCookie(request,"entry",""));
    		executor.addSuccessed(req);
    		
    		String orderTargetUrl = (String) request.getSession().getAttribute("orderTargetUrl");
    		if(isEmpty(orderTargetUrl)){
    			orderTargetUrl=orderBackUrl;
            }
            response.sendRedirect(orderTargetUrl);
		} else {//否则保存订购失败日志
            String reason = "month";//订购失败,  其他原因
            if(null==description||"".equals(description)||"         ".equals(description)||"null".equals(description)) {//订购返回
                description = "ERROR:1100-order_back";
                //back_url = "health_002520140728fkcxhd.jsp?method=home";
            }
            
            AddOrderRequest req = new AddOrderRequest();
    		req.setUserid(getUserId(request,response));
    		req.setCity(getCityCode(request,response));
    		req.setRole(getRoleName(request,response));		
    		req.setAppVersion(APP_VERSION);
    		req.setCarrier(CARRIER);
    		req.setPlatform(PLATFORM);
    		req.setCode(video_code);
    		req.setSource(source);
    		req.setSourceType(sourceType);
    		req.setOrderType(reason);
    		req.setPagePropSrc(pagePropSrc);
    		req.setUserProp(userProp);
    		req.setPageProp(pageProp);
    		req.setDescription(description);
    		
    		OrderExecutor executor = new OrderExecutor(API_URL);
    		executor.addFailed(req);
    		
    		MemoryStore memoryStore = new MemoryStore(API_URL);
			String json = memoryStore.get("dgwl_"+getUserId(request,response));
			if(json == null || "".equals(json)){
				memoryStore.set("dgwl_"+getUserId(request,response), "1",6, TimeUnit.HOUR);
				response.sendRedirect(BASE_PATH+"activity/20160811_wdsj_activity/index.jsp?source=dgwl");
				return;
			}
			
            response.sendRedirect(orderBackUrl);
        }
	}
	
%>
<%
	String method=request.getParameter("method");
	if("order".equals(method)){
		order(request, response);
	}else if("orderResult".equals(method)){
		orderResult(request, response);
	}
%>
