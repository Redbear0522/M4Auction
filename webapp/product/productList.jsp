<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.auction.dto.ProductDTO" %>
<%@ page import="com.auction.dao.ProductDAO" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %>
<%@ page import="com.auction.dto.MemberDTO" %>

<%
    String ctx = request.getContextPath();
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    
    // 검색 및 필터 파라미터
    String searchKeyword = request.getParameter("keyword");
    String categoryFilter = request.getParameter("category");
    String statusFilter = request.getParameter("status");
    String sortBy = request.getParameter("sort");
    
    if(searchKeyword == null) searchKeyword = "";
    if(categoryFilter == null) categoryFilter = "";
    if(statusFilter == null) statusFilter = "";
    if(sortBy == null) sortBy = "newest";
    
    // 데이터베이스에서 상품 목록 조회
    List<ProductDTO> productList = new ArrayList<>();
    Connection conn = null;
    try {
        conn = getConnection();
        ProductDAO productDao = new ProductDAO();
        productList = productDao.selectAllProducts(conn);
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (conn != null) close(conn);
    }
    
    // 포맷터
    DecimalFormat df = new DecimalFormat("###,###,###");
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy.MM.dd");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>전체 상품 목록 - M4 Auction</title>
    
    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    
    <!-- Global Styles -->
    <link rel="stylesheet" href="<%=ctx%>/resources/css/luxury-global-style.css">
    <link rel="stylesheet" href="<%=ctx%>/resources/css/common-utilities.css">
    <link rel="stylesheet" href="<%=ctx%>/resources/css/product-list.css">
