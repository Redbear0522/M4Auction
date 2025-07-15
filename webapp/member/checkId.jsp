<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %>
<%
    String checkId = request.getParameter("userId");
    String result = "N";
    
    if(checkId != null && checkId.length() >= 4) {
        Connection conn = getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            // 여기! USERS 테이블로 바꿨나요?
            String sql = "SELECT COUNT(*) FROM USERS WHERE MEMBER_ID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, checkId);
            rs = pstmt.executeQuery();
            
            if(rs.next()) {
                int count = rs.getInt(1);
                if(count == 0) {
                    result = "Y";
                }
            }
            
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            close(rs);
            close(pstmt);
            close(conn);
        }
    }
    
    out.print(result);
%>