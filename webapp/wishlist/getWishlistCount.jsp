<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="com.auction.dao.WishlistDAO" %>
<%@ page import="com.auction.dto.MemberDTO" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>

<%
    // JSON 응답 설정
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    
    // 응답 데이터 맵
    Map<String, Object> responseData = new HashMap<>();
    
    try {
        // 로그인 체크
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
        if (loginUser == null) {
            responseData.put("success", true);
            responseData.put("count", 0);
            out.print(new Gson().toJson(responseData));
            return;
        }
        
        // 데이터베이스 연결
        Connection conn = getConnection();
        WishlistDAO wishlistDAO = new WishlistDAO();
        
        // 찜 개수 조회
        int count = wishlistDAO.selectWishlistCount(conn, loginUser.getMemberId());
        
        close(conn);
        
        responseData.put("success", true);
        responseData.put("count", count);
        
    } catch (Exception e) {
        e.printStackTrace();
        responseData.put("success", false);
        responseData.put("message", "서버 오류가 발생했습니다.");
        responseData.put("count", 0);
    }
    
    // JSON 응답 출력
    out.print(new Gson().toJson(responseData));
%>