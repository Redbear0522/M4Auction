<%--
  File: WebContent/product/productDetail.jsp
  역할: 즉시 구매 기능이 포함된 최종 버전의 상품 상세 페이지입니다.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.auction.vo.MemberDTO" %>
<%@ page import="com.auction.vo.ProductDTO" %>
<%@ page import="com.auction.dao.ProductDAO" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %>
<%
    MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");

    String productIdStr = request.getParameter("productId");
    int productId = 0;
    if(productIdStr != null) {
        productId = Integer.parseInt(productIdStr);
    }
    
    ProductDTO p = null;
    if(productId > 0){
        Connection conn = getConnection();
        p = new ProductDAO().selectProductById(conn, productId);
        close(conn);
    }
    
    boolean isEnded = p != null && new java.util.Date().after(p.getEndTime());
    boolean isSeller = loginUser != null && p != null && loginUser.getMemberId().equals(p.getSellerId());
    boolean isWinner = loginUser != null && p != null && p.getWinnerId() != null && loginUser.getMemberId().equals(p.getWinnerId());

    DecimalFormat df = new DecimalFormat("###,###,###");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy년 MM월 dd일 HH:mm");
    
    int currentPrice = (p != null) ? (p.getCurrentPrice() == 0 ? p.getStartPrice() : p.getCurrentPrice()) : 0;
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Art Auction - 작품 상세</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;700&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">
<style>
    body { margin: 0; background-color: #1a1a1a; color: #e0e0e0; font-family: 'Noto Sans KR', sans-serif; }
    a { text-decoration: none; color: inherit; }
    .header { display: flex; justify-content: space-between; align-items: center; padding: 20px 50px; background-color: rgba(0,0,0,0.3); border-bottom: 1px solid #333; }
    .header .logo { font-family: 'Playfair Display', serif; font-size: 28px; color: #d4af37; }
    .header .nav a { margin-left: 25px; font-size: 16px; transition: color 0.3s; }
    .header .nav a:hover { color: #d4af37; }
    .footer { text-align: center; padding: 40px; margin-top: 50px; background-color: #000; color: #777; font-size: 14px; }
    .detail-container { display: flex; gap: 50px; max-width: 1200px; margin: 50px auto; padding: 50px; background-color: #2b2b2b; border-radius: 10px; }
    .product-image-section { flex-basis: 50%; }
    .product-image-section img { width: 100%; border-radius: 8px; }
    .product-details-section { flex-basis: 50%; display: flex; flex-direction: column; }
    .product-details-section .artist-name { font-size: 20px; color: #aaa; }
    .product-details-section .product-title { font-size: 42px; font-family: 'Playfair Display', serif; color: #fff; margin: 10px 0; }
    .product-details-section .description { margin-top: 30px; line-height: 1.8; flex-grow: 1; }
    .price-info { margin-top: 20px; padding: 20px; background-color: rgba(0,0,0,0.3); border-radius: 8px; }
    .price-info .label { font-size: 16px; color: #aaa; }
    .price-info .price { font-size: 32px; font-weight: 700; color: #d4af37; }
    .bid-actions { margin-top: 30px; }
    .bid-form { margin-top: 15px; }
    .bid-input-group { display: flex; gap: 10px; }
    .bid-input-group input { flex-grow: 1; padding: 15px; font-size: 18px; background-color: #1a1a1a; border: 1px solid #555; color: #fff; border-radius: 8px; -moz-appearance: textfield; }
    .bid-input-group input::-webkit-outer-spin-button, .bid-input-group input::-webkit-inner-spin-button { -webkit-appearance: none; margin: 0; }
    .bid-button { display: block; width: 100%; padding: 15px; margin-top: 15px; font-size: 20px; font-weight: bold; color: #1a1a1a; background-color: #d4af37; border: none; border-radius: 8px; cursor: pointer; transition: background-color 0.3s; text-align:center; }
    .bid-button:hover { background-color: #e6c567; }
    .bid-button.buy-now { background-color: #c82333; color: white; }
    .bid-button.buy-now:hover { background-color: #a71d2a; }
    .bid-button:disabled { background-color: #555; color: #999; cursor: not-allowed; }
    .product-meta { margin-top: 20px; color: #aaa; }
</style>
</head>
<body>
    <header class="header">
        <div class="logo"><a href="<%= request.getContextPath() %>/index.jsp">Art Auction</a></div>
        <nav class="nav">
            <% if(loginUser == null) { %>
                <a href="<%= request.getContextPath() %>/member/loginForm.jsp">로그인</a>
                <a href="<%= request.getContextPath() %>/member/enroll_step1.jsp">회원가입</a>
            <% } else { %>
                <span><%= loginUser.getMemberName() %>님 환영합니다.</span>
                <a href="<%= request.getContextPath() %>/product/productEnrollForm.jsp">상품등록</a>
                <a href="<%= request.getContextPath() %>/mypage/myPage.jsp">마이페이지</a>
                <a href="<%= request.getContextPath() %>/member/logout.jsp">로그아웃</a>
            <% } %>
        </nav>
    </header>

    <% if(p != null) { %>
        <div class="detail-container">
            <div class="product-image-section">
                 <% if(p.getImageRenamedName() != null) { %>
                    <img src="<%= request.getContextPath() %>/resources/product_images/<%= p.getImageRenamedName() %>" alt="<%= p.getProductName() %>">
                <% } else { %>
                    <img src="https://placehold.co/800x800/2b2b2b/e0e0e0?text=<%= p.getProductName() %>" alt="<%= p.getProductName() %>">
                <% } %>
            </div>
            <div class="product-details-section">
                <p class="artist-name"><%= p.getArtistName() %></p>
                <h1 class="product-title"><%= p.getProductName() %></h1>
                
                <div class="bid-actions">
                <% if(p.getStatus().equals("A")) { %> <%-- 1. 경매가 아직 진행중일 때 --%>
                    <div class="price-info">
                        <span class="label">현재가</span>
                        <p class="price">₩ <%= df.format(currentPrice) %></p>
                    </div>
                    <% if(isEnded) { %> <%-- 1-1. 시간은 마감됐지만, 아직 낙찰 처리 전 --%>
                        <% if(isSeller) { %>
                            <a href="processWinnerAction.jsp?productId=<%= p.getProductId() %>" class="bid-button">낙찰 처리하기</a>
                        <% } else { %>
                            <button class="bid-button" disabled>경매 마감 (낙찰 처리중)</button>
                        <% } %>
                    <% } else { %> <%-- 1-2. 시간도 남았고, 정상 진행중 --%>
                        <form id="bidForm" class="bid-form" action="bidAction.jsp" method="post" onsubmit="return validateBid();">
                            <input type="hidden" name="productId" value="<%= p.getProductId() %>">
                            <input type="hidden" name="currentPrice" value="<%= currentPrice %>">
                            <div class="bid-input-group">
                                <input type="number" name="bidPrice" id="bidPriceInput" placeholder="입찰 금액" required>
                                <button type="submit" class="bid-button">입찰하기</button>
                            </div>
                        </form>
                        <% if(p.getBuyNowPrice() > 0 && !isSeller) { %>
                             <a href="paymentAction.jsp?productId=<%= p.getProductId() %>" class="bid-button buy-now" onclick="return confirm('즉시 구매가(<%= df.format(p.getBuyNowPrice()) %>원)로 구매하시겠습니까?');">즉시 구매</a>
                        <% } %>
                    <% } %>
                <% } else if(p.getStatus().equals("E")) { %> <%-- 2. 경매가 종료되었을 때 --%>
                    <div class="price-info">
                        <span class="label">최종 낙찰가</span>
                        <p class="price">₩ <%= df.format(p.getFinalPrice()) %></p>
                    </div>
                    <% if(isWinner) { %>
                        <a href="paymentAction.jsp?productId=<%= p.getProductId() %>" class="bid-button" onclick="return confirm('보유 마일리지에서 낙찰가만큼 차감하여 결제하시겠습니까?');">결제하기 (마일리지 차감)</a>
                    <% } else { %>
                         <button class="bid-button" disabled>경매 종료</button>
                    <% } %>
                <% } else if(p.getStatus().equals("P")) { %> <%-- 수정된 부분: 결제 완료 상태('P')일 때의 UI --%>
                    <div class="price-info">
                        <span class="label">최종 낙찰가</span>
                        <p class="price">₩ <%= df.format(p.getFinalPrice()) %></p>
                    </div>
                    <button class="bid-button" disabled>결제 완료</button>
                <% } else { %> <%-- 3. 그 외 (취소 등) --%>
                    <button class="bid-button" disabled>종료된 경매입니다</button>
                <% } %>
                </div>

                <p class="description"><%= p.getProductDesc() %></p>
                <div class="product-meta">
                    <p>판매자: <%= p.getSellerId() %></p>
                    <p>경매 마감: <%= sdf.format(p.getEndTime()) %></p>
                    <% if(p.getWinnerId() != null) { %>
                        <p style="color:#d4af37; font-weight:bold;">낙찰자: <%= p.getWinnerId() %></p>
                    <% } %>
                </div>
            </div>
        </div>
    <% } else { %>
        <h1 style="text-align:center; margin-top:100px;">해당 상품을 찾을 수 없습니다.</h1>
    <% } %>
    <footer class="footer">
        <p>&copy; 2025 Art Auction. All Rights Reserved.</p>
    </footer>
    <script>
        function validateBid() { 
            const bidPrice = parseInt(document.getElementById('bidPriceInput').value);
            const currentPrice = <%= currentPrice %>;

            if (isNaN(bidPrice) || bidPrice <= 0) {
                alert("올바른 입찰 금액을 입력해주세요.");
                return false;
            }
            
            if (bidPrice <= currentPrice) {
                alert("입찰가는 현재가보다 높아야 합니다.");
                return false;
            }

            return true;
        }
    </script>
</body>
</html>
