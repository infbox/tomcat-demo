package com.infbox.demo.article;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import com.infbox.demo.MyUser;
import com.infbox.demo.Page;
import com.infbox.demo.article.ArticleCollect;
import com.infbox.demo.article.ArticleCollectUtil;

/**
 * Servlet implementation class ActivityCollectServlet
 */
@WebServlet("/ArticleCollectServlet")
public class ArticleCollectServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ArticleCollectServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("utf-8");
		response.setHeader("Access-Control-Allow-Origin", "*");		
		String uri = request.getRequestURI();
		String path = uri.substring(uri.lastIndexOf("/"), uri.lastIndexOf("."));
		MyUser user = (MyUser) request.getSession().getAttribute("user");
		
		if ("/add".equals(path)) {
			if(user==null){ return;}
			int articleId = Integer.valueOf(request.getParameter("articleId"));
			Long userId = user.getId();
			ArticleCollect collect = ArticleCollectUtil.findByUserId(user.getId(),articleId);
			if(collect==null){
				String author = request.getParameter("author");
				String bgimg = request.getParameter("bgimg");
				String title =request.getParameter("title");
				String urlPath =request.getParameter("url");
			//	int readnum = Integer.valueOf(request.getParameter("readnum"));
				collect = new ArticleCollect();
				collect.setArticleId(articleId);
				collect.setAuthor(author);
				collect.setBgimg(bgimg);
				collect.setUrlpath(urlPath);
			//	collect.setReadnum(readnum); 
				collect.setTitle(title);
				collect.setUserId(userId.intValue());
				ArticleCollectUtil.addCollect(collect);
			}else{
				ArticleCollectUtil.delCollect(user.getId(),articleId);
			}
			
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("code", "1");
			PrintWriter out = response.getWriter();
			out.write(jsonObject.toString());
		}else if ("/list".equals(path)) {
			//传入userId代表查看他人收藏列表，不传代表看自己的
			String userI = request.getParameter("userId");
			Long userId;
			if(userI==null)
				 userId = user.getId();
			else
				userId = Long.valueOf(userI);
			
			int pageCount = 1;
			int pageSize = 10;
			try {
				pageCount = Integer.parseInt(request.getParameter("pagecount"));
				pageSize = Integer.parseInt(request.getParameter("pagesize"));
			} catch (Exception ex) {

			}
			
			int totalRow = ArticleCollectUtil.getCount(userId.intValue());
			Page page = new Page(totalRow, pageCount, pageSize);
			ArrayList<ArticleCollect> collects = ArticleCollectUtil.getCollectList(userId.intValue(), page);
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("code", "1");
			jsonObject.put("data", collects);
			jsonObject.put("page", page);
			PrintWriter out = response.getWriter();
			out.write(jsonObject.toString());
		}
	}


}
