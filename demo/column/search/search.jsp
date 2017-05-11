<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/com/com_head.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/tags/epg" prefix="epg" %>
<%@ taglib tagdir="/WEB-INF/tags/epg" prefix="e" %>
<title>搜索</title>
<%!
	public static final String COLUMN_CODE = "search";//首页栏目code
	public static final String CURRENT_URI = BASE_PATH + "column/search/search.jsp?1=1";//当前页面访问地址
%>	
<%
	imagePath = BASE_IMAGE_PATH + "column/search/";//修正栏目图片路径
	String comImagePath = BASE_IMAGE_PATH + "/com/";//修正公共图片路径
	String testImagePaht = BASE_PATH+"column/search/images/";
	UserStore store = new UserStore(request, response);
	String userid = store.getUserid();
	
	String returnURI = HttpUtils.markURI(request, response, "returnURI", "f", "info", "backURI", "dir", "source", "addAccessLog");
	// 从本页跳转到其它栏目后，再返回本页的地址
	String backURI = HttpUtils.markURIList(request, API_URL, userid, "backURI");
	
	request.setAttribute("backURI", backURI);
	
	setAttr
	(
		request,
		"imagePath", imagePath,//图片路径
		"testImagePaht",testImagePaht,
		"comImagePath", comImagePath,
		"currentURI", CURRENT_URI,//当前页面路径
		"target", COLUMN_CODE//记录日志用到的target
	);
	
	//根据栏目code取得首页Epg对象
	List<EpgMetadataGroup> groupList = getEpg(COLUMN_CODE).getGroups();
	setAttr
	(
		request,
		"recommendList", groupList.get(0).getMetadatas(), //取出推荐位
		"searchRankList",groupList.get(1).getMetadatas() //取出搜索排行
	);
%>
<style type="text/css">
body{
	margin:0;
	padding:0;
	color:#f0f0f0;
	background: transparent url('${comImagePath}bg_search.jpg') no-repeat;
}

.recommend_0_img{position:absolute;left:273px;top:88px;width:150px;height:85px;}
.recommend_1_img{position:absolute;left:273px;top:183px;width:150px;height:85px;}
.recommend_2_img{position:absolute;left:273px;top:278px;width:150px;height:85px;}
.recommend_3_img{position:absolute;left:273px;top:373px;width:150px;height:85px;}

.recommend_0_div{position:absolute;left:262px;top:78px;width:172px;height:102px;}
.recommend_1_div{position:absolute;left:262px;top:173px;width:172px;height:102px;}
.recommend_2_div{position:absolute;left:262px;top:268px;width:172px;height:102px;}
.recommend_3_div{position:absolute;left:262px;top:363px;width:172px;height:102px;}


.searchRank_0_div{position:absolute;left:447px;top:89px;width:173px;height:37px;background-image: url(${imagePath}bg_paihang_nor.png);}
.searchRank_1_div{position:absolute;left:447px;top:127px;width:173px;height:37px;background-image: url(${imagePath}bg_paihang_nor.png);}
.searchRank_2_div{position:absolute;left:447px;top:165px;width:173px;height:37px;background-image: url(${imagePath}bg_paihang_nor.png);}
.searchRank_3_div{position:absolute;left:447px;top:203px;width:173px;height:37px;background-image: url(${imagePath}bg_paihang_nor.png);}
.searchRank_4_div{position:absolute;left:447px;top:241px;width:173px;height:37px;background-image: url(${imagePath}bg_paihang_nor.png);}
.searchRank_5_div{position:absolute;left:447px;top:279px;width:173px;height:37px;background-image: url(${imagePath}bg_paihang_nor.png);}
.searchRank_6_div{position:absolute;left:447px;top:317px;width:173px;height:37px;background-image: url(${imagePath}bg_paihang_nor.png);}

</style>
<script src="${basePath}resources/js/jquery-v2.1.1.js"></script>
<script type="text/javascript">	

