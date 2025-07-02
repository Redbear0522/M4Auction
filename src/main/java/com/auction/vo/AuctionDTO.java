package com.auction.vo;

import java.util.Date;

public class AuctionDTO {
	private int id; 			// 경매 상품 고유 번호 (기본키, 시퀀스로 자동 생성)
	private String title; 		// 경매 상품 제목 
	private int startPrice;		// 경매 시작 가격 (판매자가 등록할 때 입력하는 가격)
	private int currentPrice;	// 현재 최고 입찰가 (입찰이 들어올 떄마다 갱신됨)	
	private String status;		// 경매 상태 (ex: 대기중, 경매 진행중, 경매 종료 )
	private Date regDate;		// 상품 등록일 (sysdate로 자동 설정이됨)
	private String description; // 경매 상품 상세 설명
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public int getStartPrice() {
		return startPrice;
	}
	public void setStartPrice(int startPrice) {
		this.startPrice = startPrice;
	}
	public int getCurrentPrice() {
		return currentPrice;
	}
	public void setCurrentPrice(int currentPrice) {
		this.currentPrice = currentPrice;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public Date getRegDate() {
		return regDate;
	}
	public void setRegDate(Date regDate) {
		this.regDate = regDate;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	
	
	
}
