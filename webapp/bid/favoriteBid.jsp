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
    
    // 인기 경매 목록 조회
    List<ProductDTO> popularAuctions = new ArrayList<>();
    Connection conn = null;
    try {
        conn = getConnection();
        ProductDAO productDao = new ProductDAO();
        popularAuctions = productDao.selectPopularAuctions(conn);
        if (popularAuctions == null) {
            popularAuctions = new ArrayList<>();
        }
    } catch (Exception e) {
        e.printStackTrace();
        popularAuctions = new ArrayList<>();
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
    <title>인기경매 - M4 Auction</title>
    
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
        
        .page-hero {
            background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
            color: white;
            padding: 100px 0;
            position: relative;
            overflow: hidden;
        }
        
        .page-hero::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('https://images.unsplash.com/photo-1578662996442-48f60103fc96?q=80&w=2000') center/cover;
            opacity: 0.1;
        }
        
        .hero-content {
            position: relative;
            z-index: 2;
            text-align: center;
        }
        
        .hero-title {
            font-family: 'Playfair Display', serif;
            font-size: 56px;
            font-weight: 700;
            margin-bottom: 20px;
            background: linear-gradient(45deg, #c9961a, #d4af37);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .hero-subtitle {
            font-size: 22px;
            opacity: 0.9;
            max-width: 600px;
            margin: 0 auto 50px;
        }
        
        .hero-stats {
            display: flex;
            justify-content: center;
            gap: 60px;
            flex-wrap: wrap;
        }
        
        .hero-stat {
            text-align: center;
        }
        
        .hero-stat-number {
            font-size: 36px;
            font-weight: 700;
            margin-bottom: 8px;
            color: #c9961a;
        }
        
        .hero-stat-label {
            font-size: 14px;
            opacity: 0.8;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 20px;
        }
        
        .content-section {
            padding: 80px 0;
        }
        
        .section-header {
            text-align: center;
            margin-bottom: 60px;
        }
        
        .section-title {
            font-family: 'Playfair Display', serif;
            font-size: 42px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 15px;
        }
        
        .section-subtitle {
            font-size: 18px;
            color: #666;
            max-width: 600px;
            margin: 0 auto;
        }
        
        .filter-controls {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-bottom: 50px;
            flex-wrap: wrap;
        }
        
        .filter-btn {
            padding: 12px 24px;
            border: 2px solid #e5e5e5;
            background: white;
            border-radius: 25px;
            font-size: 16px;
            font-weight: 500;
            color: #666;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .filter-btn:hover,
        .filter-btn.active {
            background: #c9961a;
            color: white;
            border-color: #c9961a;
            transform: translateY(-2px);
        }
        
        .popular-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 30px;
            margin-bottom: 50px;
        }
        
        .popular-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            transition: all 0.3s;
            position: relative;
        }
        
        .popular-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.15);
        }
        
        .card-image {
            position: relative;
            height: 250px;
            overflow: hidden;
        }
        
        .card-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s;
        }
        
        .popular-card:hover .card-image img {
            transform: scale(1.05);
        }
        
        .popularity-badge {
            position: absolute;
            top: 15px;
            left: 15px;
            background: linear-gradient(135deg, #dc2626 0%, #ef4444 100%);
            color: white;
            padding: 6px 12px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .time-left {
            position: absolute;
            top: 15px;
            right: 15px;
            background: rgba(0,0,0,0.8);
            color: white;
            padding: 8px 12px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .bid-overlay {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            background: linear-gradient(transparent, rgba(0,0,0,0.8));
            color: white;
            padding: 25px 20px 20px;
        }
        
        .current-bid {
            font-size: 22px;
            font-weight: 700;
            margin-bottom: 5px;
        }
        
        .bid-label {
            font-size: 12px;
            opacity: 0.8;
        }
        
        .card-content {
            padding: 25px;
        }
        
        .card-title {
            font-size: 20px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 8px;
            line-height: 1.4;
        }
        
        .card-artist {
            color: #666;
            font-size: 16px;
            margin-bottom: 20px;
        }
        
        .card-stats {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-bottom: 20px;
        }
        
        .stat-item {
            text-align: center;
            padding: 12px;
            background: #f8f9fa;
            border-radius: 8px;
        }
        
        .stat-number {
            font-size: 18px;
            font-weight: 700;
            color: #c9961a;
            margin-bottom: 3px;
        }
        
        .stat-label {
            font-size: 12px;
            color: #666;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .card-actions {
            display: flex;
            gap: 10px;
        }
        
        .btn-primary {
            flex: 1;
            background: linear-gradient(135deg, #c9961a 0%, #d4af37 100%);
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            text-align: center;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(201, 150, 26, 0.3);
        }
        
        .btn-secondary {
            background: white;
            color: #666;
            border: 2px solid #e5e5e5;
            padding: 12px 16px;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .btn-secondary:hover {
            border-color: #c9961a;
            color: #c9961a;
        }
        
        .trending-section {
            background: white;
            padding: 80px 0;
            margin: 60px 0;
        }
        
        .trending-list {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
        }
        
        .trending-item {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 12px;
            transition: all 0.3s;
        }
        
        .trending-item:hover {
            background: #e9ecef;
            transform: translateY(-3px);
        }
        
        .trending-rank {
            width: 40px;
            height: 40px;
            background: #c9961a;
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            font-weight: 700;
        }
        
        .trending-info {
            flex: 1;
        }
        
        .trending-title {
            font-size: 16px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 5px;
        }
        
        .trending-price {
            font-size: 14px;
            color: #c9961a;
            font-weight: 600;
        }
        
        .empty-state {
            text-align: center;
            padding: 100px 20px;
            color: #666;
        }
        
        .empty-state i {
            font-size: 64px;
            color: #ddd;
            margin-bottom: 20px;
        }
        
        .empty-state h3 {
            font-size: 24px;
            margin-bottom: 10px;
            color: #333;
        }
        
        .empty-state p {
            font-size: 16px;
            margin-bottom: 30px;
        }
        
        .cta-button {
            background: linear-gradient(135deg, #c9961a 0%, #d4af37 100%);
            color: white;
            padding: 15px 30px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            display: inline-block;
            transition: transform 0.3s;
        }
        
        .cta-button:hover {
            transform: translateY(-2px);
        }
        
        @media (max-width: 768px) {
            .hero-title {
                font-size: 36px;
            }
            
            .hero-subtitle {
                font-size: 18px;
            }
            
            .hero-stats {
                gap: 30px;
            }
            
            .popular-grid {
                grid-template-columns: 1fr;
            }
            
            .filter-controls {
                gap: 10px;
            }
            
            .filter-btn {
                padding: 10px 16px;
                font-size: 14px;
            }
            
            .trending-list {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/layout/header/luxury-header.jsp" />
    
    <!-- Page Hero -->
    <section class="page-hero">
        <div class="container">
            <div class="hero-content">
                <h1 class="hero-title">Popular Auctions</h1>
                <p class="hero-subtitle">
                    가장 인기 있는 경매들을 확인하고 놓치지 마세요.<br>
                    실시간으로 업데이트되는 인기 경매 목록입니다.
                </p>
                <div class="hero-stats">
                    <div class="hero-stat">
                        <div class="hero-stat-number"><%=popularAuctions.size()%></div>
                        <div class="hero-stat-label">인기 경매</div>
                    </div>
                    <div class="hero-stat">
                        <div class="hero-stat-number">24H</div>
                        <div class="hero-stat-label">실시간 업데이트</div>
                    </div>
                    <div class="hero-stat">
                        <div class="hero-stat-number"><%=loginUser != null ? "VIP" : "GUEST"%></div>
                        <div class="hero-stat-label">회원 등급</div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Content -->
    <section class="content-section">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">인기 경매</h2>
                <p class="section-subtitle">조회수와 입찰 수가 많은 인기 경매 아이템들</p>
            </div>
            
            <!-- Filter Controls -->
            <div class="filter-controls">
                <a href="#" class="filter-btn active" onclick="filterAuctions('all')">
                    <i class="fas fa-fire"></i>
                    전체
                </a>
                <a href="#" class="filter-btn" onclick="filterAuctions('painting')">
                    <i class="fas fa-palette"></i>
                    회화
                </a>
                <a href="#" class="filter-btn" onclick="filterAuctions('sculpture')">
                    <i class="fas fa-cube"></i>
                    조각
                </a>
                <a href="#" class="filter-btn" onclick="filterAuctions('print')">
                    <i class="fas fa-print"></i>
                    판화
                </a>
                <a href="#" class="filter-btn" onclick="filterAuctions('photography')">
                    <i class="fas fa-camera"></i>
                    사진
                </a>
            </div>
            
            <!-- Popular Auctions Grid -->
            <% if (popularAuctions.isEmpty()) { %>
                <div class="empty-state">
                    <i class="fas fa-fire"></i>
                    <h3>인기 경매가 없습니다</h3>
                    <p>현재 진행중인 인기 경매가 없습니다. 다른 경매를 확인해보세요.</p>
                    <a href="<%=ctx%>/auction/auctionList.jsp" class="cta-button">전체 경매 보기</a>
                </div>
            <% } else { %>
                <div class="popular-grid">
                    <% for (int i = 0; i < Math.min(popularAuctions.size(), 12); i++) { 
                        ProductDTO auction = popularAuctions.get(i);
                    %>
                        <div class="popular-card" data-category="<%=auction.getCategory() != null ? auction.getCategory() : "etc"%>">
                            <div class="card-image">
                                <% if (auction.getImageRenamedName() != null) { %>
                                    <img src="<%=ctx%>/resources/product_images/<%=auction.getImageRenamedName()%>" 
                                         alt="<%=auction.getProductName()%>" 
                                         onerror="this.src='<%=ctx%>/resources/product_images/default.jpg'">
                                <% } else { %>
                                    <img src="<%=ctx%>/resources/product_images/default.jpg" alt="No Image">
                                <% } %>
                                
                                <div class="popularity-badge">
                                    <i class="fas fa-fire"></i>
                                    HOT
                                </div>
                                
                                <div class="time-left">
                                    <i class="fas fa-clock"></i>
                                    <%= auction.getStatus() != null && auction.getStatus().equals("ONGOING") ? "진행중" : "종료" %>
                                </div>
                                
                                <div class="bid-overlay">
                                    <div class="current-bid">
                                        <%=auction.getCurrentPrice() > 0 ? df.format(auction.getCurrentPrice()) : df.format(auction.getStartPrice())%>원
                                    </div>
                                    <div class="bid-label">현재 입찰가</div>
                                </div>
                            </div>
                            
                            <div class="card-content">
                                <h3 class="card-title"><%=auction.getProductName()%></h3>
                                <p class="card-artist"><%=auction.getArtistName() != null ? auction.getArtistName() : "작가 미상"%></p>
                                
                                <div class="card-stats">
                                    <div class="stat-item">
                                        <div class="stat-number"><%=auction.getViewCount() != null ? auction.getViewCount() : 0%></div>
                                        <div class="stat-label">조회수</div>
                                    </div>
                                    <div class="stat-item">
                                        <div class="stat-number"><%=auction.getBidCount() != null ? auction.getBidCount() : 0%></div>
                                        <div class="stat-label">입찰 수</div>
                                    </div>
                                </div>
                                
                                <div class="card-actions">
                                    <% if (loginUser != null) { %>
                                        <a href="<%=ctx%>/product/bidAction.jsp?productId=<%=auction.getProductId()%>" class="btn-primary">
                                            <i class="fas fa-gavel"></i>
                                            입찰하기
                                        </a>
                                    <% } else { %>
                                        <a href="<%=ctx%>/member/luxury-login.jsp" class="btn-primary">
                                            <i class="fas fa-sign-in-alt"></i>
                                            로그인
                                        </a>
                                    <% } %>
                                    <a href="<%=ctx%>/product/productDetail.jsp?productId=<%=auction.getProductId()%>" class="btn-secondary">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </div>
    </section>
    
    <!-- Trending Section -->
    <section class="trending-section">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">실시간 인기 순위</h2>
                <p class="section-subtitle">지금 가장 관심받는 경매 TOP 10</p>
            </div>
            
            <div class="trending-list">
                <% for (int i = 0; i < Math.min(popularAuctions.size(), 10); i++) { 
                    ProductDTO item = popularAuctions.get(i);
                %>
                    <div class="trending-item">
                        <div class="trending-rank"><%=i + 1%></div>
                        <div class="trending-info">
                            <div class="trending-title"><%=item.getProductName()%></div>
                            <div class="trending-price">
                                <%=item.getCurrentPrice() > 0 ? df.format(item.getCurrentPrice()) : df.format(item.getStartPrice())%>원
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>
    </section>
    
    <jsp:include page="/layout/footer/luxury-footer.jsp" />
    
    <script>
        function filterAuctions(category) {
            // 모든 필터 버튼에서 active 클래스 제거
            document.querySelectorAll('.filter-btn').forEach(btn => {
                btn.classList.remove('active');
            });
            
            // 클릭된 버튼에 active 클래스 추가
            event.target.classList.add('active');
            
            // 카드 필터링
            const cards = document.querySelectorAll('.popular-card');
            cards.forEach(card => {
                const cardCategory = card.getAttribute('data-category');
                if (category === 'all' || cardCategory === category) {
                    card.style.display = 'block';
                } else {
                    card.style.display = 'none';
                }
            });
        }
        
        // 페이지 로드 시 시간 업데이트
        function updateTimeLeft() {
            const timeElements = document.querySelectorAll('.time-left');
            timeElements.forEach(element => {
                // 실제 구현에서는 서버에서 받은 종료 시간과 현재 시간을 비교하여 업데이트
                // 지금은 데모용으로 고정
            });
        }
        
        // 5초마다 시간 업데이트
        setInterval(updateTimeLeft, 5000);
        
        // 초기 로드
        updateTimeLeft();
    </script>
</body>
</html>