var buttons=[
<c:forEach items="${recommendList}" var="p" varStatus="vs">
{id:'recommend_${vs.index}',name:'推荐位1',action:goRecommand,code:'${p.value}',type:'${p.type}',left:['delete'], right:['searchRank_0'], up:'recommend_${vs.index-1}', down:'recommend_${vs.index+1}',linkImage:'${touming}', focusImage:'${imagePath}button.png'},
</c:forEach>
<c:forEach items="${searchRankList}" var="p" varStatus="vs">
{id:'searchRank_${vs.index}',name:'搜索排行',action:goRecommand,left:['recommend_0'], right:[''], up:'searchRank_${vs.index-1}', down:'searchRank_${vs.index+1}',linkImage:'${touming}', focusImage:'${imagePath}bg_paihang_sel.png'},
</c:forEach>
{id:'deleteAll',name:'清空',action:press,left:[''], right:['space'], up:'', down:'t9_key_01',linkImage:'${imagePath}btn_qingk_nor.png', focusImage:'${imagePath}btn_qingk_sel.png',beforeMove:goKeyBoard},
{id:'space',name:'空格',action:press,left:['deleteAll'], right:['delete'], up:'', down:'t9_key_02',linkImage:'${imagePath}btn_kongge_nor.png', focusImage:'${imagePath}btn_kongge_sel.png',beforeMove:goKeyBoard},
{id:'delete',name:'退格',action:press,left:['space'], right:['recommend_0'], up:'', down:'t9_key_03',linkImage:'${imagePath}btn_tuige_nor.png', focusImage:'${imagePath}btn_tuige_sel.png',beforeMove:goKeyBoard},

//t9键盘
{id:'t9_key_01',name:'t9_01',action:press,left:[''], right:['t9_key_02'], up:'deleteAll', down:'t9_key_04',linkImage:'${imagePath}t9/btn_no01_nor.png', focusImage:'${imagePath}t9/btn_no01_sel.png',beforeMove:selectKey},
{id:'t9_key_02',name:'t9_02',action:press,left:['t9_key_01'], right:['t9_key_03'], up:'space', down:'t9_key_05',linkImage:'${imagePath}t9/btn_no02_nor.png', focusImage:'${imagePath}t9/btn_no02_sel.png',beforeMove:selectKey},
{id:'t9_key_03',name:'t9_02',action:press,left:['t9_key_02'], right:['recommend_0'], up:'delete', down:'t9_key_06',linkImage:'${imagePath}t9/btn_no03_nor.png', focusImage:'${imagePath}t9/btn_no03_sel.png',beforeMove:selectKey},

{id:'t9_key_04',name:'t9_04',action:press,left:[''], right:['t9_key_05'], up:'t9_key_01', down:'t9_key_07',linkImage:'${imagePath}t9/btn_no04_nor.png', focusImage:'${imagePath}t9/btn_no04_sel.png',beforeMove:selectKey},
{id:'t9_key_05',name:'t9_05',action:press,left:['t9_key_04'], right:['t9_key_06'], up:'t9_key_02', down:'t9_key_08',linkImage:'${imagePath}t9/btn_no05_nor.png', focusImage:'${imagePath}t9/btn_no05_sel.png',beforeMove:selectKey},
{id:'t9_key_06',name:'t9_06',action:press,left:['t9_key_05'], right:['recommend_0'], up:'t9_key_03', down:'t9_key_09',linkImage:'${imagePath}t9/btn_no06_nor.png', focusImage:'${imagePath}t9/btn_no06_sel.png',beforeMove:selectKey},

{id:'t9_key_07',name:'t9_07',action:press,left:[''], right:['t9_key_08'], up:'t9_key_04', down:'allkeybutton',linkImage:'${imagePath}t9/btn_no07_nor.png', focusImage:'${imagePath}t9/btn_no07_sel.png',beforeMove:selectKey},
{id:'t9_key_08',name:'t9_08',action:press,left:['t9_key_07'], right:['t9_key_09'], up:'t9_key_05', down:'allkeybutton',linkImage:'${imagePath}t9/btn_no08_nor.png', focusImage:'${imagePath}t9/btn_no08_sel.png',beforeMove:selectKey},
{id:'t9_key_09',name:'t9_09',action:press,left:['t9_key_08'], right:['recommend_0'], up:'t9_key_06', down:'allkeybutton',linkImage:'${imagePath}t9/btn_no09_nor.png', focusImage:'${imagePath}t9/btn_no09_sel.png',beforeMove:selectKey},

//全键盘
{id:'all_key_a',name:'A',action:"input('A')",left:[''],          right:['all_key_b'], up:'deleteAll', down:'all_key_g',linkImage:'${imagePath}allkey/btn_A_nor.png', focusImage:'${imagePath}allkey/btn_A_sel.png'},
{id:'all_key_b',name:'B',action:"input('B')",left:['all_key_a'], right:['all_key_c'], up:'deleteAll', down:'all_key_h',linkImage:'${imagePath}allkey/btn_B_nor.png', focusImage:'${imagePath}allkey/btn_B_sel.png'},
{id:'all_key_c',name:'C',action:"input('C')",left:['all_key_b'], right:['all_key_d'], up:'space', down:'all_key_i',linkImage:'${imagePath}allkey/btn_C_nor.png', focusImage:'${imagePath}allkey/btn_C_sel.png'},
{id:'all_key_d',name:'D',action:"input('D')",left:['all_key_c'], right:['all_key_e'], up:'space', down:'all_key_j',linkImage:'${imagePath}allkey/btn_D_nor.png', focusImage:'${imagePath}allkey/btn_D_sel.png'},
{id:'all_key_e',name:'E',action:"input('E')",left:['all_key_d'], right:['all_key_f'], up:'delete', down:'all_key_k',linkImage:'${imagePath}allkey/btn_E_nor.png', focusImage:'${imagePath}allkey/btn_E_sel.png'},
{id:'all_key_f',name:'F',action:"input('F')",left:['all_key_e'], right:['recommend_0'], up:'delete', down:'all_key_l',linkImage:'${imagePath}allkey/btn_F_nor.png', focusImage:'${imagePath}allkey/btn_F_sel.png'},

{id:'all_key_g',name:'G',action:"input('G')",left:[''], 		   right:['all_key_h'], up:'all_key_a', down:'all_key_m',linkImage:'${imagePath}allkey/btn_G_nor.png', focusImage:'${imagePath}allkey/btn_G_sel.png'},
{id:'all_key_h',name:'H',action:"input('H')",left:['all_key_g'], right:['all_key_i'], up:'all_key_b', down:'all_key_n',linkImage:'${imagePath}allkey/btn_H_nor.png', focusImage:'${imagePath}allkey/btn_H_sel.png'},
{id:'all_key_i',name:'I',action:"input('I')",left:['all_key_h'], right:['all_key_j'], up:'all_key_c', down:'all_key_o',linkImage:'${imagePath}allkey/btn_I_nor.png', focusImage:'${imagePath}allkey/btn_I_sel.png'},
{id:'all_key_j',name:'J',action:"input('J')",left:['all_key_i'], right:['all_key_k'], up:'all_key_d', down:'all_key_p',linkImage:'${imagePath}allkey/btn_J_nor.png', focusImage:'${imagePath}allkey/btn_J_sel.png'},
{id:'all_key_k',name:'K',action:"input('K')",left:['all_key_j'], right:['all_key_l'], up:'all_key_e', down:'all_key_q',linkImage:'${imagePath}allkey/btn_K_nor.png', focusImage:'${imagePath}allkey/btn_K_sel.png'},
{id:'all_key_l',name:'L',action:"input('L')",left:['all_key_k'], right:['recommend_0'],          up:'all_key_f', down:'all_key_r',linkImage:'${imagePath}allkey/btn_L_nor.png', focusImage:'${imagePath}allkey/btn_L_sel.png'},

{id:'all_key_m',name:'M',action:"input('M')",left:[''],          right:['all_key_n'], up:'all_key_g', down:'all_key_s',linkImage:'${imagePath}allkey/btn_M_nor.png', focusImage:'${imagePath}allkey/btn_M_sel.png'},
{id:'all_key_n',name:'N',action:"input('N')",left:['all_key_m'], right:['all_key_o'], up:'all_key_h', down:'all_key_t',linkImage:'${imagePath}allkey/btn_N_nor.png', focusImage:'${imagePath}allkey/btn_N_sel.png'},
{id:'all_key_o',name:'O',action:"input('O')",left:['all_key_n'], right:['all_key_p'], up:'all_key_i', down:'all_key_u',linkImage:'${imagePath}allkey/btn_O_nor.png', focusImage:'${imagePath}allkey/btn_O_sel.png'},
{id:'all_key_p',name:'P',action:"input('P')",left:['all_key_o'], right:['all_key_q'], up:'all_key_j', down:'all_key_v',linkImage:'${imagePath}allkey/btn_P_nor.png', focusImage:'${imagePath}allkey/btn_P_sel.png'},
{id:'all_key_q',name:'Q',action:"input('Q')",left:['all_key_p'], right:['all_key_r'], up:'all_key_k', down:'all_key_w',linkImage:'${imagePath}allkey/btn_Q_nor.png', focusImage:'${imagePath}allkey/btn_Q_sel.png'},
{id:'all_key_r',name:'R',action:"input('R')",left:['all_key_q'], right:['recommend_0'],          up:'all_key_l', down:'all_key_x',linkImage:'${imagePath}allkey/btn_R_nor.png', focusImage:'${imagePath}allkey/btn_R_sel.png'},

{id:'all_key_s',name:'S',action:"input('S')",left:[''],          right:['all_key_t'], up:'all_key_m', down:'all_key_y',linkImage:'${imagePath}allkey/btn_S_nor.png', focusImage:'${imagePath}allkey/btn_S_sel.png'},
{id:'all_key_t',name:'T',action:"input('T')",left:['all_key_s'], right:['all_key_u'], up:'all_key_n', down:'all_key_z',linkImage:'${imagePath}allkey/btn_T_nor.png', focusImage:'${imagePath}allkey/btn_T_sel.png'},
{id:'all_key_u',name:'U',action:"input('U')",left:['all_key_t'], right:['all_key_v'], up:'all_key_o', down:'all_key_1',linkImage:'${imagePath}allkey/btn_U_nor.png', focusImage:'${imagePath}allkey/btn_U_sel.png'},
{id:'all_key_v',name:'V',action:"input('V')",left:['all_key_u'], right:['all_key_w'], up:'all_key_p', down:'all_key_2',linkImage:'${imagePath}allkey/btn_V_nor.png', focusImage:'${imagePath}allkey/btn_V_sel.png'},
{id:'all_key_w',name:'W',action:"input('W')",left:['all_key_v'], right:['all_key_x'], up:'all_key_q', down:'all_key_3',linkImage:'${imagePath}allkey/btn_W_nor.png', focusImage:'${imagePath}allkey/btn_W_sel.png'},
{id:'all_key_x',name:'X',action:"input('X')",left:['all_key_w'], right:['recommend_0'], up:'all_key_r', down:'all_key_4',linkImage:'${imagePath}allkey/btn_X_nor.png', focusImage:'${imagePath}allkey/btn_X_sel.png'},

{id:'all_key_y',name:'Y',action:"input('Y')",left:[''],          right:['all_key_z'], up:'all_key_s', down:'all_key_5',linkImage:'${imagePath}allkey/btn_Y_nor.png', focusImage:'${imagePath}allkey/btn_Y_sel.png'},
{id:'all_key_z',name:'Z',action:"input('Z')",left:['all_key_y'], right:['all_key_1'], up:'all_key_t', down:'all_key_6',linkImage:'${imagePath}allkey/btn_Z_nor.png', focusImage:'${imagePath}allkey/btn_Z_sel.png'},
{id:'all_key_1',name:'1',action:"input('1')",left:['all_key_z'], right:['all_key_2'], up:'all_key_u', down:'all_key_7',linkImage:'${imagePath}allkey/btn_1_nor.png', focusImage:'${imagePath}allkey/btn_1_sel.png'},
{id:'all_key_2',name:'2',action:"input('2')",left:['all_key_1'], right:['all_key_3'], up:'all_key_v', down:'all_key_8',linkImage:'${imagePath}allkey/btn_2_nor.png', focusImage:'${imagePath}allkey/btn_2_sel.png'},
{id:'all_key_3',name:'3',action:"input('3')",left:['all_key_2'], right:['all_key_4'], up:'all_key_w', down:'all_key_9',linkImage:'${imagePath}allkey/btn_3_nor.png', focusImage:'${imagePath}allkey/btn_3_sel.png'},
{id:'all_key_4',name:'4',action:"input('4')",left:['all_key_3'], right:['recommend_0'], up:'all_key_x', down:'all_key_0',linkImage:'${imagePath}allkey/btn_4_nor.png', focusImage:'${imagePath}allkey/btn_4_sel.png'},

{id:'all_key_5',name:'5',action:"input('5')",left:[''], right:['all_key_6'], 			up:'all_key_y', down:'t9button',linkImage:'${imagePath}allkey/btn_5_nor.png', focusImage:'${imagePath}allkey/btn_5_sel.png'},
{id:'all_key_6',name:'6',action:"input('6')",left:['all_key_5'], right:['all_key_7'], up:'all_key_z', down:'t9button',linkImage:'${imagePath}allkey/btn_6_nor.png', focusImage:'${imagePath}allkey/btn_6_sel.png'},
{id:'all_key_7',name:'7',action:"input('7')",left:['all_key_6'], right:['all_key_8'], up:'all_key_1', down:'t9button',linkImage:'${imagePath}allkey/btn_7_nor.png', focusImage:'${imagePath}allkey/btn_7_sel.png'},
{id:'all_key_8',name:'8',action:"input('8')",left:['all_key_7'], right:['all_key_9'], up:'all_key_2', down:'t9button',linkImage:'${imagePath}allkey/btn_8_nor.png', focusImage:'${imagePath}allkey/btn_8_sel.png'},
{id:'all_key_9',name:'9',action:"input('9')",left:['all_key_8'], right:['all_key_0'], up:'all_key_3', down:'t9button',linkImage:'${imagePath}allkey/btn_9_nor.png', focusImage:'${imagePath}allkey/btn_9_sel.png'},
{id:'all_key_0',name:'0',action:"input('0')",left:['all_key_9'], right:['recommend_0'], up:'all_key_4', down:'t9button',linkImage:'${imagePath}allkey/btn_0_nor.png', focusImage:'${imagePath}allkey/btn_0_sel.png'},


{id:'t9button',name:'t9',action:showT9,left:[''], right:['allkeybutton'], up:'', down:'',linkImage:'${imagePath}btn_kb_nor.png', focusImage:'${imagePath}btn_kb_sel.png',beforeMove:goKeyBoard},
{id:'allkeybutton',name:'allkey',action:showAllKey,left:['t9button'], right:['recommend_3'], up:'', down:'',linkImage:'${imagePath}btn_kb_nor.png', focusImage:'${imagePath}btn_kb_sel.png',beforeMove:goKeyBoard}

];

