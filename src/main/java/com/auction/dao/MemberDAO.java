// File: src/main/java/com/auction/dao/MemberDAO.java
// 역할: 회원과 관련된 모든 DB 작업을 처리하는 클래스입니다.
package com.auction.dao;

import static com.auction.common.JDBCTemplate.*;

<<<<<<< HEAD
import com.auction.common.SHA256;
=======
>>>>>>> 692b283f4bff172ab4f6a2f39dca655088613fa8
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;
 

import com.auction.vo.MemberDTO;

public class MemberDAO {

	public MemberDAO() {}
	
<<<<<<< HEAD
	public MemberDTO loginMember(Connection conn, String userId, String userPwd) {
	    MemberDTO loginUser = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String sql = "SELECT * FROM USERS WHERE MEMBER_ID = ? AND MEMBER_PWD = ?";

	    try {
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, userId);
	        pstmt.setString(2, SHA256.encrypt(userPwd));
	        rs = pstmt.executeQuery();

	        if (rs.next()) {
	            loginUser = new MemberDTO();
	            loginUser.setMemberId(rs.getString("MEMBER_ID"));
	            loginUser.setMemberName(rs.getString("MEMBER_NAME"));
	            loginUser.setEmail(rs.getString("EMAIL"));
	            loginUser.setTel(rs.getString("TEL"));
	            loginUser.setEnrollDate(rs.getDate("ENROLL_DATE"));
	            loginUser.setBirthdate(rs.getString("BIRTHDATE"));
	            loginUser.setGender(rs.getString("GENDER"));
	            loginUser.setMobileCarrier(rs.getString("MOBILE_CARRIER"));
	            loginUser.setMileage(rs.getInt("MILEAGE"));
	            
	            // ===== 주소 정보 추가 =====
	            loginUser.setZip(rs.getString("ZIP"));
	            loginUser.setAddr1(rs.getString("ADDR1"));
	            loginUser.setAddr2(rs.getString("ADDR2"));
	            loginUser.setMemberType(rs.getInt("MEMBER_TYPE"));
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        close(rs);
	        close(pstmt);
	    }
	    return loginUser;
	}
=======
	  public MemberDTO loginMember(Connection conn, String userId, String userPwd) {
	        MemberDTO loginUser = null;
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;
	        String sql = "SELECT * FROM USERS \r\n WHERE MEMBER_ID = ? AND MEMBER_PWD = ?";

	        try {
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setString(1, userId);
	            pstmt.setString(2, userPwd);
	            rs = pstmt.executeQuery();

	            if (rs.next()) {
	                loginUser = new MemberDTO();
	                loginUser.setMemberId(rs.getString("MEMBER_ID"));
	                loginUser.setMemberName(rs.getString("MEMBER_NAME"));
	                loginUser.setEmail(rs.getString("EMAIL"));
	                loginUser.setTel(rs.getString("TEL"));
	                loginUser.setEnrollDate(rs.getDate("ENROLL_DATE"));
	                loginUser.setBirthdate(rs.getString("BIRTHDATE"));
	                loginUser.setGender(rs.getString("GENDER"));
	                loginUser.setMobileCarrier(rs.getString("MOBILE_CARRIER"));
	                loginUser.setMileage(rs.getInt("MILEAGE"));
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	        } finally {
	            close(rs);
	            close(pstmt);
	        }
	        return loginUser;
	    }
>>>>>>> 692b283f4bff172ab4f6a2f39dca655088613fa8

    /**
     * 회원가입 기능 (상세 정보 버전) - 최종 수정됨
     */
	  public int enrollMember(Connection conn, MemberDTO m) {
<<<<<<< HEAD
		    int result = 0;
		    PreparedStatement pstmt = null;
		    
		    // SQL문 수정 - 컬럼 4개 추가!
		    String sql = "INSERT INTO USERS (MEMBER_ID, MEMBER_PWD, MEMBER_NAME, EMAIL, TEL, "
		                + "BIRTHDATE, GENDER, MOBILE_CARRIER, ENROLL_DATE, MILEAGE, "
		                + "ZIP, ADDR1, ADDR2, MEMBER_TYPE) "  // ← 여기 4개 추가!
		                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, SYSDATE, 0, ?, ?, ?, ?)";
		                //        1  2  3  4  5  6  7  8              9 10 11 12

		    try {
		        pstmt = conn.prepareStatement(sql);
		        
		        pstmt.setString(1, m.getMemberId());
		        pstmt.setString(2, SHA256.encrypt(m.getMemberPwd()));
		        pstmt.setString(3, m.getMemberName());
		        pstmt.setString(4, m.getEmail());
		        pstmt.setString(5, m.getTel());
		        pstmt.setString(6, m.getBirthdate());
		        pstmt.setString(7, m.getGender());
		        pstmt.setString(8, m.getMobileCarrier());
		        pstmt.setString(9, m.getZip());
		        pstmt.setString(10, m.getAddr1());
		        pstmt.setString(11, m.getAddr2());
		        pstmt.setInt(12, m.getMemberType());

		        result = pstmt.executeUpdate();

		    } catch (SQLException e) {
		        e.printStackTrace();
		    } finally {
		        close(pstmt);
		    }
		    return result;
		}
    
