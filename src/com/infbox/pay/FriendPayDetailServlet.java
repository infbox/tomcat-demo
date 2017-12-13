package com.infbox.pay;

import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.BeanUtils;

import net.sf.json.JSONObject;

import com.infbox.demo.DemoUtil;
import com.infbox.demo.MyUser;
import com.infbox.demo.Page;
import com.infbox.demo.article.Liuyan;
import com.infbox.demo.article.LiuyanResult;
import com.infbox.demo.article.LiuyanUtil;

/**
 * Servlet implementation class LiuyanServlet
 */
@WebServlet("/FriendPayDetailServlet")
public class FriendPayDetailServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public FriendPayDetailServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("utf-8");
		response.setHeader("Access-Control-Allow-Origin", "*");
		
		String uri = request.getRequestURI();
		String path = uri.substring(uri.lastIndexOf("/"), uri.lastIndexOf("."));
		MyUser user = (MyUser) request.getSession().getAttribute("user");
				
		if ("/list".equals(path)) {			

			int pageCount = 1;
			int pageSize = 10;
			try {
				pageCount = Integer.parseInt(request.getParameter("pagecount"));
				pageSize = Integer.parseInt(request.getParameter("pagesize"));
			} catch (Exception ex) {

			}
			Long ownerId = user.getId();
			int totalRow = PayUtil.getFriendPayCount(ownerId.intValue());
			Page page = new Page(totalRow, pageCount, pageSize);
			ArrayList<PayLog> list = PayUtil.getFriendPayList(
					ownerId.intValue(), page);
			
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("code", "1");
			jsonObject.put("data", list);
			jsonObject.put("page", page);
			PrintWriter out = response.getWriter();
			out.write(jsonObject.toString());
		}
	}

}
