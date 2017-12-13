<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.infbox.pay.PayUtil,com.infbox.demo.article.*,java.util.HashMap,com.infbox.sdk.*"%>
<%@page import="com.infbox.demo.*,com.infbox.sdk.*" %>
<%@page import="com.alipay.api.AlipayClient"%>
<%@page import="com.alipay.api.DefaultAlipayClient"%>
<%@page import="com.alipay.api.AlipayApiException"%>
<%@page import="com.alipay.api.response.AlipayTradeWapPayResponse"%>
<%@page import="com.alipay.api.request.AlipayTradeWapPayRequest"%>
<%@page import="com.alipay.api.domain.AlipayTradeWapPayModel" %>
<%@page import="com.alipay.api.domain.AlipayTradeCreateModel"%>
<%
/* *
 * 功能：抓信微信支付接口，网页要发起微信支付的时候，先调用这个页面，
   生成一个业务订单号，然后，把这个订单号返回给网页
 * 版本：1.0
 * 修改日期：2017-9-14
 * 
 */
%>
<%
	request.setCharacterEncoding("UTF-8");	
	// 付款金额，必填
	String total_amount=new String(request.getParameter("amount").getBytes("ISO-8859-1"),"UTF-8");
	String payType="2";//微信支付
	String articleId=new String(request.getParameter("articleId").getBytes("ISO-8859-1"),"UTF-8");
	String uId=request.getParameter("userId");
	if(uId==null)uId="";
	MiscUtil.debug("user is:"+uId+",pay total_amount="+total_amount);
	long userid =0;
	if(uId.length()>0){
		userid =Long.parseLong(uId);
		
	}else {
		 out.print("{\"error\":\"-1\"}");
		return;		
	}
	float f_total_amount=0.01f;
	//保存订单
	
	int articleid=0;
	byte status = 1;
	byte pay_type = 2;
	try{
		if(payType!=null)pay_type=Byte.parseByte(payType);
		if(articleId!=null)articleid=Integer.parseInt(articleId);
		if(total_amount!=null)f_total_amount=Float.parseFloat(total_amount);
	}catch(Exception e){
		
	}
	Article art1=JHArticleUtil.getArticle(Integer.parseInt(articleId));

	//以下代码可以用于测试,将来去掉
	if(f_total_amount==100)f_total_amount=1;
	else f_total_amount=1;
	
	String out_trade_no =PayUtil.addLog(userid, articleid,"", status, pay_type, f_total_amount,art1.userid); 
	
	if(out_trade_no!=null){		
	    String subject ="文章打赏";//
		System.out.println(subject);		
		String url4="http://infbox.net/wxpay/create?title="+subject+"&siteid="+InfBoxUtil.siteId
				+"&money="+f_total_amount+"&out_trade_no="+out_trade_no+"&token="+InfBoxUtil.ac.token;
		String retv=HttpUtil.post(url4,null);
		if(retv.contains("ok"))		out.print("{\"trade_no\":\""+out_trade_no+"\"}");
		else{ 
			InfBoxUtil.log(url4+",can't create wx_pay ,maybe the access_token of site "+InfBoxUtil.siteId+" is wrong,"+retv);
			InfBoxUtil.ac=null;
			out.print("{\"error\":\"-3\"}");	 
		}
		
	}else  out.print("{\"error\":\"-1\"}");

%>