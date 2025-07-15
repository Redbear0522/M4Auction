<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.util.List, java.text.DecimalFormat, java.text.SimpleDateFormat" %>
<%@ page import="com.auction.dao.WishlistDAO" %>
<%@ page import="com.auction.dto.WishlistDTO, com.auction.dto.MemberDTO" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %>

<%
    String ctx = request.getContextPath();
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    
    // 로그인 체크
    if (loginUser == null) {
        response.sendRedirect(ctx + "/member/luxury-login.jsp");
        return;
    }
    
    // 찜 목록 조회
    List<WishlistDTO> wishlist = null;
    int wishlistCount = 0;
    
    Connection conn = null;
    try {
        conn = getConnection();
        WishlistDAO wishlistDAO = new WishlistDAO();
        wishlist = wishlistDAO.selectWishlistByMember(conn, loginUser.getMemberId());
        wishlistCount = wishlist.size();
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (conn != null) close(conn);
    }
    
    DecimalFormat df = new DecimalFormat("###,###,###");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>찜 목록 - M4 Auction</title>
    
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
        
        .wishlist-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 40px 20px;
        }
        
        .wishlist-header {
            text-align: center;
            margin-bottom: 60px;
        }
        
        .wishlist-title {
            font-family: 'Playfair Display', serif;
            font-size: 48px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 16px;
        }
        
        .wishlist-subtitle {
            font-size: 18px;
            color: #666;
            margin-bottom: 20px;
        }
        
        .wishlist-count {
            display: inline-block;
            background: #c9961a;
            color: white;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
        }
        
        .wishlist-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
            gap: 20px;
        }
        
        .action-buttons {
            display: flex;
            gap: 12px;
        }
        
        .action-btn {
            padding: 10px 20px;
            background: white;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 500;
            color: #374151;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .action-btn:hover {
            background: #f3f4f6;
            border-color: #d1d5db;
        }
        
        .action-btn.danger {
            color: #dc2626;
            border-color: #dc2626;
        }
        
        .action-btn.danger:hover {
            background: #fef2f2;
        }
        
        .sort-select {
            padding: 10px 16px;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            font-size: 14px;
            background: white;
            min-width: 150px;
        }
        
        .wishlist-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 30px;
            margin-bottom: 60px;
        }
        
        .wishlist-item {
            background: white;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
            position: relative;
        }
        
        .wishlist-item:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 30px rgba(0,0,0,0.1);
        }
        
        .wishlist-checkbox {
            position: absolute;
            top: 16px;
            left: 16px;
            z-index: 2;
        }
        
        .wishlist-checkbox input[type="checkbox"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
        }
        
        .wishlist-image {
            width: 100%;
            height: 240px;
            background: #f3f4f6;
            position: relative;
            overflow: hidden;
        }
        
        .wishlist-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }
        
        .wishlist-item:hover .wishlist-image img {
            transform: scale(1.05);
        }
        
        .wishlist-image-placeholder {
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            color: #9ca3af;
        }
        
        .wishlist-image-placeholder i {
            font-size: 48px;
            margin-bottom: 12px;
        }
        
        .wishlist-remove-btn {
            position: absolute;
            top: 16px;
            right: 16px;
            background: rgba(0,0,0,0.7);
            color: white;
            border: none;
            width: 36px;
            height: 36px;
            border-radius: 50%;
            cursor: pointer;
            font-size: 16px;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .wishlist-remove-btn:hover {
            background: #dc2626;
            transform: scale(1.1);
        }
        
        .wishlist-info {
            padding: 24px;
        }
        
        .wishlist-category {
            font-size: 12px;
            color: #c9961a;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 8px;
        }
        
        .wishlist-product-title {
            font-size: 20px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 8px;
            line-height: 1.4;
        }
        
        .wishlist-artist {
            font-size: 16px;
            color: #666;
            margin-bottom: 16px;
        }
        
        .wishlist-price {
            margin-bottom: 16px;
        }
        
        .current-price {
            font-size: 20px;
            font-weight: 700;
            color: #c9961a;
            margin-bottom: 4px;
        }
        
        .start-price {
            font-size: 14px;
            color: #999;
        }
        
        .wishlist-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 12px;
            color: #999;
            margin-bottom: 16px;
        }
        
        .wishlist-added-date {
            display: flex;
            align-items: center;
            gap: 4px;
        }
        
        .wishlist-status {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .status-active {
            background: #dcfce7;
            color: #16a34a;
        }
        
        .status-ended {
            background: #fee2e2;
            color: #dc2626;
        }
        
        .wishlist-actions-btn {
            display: flex;
            gap: 8px;
        }
        
        .wishlist-btn {
            flex: 1;
            padding: 12px 16px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 500;
            text-decoration: none;
            text-align: center;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }
        
        .wishlist-btn.primary {
            background: #1a1a1a;
            color: white;
        }
        
        .wishlist-btn.primary:hover {
            background: #333;
        }
        
        .wishlist-btn.secondary {
            background: #f3f4f6;
            color: #374151;
        }
        
        .wishlist-btn.secondary:hover {
            background: #e5e7eb;
        }
        
        .empty-wishlist {
            text-align: center;
            padding: 80px 20px;
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }
        
        .empty-wishlist i {
            font-size: 80px;
            color: #e5e7eb;
            margin-bottom: 24px;
        }
        
        .empty-wishlist h3 {
            font-size: 24px;
            color: #374151;
            margin-bottom: 12px;
        }
        
        .empty-wishlist p {
            color: #6b7280;
            font-size: 16px;
            margin-bottom: 32px;
        }
        
        .empty-wishlist-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 14px 28px;
            background: #c9961a;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .empty-wishlist-btn:hover {
            background: #b8851a;
            transform: translateY(-2px);
        }
        
        /* 반응형 */
        @media (max-width: 768px) {
            .wishlist-title {
                font-size: 36px;
            }
            
            .wishlist-actions {
                flex-direction: column;
                align-items: stretch;
            }
            
            .action-buttons {
                justify-content: center;
            }
            
            .wishlist-grid {
                grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                gap: 20px;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/layout/header/luxury-header.jsp" />
    
    <div class="wishlist-container">
        <div class="wishlist-header">
            <h1 class="wishlist-title">찜 목록</h1>
            <p class="wishlist-subtitle">관심 있는 작품들을 모아보세요</p>
            <div class="wishlist-count">
                <i class="fas fa-heart"></i>
                총 <%=wishlistCount%>개의 작품
            </div>
        </div>
        
        <% if (wishlist != null && !wishlist.isEmpty()) { %>
        <div class="wishlist-actions">
            <div class="action-buttons">
                <button class="action-btn" onclick="selectAll()">
                    <i class="fas fa-check-square"></i>
                    전체 선택
                </button>
                <button class="action-btn danger" onclick="removeSelected()">
                    <i class="fas fa-trash"></i>
                    선택 삭제
                </button>
            </div>
            
            <select class="sort-select" onchange="sortWishlist(this.value)">
                <option value="recent">최근 추가순</option>
                <option value="price-high">높은 가격순</option>
                <option value="price-low">낮은 가격순</option>
                <option value="name">작품명순</option>
            </select>
        </div>
        
        <div class="wishlist-grid">
            <% for (WishlistDTO item : wishlist) { %>
            <div class="wishlist-item" data-product-id="<%=item.getProductId()%>">
                <div class="wishlist-checkbox">
                    <input type="checkbox" class="item-checkbox" value="<%=item.getProductId()%>">
                </div>
                
                <div class="wishlist-image">
                    <% if (item.getImageRenamedName() != null) { %>
                        <img src="<%=ctx%>/resources/product_images/<%=item.getImageRenamedName()%>" 
                             alt="<%=item.getProductName()%>">
                    <% } else { %>
                        <div class="wishlist-image-placeholder">
                            <i class="fas fa-image"></i>
                            <span>이미지 없음</span>
                        </div>
                    <% } %>
                    
                    <button class="wishlist-remove-btn" onclick="removeWishlist(<%=item.getProductId()%>)">
                        <i class="fas fa-heart"></i>
                    </button>
                </div>
                
                <div class="wishlist-info">
                    <div class="wishlist-category"><%=item.getCategory() != null ? item.getCategory() : "기타"%></div>
                    <h3 class="wishlist-product-title"><%=item.getProductName()%></h3>
                    <p class="wishlist-artist"><%=item.getArtistName() != null ? item.getArtistName() : "작가 미상"%></p>
                    
                    <div class="wishlist-price">
                        <div class="current-price">
                            ₩<%=df.format(item.getCurrentPrice() > 0 ? item.getCurrentPrice() : item.getStartPrice())%>
                        </div>
                        <div class="start-price">시작가: ₩<%=df.format(item.getStartPrice())%></div>
                    </div>
                    
                    <div class="wishlist-meta">
                        <div class="wishlist-added-date">
                            <i class="fas fa-clock"></i>
                            <%=sdf.format(item.getCreatedAt())%> 추가
                        </div>
                        <div class="wishlist-status <%= "A".equals(item.getStatus()) ? "status-active" : "status-ended" %>">
                            <%= "A".equals(item.getStatus()) ? "진행중" : "종료" %>
                        </div>
                    </div>
                    
                    <div class="wishlist-actions-btn">
                        <a href="<%=ctx%>/product/productDetail.jsp?productId=<%=item.getProductId()%>" 
                           class="wishlist-btn primary">
                            <i class="fas fa-eye"></i>
                            상세보기
                        </a>
                        <% if ("A".equals(item.getStatus())) { %>
                        <a href="<%=ctx%>/auction/auctionList.jsp" class="wishlist-btn secondary">
                            <i class="fas fa-gavel"></i>
                            입찰하기
                        </a>
                        <% } %>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
        <% } else { %>
        <div class="empty-wishlist">
            <i class="far fa-heart"></i>
            <h3>찜한 작품이 없습니다</h3>
            <p>마음에 드는 작품을 찜해보세요!</p>
            <a href="<%=ctx%>/auction/auctionList.jsp" class="empty-wishlist-btn">
                <i class="fas fa-search"></i>
                작품 둘러보기
            </a>
        </div>
        <% } %>
    </div>
    
    <jsp:include page="/layout/footer/luxury-footer.jsp" />
    
    <script>
        // 전체 선택/해제
        function selectAll() {
            const checkboxes = document.querySelectorAll('.item-checkbox');
            const allChecked = Array.from(checkboxes).every(cb => cb.checked);
            
            checkboxes.forEach(checkbox => {
                checkbox.checked = !allChecked;
            });
        }
        
        // 선택된 항목 삭제
        function removeSelected() {
            const selectedItems = document.querySelectorAll('.item-checkbox:checked');
            
            if (selectedItems.length === 0) {
                alert('삭제할 항목을 선택해주세요.');
                return;
            }
            
            if (confirm('선택한 ' + selectedItems.length + '개의 작품을 찜 목록에서 제거하시겠습니까?')) {
                selectedItems.forEach(checkbox => {
                    removeWishlist(checkbox.value, false);
                });
                
                // 페이지 새로고침
                setTimeout(() => {
                    location.reload();
                }, 1000);
            }
        }
        
        // 찜 제거 함수
        function removeWishlist(productId, showConfirm = true) {
            if (showConfirm && !confirm('이 작품을 찜 목록에서 제거하시겠습니까?')) {
                return;
            }
            
            fetch('<%=ctx%>/wishlist/wishlistAction.jsp', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=remove&productId=' + productId
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    if (showConfirm) {
                        alert(data.message);
                        location.reload();
                    }
                } else {
                    alert(data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('오류가 발생했습니다.');
            });
        }
        
        // 정렬 기능
        function sortWishlist(sortBy) {
            const grid = document.querySelector('.wishlist-grid');
            const items = Array.from(grid.querySelectorAll('.wishlist-item'));
            
            items.sort((a, b) => {
                switch(sortBy) {
                    case 'price-high':
                        const priceA = parseInt(a.querySelector('.current-price').textContent.replace(/[^\d]/g, ''));
                        const priceB = parseInt(b.querySelector('.current-price').textContent.replace(/[^\d]/g, ''));
                        return priceB - priceA;
                    case 'price-low':
                        const priceA2 = parseInt(a.querySelector('.current-price').textContent.replace(/[^\d]/g, ''));
                        const priceB2 = parseInt(b.querySelector('.current-price').textContent.replace(/[^\d]/g, ''));
                        return priceA2 - priceB2;
                    case 'name':
                        const nameA = a.querySelector('.wishlist-product-title').textContent;
                        const nameB = b.querySelector('.wishlist-product-title').textContent;
                        return nameA.localeCompare(nameB);
                    default:
                        return 0;
                }
            });
            
            // 정렬된 순서로 다시 배치
            items.forEach(item => grid.appendChild(item));
        }
    </script>
</body>
</html>