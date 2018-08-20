package com.infbox.demo;

import java.io.IOException;
import java.util.HashMap;
import java.util.TimeZone;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONException;

import com.infbox.demo.article.JHArticleUtil;
import com.infbox.sdk.HttpUtil;

public class InitWorkServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * Constructor of the object.
	 */
	public InitWorkServlet() {
		super();			
		
	}

	/**
	 * Destruction of the servlet. <br>
	 */
	public void destroy() {
		super.destroy(); // Just puts "destroy" string in log
		// Put your code here
	}

	/**
	 * The doGet method of the servlet. <br>
	 *
	 * This method is called when a form has its tag value method equals to get.
	 * 
	 * @param request the request send by the client to the server
	 * @param response the response send by the server to the client
	 * @throws ServletException if an error occurred
	 * @throws IOException if an error occurred
	 */
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

	
	}

	/**
	 * The doPost method of the servlet. <br>
	 *
	 * This method is called when a form has its tag value method equals to post.
	 * 
	 * @param request the request send by the client to the server
	 * @param response the response send by the server to the client
	 * @throws ServletException if an error occurred
	 * @throws IOException if an error occurred
	 */
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

	
	}

	/**
	 * Initialization of the servlet. <br>
	 *
	 * @throws ServletException if an error occurs
	 */
	public void init() throws ServletException {		
		String mysql_url=this.getServletConfig().getInitParameter("mysql_url");
		if(mysql_url==null)mysql_url="jdbc:mysql://localhost:3306/shequn";
		String mysql_user = this.getServletConfig().getInitParameter("mysql_user");
		String mysql_passwd = this.getServletConfig().getInitParameter("mysql_passwd");
		String myUrl= mysql_url+"?user="+mysql_user+"&password="+mysql_passwd+"&useUnicode=true&characterEncoding=utf-8&autoReconnect=true&useSSL=false&serverTimezone=Hongkong";
		DBPoolTomcat.setDBUrl(myUrl);
		
	}

}
