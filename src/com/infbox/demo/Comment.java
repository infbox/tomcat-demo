package com.infbox.demo;

import java.util.Date;

//帖子评论
public class Comment {
	public String content;//评论内容
	
	public int post_id,//所属帖子的id
	author_id,
			 id;//评论id
	public Date addTime;
}
