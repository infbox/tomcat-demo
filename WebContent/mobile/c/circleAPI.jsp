<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ page import="com.infbox.pyq.*"%>
<%@ page import="javax.servlet.http.*"%>
<%@ page import="sun.misc.*,com.infbox.sdk.*"%>
<%@ page import="java.util.*,com.jingh.bean.*,com.infbox.demo.Page,com.infbox.demo.*"%>
<%@ page import="java.io.*,net.sf.json.JSONObject"%>
<%@ page session="true" %> 
<%		

MyUser user = (MyUser) session.getAttribute("user");
if (user == null) {
	out.println("{}");
	return;
}
		
		request.setCharacterEncoding("UTF-8");
			String path = request.getParameter("action");
			if(path==null){
				path="list";
			}
						
			//---------------
			if ("list".equals(path)) {			
			int pageCount = 1;
			int pageSize = 10;
			try {
				pageCount = Integer.parseInt(request.getParameter("pagecount"));
				pageSize = Integer.parseInt(request.getParameter("pagesize"));
			} catch (Exception ex) {

			}
			Long ownerId = user.getId();
			int totalRow = FriendsCircleUtil.getFriendCircleCount(appName);
			Page page2 = new Page(totalRow, pageCount, pageSize);
			Map<String, Object> list = FriendsCircleUtil.getFriendCricleList(page2,request);
			JSONObject jsonObject = new JSONObject();
			Boolean bb=ShareAPIUtil.isQiNiuPic(appName);
			if(bb)jsonObject.put("needURLBase", "1");
			else jsonObject.put("needURLBase", "0");
			jsonObject.put("code", "1");
			jsonObject.put("data", list);
			jsonObject.put("page", page2);			
			out.print(jsonObject.toString());
		}else if("like".equals(path)){
			String state = request.getParameter("state");
			int userId = Integer.parseInt(request.getParameter("userId"));
			int pyqId = Integer.parseInt(request.getParameter("pyqId"));
			PyqLike like = new PyqLike();
			like.setPyqId(pyqId);
			like.setState(state);
			like.setUserId(userId);
			String name = user.getName();
			like.setUserName(name);
			int saveOrUpdate = PyqLikeUtil.saveOrUpdate(like,appName);
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("data", saveOrUpdate);			
			out.print(jsonObject.toString());
		}else if("comment".equals(path)){
			int userId = Integer.parseInt(request.getParameter("userId"));
			int pyqId = Integer.parseInt(request.getParameter("pyqId"));
			String comText =request.getParameter("comText");
			PyqComment com = new PyqComment();
			com.setComText(comText);
			com.setPyqId(pyqId);
			com.setUserId(userId);
			String userName=user.getName();
			com.setUserName(userName);
			int comId = PyqCommentUtil.save(com,appName);
			JSONObject jsonObject = new JSONObject();
			//com.setId(comId);
			//jsonObject.put("com", com);	
			jsonObject.put("id", comId);		
			jsonObject.put("comText", comText);		
			jsonObject.put("userId", userId);	
			jsonObject.put("userName", userName);
			out.print(jsonObject.toString());
		}else if("delComment".equals(path)){
			//是否有删除权限
			int id = Integer.parseInt(request.getParameter("id"));
			int delete = PyqCommentUtil.delete(id,appName);
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("id", delete);			
			out.print(jsonObject.toString());
		}
	
			
	%>