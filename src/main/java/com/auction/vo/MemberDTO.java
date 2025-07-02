// File: src/main/java/com/auction/vo/Member.java
// 역할: 회원 한 명의 정보를 담는 '이름표' 양식입니다. (최종 업그레이드 버전)
package com.auction.vo;

import java.sql.Date;

public class MemberDTO {
    // 기존 필드
    private String memberId;
    private String memberPwd;
    private String memberName;
    private String email;
    private String tel;
    private Date enrollDate;
    private String birthdate;
    private String gender;
    private String mobileCarrier;
    private int mileage; // 마일리지
    private String preferredCategory;  // 관심 분야
    private String annualBudget;       // 연간 예산
    private String vipNote;            // 특별 요청사항
        
	private String zip;         // 우편번호
    private String addr1;       // 기본주소  
    private String addr2;       // 상세주소
    private int memberType;     // 회원종류 (1=일반, 2=VIP)
    public MemberDTO() {}
    public MemberDTO(String memberId, String memberPwd, String memberName, String email, String tel,
                  String birthdate, String gender, String mobileCarrier) {
    	this.memberType = 1;
    	this.memberId = memberId;
        this.memberPwd = memberPwd;
        this.memberName = memberName;
        this.email = email;
        this.tel = tel;
        this.birthdate = birthdate;
        this.gender = gender;
        this.mobileCarrier = mobileCarrier;
    }

	// --- Getters and Setters ---
    
    public String getMemberId() { return memberId; }
    public void setMemberId(String memberId) { this.memberId = memberId; }
    public String getMemberPwd() { return memberPwd; }
    public void setMemberPwd(String memberPwd) { this.memberPwd = memberPwd; }
    public String getMemberName() { return memberName; }
    public void setMemberName(String memberName) { this.memberName = memberName; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getTel() { return tel; }
    public void setTel(String tel) { this.tel = tel; }
    public Date getEnrollDate() { return enrollDate; }
    public void setEnrollDate(Date enrollDate) { this.enrollDate = enrollDate; }
    public String getBirthdate() { return birthdate; }
    public void setBirthdate(String birthdate) { this.birthdate = birthdate; }
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
    public String getMobileCarrier() { return mobileCarrier; }
    public void setMobileCarrier(String mobileCarrier) { this.mobileCarrier = mobileCarrier; }
    
    // ======== 새로 추가된 마일리지 Getter/Setter ========
    public int getMileage() { return mileage; }
    public void setMileage(int mileage) { this.mileage = mileage; }
    public String getZip() { return zip; }
    public void setZip(String zip) { this.zip = zip; }

    public String getAddr1() { return addr1; }
    public void setAddr1(String addr1) { this.addr1 = addr1; }

    public String getAddr2() { return addr2; }
    public void setAddr2(String addr2) { this.addr2 = addr2; }

    public int getMemberType() { return memberType; }
    public void setMemberType(int memberType) { this.memberType = memberType; }
    
    public String getPreferredCategory() {return preferredCategory;}

	public void setPreferredCategory(String preferredCategory) {this.preferredCategory = preferredCategory;}

	public String getAnnualBudget() {return annualBudget;}

	public void setAnnualBudget(String annualBudget) {this.annualBudget = annualBudget;}

	public String getVipNote() {return vipNote;}

	public void setVipNote(String vipNote) {this.vipNote = vipNote;}
}
