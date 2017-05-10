<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.lutongnet.iptv.util.*"%>
<%@ page import="com.lutongnet.iptv.util.HttpUtils"%>
<%@ page import="com.lutongnet.iptv.api.util.PaginationBean"%>
<%@ page import="com.lutongnet.iptv.store.*" %>
<%@ page import="com.lutongnet.iptv.constant.*" %>
<%@ page import="com.lutongnet.iptv.api.executor.*"%>
<%@ page import="com.lutongnet.iptv.api.message.entity.*"%>
<%@ page import="com.lutongnet.iptv.api.message.req.*"%>
<%@ page import="com.lutongnet.iptv.api.message.rsp.*"%>
<%@ page import="com.lutongnet.iptv.api.message.rsp.*"%>
<%@ page import="org.joda.time.DateTime" %>
<%@ page import="org.apache.commons.io.IOUtils"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="org.codehaus.jackson.type.TypeReference"%>
<%@ page import="org.slf4j.LoggerFactory"%>
<%@ page import="org.slf4j.Logger"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.regex.Pattern"%>
<%@ page import="java.util.regex.Matcher"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="/tags/path" prefix="w" %>
<%@ taglib uri="/tags/epg" prefix="epg" %>
<%@ taglib tagdir="/WEB-INF/tags/epg" prefix="e" %>
<%@ taglib uri="/tags/demo" prefix="demo" %>
<%!

	/** API地址 */
	public final static String API_URL = "http://192.168.57.201:8091/province-api/";

	/** EPG地址 */
	public final static String BASE_PATH = "http://172.16.4.4:8080/demo/";

	/**
	 *	是否是开发模式，这个参数很重要，决定了是否开启鉴权、是否开启console.log、是否启用按5刷新、是否支持Chrome浏览器等等，
	 *	上线后【必须】改为【false】 ！！！
	 */
	public final static boolean DEBUG_MODE = true;

	/** 是否是OTT版 */
	public final static boolean IS_OTT = true;

	/** 是否启用动画效果，标清版不建议打开 */
	public final static boolean ANIMATE = false;

	/** 运营商 */
	public final static String CARRIER = "ct";

	/** 产品版本 */
	public final static String APP_VERSION = "A";

	/** 运行平台 */
	public final static String PLATFORM = "hw-20";

	/** 视频格式 */
	public final static String FORMAT = "ts-"+APP_VERSION;
	//public final static String FORMAT = "ts-sd";

	/** 日志输出对象，页码有打印日志的需要时都可以使用这个 */
	public final Logger log = LoggerFactory.getLogger(getClass());

	/** 用于项目内的固定图片访问 */
	public final static String BASE_IMAGE_PATH = BASE_PATH + "resources/" + APP_VERSION + "/";

	/** 通用图片统一路径 */
	public final static String COM_IMAGE_PATH = BASE_IMAGE_PATH + "com/";

	/** 透明图片地址 */
	public final static String SPACER = COM_IMAGE_PATH + "spacer.gif";

	/** 没有前缀的透明图片地址，直接从basePath后面开始，很多时候需要用到这个 */
	public final static String SPACER_NO_BASE_PATH = "resources/"+APP_VERSION+"/com/spacer.gif";

	/** 头像  */
	public final static String COOKIE_HEAD_IMAGE = "head_image";

	/** 用户属性  */
	public final static String COOKIE_USER_PROP = "user_prop";

	/** 退出EPG地址  */
	public final static String COOKIE_BACK_EPG_URL = "back_epg_url";

	/** 累计播放时长，播放页面超过30分钟会提示信息  */
	public final static String COOKIE_PLAY_TIME = "play_time";

	/** 每一种精灵形象的个数  */
	public final static int GENIUS_COUNT = 6;

	/** 无法正确匹配用户城市时的默认城市，一般是省会城市 */
	private final static String DEFAULT_CITY_NAME = "深圳";

	/** DEFAULT_CITY_NAME相对应的city code */
	private final static String DEFAULT_CITY_CODE = "440300";

	/** 所有省份城市信息，第一个是区号，第二个是身份证前6位，第三位是城市名  */
	private final static String[][] CITYS = new String[][]
	{
		{"020","440100","广州"},
		{"0751","440200","韶关"},
		{"0755","440300","深圳"},
		{"0756","440400","珠海"},
		{"0754","440500","汕头"},
		{"0757","440600","佛山"},
		{"0750","440700","江门"},
		{"0759","440800","湛江"},
		{"0668","440900","茂名"},
		{"0758","441200","肇庆"},
		{"0752","441300","惠州"},
		{"0753","441400","梅州"},
		{"0660","441500","汕尾"},
		{"0762","441600","河源"},
		{"0662","441700","阳江"},
		{"0763","441800","清远"},
		{"0769","441900","东莞"},
		{"0760","442000","中山"},
		{"0768","445100","潮州"},
		{"0663","445200","揭阳"},
		{"0766","445300","云浮"}
	};

	/** 针对活动的唯一API接口地址，部署多套API后，该变量设置为同一个，保证抽奖接口原子操作 */
	public final static String ACTIVITY_API_URL = API_URL;

	/** 免费点播时长，单位：毫秒 */
	public final static int FREE_VOD_DURATION = 10000;

	/** 进入各专区、栏目后驻留时长后弹订购，单位：毫秒 */
	public final static int FREE_USE_DURATION = 5000;

	/**部分参数  */
	private final static String FREELY="free";//未包月
    private final static String MONTHLY="month";//包月
    private final static String COOKIE_ROLE="role";//角色名
	private final static String COOKIE_USER_ID="userid";//账户ID
	private final static String COOKIE_USER_TOKEN="user_token";//token
	private final static String COOKIE_ORDER_TYPE="order_type";//用户订购类型
	private final static String COOKIE_CITY_CODE="city_code";//城市代码，类似400100这样的格式
	private final static String COOKIE_CITY_NAME="city_name";//城市中文名，仅用于天气
	private final static String COOKIE_APP_VERSION="app_version";//版本
	private final static String COOKIE_PLATFORM="platform";//平台

%>