//显示T9 关闭allkey
function showT9(){
	G("t9").style.display = "block";
	G("allkey").style.display = "none";
	G("t9buttondiv").style.color = "#67a4ff";
	G("allkeybuttondiv").style.color = "#f0f0f0";
}
//显示allkey 半闭t9
function showAllKey(){
	G("t9").style.display = "none";
	G("allkey").style.display = "block";
	G("t9buttondiv").style.color = "#f0f0f0";
	G("allkeybuttondiv").style.color = "#67a4ff";
}

function goKeyBoard(dir,button){
	if(button.id=="deleteAll"){
		if(dir == 'down'){
			if(G("t9").style.display != 'none'){
				//如果 t9是打开的状态
				button.down = "t9_key_01";
			}else{
				//如果全健盘是打开的状态
				button.down = "all_key_a";
			}
			
		}
	}
	if(button.id=="space"){
		if(dir == 'down'){
			if(G("t9").style.display != 'none'){
				//如果 t9是打开的状态
				button.down = "t9_key_02";
			}else{
				//如果全健盘是打开的状态
				button.down = "all_key_c";
			}
			
		}
	}
	if(button.id=="delete"){
		if(dir == 'down'){
			if(G("t9").style.display != 'none'){
				//如果 t9是打开的状态
				button.down = "t9_key_03";
			}else{
				//如果全健盘是打开的状态
				button.down = "all_key_e";
			}
			
		}
	}
	if(button.id=="t9button"){
		if(dir == 'up'){
			if(G("t9").style.display != 'none'){
				//如果 t9是打开的状态
				button.up = "t9_key_07";
			}else{
				//如果全健盘是打开的状态
				button.up = "all_key_5";
			}
			
		}
	}
	if(button.id=="allkeybutton"){
		if(dir == 'up'){
			if(G("t9").style.display != 'none'){
				//如果 t9是打开的状态
				button.up = "t9_key_08";
			}else{
				//如果全健盘是打开的状态
				button.up = "all_key_8";
			}
			
		}
	}
}

