// File: src/main/java/com/auction/vo/ProductDTO.java
package com.auction.vo;

import java.sql.Date;
import java.sql.Timestamp;

public class ProductDTO {

    private int productId;
    private String productName;
    private String artistName;
    private String productDesc;
    private int startPrice;
    
    // ======== 새로 추가된 필드 ========
    private int buyNowPrice; // 즉시 구매가
    
    private int currentPrice;
    private Timestamp endTime;
    private String imageOriginalName;
    private String imageRenamedName;
    private String category;
    private String sellerId;
    private Date regDate;
    private String status;
    private String winnerId;
    private int finalPrice;
    private ScheduleDTO schedule;

    public ScheduleDTO getSchedule() {
		return schedule;
	}

	public void setSchedule(ScheduleDTO schedule) {
		this.schedule = schedule;
	}

	public ProductDTO() {}
    
	// --- Getters and Setters ---
    
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public String getArtistName() { return artistName; }
    public void setArtistName(String artistName) { this.artistName = artistName; }
    public String getProductDesc() { return productDesc; }
    public void setProductDesc(String productDesc) { this.productDesc = productDesc; }
    public int getStartPrice() { return startPrice; }
    public void setStartPrice(int startPrice) { this.startPrice = startPrice; }
    
    // ======== 새로 추가된 Getter/Setter ========
    public int getBuyNowPrice() { return buyNowPrice; }
    public void setBuyNowPrice(int buyNowPrice) { this.buyNowPrice = buyNowPrice; }

    public int getCurrentPrice() { return currentPrice; }
    public void setCurrentPrice(int currentPrice) { this.currentPrice = currentPrice; }
    public Timestamp getEndTime() { return endTime; }
    public void setEndTime(Timestamp endTime) { this.endTime = endTime; }
    public String getImageOriginalName() { return imageOriginalName; }
    public void setImageOriginalName(String imageOriginalName) { this.imageOriginalName = imageOriginalName; }
    public String getImageRenamedName() { return imageRenamedName; }
    public void setImageRenamedName(String imageRenamedName) { this.imageRenamedName = imageRenamedName; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public String getSellerId() { return sellerId; }
    public void setSellerId(String sellerId) { this.sellerId = sellerId; }
    public Date getRegDate() { return regDate; }
    public void setRegDate(Date regDate) { this.regDate = regDate; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getWinnerId() { return winnerId; }
    public void setWinnerId(String winnerId) { this.winnerId = winnerId; }
    public int getFinalPrice() { return finalPrice; }
    public void setFinalPrice(int finalPrice) { this.finalPrice = finalPrice; }
}
