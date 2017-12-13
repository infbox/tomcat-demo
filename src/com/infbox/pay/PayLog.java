package com.infbox.pay;

import java.sql.Timestamp;

public class PayLog {
	
	private int id;
	private int userid;
	public int getRecv_id() {
		return recv_id;
	}
	public void setRecv_id(int recv_id) {
		this.recv_id = recv_id;
	}
	public int recv_id;//收款人的id
	private int articleid;
	private String outTradeNo;
	private String reamrk;
	private String payTradeNo;
	private String toAcct;
	private byte status;
	private byte payType;
	private Double amount;
	private Timestamp createTime;
	private Timestamp payTime;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getUserid() {
		return userid;
	}
	public void setUserid(int userid) {
		this.userid = userid;
	}
	public int getArticleid() {
		return articleid;
	}
	public void setArticleid(int articleid) {
		this.articleid = articleid;
	}
	public String getOutTradeNo() {
		return outTradeNo;
	}
	public void setOutTradeNo(String outTradeNo) {
		this.outTradeNo = outTradeNo;
	}
	public String getReamrk() {
		return reamrk;
	}
	public void setReamrk(String reamrk) {
		this.reamrk = reamrk;
	}
	public String getPayTradeNo() {
		return payTradeNo;
	}
	public void setPayTradeNo(String payTradeNo) {
		this.payTradeNo = payTradeNo;
	}
	public String getToAcct() {
		return toAcct;
	}
	public void setToAcct(String toAcct) {
		this.toAcct = toAcct;
	}
	public byte getStatus() {
		return status;
	}
	public void setStatus(byte status) {
		this.status = status;
	}
	public byte getPayType() {
		return payType;
	}
	public void setPayType(byte payType) {
		this.payType = payType;
	}
	public Double getAmount() {
		return amount;
	}
	public void setAmount(Double amount) {
		this.amount = amount;
	}
	public Timestamp getCreateTime() {
		return createTime;
	}
	public void setCreateTime(Timestamp createTime) {
		this.createTime = createTime;
	}
	public Timestamp getPayTime() {
		return payTime;
	}
	public void setPayTime(Timestamp payTime) {
		this.payTime = payTime;
	}
	
	
}