</head>
<body class="pl-body">
    <jsp:include page="/layout/header/luxury-header.jsp" />
    
    <!-- Page Header -->
    <section class="pl-page-header">
        <div class="pl-container">
            <h1>전체 상품 목록</h1>
            <p>M4 Auction의 모든 경매 상품을 한 눈에 확인하세요</p>
        </div>
    </section>
    
    <!-- Content -->
    <section class="pl-content-wrapper">
        <div class="pl-container">
            <!-- Filter Section -->
            <div class="pl-filter-section">
                <form method="get" action="">
                    <div class="pl-filter-row">
                        <div class="pl-form-group">
                            <label for="keyword">검색어</label>
                            <input type="text" id="keyword" name="keyword" 
                                   placeholder="작품명, 작가명으로 검색" value="<%=searchKeyword%>">
                        </div>
                        <div class="pl-form-group">
                            <label for="category">카테고리</label>
                            <select id="category" name="category">
                                <option value="">전체</option>
                                <option value="회화" <%="회화".equals(categoryFilter) ? "selected" : ""%>>회화</option>
                                <option value="조각" <%="조각".equals(categoryFilter) ? "selected" : ""%>>조각</option>
                                <option value="판화" <%="판화".equals(categoryFilter) ? "selected" : ""%>>판화</option>
                                <option value="사진" <%="사진".equals(categoryFilter) ? "selected" : ""%>>사진</option>
                            </select>
                        </div>
                        <div class="pl-form-group">
                            <label for="status">상태</label>
                            <select id="status" name="status">
                                <option value="">전체</option>
                                <option value="A" <%="A".equals(statusFilter) ? "selected" : ""%>>진행중</option>
                                <option value="P" <%="P".equals(statusFilter) ? "selected" : ""%>>예정</option>
                                <option value="E" <%="E".equals(statusFilter) ? "selected" : ""%>>종료</option>
                            </select>
                        </div>
                        <div class="pl-form-group">
                            <label for="sort">정렬</label>
                            <select id="sort" name="sort">
                                <option value="newest" <%="newest".equals(sortBy) ? "selected" : ""%>>최신순</option>
                                <option value="price_low" <%="price_low".equals(sortBy) ? "selected" : ""%>>낮은가격순</option>
                                <option value="price_high" <%="price_high".equals(sortBy) ? "selected" : ""%>>높은가격순</option>
                                <option value="ending" <%="ending".equals(sortBy) ? "selected" : ""%>>마감임박순</option>
                            </select>
                        </div>
                        <button type="submit" class="pl-search-btn">
                            <i class="fas fa-search"></i> 검색
                        </button>
                    </div>
                </form>
            </div>
            
            <!-- Results Header -->
            <div class="pl-results-header">
                <div class="pl-results-count">
                    총 <strong><%=productList.size()%></strong>개의 상품이 등록되어 있습니다.
                </div>
                <div class="view-toggle">
                    <button class="view-btn active" onclick="toggleView('grid')">
                        <i class="fas fa-th"></i>
                    </button>
                    <button class="view-btn" onclick="toggleView('list')">
                        <i class="fas fa-list"></i>
                    </button>
                </div>
            </div>
            
            <!-- Products Grid -->
            <div class="pl-product-grid" id="productsContainer">
                <% if (productList.isEmpty()) { %>
                    <div class="pl-empty-state">
                        <i class="fas fa-palette pl-empty-icon"></i>
                        <h3 class="pl-empty-title">등록된 상품이 없습니다</h3>
                        <p class="pl-empty-text">새로운 경매 상품이 등록되면 여기에 표시됩니다.</p>
                    </div>
                <% } else { %>
                    <% for (ProductDTO product : productList) { %>
                        <div class="pl-product-card">
                            <div class="pl-product-image">
                                <% if (product.getImageRenamedName() != null) { %>
                                    <img src="<%=ctx%>/resources/images/<%=product.getImageRenamedName()%>" 
                                         alt="<%=product.getProductName()%>" 
                                         onerror="this.src='<%=ctx%>/resources/images/no-image.jpg'">
                                <% } else { %>
                                    <img src="<%=ctx%>/resources/images/no-image.jpg" alt="No Image">
                                <% } %>
                                
                                <div class="pl-status-badge 
                                    <% if ("A".equals(product.getStatus())) { %>pl-status-active
                                    <% } else if ("P".equals(product.getStatus())) { %>pl-status-waiting
                                    <% } else { %>status-ended<% } %>">
                                    <% if ("A".equals(product.getStatus())) { %>진행중
                                    <% } else if ("P".equals(product.getStatus())) { %>예정
                                    <% } else { %>종료<% } %>
                                </div>
                            </div>
                            
                            <div class="pl-product-info">
                                <h3 class="pl-product-title"><%=product.getProductName()%></h3>
                                <p class="pl-product-details"><%=product.getSellerId()%></p>
                                
                                <div class="pl-detail-row">
                                    <div class="pl-price-info">
                                        <div class="pl-price-label">시작가</div>
                                        <div class="pl-price-value"><%=df.format(product.getStartPrice())%>원</div>
                                    </div>
                                    <div class="pl-price-info">
                                        <div class="pl-price-label">현재가</div>
                                        <div class="pl-price-value pl-current-price"><%=df.format(product.getCurrentPrice())%>원</div>
                                    </div>
                                </div>
                                
                                <div class="pl-time-left">
                                    <span>상품 #<%=product.getProductId()%></span>
                                    <span><%=product.getStatus()%></span>
                                </div>
                                
                                <div class="pl-product-actions">
                                    <a href="<%=ctx%>/product/productDetail.jsp?id=<%=product.getProductId()%>" 
                                       class="pl-btn-primary">상세보기</a>
                                    <% if ("A".equals(product.getStatus()) && loginUser != null) { %>
                                        <a href="<%=ctx%>/auction/auction.jsp?id=<%=product.getProductId()%>" 
                                           class="pl-btn-secondary">입찰하기</a>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    <% } %>
                <% } %>
            </div>
        </div>
    </section>
    
    <jsp:include page="/layout/footer/luxury-footer.jsp" />
    
    <script>
        function toggleView(viewType) {
            const buttons = document.querySelectorAll('.view-btn');
            const container = document.getElementById('productsContainer');
            
            buttons.forEach(btn => btn.classList.remove('active'));
            event.target.closest('.view-btn').classList.add('active');
            
            if (viewType === 'list') {
                container.classList.add('pl-list-view');
                container.classList.remove('pl-grid-view');
            } else {
                container.classList.add('pl-grid-view');
                container.classList.remove('pl-list-view');
            }
        }
    </script>
</body>
</html>