package com.infbox.demo;

import java.math.BigDecimal;

public class MyUser {
	//当多个社区共享一个webapp的时候，
	private long id;
	private double distance; // 相距多少米
	private String name;
	private String IBOpenId;//抓信用户的openId
	public String headPic,
					memo,//个人简介，slogan
					city;//所在城市
	public String getMemo() {
		return memo;
	}
	public void setMemo(String memo) {
		this.memo = memo;
	}

	public int fansCount,idolCount;//粉丝数，偶像数
	
	public int getIdolCount() {
		return idolCount;
	}
	public void setIdolCount(int idolCount) {
		this.idolCount = idolCount;
	}
	public int getFansCount() {
		return fansCount;
	}
	public void setFansCount(int fansCount) {
		this.fansCount = fansCount;
	}

	private int level;  //认证等级 1-5  0未认证
	
	public String getCity() {
		return city;
	}
	public void setCity(String city) {
		this.city = city;
	}

	private double longitud; // 精度
	private double latitude; // 纬度

	public double getLongitud() {
		return longitud;
	}
	public void setLongitud(double longitud) {
		this.longitud = longitud;
	}
	public double getLatitude() {
		return latitude;
	}
	public void setLatitude(double latitude) {
		this.latitude = latitude;
	}
	
	public double getDistance() {
		BigDecimal b = new BigDecimal(this.distance);
		double f1 = b.setScale(4, BigDecimal.ROUND_HALF_UP).doubleValue();
		return f1;
	}

	public void setDistance(double distance) {
		this.distance = distance;
	}

	
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getIBOpenId() {
		return IBOpenId;
	}
	public void setIBOpenId(String iBOpenId) {
		IBOpenId = iBOpenId;
	}
	public String getHeadPic() {
		return headPic;
	}
	public void setHeadPic(String headPic) {
		this.headPic = headPic;
	}
	
	public long getId() {
		return id;
	}
	
	public void setId(long id) {
		this.id = id;
	}
	public int getLevel() {
		return level;
	}
	public void setLevel(int level) {
		this.level = level;
	}
	
}
