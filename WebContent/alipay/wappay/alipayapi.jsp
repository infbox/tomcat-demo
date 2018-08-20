<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.infbox.pay.PayUtil,com.infbox.demo.article.*,java.util.HashMap"%>
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
 * 演示一个抓信服务号如何通过抓信的支付宝服务完成交易
 */
%>
<%
	request.setCharacterEncoding("UTF-8");	
/**访问抓信的支付宝服务器luck1.net*****/  
	String  InfBox_Alipay_Host="http://lyf.infbox.com/ibpay/";
	System.out.println("my site id:"+InfBoxUtil.siteId);
 	HashMap<String, Object> params=new HashMap<String, Object>();
 	if(PayUtil.tellMyCallBack==null)PayUtil.tellMyCallBack=false;	
		if(true){//PayUtil.tellMyCallBack==true
			//告诉抓信的支付宝网关，我的return_url是什么
			String url1=InfBoxUtil.SITE_URL+"/alipay/callBack.jsp";
			System.out.println(url1);
			BASE64Encoder myEnCoder=new BASE64Encoder();
	  		//必须制定编码，因为有很多平台的默认编码不是utf-8
			String base64Url =myEnCoder.encode(url1.getBytes("utf-8"));
			System.out.println("base64url="+base64Url);
			params.put("url",base64Url);
			params.put("siteid",InfBoxUtil.siteId);
			params.put("appid",InfBoxUtil.appId);
			params.put("appsecret",InfBoxUtil.getAppSecret() );
			String retv=HttpUtil.post(InfBox_Alipay_Host+"setCallBack.jsp",
					params);
			System.out.println("setCallBack return:"+retv.trim());
			if(retv.trim().equalsIgnoreCase("ok"))PayUtil.tellMyCallBack=true;				
		}
		
	// 付款金额，必填
	String total_amount=new String(request.getParameter("amount").getBytes("ISO-8859-1"),"UTF-8");
	String payType=new String(request.getParameter("payType").getBytes("ISO-8859-1"),"UTF-8");
	String articleId=new String(request.getParameter("articleId").getBytes("ISO-8859-1"),"UTF-8");
	String uId=request.getParameter("userId");
	if(uId==null)uId="";
	MiscUtil.debug("user is:"+uId+",pay total_amount="+total_amount);
	long userid =0;
	if(uId.length()>0){
		userid =Long.parseLong(uId);
		
	}else {
		out.print("need user id");
		return;		
	}
	//因为是测试，所以支付金额为1分钱，实际使用的时候，金额为传递过来的参数
	float f_total_amount=0.01f;
	//保存订单
	
	int articleid=0;
	byte status = 1;
	byte pay_type = 1;
	try{
		if(payType!=null)pay_type=Byte.parseByte(payType);
		if(articleId!=null)articleid=Integer.parseInt(articleId);
		if(total_amount!=null)f_total_amount=Float.parseFloat(total_amount);
	}catch(Exception e){
		
	}
	Article art1=JHArticleUtil.getArticle(Integer.parseInt(articleId));

	//以下代码可以用于测试,将来去掉
	if(f_total_amount==100)f_total_amount=0.01f;
	else if(f_total_amount==200)f_total_amount=0.02f;

	String out_trade_no = PayUtil.addLog(userid, articleid,"", status, pay_type, f_total_amount,art1.userid); 

	if(out_trade_no!=null){
		// 商户订单号，商户网站订单系统中唯一订单号，必填
	   // String out_trade_no = out_trade_no;
		// 订单名称，必填，会显示在支付宝的支付界面
	    String subject = java.net.URLEncoder.encode("文章打赏", "utf-8");	  
		System.out.println(subject);
	    // 付款金额，必填
	   // String total_amount=new String(request.getParameter("amount").getBytes("ISO-8859-1"),"UTF-8");
	    // 商品描述，可空
	    String body = "";
	    // 超时时间 可空
	   String timeout_express="2m";
	    // 销售产品码 必填
	    String product_code="QUICK_WAP_PAY";
	    
	    try {
	 	
	 	
			//调用支付宝抓信网关			
			response.setCharacterEncoding("UTF-8");			
			System.out.println("call url:"+InfBox_Alipay_Host+"wappay/alipayapi.jsp?siteid="+InfBoxUtil.siteId+"&out_trade_no="+
					out_trade_no+"&amount="+f_total_amount+"&title="+subject+"&userid="+userid+"&memo="+body);
			response.sendRedirect(InfBox_Alipay_Host+"wappay/alipayapi.jsp?siteid="+InfBoxUtil.siteId+"&out_trade_no="+
					out_trade_no+"&amount="+f_total_amount+"&title="+subject+"&userid="+userid+"&memo="+body);
			
			
			
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
	}

%>