	  public int updateMember(Connection conn, MemberDTO m) {
		    int result = 0;
		    PreparedStatement pstmt = null;
		    
		    // 주소 정보도 함께 수정
		    String sql = "UPDATE USERS SET "
		                + "MEMBER_NAME = ?, "
		                + "EMAIL = ?, "
		                + "TEL = ?, "
		                + "ZIP = ?, "
		                + "ADDR1 = ?, "
		                + "ADDR2 = ? "
		                + "WHERE MEMBER_ID = ?";
		    
		    try {
		        pstmt = conn.prepareStatement(sql);
		        pstmt.setString(1, m.getMemberName());
		        pstmt.setString(2, m.getEmail());
		        pstmt.setString(3, m.getTel());
		        pstmt.setString(4, m.getZip());
		        pstmt.setString(5, m.getAddr1());
		        pstmt.setString(6, m.getAddr2());
		        pstmt.setString(7, m.getMemberId());
		        
		        result = pstmt.executeUpdate();
		        
		    } catch (SQLException e) {
		        e.printStackTrace();
		    } finally {
		        close(pstmt);
		    }
		    
		    return result;
		}
	  
	// 비밀번호 변경 메소드 추가
	  public int updatePassword(Connection conn, String memberId, String currentPwd, String newPwd) {
	      int result = 0;
	      PreparedStatement pstmt = null;
	      
	      // 현재 비밀번호 확인 후 변경
	      String sql = "UPDATE USERS SET MEMBER_PWD = ? "
	                  + "WHERE MEMBER_ID = ? AND MEMBER_PWD = ?";
	      
	      try {
	          pstmt = conn.prepareStatement(sql);
	          pstmt.setString(1, SHA256.encrypt(newPwd));
	          pstmt.setString(2, memberId);
	          pstmt.setString(3, SHA256.encrypt(currentPwd));
	          
	          result = pstmt.executeUpdate();
	          
	      } catch (SQLException e) {
	          e.printStackTrace();
	      } finally {
	          close(pstmt);
	      }
	      
	      return result;
	  }
=======
	        int result = 0;
	        PreparedStatement pstmt = null;
	        String sql = "INSERT INTO USERS (MEMBER_ID, MEMBER_PWD, MEMBER_NAME, EMAIL, TEL,"
	    		     + "BIRTHDATE, GENDER, MOBILE_CARRIER, ENROLL_DATE, MILEAGE)"
	    			 + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, SYSDATE, 0)";

	        try {
	            pstmt = conn.prepareStatement(sql);
	            
	            pstmt.setString(1, m.getMemberId());
	            pstmt.setString(2, m.getMemberPwd());
	            pstmt.setString(3, m.getMemberName());
	            pstmt.setString(4, m.getEmail());
	            pstmt.setString(5, m.getTel());
	            pstmt.setString(6, m.getBirthdate());
	            pstmt.setString(7, m.getGender());
	            pstmt.setString(8, m.getMobileCarrier());

	            result = pstmt.executeUpdate();

	        } catch (SQLException e) {
	            e.printStackTrace();
	        } finally {
	            close(pstmt);
	        }
	        return result;
	    }
    
	  public int updateMember(Connection conn, MemberDTO m) {
	        int result = 0;
	        PreparedStatement pstmt = null;
	        String sql = "UPDATE USERS\r\n SET MEMBER_NAME = ?,\r\n EMAIL = ?,\r\n TEL = ?\r\n WHERE MEMBER_ID = ?";
	        
	        try {
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setString(1, m.getMemberName());
	            pstmt.setString(2, m.getEmail());
	            pstmt.setString(3, m.getTel());
	            pstmt.setString(4, m.getMemberId());
	            
	            result = pstmt.executeUpdate();
	            
	        } catch (SQLException e) {
	            e.printStackTrace();
	        } finally {
	            close(pstmt);
	        }
	        
	        return result;
	    }