function goRecommand(button){

	if(button.type == "recommend_video"){
		playVideo(button.code);
	}
	if(button.type == "video"){
		playVideo(button.code);
		//Epg.go("seriesDetail.jsp?code="+button.code,"search");
	}
}

function input(key){
	var inputDiv = G("keyword");
	if(key == 'DELETE'){
		if(inputDiv.innerHTML.indexOf("首字母搜索游戏") >= 0 ){
			inputDiv.innerHTML = "";
			doSearch("");
		}else{
			inputDiv.innerHTML = inputDiv.innerHTML.substring(0,inputDiv.innerHTML.length - 1);
			doSearch(inputDiv.innerHTML);
		}	
		return;
	}

	if(key == 'DELETEALL'){
		inputDiv.innerHTML = "首字母搜索游戏";
		doSearch("");
		return;
	}
	
	if(inputDiv.innerHTML.length >= 18)return;
	if(inputDiv.innerHTML.indexOf("首字母搜索游戏") >= 0 ){
		inputDiv.innerHTML = key;
	}else{
		inputDiv.innerHTML += key;
	}
	//ajax进行搜索
	doSearch(inputDiv.innerHTML);
}

//保存搜索结果前的页面状态信息
var recommendListHtml = "";
var button1 = "";
var button2 = "";
var button3 = "";
var button4 = "";

function doSearch(key){
	if(key != ''){
		var param = "&kw="+key;
		$.ajax({
			url:'${basePath}search.jsp?method=ajaxSearch'+param,
			type:'GET', 
			async:true,    
			data:param,
			dataType:'json',    	
			success:function(data){
				showRecommendAndSearchDiv(data.pb.dataList);
			},
			error:function(data){
				
			}
		})		
	}else{
		G("recommendAndSearchDiv").innerHTML = recommendListHtml;
		buttons[0] = button1;
		buttons[1] = button2;
		buttons[2] = button3;
		buttons[3] = button4;
	}
}



//根据条件显示猜你喜欢还是搜索结果
function showRecommendAndSearchDiv(data){
	var html = "";
	
	for(var i=0 ; i< data.length; i++){
		buttons[i].type = data[i].type ;
		buttons[i].code = data[i].code;
		html = html + 
			"<div class='recommend_"+i+"_img'>"+
			"<img  src='${basePath}"+ data[i].thumbHD +"' width='100%' height='100%' />"+
			"</div>"+
			"<div class='recommend_"+i+"_div'>"+
			"<img id='recommend_"+i+"' src='${touming}' width='100%' height='100%' />"+
			"<div style='background:url(${imagePath}bg_zhezhao.png);top:72px;left:11px;width:150px;height:23px;font-size:10px;' >"+data[i].name+"</div>"+
			"</div>";
	}
	
	G("recommendAndSearchDiv").innerHTML = html;
}

