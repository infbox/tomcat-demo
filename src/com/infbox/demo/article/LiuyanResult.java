package com.infbox.demo.article;

import java.util.Calendar;
import java.util.Date;

import com.infbox.demo.MiscUtil;

public class LiuyanResult {
	public long id;
	public int owner, friend, receiver, sender;
	public short type;
	public String content;

	public String sendTime, readTime;

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public int getOwner() {
		return owner;
	}

	public void setOwner(int owner) {
		this.owner = owner;
	}

	public int getFriend() {
		return friend;
	}

	public void setFriend(int friend) {
		this.friend = friend;
	}

	public int getReceiver() {
		return receiver;
	}

	public void setReceiver(int receiver) {
		this.receiver = receiver;
	}

	public int getSender() {
		return sender;
	}

	public void setSender(int sender) {
		this.sender = sender;
	}

	public short getType() {
		return type;
	}

	public void setType(short type) {
		this.type = type;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getSendTime() {
		return sendTime;
	}

	public void setSendTime(Date sendTime) {
		this.sendTime =  MiscUtil.date2Str(sendTime);
	}

	public String getReadTime() {
		return readTime;
	}

	public void setReadTime(Date readTime) {
		this.readTime = MiscUtil.date2Str(readTime);
	}

}
