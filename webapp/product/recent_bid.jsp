<%-- 
  File: WebContent/recent_bid.jsp
  역할: 최근 낙찰된 상품을 목록으로 출력
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.sql.*, com.auction.dao.ProductDAO, com.auction.dto.ProductDTO" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %>

<html>
<head>
    <title>최근 낙찰된 상품</title>
    
    <!-- Recent Bid Page Styles -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/recent-bid.css">
</head>
<body>
<jsp:include page="/layout/header/luxury-header.jsp" />
    <div class="container">
        <div class="title">📦 최근 낙찰된 상품 목록</div>
        <%
            Connection conn = getConnection();
            ProductDAO dao = new ProductDAO();
            List<ProductDTO> winList = dao.selectRecentWins(conn);
            close(conn);

            if (winList != null && !winList.isEmpty()) {
                for (ProductDTO p : winList) {
        %>
        <div class="win-item">
            <img src="upload/<%= p.getImageRenamedName() %>" alt="썸네일">
            <div class="win-info">
                <strong><%= p.getProductName() %></strong>
                <span>작가: <%= p.getArtistName() %></span>
                <span>낙찰가: <%= p.getFinalPrice() %>원</span>
                <span>낙찰자: <%= p.getWinnerId() %></span>
            </div>
        </div>
        <%
                }
            } else {
        %>
        <p style="text-align:center;">최근 낙찰된 상품이 없습니다.</p>
        <% } %>
    </div>
</body>
</html>
