<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="com.auction.dao.ProductDAO" %>
<%@ page import="com.auction.dto.ProductDTO" %>
<%@ page import="com.auction.dto.MemberDTO" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %>

<%
    String ctx = request.getContextPath();
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    
    // 검색 파라미터 받기
    String keyword = request.getParameter("keyword");
    String category = request.getParameter("category");
    String sortBy = request.getParameter("sortBy");
    String priceRange = request.getParameter("priceRange");
    
    if (keyword == null) keyword = "";
    if (category == null) category = "all";
    if (sortBy == null) sortBy = "latest";
    if (priceRange == null) priceRange = "all";
    
    // 검색 결과 조회
    List<ProductDTO> searchResults = new ArrayList<>();
    int totalCount = 0;
    
    Connection conn = null;
    try {
        conn = getConnection();
        ProductDAO productDao = new ProductDAO();
        
        // 키워드가 있으면 검색 실행
        if (!keyword.trim().isEmpty()) {
            searchResults = productDao.searchProducts(conn, keyword, category, sortBy, priceRange);
            totalCount = searchResults.size();
        }
        
        if (searchResults == null) {
            searchResults = new ArrayList<>();
        }
        
    } catch (Exception e) {
        e.printStackTrace();
        searchResults = new ArrayList<>();
    } finally {
        if (conn != null) close(conn);
    }
    
    // 포맷터
    DecimalFormat df = new DecimalFormat("###,###,###");
    SimpleDateFormat dateFormat = new SimpleDateFormat("MM.dd HH:mm");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>검색 결과 - M4 Auction</title>
    
    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    
    <!-- Global Styles -->
    <link rel="stylesheet" href="<%=ctx%>/resources/css/luxury-global-style.css">
    
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background: #f8f9fa;
            padding-top: 120px;
            line-height: 1.6;
        }
        
        .search-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 40px 20px;
        }
        
        .search-header {
            margin-bottom: 40px;
        }
        
        .search-title {
            font-family: 'Playfair Display', serif;
            font-size: 36px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 16px;
        }
        
        .search-subtitle {
            color: #6b7280;
            font-size: 16px;
            margin-bottom: 24px;
        }
        
        .search-summary {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 16px;
        }
        
        .search-keyword {
            font-size: 18px;
            color: #1a1a1a;
        }
        
        .search-keyword strong {
            color: #c9961a;
            font-weight: 600;
        }
        
        .search-count {
            font-size: 14px;
            color: #6b7280;
        }
        
        .search-filters {
            background: white;
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 32px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        
        .filter-row {
            display: flex;
            gap: 32px;
            flex-wrap: wrap;
            align-items: center;
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
            min-width: 60px;
        }
        
        .filter-select {
            padding: 8px 12px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 14px;
            background: white;
            color: #374151;
            cursor: pointer;
        }
        
        .filter-select:focus {
            outline: none;
            border-color: #c9961a;
        }
        
        .search-actions {
            display: flex;
            gap: 12px;
            align-items: center;
        }
        
        .search-input {
            flex: 1;
            padding: 10px 16px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 14px;
            max-width: 300px;
        }
        
        .search-btn {
            background: #c9961a;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.3s;
        }
        
        .search-btn:hover {
            background: #b8851a;
        }
        
        .reset-btn {
            background: #6b7280;
            color: white;
            border: none;
            padding: 10px 16px;
            border-radius: 6px;
            font-size: 14px;
            cursor: pointer;
            transition: background 0.3s;
        }
        
        .reset-btn:hover {
            background: #4b5563;
        }
        
        .results-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 24px;
            margin-bottom: 40px;
        }
        
        .result-card {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            transition: all 0.3s;
            cursor: pointer;
        }
        
        .result-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 24px rgba(0,0,0,0.1);
        }
        
        .result-image {
            width: 100%;
            height: 200px;
            background: #f3f4f6;
            position: relative;
            overflow: hidden;
        }
        
        .result-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .result-image-placeholder {
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            color: #9ca3af;
        }
        
        .result-image-placeholder i {
            font-size: 48px;
            margin-bottom: 8px;
        }
        
        .result-status {
            position: absolute;
            top: 12px;
            right: 12px;
            background: #16a34a;
            color: white;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
        }
        
        .result-info {
            padding: 20px;
        }
        
        .result-category {
            font-size: 11px;
            color: #c9961a;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 8px;
        }
        
        .result-title {
            font-size: 18px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 4px;
            line-height: 1.3;
        }
        
        .result-artist {
            font-size: 14px;
            color: #6b7280;
            margin-bottom: 16px;
        }
        
        .result-price {
            font-size: 20px;
            font-weight: 700;
            color: #c9961a;
            margin-bottom: 12px;
        }
        
        .result-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 12px;
            color: #9ca3af;
            margin-bottom: 16px;
        }
        
        .result-actions {
            display: flex;
            gap: 8px;
        }
        
        .view-btn {
            flex: 1;
            background: #1a1a1a;
            color: white;
            border: none;
            padding: 10px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.3s;
            text-decoration: none;
            text-align: center;
        }
        
        .view-btn:hover {
            background: #c9961a;
        }
        
        .wishlist-btn {
            background: #f3f4f6;
            border: none;
            padding: 10px 12px;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .wishlist-btn:hover {
            background: #e5e7eb;
        }
        
        .empty-state {
            text-align: center;
            padding: 80px 20px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        
        .empty-state i {
            font-size: 64px;
            color: #d1d5db;
            margin-bottom: 20px;
        }
        
        .empty-state h3 {
            font-size: 24px;
            color: #374151;
            margin-bottom: 12px;
        }
        
        .empty-state p {
            color: #6b7280;
            font-size: 16px;
            margin-bottom: 24px;
        }
        
        .empty-state .cta-btn {
            background: #c9961a;
            color: white;
            padding: 12px 24px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 600;
            transition: background 0.3s;
        }
        
        .empty-state .cta-btn:hover {
            background: #b8851a;
        }
        
        .search-suggestions {
            background: white;
            border-radius: 12px;
            padding: 24px;
            margin-top: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        
        .suggestions-title {
            font-size: 18px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 16px;
        }
        
        .suggestion-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }
        
        .suggestion-tag {
            background: #f3f4f6;
            color: #374151;
            padding: 6px 12px;
            border-radius: 16px;
            font-size: 13px;
            text-decoration: none;
            transition: all 0.3s;
        }
        
        .suggestion-tag:hover {
            background: #c9961a;
            color: white;
        }
        
        /* 반응형 */
        @media (max-width: 768px) {
            .search-container {
                padding: 20px 16px;
            }
            
            .search-title {
                font-size: 28px;
            }
            
            .search-summary {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .filter-row {
                flex-direction: column;
                gap: 16px;
                align-items: flex-start;
            }
            
            .search-actions {
                flex-direction: column;
                width: 100%;
            }
            
            .search-input {
                max-width: none;
            }
            
            .results-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/layout/header/luxury-header.jsp" />
    
    <div class="search-container">
        <!-- Search Header -->
        <div class="search-header">
            <h1 class="search-title">검색 결과</h1>
            <p class="search-subtitle">원하는 작품을 찾아보세요</p>
            
            <div class="search-summary">
                <div class="search-keyword">
                    <% if (!keyword.trim().isEmpty()) { %>
                        '<strong><%=keyword%></strong>'에 대한 검색 결과
                    <% } else { %>
                        전체 검색 결과
                    <% } %>
                </div>
                <div class="search-count">총 <%=totalCount%>개의 결과</div>
            </div>
        </div>
        
        <!-- Search Filters -->
        <div class="search-filters">
            <form method="get" action="<%=ctx%>/search/searchResult.jsp">
                <div class="filter-row">
                    <div class="filter-group">
                        <label class="filter-label">카테고리</label>
                        <select name="category" class="filter-select">
                            <option value="all" <%= "all".equals(category) ? "selected" : "" %>>전체</option>
                            <option value="회화" <%= "회화".equals(category) ? "selected" : "" %>>회화</option>
                            <option value="조각" <%= "조각".equals(category) ? "selected" : "" %>>조각</option>
                            <option value="판화" <%= "판화".equals(category) ? "selected" : "" %>>판화</option>
                            <option value="사진" <%= "사진".equals(category) ? "selected" : "" %>>사진</option>
                            <option value="추상화" <%= "추상화".equals(category) ? "selected" : "" %>>추상화</option>
                            <option value="고미술" <%= "고미술".equals(category) ? "selected" : "" %>>고미술</option>
                        </select>
                    </div>
                    
                    <div class="filter-group">
                        <label class="filter-label">정렬</label>
                        <select name="sortBy" class="filter-select">
                            <option value="latest" <%= "latest".equals(sortBy) ? "selected" : "" %>>최신순</option>
                            <option value="popular" <%= "popular".equals(sortBy) ? "selected" : "" %>>인기순</option>
                            <option value="price_low" <%= "price_low".equals(sortBy) ? "selected" : "" %>>가격 낮은순</option>
                            <option value="price_high" <%= "price_high".equals(sortBy) ? "selected" : "" %>>가격 높은순</option>
                            <option value="ending_soon" <%= "ending_soon".equals(sortBy) ? "selected" : "" %>>마감 임박순</option>
                        </select>
                    </div>
                    
                    <div class="filter-group">
                        <label class="filter-label">가격대</label>
                        <select name="priceRange" class="filter-select">
                            <option value="all" <%= "all".equals(priceRange) ? "selected" : "" %>>전체</option>
                            <option value="under_1m" <%= "under_1m".equals(priceRange) ? "selected" : "" %>>100만원 미만</option>
                            <option value="1m_5m" <%= "1m_5m".equals(priceRange) ? "selected" : "" %>>100만원 - 500만원</option>
                            <option value="5m_10m" <%= "5m_10m".equals(priceRange) ? "selected" : "" %>>500만원 - 1000만원</option>
                            <option value="over_10m" <%= "over_10m".equals(priceRange) ? "selected" : "" %>>1000만원 이상</option>
                        </select>
                    </div>
                    
                    <div class="search-actions">
                        <input type="text" name="keyword" class="search-input" 
                               placeholder="작가명, 작품명, 키워드 검색..." 
                               value="<%=keyword%>">
                        <button type="submit" class="search-btn">
                            <i class="fas fa-search"></i> 검색
                        </button>
                        <button type="button" class="reset-btn" onclick="resetFilters()">
                            <i class="fas fa-undo"></i> 초기화
                        </button>
                    </div>
                </div>
            </form>
        </div>
        
        <!-- Search Results -->
        <% if (!searchResults.isEmpty()) { %>
        <div class="results-grid">
            <% for (ProductDTO product : searchResults) { %>
            <div class="result-card" onclick="viewProduct(<%=product.getProductId()%>)">
                <div class="result-image">
                    <% if (product.getImageRenamedName() != null) { %>
                        <img src="<%=ctx%>/resources/product_images/<%=product.getImageRenamedName()%>" 
                             alt="<%=product.getProductName()%>">
                    <% } else { %>
                        <div class="result-image-placeholder">
                            <i class="fas fa-image"></i>
                            <span>이미지 없음</span>
                        </div>
                    <% } %>
                    
                    <% if ("A".equals(product.getStatus())) { %>
                        <div class="result-status">진행중</div>
                    <% } %>
                </div>
                
                <div class="result-info">
                    <div class="result-category"><%=product.getCategory() != null ? product.getCategory() : "기타"%></div>
                    <h3 class="result-title"><%=product.getProductName()%></h3>
                    <p class="result-artist"><%=product.getArtistName() != null ? product.getArtistName() : "작가 미상"%></p>
                    
                    <div class="result-price">
                        <%=df.format(product.getCurrentPrice() > 0 ? product.getCurrentPrice() : product.getStartPrice())%>원
                    </div>
                    
                    <div class="result-meta">
                        <span>시작가: <%=df.format(product.getStartPrice())%>원</span>
                        <% if (product.getEndTime() != null) { %>
                        <span><%=dateFormat.format(product.getEndTime())%> 마감</span>
                        <% } %>
                    </div>
                    
                    <div class="result-actions">
                        <a href="<%=ctx%>/product/productDetail.jsp?productId=<%=product.getProductId()%>" 
                           class="view-btn" onclick="event.stopPropagation()">
                            <i class="fas fa-eye"></i> 상세보기
                        </a>
                        <button class="wishlist-btn" onclick="event.stopPropagation(); toggleWishlist(<%=product.getProductId()%>)">
                            <i class="far fa-heart"></i>
                        </button>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
        <% } else { %>
        <div class="empty-state">
            <i class="fas fa-search"></i>
            <h3>검색 결과가 없습니다</h3>
            <% if (!keyword.trim().isEmpty()) { %>
                <p>'<%=keyword%>'에 대한 검색 결과를 찾을 수 없습니다.<br>다른 키워드로 검색해보세요.</p>
            <% } else { %>
                <p>검색어를 입력하여 원하는 작품을 찾아보세요.</p>
            <% } %>
            <a href="<%=ctx%>/auction/auctionList.jsp" class="cta-btn">
                전체 경매 보기
            </a>
        </div>
        <% } %>
        
        <!-- Search Suggestions -->
        <div class="search-suggestions">
            <h3 class="suggestions-title">추천 검색어</h3>
            <div class="suggestion-tags">
                <a href="?keyword=김환기" class="suggestion-tag">김환기</a>
                <a href="?keyword=이우환" class="suggestion-tag">이우환</a>
                <a href="?keyword=박수근" class="suggestion-tag">박수근</a>
                <a href="?keyword=이중섭" class="suggestion-tag">이중섭</a>
                <a href="?keyword=천경자" class="suggestion-tag">천경자</a>
                <a href="?keyword=회화" class="suggestion-tag">회화</a>
                <a href="?keyword=조각" class="suggestion-tag">조각</a>
                <a href="?keyword=판화" class="suggestion-tag">판화</a>
                <a href="?keyword=추상화" class="suggestion-tag">추상화</a>
                <a href="?keyword=현대미술" class="suggestion-tag">현대미술</a>
            </div>
        </div>
    </div>
    
    <jsp:include page="/layout/footer/luxury-footer.jsp" />
    
    <script>
        function viewProduct(productId) {
            location.href = '<%=ctx%>/product/productDetail.jsp?productId=' + productId;
        }
        
        function toggleWishlist(productId) {
            <% if (loginUser != null) { %>
                // 실제 위시리스트 토글 로직 구현
                console.log('Toggle wishlist for product:', productId);
                // AJAX 호출로 위시리스트 추가/제거
            <% } else { %>
                if (confirm('로그인이 필요한 서비스입니다. 로그인 페이지로 이동하시겠습니까?')) {
                    location.href = '<%=ctx%>/member/luxury-login.jsp';
                }
            <% } %>
        }
        
        function resetFilters() {
            location.href = '<%=ctx%>/search/searchResult.jsp';
        }
        
        // 필터 변경 시 자동 검색
        document.querySelectorAll('.filter-select').forEach(select => {
            select.addEventListener('change', function() {
                this.form.submit();
            });
        });
    </script>
</body>
</html>