var selectFlag = false;
var selectKeys = [];
function press(button){
	
	
	if(button.id=="deleteAll"){
		var inputDiv = G("keyword");
		//inputDiv.innerHTML = "首字母搜索游戏";
		input("DELETEALL");
		return;
	}else if(button.id=="space"){
		input(" ");
		return;
	}else if(button.id == "delete"){
		var inputDiv = G("keyword");
		input("DELETE");
		/*
		if(inputDiv.innerHTML.indexOf("首字母搜索游戏") >= 0 ){
			inputDiv.innerHTML = "";
		}else{
			inputDiv.innerHTML = inputDiv.innerHTML.substring(0,inputDiv.innerHTML.length - 1);
		}
		*/
		return;
	}
	
	if(selectFlag){
		//说明打开了选择div
		if(button.id == 't9_key_01'){
			input("0");
		}
		if(button.id == 't9_key_02'){
			input("2");
		}
		if(button.id == 't9_key_03'){
			input("3");
		}
		if(button.id == 't9_key_04'){
			input("4");
		}
		if(button.id == 't9_key_05'){
			input("5");
		}
		if(button.id == 't9_key_06'){
			input("6");
		}
		if(button.id == 't9_key_07'){
			input("7");
		}
		if(button.id == 't9_key_08'){
			input("8");
		}
		if(button.id == 't9_key_09'){
			input("9");
		}
		//关闭弹出的div
		closeDiv();
		//恢复
		selectFlag = false;
		return;
	}
	
	//修改成全部在中间显示
	var objDiv = G("t9_key_05_div");
	//当前按扭的left坐标
	var left = objDiv.style.left;
	//当前按扭的top坐标
	var top = objDiv.style.top;
	//计算中间方块
	var midBlock = [];
	midBlock.push(parseInt(left));
	midBlock.push(parseInt(top));	
	//计算左边方块的坐标
	var leftBlock = [];
	var templeft = parseInt(left) - 67;
	var temptop = parseInt(top);
	leftBlock.push(templeft);
	leftBlock.push(temptop);
	//计算右边方块的坐标
	var rightBlock = [];
	templeft = parseInt(left) + 67;
	temptop = parseInt(top);
	rightBlock.push(templeft);
	rightBlock.push(temptop);
	//计算上边方块的坐标
	var upBlock = [];
	templeft = parseInt(left) ;
	temptop = parseInt(top) - 67;
	upBlock.push(templeft);
	upBlock.push(temptop);	
	//计算下边方块的坐标
	var downBlock = [];
	templeft = parseInt(left) ;
	temptop = parseInt(top) + 67;
	downBlock.push(templeft);
	downBlock.push(temptop);	
	
	if(button.id == 't9_key_01'){
		selectFlag = true;
		//恢复当前选中按扭成正常光标
		G(button.id).src = button.linkImage;
		//背景磨纱
		S("mosha");
		//G("ms").style.opacity = 1.0;
		//在当前按钮的右边显示 1 ,本身显示 0
		//首先在中间显示一个方块
		showBlock(midBlock,'btn_0_sel.png');
		showBlock(rightBlock,'btn_1_sel.png');
	}

	if(button.id == 't9_key_02'){
		selectFlag = true;
		//恢复当前选中按扭成正常光标
		G(button.id).src = button.linkImage;
		//背景磨纱
		S("mosha");
		//在当前按钮的右边显示 c 左边显示a 下边显示b ,本身显示 2
		showBlock(midBlock,'btn_2_sel.png');
		showBlock(rightBlock,'btn_C_nor.png');
		showBlock(leftBlock,'btn_A_nor.png');
		showBlock(downBlock,'btn_B_nor.png');
	}
	
	if(button.id == 't9_key_03'){
		selectFlag = true;
		//恢复当前选中按扭成正常光标
		G(button.id).src = button.linkImage;
		//背景磨纱
		S("mosha");
		//在当前按钮的左边显示 e   上边显示d 下边显示f ,本身显示 3
		showBlock(midBlock,'btn_3_sel.png');
		showBlock(leftBlock,'btn_E_nor.png');
		showBlock(upBlock,'btn_D_nor.png');
		showBlock(downBlock,'btn_F_nor.png');
	}
	
	if(button.id == 't9_key_04'){
		selectFlag = true;
		//恢复当前选中按扭成正常光标
		G(button.id).src = button.linkImage;
		//背景磨纱
		S("mosha");
		showBlock(midBlock,'btn_4_sel.png');
		showBlock(rightBlock,'btn_H_nor.png');
		showBlock(upBlock,'btn_G_nor.png');
		showBlock(downBlock,'btn_I_nor.png');
	}

	if(button.id == 't9_key_05'){
		selectFlag = true;
		//恢复当前选中按扭成正常光标
		G(button.id).src = button.linkImage;
		//背景磨纱
		S("mosha");
		showBlock(midBlock,'btn_5_sel.png');
		showBlock(leftBlock,'btn_J_nor.png');
		showBlock(downBlock,'btn_K_nor.png');
		showBlock(rightBlock,'btn_L_nor.png');
	}
	
	if(button.id == 't9_key_06'){
		selectFlag = true;
		//恢复当前选中按扭成正常光标
		G(button.id).src = button.linkImage;
		//背景磨纱
		S("mosha");
		showBlock(midBlock,'btn_6_sel.png');
		showBlock(upBlock,'btn_M_nor.png');
		showBlock(leftBlock,'btn_N_nor.png');
		showBlock(downBlock,'btn_O_nor.png');
	}
	
	if(button.id == 't9_key_07'){
		selectFlag = true;
		//恢复当前选中按扭成正常光标
		G(button.id).src = button.linkImage;
		//背景磨纱
		S("mosha");
		showBlock(midBlock,'btn_7_sel.png');
		showBlock(upBlock,'btn_P_nor.png');
		showBlock(rightBlock,'btn_Q_nor.png');
		showBlock(downBlock,'btn_R_nor.png');
		showBlock(leftBlock,'btn_S_nor.png');
	}
	
	if(button.id == 't9_key_08'){
		selectFlag = true;
		//恢复当前选中按扭成正常光标
		G(button.id).src = button.linkImage;
		//背景磨纱
		S("mosha");
		showBlock(midBlock,'btn_8_sel.png');
		showBlock(upBlock,'btn_U_nor.png');
		showBlock(rightBlock,'btn_V_nor.png');
		showBlock(leftBlock,'btn_T_nor.png');
	}
	
	if(button.id == 't9_key_09'){
		selectFlag = true;
		//恢复当前选中按扭成正常光标
		G(button.id).src = button.linkImage;
		//背景磨纱
		S("mosha");
		showBlock(midBlock,'btn_9_sel.png');
		showBlock(upBlock,'btn_W_nor.png');
		showBlock(rightBlock,'btn_X_nor.png');
		showBlock(leftBlock,'btn_Z_nor.png');
		showBlock(downBlock,'btn_Y_nor.png');
	}
}


