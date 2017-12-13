<%@page import="com.alipay.api.internal.util.AlipaySignature"%>
<%
/* *
 功能：支付宝页面跳转同步通知页面

 * */
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.infbox.pay.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.Map"%>

<%@ page import="com.alipay.api.*"%>
<%
request.setCharacterEncoding("UTF-8");
	String trade_no = request.getParameter("trade_no");
	String total_fee = request.getParameter("total_amount");
	String seller_id = request.getParameter("seller_id");
	String out_trade_no = request.getParameter("out_trade_no");
	System.out.println("callback.jsp get trade_no:"+trade_no+",out_trade_no="+out_trade_no+",amount="+total_fee);
	PayLog pl=PayUtil.getLogByOutTradeNo(out_trade_no);	
	System.out.println("pl="+pl.getId()+",userid="+pl.getUserid());
	if(pl!=null){//订单存在
		//////////////////////////////////////////////////////////////////////////////////////////
		//请在这里加上商户的业务逻辑程序代码	
		PayUtil.notify(out_trade_no, total_fee, trade_no, "");		
		out.clear();
		out.print("ok");
		//——请根据您的业务逻辑来编写程序（以上代码仅作参考）——

		//////////////////////////////////////////////////////////////////////////////////////////
	}else{
		//该页面可做页面美工编辑
		out.clear();
		out.println("error");
	}
%>