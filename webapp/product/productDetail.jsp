<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.auction.dto.MemberDTO, com.auction.dto.ProductDTO,
                 com.auction.dao.ProductDAO,
                 java.sql.Connection,
                 java.text.SimpleDateFormat,
                 java.text.DecimalFormat,
                 static com.auction.common.JDBCTemplate.*" %>
<%
    String ctx = request.getContextPath();
    MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");
    if (loginUser == null) {
        response.sendRedirect(ctx + "/member/loginForm.jsp");
        return;
    }

    // productId 파싱 및 DTO 조회
    int productId = 0;
    if (request.getParameter("productId") != null)
        productId = Integer.parseInt(request.getParameter("productId"));

    ProductDTO p = null;
    if (productId > 0) {
        Connection conn = getConnection();
        p = new ProductDAO().selectProductById(conn, productId);
        close(conn);
    }

    // 상태 플래그 (시간 기반 종료 체크 추가)
    java.util.Date now = new java.util.Date();
    
    // 디버깅 정보 출력
    if (p != null) {
        System.out.println("=== 상품 상세 디버깅 정보 ===");
        System.out.println("상품명: " + p.getProductName());
        System.out.println("현재시간: " + now);
        System.out.println("종료시간: " + p.getEndTime());
        System.out.println("상품상태: " + p.getStatus());
        if (p.getEndTime() != null) {
            System.out.println("시간비교 결과(now.after(endTime)): " + now.after(p.getEndTime()));
            System.out.println("시간차이(ms): " + (p.getEndTime().getTime() - now.getTime()));
        }
        System.out.println("===============================");
    }
    
    boolean isTimeEnded = p != null && p.getEndTime() != null && now.after(p.getEndTime());
    boolean isEnded = p != null && ("E".equals(p.getStatus()) || isTimeEnded);
    boolean isSeller = p != null && loginUser.getMemberId().equals(p.getSellerId());
    boolean isWinner = p != null && p.getWinnerId() != null && loginUser.getMemberId().equals(p.getWinnerId());
    
    // 낙찰 완료 상품 접근 제한 - 판매자, 낙찰자, 관리자만 접근 가능
    boolean isAdmin = "admin".equals(loginUser.getMemberId());
    boolean canAccess = !isEnded || isSeller || isWinner || isAdmin;
    
    if (p != null && isEnded && !canAccess) {
        session.setAttribute("alertMsg", "이미 낙찰 완료된 상품입니다. 접근 권한이 없습니다.");
        response.sendRedirect(ctx + "/auction/auctionList.jsp");
        return;
    }

    // 포맷터 준비
    DecimalFormat df = new DecimalFormat("###,###,###");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd HH:mm");
    int currentPrice = (p != null) 
        ? (p.getCurrentPrice() == 0 ? p.getStartPrice() : p.getCurrentPrice()) 
        : 0;
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= p != null ? p.getProductName() + " - M4 Auction" : "상품을 찾을 수 없습니다" %></title>
    
    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    
    <!-- Global Styles -->
    <link rel="stylesheet" href="<%=ctx%>/resources/css/luxury-global-style.css">
    
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background: #fafbfc;
            padding-top: 120px !important;
            line-height: 1.6;
        }
        
        .product-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 40px 24px;
        }
        
        .product-grid {
            display: grid;
            grid-template-columns: 1fr 500px;
            gap: 60px;
            align-items: start;
        }
        
        /* Left: Image Section */
        .image-section {
            position: sticky;
            top: 140px;
        }
        
        .main-image {
            width: 100%;
            aspect-ratio: 1;
            object-fit: cover;
            border-radius: 8px;
            background: #f8f9fa;
            border: 1px solid #e5e7eb;
        }
        
        .image-placeholder {
            width: 100%;
            aspect-ratio: 1;
            background: #f8f9fa;
            border: 2px dashed #d1d5db;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            color: #9ca3af;
            font-size: 18px;
        }
        
        .image-placeholder i {
            font-size: 48px;
            margin-bottom: 12px;
        }
        
        /* Right: Details Section */
        .details-section {
            background: white;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            padding: 40px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        
        .product-header {
            margin-bottom: 32px;
            padding-bottom: 24px;
            border-bottom: 1px solid #f3f4f6;
        }
        
        .product-category {
            display: inline-block;
            background: #f3f4f6;
            color: #6b7280;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            padding: 4px 8px;
            border-radius: 4px;
            margin-bottom: 12px;
        }
        
        .product-title {
            font-family: 'Playfair Display', serif;
            font-size: 32px;
            font-weight: 700;
            color: #1a1a1a;
            margin: 0 0 8px 0;
            line-height: 1.2;
        }
        
        .product-artist {
            font-size: 18px;
            color: #6b7280;
            margin: 0;
        }
        
        /* Auction Info */
        .auction-info {
            margin-bottom: 32px;
        }
        
        .auction-status {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 16px;
        }
        
        .status-active {
            color: #16a34a;
        }
        
        .status-ended {
            color: #dc2626;
        }
        
        .status-icon {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: currentColor;
        }
        
        .auction-timer {
            background: #fef3c7;
            border: 1px solid #fbbf24;
            border-radius: 6px;
            padding: 12px 16px;
            margin-bottom: 24px;
        }
        
        .timer-label {
            font-size: 12px;
            color: #92400e;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 4px;
        }
        
        .timer-value {
            font-family: 'Inter', monospace;
            font-size: 18px;
            font-weight: 700;
            color: #92400e;
        }
        
        /* Price Section */
        .price-section {
            margin-bottom: 32px;
        }
        
        .price-label {
            font-size: 14px;
            color: #6b7280;
            font-weight: 500;
            margin-bottom: 8px;
        }
        
        .current-price {
            font-size: 36px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 8px;
        }
        
        .price-currency {
            font-size: 24px;
            color: #6b7280;
            margin-left: 4px;
        }
        
        .start-price {
            font-size: 14px;
            color: #9ca3af;
            margin: 0;
        }
        
        /* Bidding Section */
        .bidding-section {
            margin-bottom: 32px;
        }
        
        .bid-form {
            background: #f9fafb;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            padding: 24px;
        }
        
        .bid-input-group {
            margin-bottom: 16px;
        }
        
        .bid-input-label {
            display: block;
            font-size: 14px;
            font-weight: 600;
            color: #374151;
            margin-bottom: 8px;
        }
        
        .bid-input {
            width: 100%;
            padding: 12px 16px;
            font-size: 16px;
            font-weight: 600;
            border: 2px solid #d1d5db;
            border-radius: 6px;
            background: white;
            transition: all 0.2s ease;
            box-sizing: border-box;
        }
        
        .bid-input:focus {
            outline: none;
            border-color: #1a1a1a;
            box-shadow: 0 0 0 3px rgba(26, 26, 26, 0.1);
        }
        
        .bid-button {
            width: 100%;
            background: #1a1a1a;
            color: white;
            border: 2px solid #1a1a1a;
            padding: 16px;
            font-size: 16px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        
        .bid-button:hover {
            background: #c9961a;
            border-color: #c9961a;
            transform: translateY(-1px);
        }
        
        .bid-button:disabled {
            background: #e5e7eb;
            border-color: #e5e7eb;
            color: #9ca3af;
            cursor: not-allowed;
            transform: none;
        }
        
        /* Product Description */
        .description-section {
            margin-bottom: 32px;
        }
        
        .section-title {
            font-size: 18px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 16px;
        }
        
        .product-description {
            color: #4b5563;
            line-height: 1.7;
            font-size: 15px;
        }
        
        /* Meta Information */
        .meta-section {
            border-top: 1px solid #f3f4f6;
            padding-top: 24px;
        }
        
        .meta-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            margin-bottom: 24px;
        }
        
        .meta-item {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }
        
        .meta-label {
            font-size: 12px;
            color: #9ca3af;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .meta-value {
            font-size: 14px;
            color: #374151;
            font-weight: 500;
        }
        
        /* Action Links */
        .action-links {
            display: flex;
            gap: 16px;
            flex-wrap: wrap;
        }
        
        .action-link {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            color: #6b7280;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: color 0.2s ease;
        }
        
        .action-link:hover {
            color: #1a1a1a;
        }
        
        .action-link i {
            font-size: 13px;
        }
        
        /* Winner Section */
        .winner-section {
            background: #f0fdf4;
            border: 2px solid #16a34a;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 24px;
        }
        
        .winner-title {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 16px;
            font-weight: 700;
            color: #15803d;
            margin-bottom: 8px;
        }
        
        .winner-info {
            color: #166534;
            font-size: 14px;
        }
        
        /* Error State */
        .error-state {
            text-align: center;
            padding: 80px 40px;
            background: white;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
        }
        
        .error-state i {
            font-size: 64px;
            color: #e5e7eb;
            margin-bottom: 24px;
        }
        
        .error-state h2 {
            font-size: 24px;
            color: #374151;
            margin-bottom: 8px;
        }
        
        .error-state p {
            color: #9ca3af;
            font-size: 16px;
        }
        
        /* Responsive */
        @media (max-width: 1024px) {
            .product-grid {
                grid-template-columns: 1fr;
                gap: 40px;
            }
            
            .image-section {
                position: static;
            }
            
            .details-section {
                padding: 24px;
            }
            
            .product-title {
                font-size: 28px;
            }
            
            .current-price {
                font-size: 28px;
            }
        }
        
        @media (max-width: 768px) {
            body {
                padding-top: 100px !important;
            }
            
            .product-container {
                padding: 20px 16px;
            }
            
            .details-section {
                padding: 20px;
            }
            
            .meta-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/layout/header/luxury-header.jsp" />
    
    <div class="product-container">
        <% if (p != null) { %>
        <div class="product-grid">
            <!-- Image Section -->
            <div class="image-section">
                <% if (p.getImageRenamedName() != null) { %>
                    <img src="<%=ctx%>/resources/product_images/<%=p.getImageRenamedName()%>" 
                         alt="<%=p.getProductName()%>" class="main-image">
                <% } else { %>
                    <div class="image-placeholder">
                        <i class="fas fa-image"></i>
                        <span>이미지 없음</span>
                    </div>
                <% } %>
            </div>
            
            <!-- Details Section -->
            <div class="details-section">
                <!-- Product Header -->
                <div class="product-header">
                    <div class="product-category"><%=p.getCategory()%></div>
                    <h1 class="product-title"><%=p.getProductName()%></h1>
                    <p class="product-artist"><%=p.getArtistName()%></p>
                </div>
                
                <!-- Auction Info -->
                <div class="auction-info">
                    <div class="auction-status <%= isEnded ? "status-ended" : "status-active" %>">
                        <div class="status-icon"></div>
                        <%= isEnded ? "경매 종료" : "경매 진행중" %>
                    </div>
                    
                    <% if (p.getEndTime() != null) { %>
                    <div class="auction-timer" style="background: #fff3cd; border: 1px solid #ffeaa7; padding: 15px; border-radius: 8px; margin: 15px 0;">
                        <div class="timer-label" style="font-size: 16px; line-height: 1.5;">
                            <strong style="color: #856404;">📅 경매 마감일시:</strong> 
                            <span style="font-weight: bold; color: #d63031; font-size: 18px; margin-left: 10px;"><%=p.getEndTime()%></span>
                        </div>
                        <% if (!isEnded) { %>
                        <div style="margin-top: 8px; font-size: 14px; color: #666;">경매가 진행중입니다.</div>
                        <% } else { %>
                        <div style="margin-top: 8px; font-size: 14px; color: #dc2626;">경매가 종료되었습니다.</div>
                        <% } %>
                    </div>
                    <% } %>
                </div>
                
                <!-- Price Section -->
                <div class="price-section">
                    <div class="price-label">
                        <%= isEnded ? "최종 낙찰가" : "현재 입찰가" %>
                    </div>
                    <div class="current-price">
                        ₩<%=df.format(isEnded && p.getFinalPrice() > 0 ? p.getFinalPrice() : currentPrice)%>
                        <span class="price-currency">KRW</span>
                    </div>
                    <p class="start-price">시작가: ₩<%=df.format(p.getStartPrice())%></p>
                </div>
                
                <!-- Winner Section (if ended) -->
                <% if (isEnded && p.getWinnerId() != null) { %>
                <div class="winner-section">
                    <div class="winner-title">
                        <i class="fas fa-trophy"></i>
                        낙찰 완료
                    </div>
                    <div class="winner-info">
                        낙찰자: <%=p.getWinnerId()%> | 낙찰가: ₩<%=df.format(p.getFinalPrice())%>
                    </div>
                </div>
                <% } %>
                
                <!-- Bidding Section -->
                <% if ("A".equals(p.getStatus()) && !isSeller) { %>
                <div class="bidding-section">
                    <form action="<%=ctx%>/product/bidAction.jsp" method="post" onsubmit="return validateBid()">
                        <input type="hidden" name="productId" value="<%=productId%>">
                        <div class="bid-form">
                            <div class="bid-input-group">
                                <label class="bid-input-label">입찰가 (현재가보다 높게 입력)</label>
                                <input type="number" 
                                       id="bidPriceInput" 
                                       name="bidPrice" 
                                       class="bid-input"
                                       placeholder="<%=String.format("%,d", currentPrice + 10000)%>"
                                       min="<%=currentPrice + 1000%>"
                                       step="1000"
                                       required>
                            </div>
                            <button type="submit" class="bid-button">
                                <i class="fas fa-gavel"></i>
                                입찰하기
                            </button>
                            <% if (p.getBuyNowPrice() > 0 && p.getBuyNowPrice() > currentPrice) { %>
                            <button type="button" class="bid-button" style="background: #dc2626; margin-top: 10px;" 
                                    onclick="buyNow(<%=p.getBuyNowPrice()%>)">
                                <i class="fas fa-shopping-cart"></i>
                                즉시구매 (₩<%=df.format(p.getBuyNowPrice())%>)
                            </button>
                            <% } %>
                        </div>
                    </form>
                </div>
                <% } else if (isSeller) { %>
                <div class="bid-form">
                    <button class="bid-button" disabled>본인 상품입니다</button>
                </div>
                <% } else if (isEnded) { %>
                <div class="bid-form">
                    <button class="bid-button" disabled>경매가 종료되었습니다</button>
                </div>
                <% } %>
                
                <!-- Description -->
                <div class="description-section">
                    <h3 class="section-title">상품 설명</h3>
                    <div class="product-description">
                        <%=p.getProductDesc().replace("\n", "<br>")%>
                    </div>
                </div>
                
                <!-- Meta Information -->
                <div class="meta-section">
                    <div class="meta-grid">
                        <div class="meta-item">
                            <div class="meta-label">판매자</div>
                            <div class="meta-value"><%=p.getSellerId()%></div>
                        </div>
                        <div class="meta-item">
                            <div class="meta-label">등록일</div>
                            <div class="meta-value"><%=sdf.format(p.getRegDate())%></div>
                        </div>
                        <div class="meta-item">
                            <div class="meta-label">경매 마감</div>
                            <div class="meta-value"><%=sdf.format(p.getEndTime())%></div>
                        </div>
                        <div class="meta-item">
                            <div class="meta-label">즉시구매가</div>
                            <div class="meta-value">
                                <%= p.getBuyNowPrice() > 0 ? "₩" + df.format(p.getBuyNowPrice()) : "없음" %>
                            </div>
                        </div>
                    </div>
                    
                    <div class="action-links">
                        <a href="bidHistory.jsp?productId=<%=productId%>" class="action-link">
                            <i class="fas fa-list"></i>
                            입찰 내역
                        </a>
                        <a href="#" class="action-link" onclick="sharePage()">
                            <i class="fas fa-share"></i>
                            공유하기
                        </a>
                        <a href="#" class="action-link wishlist-btn" data-product-id="<%=productId%>" title="관심상품 추가">
                            <i class="far fa-heart"></i>
                            관심상품
                        </a>
                    </div>
                </div>
            </div>
        </div>
        <% } else { %>
        <div class="error-state">
            <i class="fas fa-exclamation-triangle"></i>
            <h2>상품을 찾을 수 없습니다</h2>
            <p>요청하신 상품이 존재하지 않거나 삭제되었습니다.</p>
        </div>
        <% } %>
    </div>
    
    <jsp:include page="/layout/footer/luxury-footer.jsp" />
    
    <% if(session.getAttribute("alertMsg") != null) { %>
    <script>
        alert("<%=session.getAttribute("alertMsg")%>");
    </script>
    <% session.removeAttribute("alertMsg"); %>
    <% } %>
    
    <script>
        const userMileage = <%=loginUser != null ? loginUser.getMileage() : 0%>;
        const currentPrice = <%=currentPrice%>;
        
        function validateBid() {
            const bidPriceInput = document.getElementById('bidPriceInput').value;
            console.log("입력값:", bidPriceInput);
            
            // 콤마 제거 후 숫자로 변환
            const bidPrice = parseInt(bidPriceInput.replace(/,/g, ''), 10);
            console.log("변환값:", bidPrice);

            if (isNaN(bidPrice) || bidPrice <= 0) {
                alert("올바른 입찰 금액을 입력해주세요. 입력값: " + bidPriceInput);
                return false;
            }
            if (bidPrice > userMileage) {
                alert(`마일리지가 부족합니다. (보유: ${userMileage.toLocaleString()}P)`);
                return false;
            }
            if (bidPrice <= currentPrice) {
                alert(`입찰가는 현재가(${currentPrice.toLocaleString()}원)보다 높아야 합니다.`);
                return false;
            }
            
            return confirm(`${bidPrice.toLocaleString()}원으로 입찰하시겠습니까?`);
        }
        
        // 즉시구매 함수
        function buyNow(buyNowPrice) {
            if (buyNowPrice > userMileage) {
                alert(`마일리지가 부족합니다. (보유: ${userMileage.toLocaleString()}P)`);
                return;
            }
            
            if (confirm(`즉시구매가 ${buyNowPrice.toLocaleString()}원으로 구매하시겠습니까?`)) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '<%=ctx%>/product/bidAction.jsp';
                
                const productIdInput = document.createElement('input');
                productIdInput.type = 'hidden';
                productIdInput.name = 'productId';
                productIdInput.value = '<%=productId%>';
                
                const bidPriceInput = document.createElement('input');
                bidPriceInput.type = 'hidden';
                bidPriceInput.name = 'bidPrice';
                bidPriceInput.value = buyNowPrice;
                
                const buyNowInput = document.createElement('input');
                buyNowInput.type = 'hidden';
                buyNowInput.name = 'isBuyNow';
                buyNowInput.value = 'true';
                
                form.appendChild(productIdInput);
                form.appendChild(bidPriceInput);
                form.appendChild(buyNowInput);
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        // 실시간 타이머 제거됨 - 정적 마감일시로 변경
        
        // 페이지 공유
        function sharePage() {
            if (navigator.share) {
                navigator.share({
                    title: '<%=p != null ? p.getProductName() : ""%>',
                    text: '<%=p != null ? p.getArtistName() + "의 작품" : ""%>',
                    url: window.location.href
                });
            } else {
                // 클립보드 복사
                navigator.clipboard.writeText(window.location.href).then(() => {
                    alert('링크가 클립보드에 복사되었습니다.');
                });
            }
        }
        
        // 관심상품 기능은 wishlist.js에서 처리됩니다
        
        // 타이머 제거됨 - 정적 마감일시 사용
        
        // 이미지 로드 실패시 대체 이미지로 변경
        document.addEventListener('DOMContentLoaded', function() {
            const images = document.querySelectorAll('img');
            images.forEach(img => {
                img.onerror = function() {
                    // 상품 상세페이지용 고품질 placeholder
                    this.src = 'https://images.unsplash.com/photo-1578321272176-b7bbc0679853?q=80&w=800';
                    this.onerror = null;
                };
            });
        });
    </script>
</body>
</html>