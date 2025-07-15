<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.auction.dto.MemberDTO, com.auction.dto.ProductDTO, com.auction.dao.ProductDAO, com.auction.common.PageInfo" %>
<%@ page import="java.sql.Connection, java.text.SimpleDateFormat, java.text.DecimalFormat" %>
<%@ page import="java.util.List, static com.auction.common.JDBCTemplate.*" %>
<%
    String ctx = request.getContextPath();
    MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");
    
    // 카테고리 파라미터 받기
    String category = request.getParameter("category");
    if(category == null || category.trim().isEmpty()) {
        category = "전체";
    }
    
    // 페이징 파라미터
    int currentPage = 1;
    int pageLimit = 5;
    int boardLimit = 12;
    
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
        
        if("전체".equals(category)) {
            listCount = productDAO.selectProductCount(conn);
            pi = new PageInfo(listCount, currentPage, pageLimit, boardLimit);
            productList = productDAO.selectProductList(conn, pi);
        } else {
            listCount = productDAO.selectProductCountByCategory(conn, category);
            pi = new PageInfo(listCount, currentPage, pageLimit, boardLimit);
            productList = productDAO.selectProductListByCategory(conn, category, pi);
        }
    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        close(conn);
    }
    
    // 카테고리별 한국어 표시명
    String categoryDisplayName = category;
    switch(category) {
        case "회화": categoryDisplayName = "회화"; break;
        case "조각": categoryDisplayName = "조각"; break;
        case "판화": categoryDisplayName = "판화"; break;
        case "사진": categoryDisplayName = "사진"; break;
        case "추상화": categoryDisplayName = "추상화"; break;
        case "고미술": categoryDisplayName = "고미술"; break;
        case "전체": categoryDisplayName = "전체 경매"; break;
        default: categoryDisplayName = category; break;
    }
    
    DecimalFormat df = new DecimalFormat("###,###,###");
    SimpleDateFormat sdf = new SimpleDateFormat("MM/dd HH:mm");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%=categoryDisplayName%> - M4 Auction</title>
    
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
        
        .category-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 40px 24px;
        }
        
        .category-header {
            text-align: center;
            margin-bottom: 48px;
            position: relative;
        }
        
        .category-header-image {
            width: 100%;
            height: 300px;
            object-fit: cover;
            margin-bottom: 32px;
            border-radius: 16px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.1);
        }
        
        .category-title {
            font-family: 'Playfair Display', serif;
            font-size: 48px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 16px;
        }
        
        .category-subtitle {
            color: #6b7280;
            font-size: 18px;
            margin-bottom: 32px;
        }
        
        .category-stats {
            display: flex;
            justify-content: center;
            gap: 32px;
            flex-wrap: wrap;
        }
        
        .stat-item {
            text-align: center;
            padding: 16px 24px;
            background: white;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            min-width: 120px;
        }
        
        .stat-number {
            font-size: 24px;
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
        
        .category-nav {
            background: white;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            padding: 24px 32px;
            margin-bottom: 40px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        
        .nav-title {
            font-size: 16px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 16px;
        }
        
        .nav-links {
            display: flex;
            gap: 24px;
            flex-wrap: wrap;
        }
        
        .nav-link {
            color: #6b7280;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            padding: 8px 16px;
            border-radius: 6px;
            transition: all 0.3s ease;
            position: relative;
        }
        
        .nav-link:hover,
        .nav-link.active {
            color: #1a1a1a;
            background: #f3f4f6;
        }
        
        .nav-link.active::after {
            content: '';
            position: absolute;
            bottom: -8px;
            left: 50%;
            transform: translateX(-50%);
            width: 4px;
            height: 4px;
            background: #c9961a;
            border-radius: 50%;
        }
        
        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
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
            transform: translateY(-4px);
            box-shadow: 0 12px 32px rgba(0,0,0,0.1);
            border-color: #d1d5db;
        }
        
        .product-image {
            width: 100%;
            height: 240px;
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
            font-size: 48px;
            margin-bottom: 8px;
        }
        
        .product-status {
            position: absolute;
            top: 12px;
            right: 12px;
            background: rgba(0,0,0,0.8);
            color: white;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .status-active {
            background: #16a34a;
        }
        
        .status-ending {
            background: #dc2626;
        }
        
        .product-info {
            padding: 24px;
        }
        
        .product-category {
            font-size: 11px;
            color: #6b7280;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 8px;
        }
        
        .product-title {
            font-size: 18px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 4px;
            line-height: 1.3;
        }
        
        .product-artist {
            font-size: 14px;
            color: #6b7280;
            margin-bottom: 16px;
        }
        
        .product-price {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
        }
        
        .current-price {
            font-size: 20px;
            font-weight: 700;
            color: #c9961a;
        }
        
        .price-currency {
            font-size: 14px;
            color: #6b7280;
            margin-left: 4px;
        }
        
        .product-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 12px;
            color: #9ca3af;
            margin-bottom: 16px;
        }
        
        .view-button {
            width: 100%;
            background: #1a1a1a;
            color: white;
            border: none;
            padding: 12px;
            font-size: 14px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }
        
        .view-button:hover {
            background: #c9961a;
            transform: translateY(-1px);
        }
        
        .empty-state {
            text-align: center;
            padding: 80px 40px;
            background: white;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
        }
        
        .empty-state i {
            font-size: 64px;
            color: #e5e7eb;
            margin-bottom: 24px;
        }
        
        .empty-state h3 {
            font-size: 24px;
            color: #374151;
            margin-bottom: 8px;
        }
        
        .empty-state p {
            color: #9ca3af;
            font-size: 16px;
            margin-bottom: 24px;
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
        
        /* 반응형 */
        @media (max-width: 768px) {
            body {
                padding-top: 100px !important;
            }
            
            .category-container {
                padding: 20px 16px;
            }
            
            .category-title {
                font-size: 36px;
            }
            
            .category-stats {
                gap: 16px;
            }
            
            .nav-links {
                gap: 12px;
            }
            
            .products-grid {
                grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                gap: 20px;
            }
            
            .category-nav {
                padding: 16px 20px;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/layout/header/luxury-header.jsp" />
    
    <div class="category-container">
        <!-- Category Header -->
        <div class="category-header">
            <% if("고미술".equals(category)) { %>
                <img src="<%=ctx%>/resources/product_images/category_antique.png" 
                     alt="고미술 카테고리" 
                     class="category-header-image">
            <% } %>
            <h1 class="category-title"><%=categoryDisplayName%></h1>
            <p class="category-subtitle">최고 품질의 예술 작품을 만나보세요</p>
            
            <div class="category-stats">
                <div class="stat-item">
                    <div class="stat-number"><%=listCount%></div>
                    <div class="stat-label">총 상품</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number"><%=productList != null ? productList.size() : 0%></div>
                    <div class="stat-label">현재 페이지</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number"><%=pi != null ? pi.getMaxPage() : 1%></div>
                    <div class="stat-label">총 페이지</div>
                </div>
            </div>
        </div>
        
        <!-- Category Navigation -->
        <div class="category-nav">
            <h3 class="nav-title">카테고리 선택</h3>
            <div class="nav-links">
                <a href="?category=전체" class="nav-link <%= "전체".equals(category) ? "active" : "" %>">전체</a>
                <a href="?category=회화" class="nav-link <%= "회화".equals(category) ? "active" : "" %>">회화</a>
                <a href="?category=조각" class="nav-link <%= "조각".equals(category) ? "active" : "" %>">조각</a>
                <a href="?category=판화" class="nav-link <%= "판화".equals(category) ? "active" : "" %>">판화</a>
                <a href="?category=사진" class="nav-link <%= "사진".equals(category) ? "active" : "" %>">사진</a>
                <a href="?category=추상화" class="nav-link <%= "추상화".equals(category) ? "active" : "" %>">추상화</a>
                <a href="?category=고미술" class="nav-link <%= "고미술".equals(category) ? "active" : "" %>">고미술</a>
            </div>
        </div>
        
        <!-- Products Grid -->
        <% if(productList != null && !productList.isEmpty()) { %>
        <div class="products-grid">
            <% for(ProductDTO product : productList) { 
                // 경매 종료까지 남은 시간 계산 (간단한 로직)
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
                        <div class="product-status <%= isEndingSoon ? "status-ending" : "status-active" %>">
                            <%= isEndingSoon ? "마감임박" : "진행중" %>
                        </div>
                    <% } %>
                </div>
                
                <div class="product-info">
                    <div class="product-category"><%=product.getCategory() != null ? product.getCategory() : "기타"%></div>
                    <h3 class="product-title"><%=product.getProductName()%></h3>
                    <p class="product-artist"><%=product.getArtistName()%></p>
                    
                    <div class="product-price">
                        <span class="current-price">
                            ₩<%=df.format(product.getCurrentPrice() > 0 ? product.getCurrentPrice() : product.getStartPrice())%>
                            <span class="price-currency">원</span>
                        </span>
                    </div>
                    
                    <div class="product-meta">
                        <span>시작가: ₩<%=df.format(product.getStartPrice())%></span>
                        <% if(product.getEndTime() != null) { %>
                        <span><%=sdf.format(product.getEndTime())%> 마감</span>
                        <% } %>
                    </div>
                    
                    <a href="<%=ctx%>/product/productDetail.jsp?productId=<%=product.getProductId()%>" 
                       class="view-button">
                        <i class="fas fa-eye"></i>
                        상세보기
                    </a>
                </div>
            </div>
            <% } %>
        </div>
        <% } else { %>
        <div class="empty-state">
            <i class="fas fa-palette"></i>
            <h3>등록된 상품이 없습니다</h3>
            <p><%=categoryDisplayName%> 카테고리에 아직 경매 상품이 없습니다.</p>
            <a href="<%=ctx%>/index.jsp" class="view-button" style="max-width: 200px; margin: 0 auto;">
                메인으로 돌아가기
            </a>
        </div>
        <% } %>
        
        <!-- Pagination -->
        <% if(pi != null && pi.getMaxPage() > 1) { %>
        <div class="pagination">
            <% if(pi.getCurrentPage() > 1) { %>
                <a href="?category=<%=category%>&page=<%=pi.getCurrentPage()-1%>">
                    <i class="fas fa-chevron-left"></i>
                </a>
            <% } %>
            
            <% for(int i = 1; i <= pi.getMaxPage(); i++) { %>
                <a href="?category=<%=category%>&page=<%=i%>" 
                   class="<%= i == pi.getCurrentPage() ? "active" : "" %>">
                    <%=i%>
                </a>
            <% } %>
            
            <% if(pi.getCurrentPage() < pi.getMaxPage()) { %>
                <a href="?category=<%=category%>&page=<%=pi.getCurrentPage()+1%>">
                    <i class="fas fa-chevron-right"></i>
                </a>
            <% } %>
        </div>
        <% } %>
    </div>
    
    <jsp:include page="/layout/footer/luxury-footer.jsp" />
    
    <script>
        // 실시간 카운트다운 (선택사항)
        function updateCountdowns() {
            const now = new Date().getTime();
            
            document.querySelectorAll('.product-status').forEach(status => {
                const card = status.closest('.product-card');
                // 실제 구현 시 서버에서 종료시간을 data 속성으로 전달
            });
        }
        
        // 페이지 로드 시 실행
        document.addEventListener('DOMContentLoaded', function() {
            // 카테고리 활성화 표시
            const activeLink = document.querySelector('.nav-link.active');
            if(activeLink) {
                activeLink.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
            }
        });
    </script>
</body>
</html>