function showBlock(position,img){
	var oDiv = document.createElement('div');
	oDiv.style.left = position[0]+"px";
	oDiv.style.top = position[1]+"px";
	oDiv.width = "107px";
	oDiv.height = "107px";
	var oImg = document.createElement('img');
	oImg.src = "${imagePath}t9/"+img;
	oDiv.appendChild(oImg);
	G("t9").appendChild(oDiv);	
	selectKeys.push(oDiv);
}

function selectKey(dir,button){
	if(selectFlag){
		//说明打开了选择div
		var sk = button.id;
		switch(sk){
			case "t9_key_01":
				switch(dir){
					case "right":
						input("1");
						//关闭弹出的div
						closeDiv();
						//恢复
						selectFlag = false;
						G(button.id).src = button.focusImage;
						//禁止光标移动
						return false;
					default:
						break;
				}
				break;
			case "t9_key_02":
				switch(dir){
					case "left":
						input("A");
						closeDiv();
						selectFlag = false;
						G(button.id).src = button.focusImage;
						return false;
					case "down":
						input("B");
						closeDiv();
						selectFlag = false;
						G(button.id).src = button.focusImage;
						return false;
					case "right":
						input("C");
						closeDiv();
						selectFlag = false;
						G(button.id).src = button.focusImage;
						return false;
					default:
						break;
				}
				break;
			case "t9_key_03":
				switch(dir){
					case "up":
						input("D");
						closeDiv();
						selectFlag = false;
						G(button.id).src = button.focusImage;
						return false;
					case "left":
						input("E");
						closeDiv();
						selectFlag = false;
						G(button.id).src = button.focusImage;
						return false;
					case "down":
						input("F");
						closeDiv();
						selectFlag = false;
						G(button.id).src = button.focusImage;
						return false;
					default:
						break;
				}
				break;
			case "t9_key_04":
				switch(dir){
					case "up":
						input("G");
						closeDiv();
						selectFlag = false;
						G(button.id).src = button.focusImage;
						return false;
					case "right":
						input("H");
						closeDiv();
						selectFlag = false;
						G(button.id).src = button.focusImage;
						return false;
					case "down":
						input("I");
						closeDiv();
						selectFlag = false;
						G(button.id).src = button.focusImage;
						return false;
					default:
						break;
				}
				break;
			case "t9_key_05":
				switch(dir){
					case "left":
						input("J");
						closeDiv();
						selectFlag = false;
						G(button.id).src = button.focusImage;
						return false;
					case "right":
						input("L");
						closeDiv();
						selectFlag = false;
						G(button.id).src = button.focusImage;
						return false;
					case "down":
						input("K");
						closeDiv();
						selectFlag = false;
						G(button.id).src = button.focusImage;
						return false;
					default:
						break;
				}
				break;
			case "t9_key_06":
				switch(dir){
					case "left":
						input("N");
						closeDiv();
						selectFlag = false;
						G(button.id).src = button.focusImage;
						return false;
					case "up":
						input("M");
						closeDiv();
						selectFlag = false;
						G(button.id).src = button.focusImage;
						return false;
					case "down":
						input("O");
						closeDiv();
						selectFlag = false;
						G(button.id).src = button.focusImage;
						return false;
					default:
						break;
				}
				break;
			case "t9_key_07":
				switch(dir){
					case "left":
						input("S");
						closeDiv();
						selectFlag = false;
						G(button.id).src = button.focusImage;
						return false;
					case "up":
						input("P");
						closeDiv();
						selectFlag = false;
						G(button.id).src = button.focusImage;
						return false;
					case "right":
						input("Q");
						closeDiv();
						selectFlag = false;
						G(button.id).src = button.focusImage;
						return false;
					case "down":
						input("R");
						closeDiv();
						selectFlag = false;
						G(button.id).src = button.focusImage;
						return false;
					default:
						break;
				}
				break;
			case "t9_key_08":
				switch(dir){
					case "left":
						input("T");
						closeDiv();
						selectFlag = false;
						G(button.id).src = button.focusImage;
						return false;
					case "up":
						input("U");
						closeDiv();
						selectFlag = false;
						G(button.id).src = button.focusImage;
						return false;
					case "right":
						input("V");
						closeDiv();
						selectFlag = false;
						G(button.id).src = button.focusImage;
						return false;
					default:
						break;
				}
				break;
			case "t9_key_09":
				switch(dir){
					case "left":
						input("Z");
						closeDiv();
						selectFlag = false;
						G(button.id).src = button.focusImage;
						return false;
					case "up":
						input("W");
						closeDiv();
						selectFlag = false;
						G(button.id).src = button.focusImage;
						return false;
					case "right":
						input("X");
						closeDiv();
						selectFlag = false;
						G(button.id).src = button.focusImage;
						return false;
					case "down":
						input("Y");
						closeDiv();
						selectFlag = false;
						G(button.id).src = button.focusImage;
						return false;
					default:
						break;
				}
				break;
		}
		
		
		
		
		
		if(dir == 'right'){
			//说明选择了1
			input("1");
			//关闭弹出的div
			closeDiv();
			//恢复
			selectFlag = false;
			G(button.id).src = button.focusImage;
			//禁止光标移动
			return false;
		}
		return false;
	}
}


