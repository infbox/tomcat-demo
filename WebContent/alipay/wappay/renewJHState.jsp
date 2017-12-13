<%@ page language="java" import="java.util.*,org.json.JSONObject,com.infbox.pay.*,com.infbox.demo.*,com.infbox.sdk.*" pageEncoding="UTF-8"%>
<%
MiscUtil.debug("query pay state...");
String tradeNo=request.getParameter("tradeNo");
String url4="http://infbox.net/wxpay/state?siteid="+InfBoxUtil.siteId+"&tradeNo="+tradeNo;
String retv=HttpUtil.post(url4,null);
/*
 "state" : 0,
  "pay_time" : "2017-09-15T08:34:18Z"
*/
JSONObject obj=new JSONObject(retv);
if(obj==null || !obj.has("state")){out.print("error");return;}
if(obj.getInt("state")==6){
	//说明支付成功了
	PayLog payLog = PayUtil.getLogByOutTradeNo(tradeNo); 
	payLog.getToAcct();
	if(payLog.getStatus()<2){
		PayUtil.updateStatus(payLog.getId(), "","",(byte)2);
	}
}else{out.print("not_payed");return;}

%>
ok