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
    
    // 관리자 권한 체크
    boolean isAdmin = (loginUser != null && "admin".equals(loginUser.getMemberId()));
    
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
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy.MM.dd HH:mm");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상품 관리 - M4 Auction</title>
    
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
        }
        
        .page-header {
            background: linear-gradient(135deg, #2d2d2d 0%, #1a1a1a 100%);
            color: white;
            padding: 60px 0;
            text-align: center;
        }
        
        .page-header h1 {
            font-family: 'Playfair Display', serif;
            font-size: 42px;
            font-weight: 700;
            margin-bottom: 15px;
        }
        
        .page-header p {
            font-size: 18px;
            opacity: 0.9;
            max-width: 600px;
            margin: 0 auto;
        }
        
        .container {
            max-width: 1600px;
            margin: 0 auto;
            padding: 0 20px;
        }
        
        .content-wrapper {
            padding: 40px 0;
        }
        
        .control-section {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08);
            margin-bottom: 30px;
        }
        
        .control-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }
        
        .control-title {
            font-family: 'Playfair Display', serif;
            font-size: 24px;
            font-weight: 700;
            color: #1a1a1a;
        }
        
        .bulk-actions {
            display: flex;
            gap: 10px;
        }
        
        .bulk-btn {
            padding: 8px 16px;
            border: 1px solid #e5e5e5;
            background: white;
            border-radius: 6px;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .bulk-btn.approve {
            color: #16a34a;
            border-color: #16a34a;
        }
        
        .bulk-btn.approve:hover {
            background: #16a34a;
            color: white;
        }
        
        .bulk-btn.reject {
            color: #dc2626;
            border-color: #dc2626;
        }
        
        .bulk-btn.reject:hover {
            background: #dc2626;
            color: white;
        }
        
        .bulk-btn.delete {
            color: #ef4444;
            border-color: #ef4444;
        }
        
        .bulk-btn.delete:hover {
            background: #ef4444;
            color: white;
        }
        
        .filter-row {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr 1fr auto;
            gap: 20px;
            align-items: end;
        }
        
        .form-group {
            display: flex;
            flex-direction: column;
        }
        
        .form-group label {
            font-weight: 600;
            margin-bottom: 8px;
            color: #1a1a1a;
        }
        
        .form-group input,
        .form-group select {
            padding: 12px;
            border: 1px solid #e5e5e5;
            border-radius: 8px;
            font-size: 15px;
            transition: border-color 0.3s;
        }
        
        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #c9961a;
        }
        
        .search-btn {
            background: linear-gradient(135deg, #c9961a 0%, #d4af37 100%);
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            height: fit-content;
        }
        
        .search-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(201, 150, 26, 0.3);
        }
        
        .stats-bar {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08);
            text-align: center;
        }
        
        .stat-icon {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #c9961a 0%, #d4af37 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 20px;
            margin: 0 auto 15px;
        }
        
        .stat-number {
            font-size: 32px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 5px;
        }
        
        .stat-label {
            color: #666;
            font-size: 14px;
        }
        
        .products-table {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08);
            overflow: hidden;
        }
        
        .table-header {
            background: #f8f9fa;
            padding: 20px 25px;
            border-bottom: 1px solid #e5e5e5;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .table-title {
            font-size: 18px;
            font-weight: 600;
            color: #1a1a1a;
        }
        
        .table-actions {
            display: flex;
            gap: 10px;
        }
        
        .export-btn {
            padding: 8px 16px;
            background: #6b7280;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            cursor: pointer;
            transition: background 0.3s;
        }
        
        .export-btn:hover {
            background: #4b5563;
        }
        
        .table-wrapper {
            overflow-x: auto;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        th {
            background: #f8f9fa;
            padding: 15px 20px;
            text-align: left;
            font-weight: 600;
            color: #374151;
            border-bottom: 1px solid #e5e5e5;
            white-space: nowrap;
        }
        
        th input[type="checkbox"] {
            margin: 0;
        }
        
        td {
            padding: 15px 20px;
            border-bottom: 1px solid #f3f4f6;
            vertical-align: middle;
        }
        
        tr:hover {
            background: #f9fafb;
        }
        
        .product-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .product-thumb {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 8px;
            background: #f3f4f6;
        }
        
        .product-details h4 {
            margin: 0 0 5px 0;
            font-size: 16px;
            font-weight: 600;
            color: #1a1a1a;
        }
        
        .product-details p {
            margin: 0;
            font-size: 14px;
            color: #666;
        }
        
        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .status-active {
            background: #dcfce7;
            color: #16a34a;
        }
        
        .status-pending {
            background: #fef3c7;
            color: #d97706;
        }
        
        .status-ended {
            background: #f3f4f6;
            color: #6b7280;
        }
        
        .status-cancelled {
            background: #fee2e2;
            color: #dc2626;
        }
        
        .price-cell {
            text-align: right;
            font-weight: 600;
        }
        
        .actions-cell {
            display: flex;
            gap: 8px;
        }
        
        .action-btn {
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            font-size: 12px;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .btn-view {
            background: #3b82f6;
            color: white;
        }
        
        .btn-view:hover {
            background: #2563eb;
        }
        
        .btn-edit {
            background: #f59e0b;
            color: white;
        }
        
        .btn-edit:hover {
            background: #d97706;
        }
        
        .btn-approve {
            background: #10b981;
            color: white;
        }
        
        .btn-approve:hover {
            background: #059669;
        }
        
        .btn-reject {
            background: #ef4444;
            color: white;
        }
        
        .btn-reject:hover {
            background: #dc2626;
        }
        
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            padding: 30px;
        }
        
        .page-btn {
            padding: 8px 12px;
            border: 1px solid #e5e5e5;
            background: white;
            border-radius: 6px;
            color: #666;
            text-decoration: none;
            transition: all 0.3s;
        }
        
        .page-btn:hover,
        .page-btn.active {
            background: #c9961a;
            color: white;
            border-color: #c9961a;
        }
        
        .empty-state {
            text-align: center;
            padding: 80px 20px;
            color: #666;
        }
        
        .empty-state i {
            font-size: 48px;
            color: #ddd;
            margin-bottom: 20px;
        }
        
        @media (max-width: 768px) {
            .filter-row {
                grid-template-columns: 1fr;
                gap: 15px;
            }
            
            .control-header {
                flex-direction: column;
                gap: 15px;
                align-items: stretch;
            }
            
            .bulk-actions {
                justify-content: center;
            }
            
            .stats-bar {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .table-wrapper {
                font-size: 14px;
            }
            
            .product-info {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/layout/header/luxury-header.jsp" />
    
    <!-- Page Header -->
    <section class="page-header">
        <div class="container">
            <h1>상품 관리</h1>
            <p>등록된 모든 상품을 관리하고 경매 상태를 제어할 수 있습니다</p>
        </div>
    </section>
    
    <!-- Content -->
    <section class="content-wrapper">
        <div class="container">
            <!-- Statistics -->
            <div class="stats-bar">
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-palette"></i>
                    </div>
                    <div class="stat-number"><%=productList.size()%></div>
                    <div class="stat-label">전체 상품</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-play"></i>
                    </div>
                    <div class="stat-number">
                        <%= productList.stream().filter(p -> "A".equals(p.getStatus())).count() %>
                    </div>
                    <div class="stat-label">진행중</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div class="stat-number">
                        <%= productList.stream().filter(p -> "P".equals(p.getStatus())).count() %>
                    </div>
                    <div class="stat-label">대기중</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-check"></i>
                    </div>
                    <div class="stat-number">
                        <%= productList.stream().filter(p -> "E".equals(p.getStatus())).count() %>
                    </div>
                    <div class="stat-label">종료됨</div>
                </div>
            </div>
            
            <!-- Control Section -->
            <div class="control-section">
                <div class="control-header">
                    <h2 class="control-title">상품 목록</h2>
                    <% if (isAdmin) { %>
                    <div class="bulk-actions">
                        <button class="bulk-btn approve" onclick="bulkAction('approve')">
                            <i class="fas fa-check"></i> 일괄 승인
                        </button>
                        <button class="bulk-btn reject" onclick="bulkAction('reject')">
                            <i class="fas fa-times"></i> 일괄 거부
                        </button>
                        <button class="bulk-btn delete" onclick="bulkAction('delete')">
                            <i class="fas fa-trash"></i> 일괄 삭제
                        </button>
                    </div>
                    <% } %>
                </div>
                
                <form method="get" action="">
                    <div class="filter-row">
                        <div class="form-group">
                            <label for="keyword">검색어</label>
                            <input type="text" id="keyword" name="keyword" 
                                   placeholder="상품명, 작가명, 판매자로 검색" value="<%=searchKeyword%>">
                        </div>
                        <div class="form-group">
                            <label for="category">카테고리</label>
                            <select id="category" name="category">
                                <option value="">전체</option>
                                <option value="회화" <%="회화".equals(categoryFilter) ? "selected" : ""%>>회화</option>
                                <option value="조각" <%="조각".equals(categoryFilter) ? "selected" : ""%>>조각</option>
                                <option value="판화" <%="판화".equals(categoryFilter) ? "selected" : ""%>>판화</option>
                                <option value="사진" <%="사진".equals(categoryFilter) ? "selected" : ""%>>사진</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="status">상태</label>
                            <select id="status" name="status">
                                <option value="">전체</option>
                                <option value="A" <%="A".equals(statusFilter) ? "selected" : ""%>>진행중</option>
                                <option value="P" <%="P".equals(statusFilter) ? "selected" : ""%>>대기중</option>
                                <option value="E" <%="E".equals(statusFilter) ? "selected" : ""%>>종료</option>
                                <option value="C" <%="C".equals(statusFilter) ? "selected" : ""%>>취소</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="sort">정렬</label>
                            <select id="sort" name="sort">
                                <option value="newest" <%="newest".equals(sortBy) ? "selected" : ""%>>최신순</option>
                                <option value="oldest" <%="oldest".equals(sortBy) ? "selected" : ""%>>오래된순</option>
                                <option value="price_high" <%="price_high".equals(sortBy) ? "selected" : ""%>>높은가격순</option>
                                <option value="price_low" <%="price_low".equals(sortBy) ? "selected" : ""%>>낮은가격순</option>
                            </select>
                        </div>
                        <button type="submit" class="search-btn">
                            <i class="fas fa-search"></i> 검색
                        </button>
                    </div>
                </form>
            </div>
            
            <!-- Products Table -->
            <div class="products-table">
                <div class="table-header">
                    <div class="table-title">상품 목록 (총 <%=productList.size()%>개)</div>
                    <div class="table-actions">
                        <button class="export-btn" onclick="exportToExcel()">
                            <i class="fas fa-download"></i> Excel 내보내기
                        </button>
                    </div>
                </div>
                
                <div class="table-wrapper">
                    <% if (productList.isEmpty()) { %>
                        <div class="empty-state">
                            <i class="fas fa-palette"></i>
                            <h3>등록된 상품이 없습니다</h3>
                            <p>새로운 경매 상품이 등록되면 여기에 표시됩니다.</p>
                        </div>
                    <% } else { %>
                        <table>
                            <thead>
                                <tr>
                                    <% if (isAdmin) { %>
                                    <th>
                                        <input type="checkbox" id="selectAll" onchange="toggleSelectAll()">
                                    </th>
                                    <% } %>
                                    <th>상품 정보</th>
                                    <th>카테고리</th>
                                    <th>시작가</th>
                                    <th>현재가</th>
                                    <th>상태</th>
                                    <th>판매자</th>
                                    <th>등록일</th>
                                    <th>관리</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (ProductDTO product : productList) { %>
                                    <tr>
                                        <% if (isAdmin) { %>
                                        <td>
                                            <input type="checkbox" name="selectedProducts" value="<%=product.getProductId()%>">
                                        </td>
                                        <% } %>
                                        <td>
                                            <div class="product-info">
                                                <% if (product.getImageRenamedName() != null) { %>
                                                    <img src="<%=ctx%>/resources/images/<%=product.getImageRenamedName()%>" 
                                                         alt="<%=product.getProductName()%>" 
                                                         class="product-thumb"
                                                         onerror="this.src='<%=ctx%>/resources/images/no-image.jpg'">
                                                <% } else { %>
                                                    <div class="product-thumb" style="background: #f3f4f6; display: flex; align-items: center; justify-content: center; color: #999;">
                                                        <i class="fas fa-image"></i>
                                                    </div>
                                                <% } %>
                                                <div class="product-details">
                                                    <h4><%=product.getProductName()%></h4>
                                                    <p>ID: #<%=product.getProductId()%></p>
                                                </div>
                                            </div>
                                        </td>
                                        <td><%=product.getCategory() != null ? product.getCategory() : "-"%></td>
                                        <td class="price-cell"><%=df.format(product.getStartPrice())%>원</td>
                                        <td class="price-cell"><%=df.format(product.getCurrentPrice())%>원</td>
                                        <td>
                                            <span class="status-badge 
                                                <% if ("A".equals(product.getStatus())) { %>status-active
                                                <% } else if ("P".equals(product.getStatus())) { %>status-pending
                                                <% } else if ("E".equals(product.getStatus())) { %>status-ended
                                                <% } else { %>status-cancelled<% } %>">
                                                <% if ("A".equals(product.getStatus())) { %>진행중
                                                <% } else if ("P".equals(product.getStatus())) { %>대기중
                                                <% } else if ("E".equals(product.getStatus())) { %>종료
                                                <% } else { %>취소<% } %>
                                            </span>
                                        </td>
                                        <td><%=product.getSellerId()%></td>
                                        <td><%=product.getRegDate() != null ? dateFormat.format(product.getRegDate()) : "-"%></td>
                                        <td>
                                            <div class="actions-cell">
                                                <button class="action-btn btn-view" 
                                                        onclick="viewProduct(<%=product.getProductId()%>)">
                                                    <i class="fas fa-eye"></i> 보기
                                                </button>
                                                <% if (isAdmin && "P".equals(product.getStatus())) { %>
                                                    <button class="action-btn btn-approve" 
                                                            onclick="approveProduct(<%=product.getProductId()%>)">
                                                        <i class="fas fa-check"></i> 승인
                                                    </button>
                                                    <button class="action-btn btn-reject" 
                                                            onclick="rejectProduct(<%=product.getProductId()%>)">
                                                        <i class="fas fa-times"></i> 거부
                                                    </button>
                                                <% } else if (isAdmin) { %>
                                                    <button class="action-btn btn-edit" 
                                                            onclick="editProduct(<%=product.getProductId()%>)">
                                                        <i class="fas fa-edit"></i> 수정
                                                    </button>
                                                <% } %>
                                            </div>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    <% } %>
                </div>
                
                <!-- Pagination -->
                <div class="pagination">
                    <a href="#" class="page-btn">&laquo;</a>
                    <a href="#" class="page-btn active">1</a>
                    <a href="#" class="page-btn">2</a>
                    <a href="#" class="page-btn">3</a>
                    <a href="#" class="page-btn">&raquo;</a>
                </div>
            </div>
        </div>
    </section>
    
    <jsp:include page="/layout/footer/luxury-footer.jsp" />
    
    <script>
        function toggleSelectAll() {
            const selectAll = document.getElementById('selectAll');
            const checkboxes = document.querySelectorAll('input[name="selectedProducts"]');
            checkboxes.forEach(cb => cb.checked = selectAll.checked);
        }
        
        function getSelectedProducts() {
            const checkboxes = document.querySelectorAll('input[name="selectedProducts"]:checked');
            return Array.from(checkboxes).map(cb => cb.value);
        }
        
        function bulkAction(action) {
            const selected = getSelectedProducts();
            if (selected.length === 0) {
                alert('선택된 상품이 없습니다.');
                return;
            }
            
            let message = '';
            switch(action) {
                case 'approve':
                    message = `선택한 ${selected.length}개 상품을 승인하시겠습니까?`;
                    break;
                case 'reject':
                    message = `선택한 ${selected.length}개 상품을 거부하시겠습니까?`;
                    break;
                case 'delete':
                    message = `선택한 ${selected.length}개 상품을 삭제하시겠습니까?`;
                    break;
            }
            
            if (confirm(message)) {
                // TODO: 실제 처리 로직 구현
                alert(`${action} 작업이 완료되었습니다.`);
                location.reload();
            }
        }
        
        function viewProduct(productId) {
            window.open('<%=ctx%>/product/productDetail.jsp?productId=' + productId, '_blank');
        }
        
        function editProduct(productId) {
            location.href = '<%=ctx%>/product/productEditForm.jsp?id=' + productId;
        }
        
        function approveProduct(productId) {
            if (confirm('이 상품을 승인하시겠습니까?')) {
                // TODO: 승인 처리 로직
                alert('상품이 승인되었습니다.');
                location.reload();
            }
        }
        
        function rejectProduct(productId) {
            if (confirm('이 상품을 거부하시겠습니까?')) {
                // TODO: 거부 처리 로직
                alert('상품이 거부되었습니다.');
                location.reload();
            }
        }
        
        function exportToExcel() {
            // TODO: Excel 내보내기 로직
            alert('Excel 파일 내보내기 기능은 곧 구현될 예정입니다.');
        }
    </script>
</body>
</html>