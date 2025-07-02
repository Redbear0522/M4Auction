package com.auction.vo;

import java.util.Date;

public class BidDTO {
	private int bidId;          // 입찰 고유 번호
	private int itemId;         // 입찰한 상품 번호
	private String bidderId;    // 입찰자 아이디
	private int bidPrice;       // 입찰 가격
	private Date bidTime;       // 입찰 시간
	private int isSuccessful;   // 낙찰 여부 (0: 실패, 1: 낙찰)

	public int getBidId() {
		return bidId;
	}
	public void setBidId(int bidId) {
		this.bidId = bidId;
	}
	public int getItemId() {
		return itemId;
	}
	public void setItemId(int itemId) {
		this.itemId = itemId;
	}
	public String getBidderId() {
		return bidderId;
	}
	public void setBidderId(String bidderId) {
		this.bidderId = bidderId;
	}
	public int getBidPrice() {
		return bidPrice;
	}
	public void setBidPrice(int bidPrice) {
		this.bidPrice = bidPrice;
	}
	public Date getBidTime() {
		return bidTime;
	}
	public void setBidTime(Date bidTime) {
		this.bidTime = bidTime;
	}
	public int getIsSuccessful() {
		return isSuccessful;
	}
	public void setIsSuccessful(int isSuccessful) {
		this.isSuccessful = isSuccessful;
	}
}
