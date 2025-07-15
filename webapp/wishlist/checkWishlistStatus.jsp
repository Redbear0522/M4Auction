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
            responseData.put("success", false);
            responseData.put("message", "로그인이 필요합니다.");
            out.print(new Gson().toJson(responseData));
            return;
        }
        
        // 상품 ID 목록 받기
        String productIdsParam = request.getParameter("productIds");
        if (productIdsParam == null || productIdsParam.trim().isEmpty()) {
            responseData.put("success", false);
            responseData.put("message", "상품 ID가 필요합니다.");
            out.print(new Gson().toJson(responseData));
            return;
        }
        
        String[] productIdArray = productIdsParam.split(",");
        String memberId = loginUser.getMemberId();
        
        // 데이터베이스 연결
        Connection conn = getConnection();
        WishlistDAO wishlistDAO = new WishlistDAO();
        
        // 찜 상태 확인
        Map<String, Boolean> wishlistStatus = new HashMap<>();
        
        for (String productIdStr : productIdArray) {
            try {
                int productId = Integer.parseInt(productIdStr.trim());
                boolean isWishlisted = wishlistDAO.isWishlisted(conn, memberId, productId);
                wishlistStatus.put(productIdStr.trim(), isWishlisted);
            } catch (NumberFormatException e) {
                // 잘못된 상품 ID는 무시
                continue;
            }
        }
        
        close(conn);
        
        responseData.put("success", true);
        responseData.put("wishlistStatus", wishlistStatus);
        
    } catch (Exception e) {
        e.printStackTrace();
        responseData.put("success", false);
        responseData.put("message", "서버 오류가 발생했습니다.");
    }
    
    // JSON 응답 출력
    out.print(new Gson().toJson(responseData));
%>