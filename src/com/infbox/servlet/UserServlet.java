package com.infbox.servlet;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.concurrent.ThreadPoolExecutor;

import javax.imageio.ImageIO;
import javax.servlet.AsyncContext;
import javax.servlet.AsyncEvent;
import javax.servlet.AsyncListener;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadBase.SizeLimitExceededException;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import com.infbox.demo.AroudUtil;
import com.infbox.demo.DemoUtil;
import com.infbox.demo.MiscUtil;
import com.infbox.demo.MyUser;
import com.infbox.demo.Page;

import com.infbox.util.Base64Test;

import net.sf.json.JSONObject;

/**
 * Servlet implementation class UserServlet
 */
@WebServlet(urlPatterns = "/UserServlet", asyncSupported = true)
public class UserServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public UserServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
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
		
		if ("/near".equals(path)) {

			PrintWriter out = response.getWriter();
			// 模拟用户已登录
			if (user == null) {
				System.out.println("附近的人测试账号");
				user = new MyUser();
				user.setId(22);
			}

			String city = request.getParameter("city");
			double lng = Double.parseDouble(request.getParameter("lng"));
			double lat = Double.parseDouble(request.getParameter("lat"));
			int raidus = Integer.parseInt(request.getParameter("raidus"));
			int pageCount = 1;
			int pageSize = 10;
			try {
				pageCount = Integer.parseInt(request.getParameter("pagecount"));
				pageSize = Integer.parseInt(request.getParameter("pagesize"));
			} catch (Exception ex) {

			}
			// 更新当前用户坐标和城市
			DemoUtil.update(city, lng, lat, user.getId());

			double n[] = AroudUtil.getAround(lat, lng, raidus);
			int totalRow = DemoUtil.getAroundCount(user.getId(), n[0], n[1],
					n[2], n[3]);
			Page page = new Page(totalRow, pageCount, pageSize);
			List<MyUser> myUsers = DemoUtil.getUserNearby(page, user.getId(),
					n[0], n[1], n[2], n[3], lat, lng);
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("code", "1");
			jsonObject.put("data", myUsers);
			jsonObject.put("page", page);

			out.write(jsonObject.toString());
		} else if ("/updatePic".equals(path)) {
			System.out.println("updatePic is accessed");
			PrintWriter out = response.getWriter();
			String imgU = request.getParameter("imgR");
			int st = imgU.indexOf(",");
			imgU = imgU.substring(st + 1);
			JSONObject jsonObject = new JSONObject();
			String saveFileName = null;
			boolean isMultipart = ServletFileUpload.isMultipartContent(request);
			// if (isMultipart) {
			// 文件保存路径
			String savePath = request.getSession().getServletContext()
					.getRealPath("/")
					+ "upload/";
			// 文件上传缓冲区
			String tempPath = request.getSession().getServletContext()
					.getRealPath("/")
					+ "upload/temp/";
			File saveFile = new File(savePath);
			File tempFile = new File(tempPath);
			// 不存在以上路径则创建
			if (!saveFile.isDirectory())
				saveFile.mkdirs();
			if (!tempFile.isDirectory())
				tempFile.mkdirs();

			String fileName;
			Date nowDate = new Date();
			// 格式化时间对象返回字符串
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddhhmmss");
			fileName = sdf.format(nowDate);
			// // 毫秒数,类似于随机数为了避免文件重名
			fileName = user.getId() + "_" + fileName;
			fileName += System.currentTimeMillis() + ".jpg";
			saveFileName = "upload/" + fileName;

			Base64Test.generateImage(imgU, savePath + fileName);

			System.out.println("图片保存到服务器成功：" + savePath + fileName);
			// 把图片传到七牛服务器，然后修改一下
			String fileAcessKey = fileName;
			String fileurl = savePath + fileName;

			com.infbox.demo.QiNiuUploadUtil.uploadFileToRemoteFs(fileurl,
					fileAcessKey);
			String oldFile = user.getHeadPic();
			// 修改数据库
			DemoUtil.updateHeadPic(user.getId(),
					com.infbox.demo.QiNiuUploadUtil.accessDomain + fileAcessKey);
			saveFileName = com.infbox.demo.QiNiuUploadUtil.accessDomain
					+ fileAcessKey;
			System.out.println("图片保存到七牛成功：" + saveFileName);
			// 删除本地文件
			File file = new File(fileurl);
			file.delete();
			// 尝试删除旧的头像
			if (oldFile != null && oldFile.length() > 15) {
				try {// 有可能是别的地方的头像
					com.infbox.demo.QiNiuUploadUtil.deleteFile(oldFile);
					MiscUtil.debug("change pic, delete old file on qiniu:"
							+ oldFile);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					MiscUtil.debug(e.toString());
				}
			}

			user.setHeadPic(saveFileName);
			jsonObject.put("code", "1");
			jsonObject.put("data", saveFileName);
			out.write(jsonObject.toString());

		} else if ("/updateName".equals(path)) {

			PrintWriter out = response.getWriter();
			String name = request.getParameter("name");
			// 修改数据库
			DemoUtil.updateName(user.getId(), name);

			user.setName(name);
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("code", "1");
			out.write(jsonObject.toString());
		}

	}

}
