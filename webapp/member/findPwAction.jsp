<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.auction.common.SHA256" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    
    String id = request.getParameter("id");
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String result = "N";
    
    Connection conn = getConnection();
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        // 1. 회원 정보 확인
        String sql = "SELECT MEMBER_ID FROM USERS WHERE MEMBER_ID = ? AND MEMBER_NAME = ? AND EMAIL = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, id);
        pstmt.setString(2, name);
        pstmt.setString(3, email);
        
        rs = pstmt.executeQuery();
        
        if(rs.next()) {
            // 2. 임시 비밀번호 생성 (간단하게 숫자 6자리)
            String tempPwd = String.valueOf((int)(Math.random() * 900000) + 100000);
            
            // 3. 비밀번호 업데이트
            close(rs);
            close(pstmt);
            
            sql = "UPDATE USERS SET MEMBER_PWD = ? WHERE MEMBER_ID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, SHA256.encrypt(tempPwd));  // 암호화해서 저장
            pstmt.setString(2, id);
            
            int updateResult = pstmt.executeUpdate();
            
            if(updateResult > 0) {
                commit(conn);
                result = "Y";
                
                // 실제로는 여기서 이메일 발송 로직이 들어가야 함
                // 지금은 콘솔에 출력만
                System.out.println("=== 임시 비밀번호 발급 ===");
                System.out.println("아이디: " + id);
                System.out.println("이메일: " + email);
                System.out.println("임시 비밀번호: " + tempPwd);
                System.out.println("======================");
            } else {
                rollback(conn);
            }
        }
        
    } catch(Exception e) {
        rollback(conn);
        e.printStackTrace();
    } finally {
        close(rs);
        close(pstmt);
        close(conn);
    }
    
    out.print(result);
%>