//半闭弹出div
function closeDiv(){
	H("mosha");
	var length = selectKeys.length;
	for(var i=0;i<length;i++){
		G("t9").removeChild(selectKeys.pop());
	}
}

//返回
function back()
{
	//如果T9选择键打开，关闭
	if(selectFlag){
		//关闭弹出的div
		closeDiv();
		//恢复
		selectFlag = false;
		//恢复按扭图片
		var button = Epg.Button.current;
		G(button.id).src = button.focusImage;
	}else{
		location.href = "${backURI}";
	}
}

Epg.key.set(
{
	KEY_BACK:'back()',
});
	

window.onload=function()
{
	recommendListHtml = G("recommendAndSearchDiv").innerHTML;
	button1 = buttons[0];
	button2 = buttons[1];
	button3 = buttons[2];
	button4 = buttons[3];
	Epg.tip('${param.info}');//显示info信息，3秒自动隐藏，如果info为空将不会显示
	Epg.btn.init(['${param.f}','t9_key_05'],buttons,'${imagePath}',true);
};
	
</script>
<body>
<!-- 搜索小图标 -->
<div style="position:absolute;left:27px;top:101px;"><img src="${imagePath}ico_sousuo.png" /></div>
<!-- 搜索线 -->
<div style="position:absolute;left:24px;top:124px;"><img src="${imagePath}line_sousuo.png" width="194px" height="2px" /></div>
<div id="keyword" style="position:absolute;left:52px;top:101px;font-size:14px;line-height:18px;text-align:left;color:#788195;">首字母搜索游戏</div>
<!-- 猜你喜欢 -->
<div id="wordChange" style="position:absolute;left:273px;top:56px;text-align:left;color:rgba(240,240,240,0.4);font-size:14px;line-height:14px;">猜你喜欢</div>

<!-- 搜索排行 -->
<div style="position:absolute;left:447px;top:56px;text-align:left;color:rgba(240,240,240,0.4);font-size:14px;line-height:14px;">搜索排行</div>

<!-- 清空 -->
<div style="position:absolute;left:21px;top:136px;"><img id="deleteAll" src="${imagePath}btn_qingk_nor.png" /></div>

<!-- 空格 -->
<div style="position:absolute;left:89px;top:136px;"><img id="space" src="${imagePath}btn_kongge_nor.png" /></div>

<!-- 退格 -->
<div style="position:absolute;left:157px;top:136px;"><img id="delete" src="${imagePath}btn_tuige_nor.png" /></div>


<!-- 半透明遮罩 -->
<%--<div id="ms" style="position:absolute;left:60px;top:92px;width:350px;height:460px;background-color:#c7bbb9;opacity:0.00;"  ></div>--%>


<!-- T9 -->
<div id="t9" style="position:absolute;left:21px;top:182px;width:197px;height:197px;display:block;">
	<!-- 1 -->
	<div id="t9_key_01_div" style="left:0px;top:0px;"><img id="t9_key_01" src="${imagePath}t9/btn_no01_nor.png" /></div>

	<!-- 4 -->
	<div id="t9_key_04_div" style="left:0px;top:68px;"><img id="t9_key_04" src="${imagePath}t9/btn_no04_nor.png" /></div>

	<!-- 7 -->
	<div  id="t9_key_07_div" style="left:0px;top:136px;"><img id="t9_key_07" src="${imagePath}t9/btn_no07_nor.png" /></div>

	<!-- 2 -->
	<div id="t9_key_02_div" style="left:68px;top:0px;"><img id="t9_key_02" src="${imagePath}t9/btn_no02_nor.png" /></div>

	<!-- 5 -->
	<div id="t9_key_05_div"  style="left:68px;top:68px;"><img id="t9_key_05" src="${imagePath}t9/btn_no05_nor.png" /></div>

	<!-- 8 -->
	<div  id="t9_key_08_div" style="left:68px;top:136px;"><img id="t9_key_08" src="${imagePath}t9/btn_no08_nor.png" /></div>

	<!-- 3 -->
	<div id="t9_key_03_div" style="left:136px;top:0px;"><img id="t9_key_03" src="${imagePath}t9/btn_no03_nor.png" /></div>

	<!-- 6 -->
	<div id="t9_key_06_div" style="left:136px;top:68px;"><img id="t9_key_06" src="${imagePath}t9/btn_no06_nor.png" /></div>

	<!-- 9 -->
	<div id="t9_key_09_div" style="left:136px;top:136px;"><img id="t9_key_09" src="${imagePath}t9/btn_no09_nor.png" /></div>

</div>

