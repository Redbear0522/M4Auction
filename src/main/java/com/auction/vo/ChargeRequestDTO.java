package com.auction.vo;

import java.sql.Date;

public class ChargeRequestDTO {
    private int reqId;
    private String memberId;
    private long amount;
    private String status;
    private Date requestDate;
    private Date approveDate;

    // getter/setter 생략 가능
    public int getReqId() { return reqId; }
    public void setReqId(int reqId) { this.reqId = reqId; }

    public String getMemberId() { return memberId; }
    public void setMemberId(String memberId) { this.memberId = memberId; }

    public long getAmount() { return amount; }
    public void setAmount(long amount) { this.amount = amount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Date getRequestDate() { return requestDate; }
    public void setRequestDate(Date requestDate) { this.requestDate = requestDate; }

    public Date getApproveDate() { return approveDate; }
    public void setApproveDate(Date approveDate) { this.approveDate = approveDate; }
}
