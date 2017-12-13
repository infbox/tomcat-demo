package com.infbox.demo;
/*
 * 抓信关注的消息源
 * */
public class Follow {
	public long id;
	public String fwId, //在抓信服务器上保存的关注id
				param,//关注参数
				tId,//消息源的id,如果是关注一个帖子，则是所关注帖子的id
				token,//抓信服务器用来识别权限的token
				openId;//抓信用户的openId
}
