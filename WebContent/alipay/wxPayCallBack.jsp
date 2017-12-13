<%@page import="com.alipay.api.internal.util.AlipaySignature"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@page import="com.infbox.pay.PayUtil"%>
<%@ page import="java.util.Map"%>

<%@ page import="com.alipay.api.*"%>
<%
		String out_trade_no = request.getParameter("out_trade_no");
		//交易号
		String trade_no ="";//

		//交易状态
		String trade_status = new String(request.getParameter("trade_status").getBytes("ISO-8859-1"),"UTF-8");
		System.out.println("wxPayCallBack.jsp get trade_no:"+trade_no);
		
		boolean verify_result = false;
		if(verify_result){//验证成功
			//////////////////////////////////////////////////////////////////////////////////////////
			//请在这里加上商户的业务逻辑程序代码
			String total_fee ="";// new String(request.getParameter("total_fee").getBytes("ISO-8859-1"),"UTF-8");
			String seller_id = "";//new String(request.getParameter("seller_id").getBytes("ISO-8859-1"),"UTF-8");	
			
			PayUtil.notify(out_trade_no,total_fee,trade_no,seller_id); 
			
			//——请根据您的业务逻辑来编写程序（以上代码仅作参考）——
			out.clear();
			out.println("success");	//请不要修改或删除

			//////////////////////////////////////////////////////////////////////////////////////////
		}else{//验证失败
			out.println("fail");
		}
%>
