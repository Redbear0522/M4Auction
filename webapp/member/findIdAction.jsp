<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String result = "N";
    
    Connection conn = getConnection();
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        String sql = "SELECT MEMBER_ID FROM USERS WHERE MEMBER_NAME = ? AND EMAIL = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, name);
        pstmt.setString(2, email);
        
        rs = pstmt.executeQuery();
        
        if(rs.next()) {
            result = rs.getString("MEMBER_ID");
        }
        
    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        close(rs);
        close(pstmt);
        close(conn);
    }
    
    out.print(result);
%>