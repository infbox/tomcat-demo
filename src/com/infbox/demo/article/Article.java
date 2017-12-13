package com.infbox.demo.article;

import java.util.Date;

public class Article  implements Comparable<Article>{
	public int id;
	private short state;
	public int readNum,commentNum,complain,
				bonusNum;//被打赏的次数
	public Integer getBonusNum() {
		return bonusNum;
	}


	public void setBonusNum(int bonusNum) {
		this.bonusNum = bonusNum;
	}



	public String urlpath;//静态页面路径
	public Integer getCommentNum() {
		return commentNum;
	}


	public void setCommentNum(int commentNum) {
		this.commentNum = commentNum;
	}


	public int getDislikeNum() {
		return dislikeNum;
	}


	public void setDislikeNum(int dislikeNum) {
		this.dislikeNum = dislikeNum;
	}



	public int  likeNum,dislikeNum;
	public Integer			userid;//文章作者的id,对应user表的id
	public Integer getUserid() {
		return userid;
	}


	public void setUserid(long userid) {
		this.userid = (int)userid;
	}



	public String title,content,author,bgImg,account,copyrightlogo,gzh_id;
	public String getAccount() {
		return account;
	}


	public void setAccount(String account) {
		this.account = account;
	}


	public String getBgImg() {
		return bgImg;
	}


	public void setBgImg(String bgImg) {
		this.bgImg = bgImg;
	}


	public Date postDate;
	public long pub_date;//审核通过的时间
	
	
	 public int getId() {
		return id;
	}


	public void setId(int id) {
		this.id = id;
	}


	public Integer  getReadNum() {
		return readNum;
	}


	public void setReadNum(int  readNum) {
		this.readNum = readNum;
	}


	public int getLikeNum() {
		return likeNum;
	}


	public void setLikeNum(int goodNum) {
		this.likeNum = goodNum;
	}


	public String getTitle() {
		return title;
	}


	public void setTitle(String title) {
		this.title = title;
	}


	public String getContent() {
		return content;
	}


	public void setContent(String content) {
		this.content = content;
	}


	public String getAuthor() {
		return author;
	}


	public void setAuthor(String author) {
		this.author = author;
	}


	public Date getPostDate() {
		return postDate;
	}


	public void setPostDate(Date postDate) {
		this.postDate = postDate;
	}
	private final static long factor3=24*3600000;//一天有多少毫秒

	public int compareTo(Article arg0) {  
		if(this.pub_date==arg0.pub_date)return 0;
		else if(this.pub_date>arg0.pub_date) return 1;
		else return -1;
		
		
    }


	public int getComplain() {
		return complain;
	}


	public void setComplain(int complain) {
		this.complain = complain;
	}


	public String getCopyrightlogo() {
		return copyrightlogo;
	}


	public void setCopyrightlogo(String copyrightlogo) {
		this.copyrightlogo = copyrightlogo;
	}


	public String getGzh_id() {
		return gzh_id;
	}


	public void setGzh_id(String gzh_id) {
		this.gzh_id = gzh_id;
	}


	public String getUrlpath() {
		return urlpath;
	}


	public void setUrlpath(String urlpath) {
		this.urlpath = urlpath;
	}  
	public short getState() {
		return state;
	}


	public void setState(short state) {
		this.state = state;
	}

}