<!-- allKEY -->
<div id="allkey" style="position:absolute;left:21px;top:182px;width:197px;height:197px;display:none;">

	<div style="left:0px;top:0px;"><img id="all_key_a" src="${imagePath}allkey/btn_A_nor.png" /></div>
	<div style="left:33px;top:0px;"><img id="all_key_b" src="${imagePath}allkey/btn_B_nor.png" /></div>
	<div style="left:66px;top:0px;"><img id="all_key_c" src="${imagePath}allkey/btn_C_nor.png" /></div>
	<div style="left:99px;top:0px;"><img id="all_key_d" src="${imagePath}allkey/btn_D_nor.png" /></div>
	<div style="left:132px;top:0px;"><img id="all_key_e" src="${imagePath}allkey/btn_E_nor.png" /></div>
	<div style="left:165px;top:0px;"><img id="all_key_f" src="${imagePath}allkey/btn_F_nor.png" /></div>

	<div style="left:0px;top:33px;"><img id="all_key_g" src="${imagePath}allkey/btn_G_nor.png" /></div>
	<div style="left:33px;top:33px;"><img id="all_key_h" src="${imagePath}allkey/btn_H_nor.png" /></div>
	<div style="left:66px;top:33px;"><img id="all_key_i" src="${imagePath}allkey/btn_I_nor.png" /></div>
	<div style="left:99px;top:33px;"><img id="all_key_j" src="${imagePath}allkey/btn_J_nor.png" /></div>
	<div style="left:132px;top:33px;"><img id="all_key_k" src="${imagePath}allkey/btn_K_nor.png" /></div>
	<div style="left:165px;top:33px;"><img id="all_key_l" src="${imagePath}allkey/btn_L_nor.png" /></div>


	<div style="left:0px;top:66px;"><img id="all_key_m" src="${imagePath}allkey/btn_M_nor.png" /></div>
	<div style="left:33px;top:66px;"><img id="all_key_n" src="${imagePath}allkey/btn_N_nor.png" /></div>
	<div style="left:66px;top:66px;"><img id="all_key_o" src="${imagePath}allkey/btn_O_nor.png" /></div>
	<div style="left:99px;top:66px;"><img id="all_key_p" src="${imagePath}allkey/btn_P_nor.png" /></div>
	<div style="left:132px;top:66px;"><img id="all_key_q" src="${imagePath}allkey/btn_Q_nor.png" /></div>
	<div style="left:165px;top:66px;"><img id="all_key_r" src="${imagePath}allkey/btn_R_nor.png" /></div>

	<div style="left:0px;top:99px;"><img id="all_key_s" src="${imagePath}allkey/btn_S_nor.png" /></div>
	<div style="left:33px;top:99px;"><img id="all_key_t" src="${imagePath}allkey/btn_T_nor.png" /></div>
	<div style="left:66px;top:99px;"><img id="all_key_u" src="${imagePath}allkey/btn_U_nor.png" /></div>
	<div style="left:99px;top:99px;"><img id="all_key_v" src="${imagePath}allkey/btn_V_nor.png" /></div>
	<div style="left:132px;top:99px;"><img id="all_key_w" src="${imagePath}allkey/btn_W_nor.png" /></div>
	<div style="left:165px;top:99px;"><img id="all_key_x" src="${imagePath}allkey/btn_X_nor.png" /></div>

	<div style="left:0px;top:132px;"><img id="all_key_y" src="${imagePath}allkey/btn_Y_nor.png" /></div>
	<div style="left:33px;top:132px;"><img id="all_key_z" src="${imagePath}allkey/btn_Z_nor.png" /></div>
	<div style="left:66px;top:132px;"><img id="all_key_1" src="${imagePath}allkey/btn_1_nor.png" /></div>
	<div style="left:99px;top:132px;"><img id="all_key_2" src="${imagePath}allkey/btn_2_nor.png" /></div>
	<div style="left:132px;top:132px;"><img id="all_key_3" src="${imagePath}allkey/btn_3_nor.png" /></div>
	<div style="left:165px;top:132px;"><img id="all_key_4" src="${imagePath}allkey/btn_4_nor.png" /></div>

	<div style="left:0px;top:165px;"><img id="all_key_5" src="${imagePath}allkey/btn_5_nor.png" /></div>
	<div style="left:33px;top:165px;"><img id="all_key_6" src="${imagePath}allkey/btn_6_nor.png" /></div>
	<div style="left:66px;top:165px;"><img id="all_key_7" src="${imagePath}allkey/btn_7_nor.png" /></div>
	<div style="left:99px;top:165px;"><img id="all_key_8" src="${imagePath}allkey/btn_8_nor.png" /></div>
	<div style="left:132px;top:165px;"><img id="all_key_9" src="${imagePath}allkey/btn_9_nor.png" /></div>
	<div style="left:165px;top:165px;"><img id="all_key_0" src="${imagePath}allkey/btn_0_nor.png" /></div>
</div>


<div id="mosha" style="position:absolute;left:20px;top:124px;visibility: hidden;z-index:-1;" ><img src="${imagePath}bg_sousuo_mohu.png" /></div>

<!-- T9 全健盘 占位 -->
<div  style="position:absolute;left:22px;top:397px;width:98px;height:38px;" ><img id="t9button" src="${touming}" width="98px" height="100%" /></div>
<div  style="position:absolute;left:120px;top:397px;width:98px;height:38px;" ><img id="allkeybutton" src="${touming}"  width="98" height="100%" /> </div>

<!-- T9 全健盘 -->
<div style="position:absolute;left:22px;top:397px;width:196px;height:38px;">
	<img src = "${imagePath}bg_jianpan_qiehuan_nor.png" />
	<div style="left:50%;top:13px;" ><img src="${imagePath}line.png" /></div>
	<div id="t9buttondiv" style="left:0;top:0;width:50%;height:100%;text-align:center;line-height:38px;font-size:12px;color:#67a4ff" >T9键盘</div>
	<div id="allkeybuttondiv" style="left:50%;top:0;width:50%;height:100%;text-align:center;line-height:38px;font-size:12px;color:#f0f0f0" >全键盘</div>
</div>


<div id="recommendAndSearchDiv" style="position:absolute;left:0px;top:0px;">
<c:forEach items="${recommendList}" var="p" varStatus="vs">
<div class="recommend_${vs.index}_img">
<img  src="${basePath}${p.linkImageUri}" width="100%" height="100%" />
</div>
<div class="recommend_${vs.index}_div">
<img id="recommend_${vs.index}" src="${touming}" width="100%" height="100%" />
</div>
</c:forEach>
</div>



<!-- 搜索排行 -->
<c:forEach items="${searchRankList}" var="p" varStatus="vs" begin="0" end="7">
<div class="searchRank_${vs.index}_div">
<img id="searchRank_${vs.index}" src="${touming}" width="100%" height="100%" />
<div style="position:absolute;top:0px;left:10px;color:#f0f0f0;font-size:14px;text-align:left;width:163px;height:100%;line-height:37px;">${vs.index+1}.${p.label}</div>
</div>
</c:forEach>
<%@include file="/com/com_bottom.jsp"%>
</body>