<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.auction.dto.MemberDTO" %>
<%@ page import="com.auction.dto.ProductDTO" %>
<%@ page import="com.auction.dto.BidDTO" %>
<%@ page import="com.auction.dao.ProductDAO" %>
<%@ page import="com.auction.dao.BidDAO" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.util.List" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %>
<%
    String ctx = request.getContextPath();
    MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");
    if (loginUser == null) {
        response.sendRedirect(ctx + "/member/loginForm.jsp");
        return;
    }

    // productId 파싱
    int productId = 0;
    if (request.getParameter("productId") != null) {
        productId = Integer.parseInt(request.getParameter("productId"));
    }

    ProductDTO product = null;
    List<BidDTO> bidHistory = null;
    
    if (productId > 0) {
        Connection conn = getConnection();
        try {
            ProductDAO productDao = new ProductDAO();
            product = productDao.selectProductById(conn, productId);
            
            BidDAO bidDao = new BidDAO();
            bidHistory = bidDao.getBidsByProductId(productId);
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            close(conn);
        }
    }

    SimpleDateFormat sdf = new SimpleDateFormat("MM-dd HH:mm:ss");
    DecimalFormat df = new DecimalFormat("###,###,###");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>입찰 내역 - M4 Auction</title>
    
    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    
    <!-- Global Styles -->
    <link rel="stylesheet" href="<%=ctx%>/resources/css/luxury-global-style.css">
    
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background: #f8f9fa;
            padding-top: 120px !important;
        }
        
        .bid-history-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 32px 24px;
        }
        
        .page-header {
            margin-bottom: 32px;
        }
        
        .page-title {
            font-size: 28px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 8px;
        }
        
        .page-subtitle {
            color: #6b7280;
            font-size: 16px;
        }
        
        /* Product Info Card */
        .product-info-card {
            background: white;
            border: 2px solid #e5e7eb;
            padding: 24px;
            margin-bottom: 32px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        
        .product-info {
            display: flex;
            align-items: center;
            gap: 16px;
        }
        
        .product-image {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 4px;
        }
        
        .product-details h3 {
            font-size: 18px;
            font-weight: 600;
            color: #1a1a1a;
            margin: 0 0 4px 0;
        }
        
        .product-details p {
            font-size: 14px;
            color: #6b7280;
            margin: 0;
        }
        
        .current-price {
            margin-top: 8px;
            font-size: 20px;
            font-weight: 700;
            color: #c9961a;
        }
        
        /* Bid History Table */
        .bid-history-section {
            background: white;
            border: 2px solid #e5e7eb;
            overflow: hidden;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        
        .section-header {
            padding: 24px;
            border-bottom: 2px solid #e5e7eb;
            background: #f9fafb;
        }
        
        .section-title {
            font-size: 18px;
            font-weight: 600;
            color: #1a1a1a;
            margin: 0;
        }
        
        .bid-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .bid-table th {
            text-align: left;
            padding: 16px 24px;
            font-size: 12px;
            font-weight: 700;
            color: #6b7280;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            background: #f9fafb;
            border-bottom: 1px solid #e5e7eb;
        }
        
        .bid-table td {
            padding: 16px 24px;
            border-bottom: 1px solid #f3f4f6;
            vertical-align: middle;
        }
        
        .bid-table tr:hover {
            background: #fafbfc;
        }
        
        .bid-table tr:last-child td {
            border-bottom: none;
        }
        
        .bidder-id {
            font-weight: 600;
            color: #1a1a1a;
        }
        
        .bid-price {
            font-size: 16px;
            font-weight: 700;
            color: #c9961a;
        }
        
        .bid-time {
            font-family: monospace;
            color: #6b7280;
            font-size: 13px;
        }
        
        .bid-rank {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 24px;
            height: 24px;
            border-radius: 50%;
            font-size: 12px;
            font-weight: 700;
            color: white;
        }
        
        .rank-1 { background: #ffd700; color: #000; }
        .rank-2 { background: #c0c0c0; color: #000; }
        .rank-3 { background: #cd7f32; color: #fff; }
        .rank-other { background: #e5e7eb; color: #6b7280; }
        
        .winning-bid {
            background: #fef3c7 !important;
        }
        
        .empty-state {
            text-align: center;
            padding: 64px 32px;
        }
        
        .empty-state i {
            font-size: 48px;
            color: #e5e7eb;
            margin-bottom: 16px;
        }
        
        .empty-state h3 {
            font-size: 18px;
            color: #6b7280;
            margin-bottom: 8px;
        }
        
        .empty-state p {
            color: #9ca3af;
        }
        
        .back-button {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #1a1a1a;
            color: white;
            font-size: 14px;
            font-weight: 600;
            padding: 10px 16px;
            text-decoration: none;
            transition: all 0.2s ease;
            margin-top: 24px;
        }
        
        .back-button:hover {
            background: #c9961a;
        }
    </style>
</head>
<body>
    <jsp:include page="/layout/header/luxury-header.jsp" />
    
    <div class="bid-history-container">
        <div class="page-header">
            <h1 class="page-title">입찰 내역</h1>
            <p class="page-subtitle">이 상품의 모든 입찰 기록을 확인할 수 있습니다</p>
        </div>
        
        <% if (product != null) { %>
        <!-- Product Info -->
        <div class="product-info-card">
            <div class="product-info">
                <img src="<%=ctx%>/resources/product_images/<%=product.getImageRenamedName()%>" 
                     alt="<%=product.getProductName()%>" class="product-image">
                <div class="product-details">
                    <h3><%=product.getProductName()%></h3>
                    <p>작가: <%=product.getArtistName()%></p>
                    <p>판매자: <%=product.getSellerId()%></p>
                    <div class="current-price">
                        현재가: ₩<%=df.format(product.getCurrentPrice() == 0 ? product.getStartPrice() : product.getCurrentPrice())%>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Bid History -->
        <div class="bid-history-section">
            <div class="section-header">
                <h2 class="section-title">입찰 기록 (총 <%=bidHistory != null ? bidHistory.size() : 0%>건)</h2>
            </div>
            
            <% if (bidHistory != null && !bidHistory.isEmpty()) { %>
            <table class="bid-table">
                <thead>
                    <tr>
                        <th>순위</th>
                        <th>입찰자</th>
                        <th>입찰가</th>
                        <th>입찰시간</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    // 가격순으로 정렬된 순위 매기기
                    for (int i = 0; i < bidHistory.size(); i++) {
                        BidDTO bid = bidHistory.get(i);
                        String rankClass = "";
                        if (i == 0) rankClass = "rank-1";
                        else if (i == 1) rankClass = "rank-2";
                        else if (i == 2) rankClass = "rank-3";
                        else rankClass = "rank-other";
                        
                        // 현재 최고가인지 확인
                        boolean isWinning = (i == 0 && bid.getBidPrice() == (product.getCurrentPrice() == 0 ? product.getStartPrice() : product.getCurrentPrice()));
                    %>
                    <tr <%= isWinning ? "class=\"winning-bid\"" : "" %>>
                        <td>
                            <span class="bid-rank <%=rankClass%>"><%=i+1%></span>
                        </td>
                        <td>
                            <span class="bidder-id">
                                <%= bid.getMemberId().substring(0, Math.min(3, bid.getMemberId().length())) %>***
                                <% if (isWinning) { %>
                                    <i class="fas fa-crown" style="color: #ffd700; margin-left: 4px;"></i>
                                <% } %>
                            </span>
                        </td>
                        <td>
                            <span class="bid-price">₩<%=df.format(bid.getBidPrice())%></span>
                        </td>
                        <td>
                            <span class="bid-time"><%=sdf.format(bid.getBidTime())%></span>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            <% } else { %>
            <div class="empty-state">
                <i class="fas fa-gavel"></i>
                <h3>입찰 기록이 없습니다</h3>
                <p>아직 이 상품에 입찰한 사용자가 없습니다.</p>
            </div>
            <% } %>
        </div>
        
        <a href="<%=ctx%>/product/productDetail.jsp?productId=<%=productId%>" class="back-button">
            <i class="fas fa-arrow-left"></i>
            상품으로 돌아가기
        </a>
        
        <% } else { %>
        <div class="empty-state">
            <i class="fas fa-exclamation-triangle"></i>
            <h3>상품을 찾을 수 없습니다</h3>
            <p>요청하신 상품 정보를 찾을 수 없습니다.</p>
        </div>
        <% } %>
    </div>
    
    <jsp:include page="/layout/footer/luxury-footer.jsp" />
</body>
</html>