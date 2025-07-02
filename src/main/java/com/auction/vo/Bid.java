// File: src/main/java/com/auction/vo/Bid.java
// 역할: BID 테이블의 한 행의 데이터를 저장하고 옮기는 데 사용되는 객체 (Value Object)
package com.auction.vo;

import java.sql.Date;

public class Bid {

    // 필드는 BID 테이블의 컬럼과 1:1로 매핑되도록 작성합니다.
    private int bidId;
    private int productId;
    private String bidderId;
    private int bidPrice;
    private Date bidTime;

    // 기본 생성자
    public Bid() {}

    // Getters and Setters
    public int getBidId() {
        return bidId;
    }

    public void setBidId(int bidId) {
        this.bidId = bidId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
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
}
