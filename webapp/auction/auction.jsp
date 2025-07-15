<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="com.auction.dto.*" %>
<%@ page import="com.auction.dao.*" %>
<%@ page import="com.auction.common.PageInfo" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %>
<%
    // 세션 체크
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    String ctx = request.getContextPath();
    
    // ⭐ 팀원이 만든 검색 기능 코드 합치기 ⭐
    // 파라미터
    String keyword = request.getParameter("keyword");
    String category = request.getParameter("category");
    if (keyword == null) keyword = "";
    if (category == null) category = "all";

    // 페이징 설정
    int currentPage = 1, pageLimit = 5, boardLimit = 12, listCount;
    
    Connection conn = getConnection();
    
    // 검색어나 카테고리에 따라 다른 카운트 가져오기
    if (!keyword.isEmpty()) {
        listCount = new ProductDAO().searchProductCount(conn, keyword);
    } else if (!"all".equals(category)) {
        listCount = new ProductDAO().selectProductCountByCategory(conn, category);
    } else {
        listCount = new ProductDAO().selectProductCount(conn);
    }
    
    if (request.getParameter("page") != null) {
        currentPage = Integer.parseInt(request.getParameter("page"));
    }
    
    PageInfo pi = new PageInfo(listCount, currentPage, pageLimit, boardLimit);

    // DAO 호출
    List<ProductDTO> productList;
    if (!keyword.isEmpty()) {
        productList = new ProductDAO().searchProductList(conn, keyword, pi);
    } else if (!"all".equals(category)) {
        productList = new ProductDAO().selectProductListByCategory(conn, category, pi);
    } else {
        productList = new ProductDAO().selectProductList(conn, pi);
    }
    
    // ScheduleDAO가 있다면 사용, 없으면 주석처리
    // List<ScheduleDTO> scheduleList = new ScheduleDAO().selectAllSchedules(conn);
    
    close(conn);

    // 포맷터
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
    SimpleDateFormat sdf2 = new SimpleDateFormat("MM/dd HH:mm");
    DecimalFormat df = new DecimalFormat("###,###,###");
    Date now = new Date();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Auction - M4 Auction</title>
    
    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700;900&family=Poppins:wght@300;400;500;600;700&family=Noto+Sans+KR:wght@300;400;500;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    
    <!-- CSS -->
    <link rel="stylesheet" href="<%=ctx%>/resources/css/luxury-global-style.css">
    
    <style>
        
        /* 기존 스타일 유지 */
        body {
            padding-top: 120px !important;
            background: #f8f8f8;
        }
        
        .auction-wrapper {
            min-height: calc(100vh - 320px);
            padding: 40px 0 80px;
        }
        
        .page-header {
            background: white;
            padding: 60px 0;
            margin-bottom: 50px;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        
        .page-title {
            font-family: 'Playfair Display', serif;
            font-size: 48px;
            color: #1a1a1a;
            margin-bottom: 10px;
        }
        
        .page-subtitle {
            color: #666;
            font-size: 18px;
        }
        
        /* ⭐ 검색 영역 스타일 추가 ⭐ */
        .search-section {
            background: white;
            padding: 40px 0;
            margin-bottom: 50px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        
        .search-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }
        
        .search-form {
            display: flex;
            gap: 15px;
            justify-content: center;
            align-items: center;
            flex-wrap: wrap;
        }
        
        .search-select {
            padding: 15px 20px;
            border: 2px solid #e5e5e5;
            background: white;
            font-size: 16px;
            min-width: 150px;
            transition: all 0.3s;
        }
        
        .search-select:focus {
            outline: none;
            border-color: #c9961a;
        }
        
        /* 수정된 검색 입력창 스타일 */
        .search-input-wrapper {
    		position: relative;
    		display: inline-block;
    		width: 500px;
		}
        
        .search-input {
    		padding: 15px 60px 15px 20px; /* 오른쪽 패딩 줄임 */
    		border: 1px solid #e5e5e5; /* 테두리 얇게 */
    		background: #f8f8f8; /* 연한 회색 배경 */
    		font-size: 16px;
    		width: 100%;
    		transition: all 0.3s;
    		border-radius: 50px; /* 완전 둥글게 */
		}
        
        .search-input:focus {
    		outline: none;
    		border-color: #c9961a;
    		background: white;
		}
        
        .search-btn {
    		position: absolute;
    		right: 8px;
    		top: 50%;
    		transform: translateY(-50%);
    		width: 40px; /* 정사각형 버튼 */
    		height: 40px;
    		background: transparent; /* 투명 배경 */
    		color: #c9961a; /* 금색 아이콘 */
    		border: none;
    		font-size: 18px;
    		cursor: pointer;
    		transition: all 0.3s;
    		display: flex;
    		align-items: center;
    		justify-content: center;
    		border-radius: 50%; /* 동그란 버튼 */
		}

		.search-btn:hover {
    		background: #f0f0f0;
		}

		/* span 텍스트 숨기기 */
		.search-btn span {
    		display: none;
		}
        
        .reset-btn {
            padding: 15px 25px;
            background: #666;
            color: white;
            border: none;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }
        
        .reset-btn:hover {
            background: #444;
        }
        
        .search-result {
            text-align: center;
            margin-top: 30px;
            font-size: 16px;
            color: #666;
        }
        
        .search-result .keyword {
            color: #c9961a;
            font-weight: 700;
            font-size: 18px;
        }
        
        .search-result .count {
            font-weight: 700;
            color: #1a1a1a;
        }
        
        /* 기존 상품 그리드 스타일 */
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 30px;
            margin-bottom: 60px;
        }
        
        .product-card {
            background: white;
            overflow: hidden;
            transition: all 0.3s;
            cursor: pointer;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        
        .product-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        }
        
        .product-image {
            position: relative;
            height: 350px;
            overflow: hidden;
        }
        
        .product-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s;
        }
        
        .product-card:hover .product-image img {
            transform: scale(1.1);
        }
        
        .auction-badge {
            position: absolute;
            top: 20px;
            right: 20px;
            padding: 8px 16px;
            background: #c9961a;
            color: white;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .product-info {
            padding: 30px;
        }
        
        .product-category {
            font-size: 12px;
            color: #999;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 10px;
        }
        
        .product-title {
            font-size: 20px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 15px;
            line-height: 1.4;
        }
        
        .product-details {
            font-size: 14px;
            color: #666;
            margin-bottom: 20px;
            line-height: 1.6;
        }
        
        .price-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        
        .current-price {
            font-size: 24px;
            font-weight: 700;
            color: #c9961a;
        }
        
        .end-time {
            font-size: 14px;
            color: #666;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .end-time i {
            font-size: 12px;
        }
        
        /* 페이지네이션 */
        .pagination {
            display: flex;
            justify-content: center;
            gap: 5px;
            margin-top: 60px;
        }
        
        .page-btn {
            padding: 10px 15px;
            border: 1px solid #e5e5e5;
            background: white;
            color: #666;
            text-decoration: none;
            transition: all 0.3s;
            min-width: 40px;
            text-align: center;
        }
        
        .page-btn:hover {
            border-color: #c9961a;
            color: #c9961a;
        }
        
        .page-btn.active {
            background: #1a1a1a;
            color: white;
            border-color: #1a1a1a;
        }
        
        .page-btn.disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }
        
        /* 데이터 없을 때 */
        .empty-state {
            text-align: center;
            padding: 100px 20px;
            color: #999;
        }
        
        .empty-state i {
            font-size: 64px;
            margin-bottom: 20px;
            opacity: 0.3;
        }
        
        .empty-state h3 {
            font-size: 24px;
            margin-bottom: 10px;
            color: #666;
        }
        
        /* 반응형 */
        @media (max-width: 768px) {
            .search-form {
                flex-direction: column;
                width: 100%;
            }
            
            .search-input-wrapper,
            .search-select {
                width: 100%;
            }
            
            .product-grid {
                grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
                gap: 20px;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <jsp:include page="/layout/header/luxury-header.jsp" />
    
    <div class="auction-wrapper">
        <!-- Page Header -->
        <div class="page-header">
            <div class="container">
                <h1 class="page-title">Auction</h1>
                <p class="page-subtitle">최고의 예술 작품을 만나보세요</p>
            </div>
        </div>
        
        <!-- ⭐ 검색 영역 추가 ⭐ -->
        <div class="search-section">
            <div class="search-container">
                <form action="auction.jsp" method="get" class="search-form">
                    <select name="category" class="search-select">
                        <option value="all" <%= "all".equals(category) ? "selected" : "" %>>전체 카테고리</option>
                        <option value="painting" <%= "painting".equals(category) ? "selected" : "" %>>회화</option>
                        <option value="sculpture" <%= "sculpture".equals(category) ? "selected" : "" %>>조각</option>
                        <option value="photography" <%= "photography".equals(category) ? "selected" : "" %>>사진</option>
                        <option value="jewelry" <%= "jewelry".equals(category) ? "selected" : "" %>>주얼리</option>
                        <option value="antique" <%= "antique".equals(category) ? "selected" : "" %>>골동품</option>
                    </select>
                    
                    <div class="search-input-wrapper">
                        <input type="text" name="keyword" value="<%= keyword %>" 
                               placeholder="작품명, 작가명으로 검색하세요" 
                               class="search-input">
                        <button type="submit" class="search-btn">
                            <i class="fas fa-search"></i>
                            <span>검색</span>
                        </button>
                    </div>
                    
                    <% if(!keyword.isEmpty() || !"all".equals(category)) { %>
                    <a href="auction.jsp" class="reset-btn">
                        <i class="fas fa-redo"></i> 초기화
                    </a>
                    <% } %>
                </form>
                
                <% if(!keyword.isEmpty()) { %>
                <div class="search-result">
                    <span class="keyword">'<%= keyword %>'</span> 검색 결과: 
                    <span class="count"><%= listCount %></span>건
                </div>
                <% } %>
            </div>
        </div>
        
        <!-- Products Grid -->
        <div class="container">
            <% if(productList != null && !productList.isEmpty()) { %>
            <div class="product-grid">
                <% for(ProductDTO product : productList) { 
                    // 경매 종료 시간 계산 (디버깅 코드 추가)
                    long timeLeft = 0;
                    long daysLeft = 0;
                    long hoursLeft = 0;
                    boolean isAuctionEnded = false;
                    
                    // 디버깅 정보 출력
                    System.out.println("=== 디버깅 정보 ===");
                    System.out.println("상품명: " + product.getProductName());
                    System.out.println("현재시간: " + now);
                    System.out.println("종료시간: " + product.getEndTime());
                    System.out.println("상품상태: " + product.getStatus());
                    
                    if (product.getEndTime() != null) {
                        timeLeft = product.getEndTime().getTime() - now.getTime();
                        daysLeft = timeLeft / (1000 * 60 * 60 * 24);
                        hoursLeft = (timeLeft % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60);
                        isAuctionEnded = timeLeft <= 0;
                        
                        System.out.println("시간차이(ms): " + timeLeft);
                        System.out.println("남은일수: " + daysLeft);
                        System.out.println("남은시간: " + hoursLeft);
                        System.out.println("종료여부: " + isAuctionEnded);
                    } else {
                        isAuctionEnded = true; // 종료 시간이 없으면 종료로 간주
                        System.out.println("종료시간이 NULL이므로 종료로 간주");
                    }
                    System.out.println("===================");
                %>
                <div class="product-card" onclick="location.href='<%=ctx%>/product/productDetail.jsp?productId=<%= product.getProductId() %>'">
                    <div class="product-image">
                        <img src="<%=ctx%>/resources/product_images/<%= product.getImageRenamedName() %>" 
                             alt="<%= product.getProductName() %>">
                        <span class="auction-badge">
                            <% if("A".equals(product.getStatus())) { %>경매중<% } 
                               else if("E".equals(product.getStatus())) { %>종료<% } 
                               else { %>준비중<% } %>
                        </span>
                    </div>
                    <div class="product-info">
                        <p class="product-category"><%= product.getCategory() != null ? product.getCategory() : "미분류" %></p>
                        <h3 class="product-title"><%= product.getProductName() %></h3>
                        <p class="product-details">
                            작가: <%= product.getArtistName() != null ? product.getArtistName() : "Unknown" %>
                        </p>
                        <div class="auction-price">
                            <div class="price-info">
                                <span class="start-price">시작가: ₩<%= df.format(product.getStartPrice()) %></span>
                                <% if(product.getCurrentPrice() > 0 && product.getCurrentPrice() != product.getStartPrice()) { %>
                                    <span class="current-price">현재가: ₩<%= df.format(product.getCurrentPrice()) %></span>
                                <% } %>
                            </div>
                        </div>
                        <div class="price-info">
                            <span class="end-time">
                                <% if("A".equals(product.getStatus())) { %>
                                    <i class="fas fa-clock"></i> 경매 진행중
                                <% } else { %>
                                    <i class="fas fa-ban"></i> 경매 종료
                                <% } %>
                            </span>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
            
            <!-- Pagination -->
            <div class="pagination">
                <% if(pi.getCurrentPage() > 1) { %>
                <a href="auction.jsp?page=<%= pi.getCurrentPage() - 1 %>&keyword=<%= keyword %>&category=<%= category %>" 
                   class="page-btn">
                    <i class="fas fa-chevron-left"></i>
                </a>
                <% } %>
                
                <% for(int p = pi.getStartPage(); p <= pi.getEndPage(); p++) { %>
                <a href="auction.jsp?page=<%= p %>&keyword=<%= keyword %>&category=<%= category %>" 
                   class="page-btn <%= p == pi.getCurrentPage() ? "active" : "" %>">
                    <%= p %>
                </a>
                <% } %>
                
                <% if(pi.getCurrentPage() < pi.getMaxPage()) { %>
                <a href="auction.jsp?page=<%= pi.getCurrentPage() + 1 %>&keyword=<%= keyword %>&category=<%= category %>" 
                   class="page-btn">
                    <i class="fas fa-chevron-right"></i>
                </a>
                <% } %>
            </div>
            
            <% } else { %>
            <!-- Empty State -->
            <div class="empty-state">
                <i class="fas fa-search"></i>
                <h3>검색 결과가 없습니다</h3>
                <p>다른 검색어로 시도해보세요</p>
            </div>
            <% } %>
        </div>
    </div>
    
    <!-- Footer -->
    <jsp:include page="/layout/footer/luxury-footer.jsp" />
</body>
</html>