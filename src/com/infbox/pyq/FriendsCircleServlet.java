package com.infbox.pyq;

import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

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


/**
 * Servlet implementation class LiuyanServlet
 */
@WebServlet("/FriendPayCircleServlet")
public class FriendsCircleServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public FriendsCircleServlet() {
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
			int totalRow = FriendsCircleUtil.getFriendCircleCount();
			Page page = new Page(totalRow, pageCount, pageSize);
			Map<String, Object> list = FriendsCircleUtil.getFriendCricleList(page,request);
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("code", "1");
			jsonObject.put("data", list);
			jsonObject.put("page", page);
			PrintWriter out = response.getWriter();
			out.write(jsonObject.toString());
		}else if("/like".equals(path)){
			String state = request.getParameter("state");
			int userId = Integer.parseInt(request.getParameter("userId"));
			int pyqId = Integer.parseInt(request.getParameter("pyqId"));
			PyqLike like = new PyqLike();
			like.setPyqId(pyqId);
			like.setState(state);
			like.setUserId(userId);
			String name = user.getName();
			like.setUserName(name);
			int saveOrUpdate = PyqLikeUtil.saveOrUpdate(like);
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("data", saveOrUpdate);
			PrintWriter out = response.getWriter();
			out.write(jsonObject.toString());
		}else if("/comment".equals(path)){
			int userId = Integer.parseInt(request.getParameter("userId"));
			int pyqId = Integer.parseInt(request.getParameter("pyqId"));
			String comText = new String(request.getParameter("comText").getBytes("iso-8859-1"), "utf-8");
			PyqComment com = new PyqComment();
			com.setComText(comText);
			com.setPyqId(pyqId);
			com.setUserId(userId);
			String userName=user.getName();
			com.setUserName(userName);
			int comId = PyqCommentUtil.save(com);
			JSONObject jsonObject = new JSONObject();
			com.setId(comId);
			jsonObject.put("com", com);
			PrintWriter out = response.getWriter();
			out.write(jsonObject.toString());
		}else if("/delComment".equals(path)){
			//是否有删除权限
			int id = Integer.parseInt(request.getParameter("id"));
			int delete = PyqCommentUtil.delete(id);
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("id", delete);
			PrintWriter out = response.getWriter();
			out.write(jsonObject.toString());
		}
		//
	}

}
