package com.infbox.demo.article;

import java.util.Date;

import org.bson.types.ObjectId;

import com.mongodb.BasicDBObject;

public class UserComment {
	public String comment,userName,userPic;
	public Date actTime;
	public ObjectId id;
	public long userID;
	public long pID;
	public int praises;
	public BasicDBObject reply;
	
}
