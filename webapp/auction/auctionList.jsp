<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.auction.dto.MemberDTO, com.auction.dto.ProductDTO, com.auction.dao.ProductDAO, com.auction.common.PageInfo" %>
<%@ page import="java.sql.Connection, java.text.SimpleDateFormat, java.text.DecimalFormat" %>
<%@ page import="java.util.List, static com.auction.common.JDBCTemplate.*" %>
<%
    String ctx = request.getContextPath();
    MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");
    
    // 필터 파라미터
    String type = request.getParameter("type"); // premium, weekly, zerobase
    String status = request.getParameter("status"); // upcoming, past
    
    // 페이징 파라미터
    int currentPage = 1;
    int pageLimit = 5;
    int boardLimit = 16;
    
    if(request.getParameter("page") != null) {
        currentPage = Integer.parseInt(request.getParameter("page"));
    }
    
    // 데이터 조회
    List<ProductDTO> productList = null;
    PageInfo pi = null;
    int listCount = 0;
    
    Connection conn = getConnection();
    try {
        ProductDAO productDAO = new ProductDAO();
        
        // 필터에 따른 데이터 조회
        if (type != null) {
            // 경매 타입별 조회
            if ("premium".equals(type)) {
                productList = productDAO.selectPremiumAuctions(conn);
                listCount = productList.size();
            } else if ("weekly".equals(type)) {
                productList = productDAO.selectWeeklyAuctions(conn);
                listCount = productList.size();
            } else if ("zerobase".equals(type)) {
                productList = productDAO.selectZerobaseAuctions(conn);
                listCount = productList.size();
            } else {
                listCount = productDAO.selectProductCount(conn);
                pi = new PageInfo(listCount, currentPage, pageLimit, boardLimit);
                productList = productDAO.selectProductList(conn, pi);
            }
        } else if (status != null) {
            // 경매 상태별 조회
            if ("upcoming".equals(status)) {
                productList = productDAO.selectUpcomingAuctions(conn, "P", 0); // P: 예정
                listCount = productList.size();
            } else if ("past".equals(status)) {
                productList = productDAO.selectUpcomingAuctions(conn, "E", 0); // E: 종료
                listCount = productList.size();
            } else {
                listCount = productDAO.selectProductCount(conn);
                pi = new PageInfo(listCount, currentPage, pageLimit, boardLimit);
                productList = productDAO.selectProductList(conn, pi);
            }
        } else {
            // 기본 전체 조회
            listCount = productDAO.selectProductCount(conn);
            pi = new PageInfo(listCount, currentPage, pageLimit, boardLimit);
            productList = productDAO.selectProductList(conn, pi);
        }
        
        if (pi == null) {
            pi = new PageInfo(listCount, currentPage, pageLimit, boardLimit);
        }
        
    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        close(conn);
    }
    
    DecimalFormat df = new DecimalFormat("###,###,###");
    SimpleDateFormat sdf = new SimpleDateFormat("MM/dd HH:mm");
    
    // 페이지 제목 설정
    String pageTitle = "전체 경매";
    if (type != null) {
        switch (type) {
            case "premium": pageTitle = "프리미엄 온라인 경매"; break;
            case "weekly": pageTitle = "위클리 온라인 경매"; break;
            case "zerobase": pageTitle = "제로베이스 경매"; break;
        }
    } else if (status != null) {
        switch (status) {
            case "upcoming": pageTitle = "예정 경매"; break;
            case "past": pageTitle = "지난 경매"; break;
        }
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%=pageTitle%> - M4 Auction</title>
    
    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    
    <!-- Global Styles -->
    <link rel="stylesheet" href="<%=ctx%>/resources/css/luxury-global-style.css">
    
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background: #f8f9fa;
            padding-top: 120px !important;
            line-height: 1.6;
        }
        
        .auction-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 40px 24px;
        }
        
        .auction-header {
            text-align: center;
            margin-bottom: 48px;
        }
        
        .auction-title {
            font-family: 'Playfair Display', serif;
            font-size: 48px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 16px;
        }
        
        .auction-subtitle {
            color: #6b7280;
            font-size: 18px;
        }
        
        /* 타입별 차별화 스타일 */
        .auction-type-badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            margin-bottom: 20px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .auction-type-premium {
            background: linear-gradient(135deg, #c9961a 0%, #d4af37 100%);
            color: white;
        }
        
        .auction-type-weekly {
            background: linear-gradient(135deg, #059669 0%, #10b981 100%);
            color: white;
        }
        
        .auction-type-zerobase {
            background: linear-gradient(135deg, #dc2626 0%, #ef4444 100%);
            color: white;
        }
        
        /* 타입별 제목 색상 */
        .auction-header.premium .auction-title {
            background: linear-gradient(45deg, #c9961a, #d4af37);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .auction-header.weekly .auction-title {
            background: linear-gradient(45deg, #059669, #10b981);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .auction-header.zerobase .auction-title {
            background: linear-gradient(45deg, #dc2626, #ef4444);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        /* 제품 카드 타입별 배지 */
        .product-type-badge {
            position: absolute;
            top: 12px;
            left: 12px;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 10px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .product-type-premium {
            background: linear-gradient(135deg, #c9961a 0%, #d4af37 100%);
            color: white;
        }
        
        .product-type-weekly {
            background: linear-gradient(135deg, #059669 0%, #10b981 100%);
            color: white;
        }
        
        .product-type-zerobase {
            background: linear-gradient(135deg, #dc2626 0%, #ef4444 100%);
            color: white;
        }
        
        /* 제품 통계 정보 */
        .product-stats {
            display: flex;
            gap: 12px;
            margin-bottom: 16px;
            flex-wrap: wrap;
        }
        
        .stat-item {
            display: flex;
            align-items: center;
            gap: 4px;
            padding: 4px 8px;
            background: #f3f4f6;
            border-radius: 12px;
            font-size: 12px;
            color: #666;
        }
        
        .stat-item i {
            font-size: 11px;
        }
        
        /* 타입별 제품 카드 hover 효과 */
        .auction-container.premium .product-card:hover {
            border-color: #c9961a;
            box-shadow: 0 8px 32px rgba(201, 150, 26, 0.15);
        }
        
        .auction-container.weekly .product-card:hover {
            border-color: #059669;
            box-shadow: 0 8px 32px rgba(5, 150, 105, 0.15);
        }
        
        .auction-container.zerobase .product-card:hover {
            border-color: #dc2626;
            box-shadow: 0 8px 32px rgba(220, 38, 38, 0.15);
        }
        
        /* 찜 버튼 스타일 */
        .wishlist-btn {
            position: absolute;
            bottom: 12px;
            right: 12px;
            background: rgba(255, 255, 255, 0.9);
            border: none;
            width: 36px;
            height: 36px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
            z-index: 3;
            backdrop-filter: blur(10px);
        }
        
        .wishlist-btn:hover {
            background: rgba(255, 255, 255, 1);
            transform: scale(1.1);
        }
        
        .wishlist-btn i {
            font-size: 16px;
            color: #666;
            transition: all 0.3s ease;
        }
        
        .wishlist-btn:hover i {
            color: #dc2626;
        }
        
        .wishlist-btn.wishlisted i {
            color: #dc2626;
        }
        
        .filter-bar {
            background: white;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            padding: 24px 32px;
            margin-bottom: 40px;
            display: flex;
            gap: 24px;
            align-items: center;
            flex-wrap: wrap;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        
        .filter-group {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .filter-label {
            font-size: 14px;
            font-weight: 600;
            color: #374151;
        }
        
        .filter-select {
            padding: 8px 12px;
            border: 2px solid #e5e7eb;
            border-radius: 6px;
            font-size: 14px;
            background: white;
            min-width: 120px;
        }
        
        .auction-stats {
            display: flex;
            justify-content: center;
            gap: 32px;
            margin-bottom: 40px;
            flex-wrap: wrap;
        }
        
        .stat-card {
            background: white;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            padding: 20px 24px;
            text-align: center;
            min-width: 140px;
        }
        
        .stat-number {
            font-size: 28px;
            font-weight: 700;
            color: #c9961a;
            margin-bottom: 4px;
        }
        
        .stat-label {
            font-size: 12px;
            color: #6b7280;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 32px;
            margin-bottom: 48px;
        }
        
        .product-card {
            background: white;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            overflow: hidden;
            transition: all 0.3s ease;
            position: relative;
        }
        
        .product-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 16px 40px rgba(0,0,0,0.12);
            border-color: #d1d5db;
        }
        
        .product-image {
            width: 100%;
            height: 280px;
            background: #f8f9fa;
            position: relative;
            overflow: hidden;
        }
        
        .product-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }
        
        .product-card:hover .product-image img {
            transform: scale(1.05);
        }
        
        .product-image-placeholder {
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            color: #9ca3af;
            background: #f3f4f6;
        }
        
        .product-image-placeholder i {
            font-size: 64px;
            margin-bottom: 12px;
        }
        
        .product-status {
            position: absolute;
            top: 16px;
            right: 16px;
            background: rgba(22, 163, 74, 0.9);
            color: white;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            backdrop-filter: blur(10px);
        }
        
        .status-ending {
            background: rgba(220, 38, 38, 0.9);
        }
        
        .product-info {
            padding: 28px;
        }
        
        .product-category {
            font-size: 11px;
            color: #6b7280;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            margin-bottom: 12px;
            font-weight: 600;
        }
        
        .product-title {
            font-family: 'Playfair Display', serif;
            font-size: 20px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 6px;
            line-height: 1.3;
        }
        
        .product-artist {
            font-size: 14px;
            color: #6b7280;
            margin-bottom: 20px;
            font-style: italic;
        }
        
        .product-price {
            margin-bottom: 20px;
        }
        
        .current-price {
            font-size: 24px;
            font-weight: 700;
            color: #c9961a;
            margin-bottom: 4px;
        }
        
        .start-price {
            font-size: 12px;
            color: #9ca3af;
        }
        
        .product-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 11px;
            color: #9ca3af;
            margin-bottom: 20px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .view-button {
            width: 100%;
            background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
            color: white;
            border: none;
            padding: 14px;
            font-size: 14px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }
        
        .view-button:hover {
            background: linear-gradient(135deg, #c9961a 0%, #d4af37 100%);
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(201, 150, 26, 0.3);
        }
        
        .pagination {
            display: flex;
            justify-content: center;
            gap: 8px;
            margin-top: 48px;
        }
        
        .pagination a {
            padding: 12px 16px;
            background: white;
            border: 2px solid #e5e7eb;
            color: #6b7280;
            text-decoration: none;
            border-radius: 6px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .pagination a:hover,
        .pagination a.active {
            background: #1a1a1a;
            color: white;
            border-color: #1a1a1a;
        }
        
        .empty-state {
            text-align: center;
            padding: 80px 40px;
            background: white;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
        }
        
        .empty-state i {
            font-size: 80px;
            color: #e5e7eb;
            margin-bottom: 32px;
        }
        
        .empty-state h3 {
            font-size: 28px;
            color: #374151;
            margin-bottom: 12px;
        }
        
        .empty-state p {
            color: #9ca3af;
            font-size: 16px;
            margin-bottom: 32px;
        }
        
        /* 반응형 */
        @media (max-width: 768px) {
            body {
                padding-top: 100px !important;
            }
            
            .auction-container {
                padding: 20px 16px;
            }
            
            .auction-title {
                font-size: 36px;
            }
            
            .filter-bar {
                padding: 16px 20px;
                flex-direction: column;
                align-items: stretch;
            }
            
            .auction-stats {
                gap: 16px;
            }
            
            .products-grid {
                grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                gap: 20px;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/layout/header/luxury-header.jsp" />
    
    <div class="auction-container <%= type != null ? type : "" %>">
        <!-- Header -->
        <div class="auction-header <%= type != null ? type : "" %>">
            <% if (type != null) { %>
                <div class="auction-type-badge auction-type-<%=type%>">
                    <%= type.equals("premium") ? "Premium Auction" : 
                        type.equals("weekly") ? "Weekly Auction" : 
                        type.equals("zerobase") ? "Zero Base Auction" : "Auction" %>
                </div>
            <% } %>
            <h1 class="auction-title"><%=pageTitle%></h1>
            <p class="auction-subtitle">
                <% if (type != null) { %>
                    <%= type.equals("premium") ? "최고 품질의 프리미엄 작품들을 만나보세요" : 
                        type.equals("weekly") ? "매주 진행되는 다양한 장르의 경매입니다" : 
                        type.equals("zerobase") ? "합리적인 가격으로 시작하는 기회의 경매입니다" : "현재 진행중인 모든 경매를 확인하세요" %>
                <% } else if (status != null) { %>
                    <%= status.equals("upcoming") ? "곧 시작될 예정인 경매 목록입니다" : 
                        status.equals("past") ? "지난 경매 결과를 확인하세요" : "현재 진행중인 모든 경매를 확인하세요" %>
                <% } else { %>
                    현재 진행중인 모든 경매를 확인하세요
                <% } %>
            </p>
        </div>
        
        <!-- Filter Bar -->
        <div class="filter-bar">
            <div class="filter-group">
                <span class="filter-label">정렬</span>
                <select class="filter-select" onchange="sortProducts(this.value)">
                    <option value="latest">최신순</option>
                    <option value="price-low">낮은 가격순</option>
                    <option value="price-high">높은 가격순</option>
                    <option value="ending">마감 임박순</option>
                </select>
            </div>
            
            <div class="filter-group">
                <span class="filter-label">카테고리</span>
                <select class="filter-select" onchange="filterByCategory(this.value)">
                    <option value="">전체</option>
                    <option value="회화">회화</option>
                    <option value="조각">조각</option>
                    <option value="판화">판화</option>
                    <option value="사진">사진</option>
                    <option value="추상화">추상화</option>
                    <option value="고미술">고미술</option>
                </select>
            </div>
            
            <div class="filter-group">
                <span class="filter-label">가격대</span>
                <select class="filter-select" onchange="filterByPrice(this.value)">
                    <option value="">전체</option>
                    <option value="0-100000">10만원 이하</option>
                    <option value="100000-500000">10만원 - 50만원</option>
                    <option value="500000-1000000">50만원 - 100만원</option>
                    <option value="1000000-">100만원 이상</option>
                </select>
            </div>
        </div>
        
        <!-- Statistics -->
        <div class="auction-stats">
            <div class="stat-card">
                <div class="stat-number"><%=listCount%></div>
                <div class="stat-label">총 경매</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><%=productList != null ? productList.size() : 0%></div>
                <div class="stat-label">현재 페이지</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><%=pi != null ? pi.getMaxPage() : 1%></div>
                <div class="stat-label">총 페이지</div>
            </div>
        </div>
        
        <!-- Products Grid -->
        <% if(productList != null && !productList.isEmpty()) { %>
        <div class="products-grid">
            <% for(ProductDTO product : productList) { 
                // 경매 종료까지 남은 시간 계산
                boolean isEndingSoon = false;
                if(product.getEndTime() != null) {
                    long timeLeft = product.getEndTime().getTime() - System.currentTimeMillis();
                    isEndingSoon = timeLeft > 0 && timeLeft < 24 * 60 * 60 * 1000; // 24시간 미만
                }
            %>
            <div class="product-card">
                <div class="product-image">
                    <% if(product.getImageRenamedName() != null) { %>
                        <img src="<%=ctx%>/resources/product_images/<%=product.getImageRenamedName()%>" 
                             alt="<%=product.getProductName()%>">
                    <% } else { %>
                        <div class="product-image-placeholder">
                            <i class="fas fa-image"></i>
                            <span>이미지 없음</span>
                        </div>
                    <% } %>
                    
                    <% if("A".equals(product.getStatus())) { %>
                        <div class="product-status <%= isEndingSoon ? "status-ending" : "" %>">
                            <%= isEndingSoon ? "마감임박" : "진행중" %>
                        </div>
                    <% } %>
                    
                    <!-- 타입별 배지 -->
                    <% if (type != null) { %>
                        <div class="product-type-badge product-type-<%=type%>">
                            <%= type.equals("premium") ? "PREMIUM" : 
                                type.equals("weekly") ? "WEEKLY" : 
                                type.equals("zerobase") ? "ZERO BASE" : "" %>
                        </div>
                    <% } %>
                    
                    <!-- 찜 버튼 -->
                    <button class="wishlist-btn" data-product-id="<%=product.getProductId()%>" title="찜 추가">
                        <i class="far fa-heart"></i>
                    </button>
                </div>
                
                <div class="product-info">
                    <div class="product-category"><%=product.getCategory() != null ? product.getCategory() : "기타"%></div>
                    <h3 class="product-title"><%=product.getProductName()%></h3>
                    <p class="product-artist"><%=product.getArtistName()%></p>
                    
                    <div class="product-price">
                        <% if(product.getCurrentPrice() > 0 && product.getCurrentPrice() != product.getStartPrice()) { %>
                            <div class="current-price">
                                현재가: ₩<%=df.format(product.getCurrentPrice())%>
                            </div>
                            <div class="start-price">시작가: ₩<%=df.format(product.getStartPrice())%></div>
                        <% } else { %>
                            <div class="current-price">
                                시작가: ₩<%=df.format(product.getStartPrice())%>
                            </div>
                        <% } %>
                    </div>
                    
                    <!-- 타입별 추가 정보 -->
                    <% if (type != null) { %>
                        <div class="product-stats">
                            <% if ("premium".equals(type)) { %>
                                <div class="stat-item">
                                    <i class="fas fa-eye"></i>
                                    <span><%=product.getViewCount()%></span>
                                </div>
                                <div class="stat-item">
                                    <i class="fas fa-gavel"></i>
                                    <span><%=product.getBidCount()%></span>
                                </div>
                                <div class="stat-item">
                                    <i class="fas fa-star"></i>
                                    <span>프리미엄</span>
                                </div>
                            <% } else if ("weekly".equals(type)) { %>
                                <div class="stat-item">
                                    <i class="fas fa-clock"></i>
                                    <span>위클리</span>
                                </div>
                                <div class="stat-item">
                                    <i class="fas fa-gavel"></i>
                                    <span><%=product.getBidCount()%></span>
                                </div>
                            <% } else if ("zerobase".equals(type)) { %>
                                <div class="stat-item">
                                    <i class="fas fa-arrow-up"></i>
                                    <span>저가시작</span>
                                </div>
                                <div class="stat-item">
                                    <i class="fas fa-users"></i>
                                    <span><%=product.getBidCount()%></span>
                                </div>
                            <% } %>
                        </div>
                    <% } %>
                    
                    <div class="product-meta">
                        <span>판매자: <%=product.getSellerId()%></span>
                        <% if(product.getEndTime() != null) { %>
                        <span><%=sdf.format(product.getEndTime())%> 마감</span>
                        <% } %>
                    </div>
                    
                    <div class="product-actions">
                        <a href="<%=ctx%>/product/productDetail.jsp?productId=<%=product.getProductId()%>" 
                           class="view-button">
                            <i class="fas fa-gavel"></i>
                            경매 참여하기
                        </a>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
        <% } else { %>
        <div class="empty-state">
            <i class="fas fa-gavel"></i>
            <h3>진행중인 경매가 없습니다</h3>
            <p>새로운 경매가 곧 시작됩니다. 조금만 기다려주세요!</p>
            <a href="<%=ctx%>/index.jsp" class="view-button" style="max-width: 200px; margin: 0 auto;">
                메인으로 돌아가기
            </a>
        </div>
        <% } %>
        
        <!-- Pagination -->
        <% if(pi != null && pi.getMaxPage() > 1) { %>
        <div class="pagination">
            <% if(pi.getCurrentPage() > 1) { %>
                <a href="?page=<%=pi.getCurrentPage()-1%>">
                    <i class="fas fa-chevron-left"></i>
                </a>
            <% } %>
            
            <% for(int i = 1; i <= pi.getMaxPage(); i++) { %>
                <a href="?page=<%=i%>" 
                   class="<%= i == pi.getCurrentPage() ? "active" : "" %>">
                    <%=i%>
                </a>
            <% } %>
            
            <% if(pi.getCurrentPage() < pi.getMaxPage()) { %>
                <a href="?page=<%=pi.getCurrentPage()+1%>">
                    <i class="fas fa-chevron-right"></i>
                </a>
            <% } %>
        </div>
        <% } %>
    </div>
    
    <jsp:include page="/layout/footer/luxury-footer.jsp" />
    
    <!-- 찜 기능 JavaScript -->
    <script src="<%=ctx%>/resources/js/wishlist.js"></script>
    
    <script>
        // 이미지 로드 실패시 대체 이미지로 변경
        document.addEventListener('DOMContentLoaded', function() {
            const images = document.querySelectorAll('img');
            images.forEach(img => {
                img.onerror = function() {
                    const placeholders = [
                        'https://images.unsplash.com/photo-1578321272176-b7bbc0679853?q=80&w=600',
                        'https://images.unsplash.com/photo-1549887534-1541e9326642?q=80&w=600',
                        'https://images.unsplash.com/photo-1561214115-f2f134cc4912?q=80&w=600'
                    ];
                    const randomIndex = Math.floor(Math.random() * placeholders.length);
                    this.src = placeholders[randomIndex];
                    this.onerror = null;
                };
            });
        });
        
        function sortProducts(value) {
            // 정렬 기능 구현 (서버사이드에서 처리하거나 클라이언트에서 정렬)
            window.location.href = '?sort=' + value;
        }
        
        function filterByCategory(category) {
            if(category) {
                window.location.href = '<%=ctx%>/category/categoryList.jsp?category=' + category;
            } else {
                window.location.href = '<%=ctx%>/auction/auctionList.jsp';
            }
        }
        
        function filterByPrice(priceRange) {
            // 가격대 필터 구현
            window.location.href = '?priceRange=' + priceRange;
        }
    </script>
</body>
</html>