>>>>>>> 692b283f4bff172ab4f6a2f39dca655088613fa8

	  public int updateMileage(Connection conn, String userId, int amount) {
	        int result = 0;
	        PreparedStatement pstmt = null;
	        String sql = "UPDATE USERS\r\n"
	        		+ "		   SET MILEAGE = MILEAGE + ?\r\n"
	        		+ "		 WHERE MEMBER_ID = ?";
	        
	        try {
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setInt(1, amount);
	            pstmt.setString(2, userId);
	            
	            result = pstmt.executeUpdate();
	            
	        } catch (SQLException e) {
	            e.printStackTrace();
	        } finally {
	            close(pstmt);
	        }
	        
	        return result;
	    }
    
	  public int deductMileage(Connection conn, String userId, int amount) {
	        int result = 0;
	        PreparedStatement pstmt = null;
	        String sql = "UPDATE USERS\r\n"
	        		+ "		   SET MILEAGE = MILEAGE - ?\r\n"
	        		+ "		 WHERE MEMBER_ID = ?";
	        
	        try {
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setInt(1, amount);
	            pstmt.setString(2, userId);
	            
	            result = pstmt.executeUpdate();
	            
	        } catch (SQLException e) {
	            e.printStackTrace();
	        } finally {
	            close(pstmt);
	        }
	        
	        return result;
	    }
<<<<<<< HEAD
	  
	  public int insertVipInfo(Connection conn, MemberDTO m) {
		    int result = 0;
		    PreparedStatement pstmt = null;
		    
		    String sql = "INSERT INTO VIP_INFO (MEMBER_ID, PREFERRED_CATEGORY, ANNUAL_BUDGET, VIP_NOTE) "
		                + "VALUES (?, ?, ?, ?)";
		    
		    try {
		        pstmt = conn.prepareStatement(sql);
		        pstmt.setString(1, m.getMemberId());
		        pstmt.setString(2, m.getPreferredCategory());
		        pstmt.setString(3, m.getAnnualBudget());
		        pstmt.setString(4, m.getVipNote());
		        
		        result = pstmt.executeUpdate();
		        
		        System.out.println("VIP INSERT 실행 결과: " + result);
		        
		    } catch(SQLException e) {
		        System.out.println("VIP 저장 중 에러 발생!");
		        e.printStackTrace();
		    } finally {
		        close(pstmt);
		    }
		    
		    return result;
		}
=======
>>>>>>> 692b283f4bff172ab4f6a2f39dca655088613fa8
	}
