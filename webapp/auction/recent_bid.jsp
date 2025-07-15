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
    
    // 데이터베이스에서 최근 낙찰 목록 조회
    List<ProductDTO> recentWins = new ArrayList<>();
    Connection conn = null;
    try {
        conn = getConnection();
        ProductDAO productDao = new ProductDAO();
        recentWins = productDao.selectRecentWins(conn);
        if (recentWins == null) {
            recentWins = new ArrayList<>();
        }
    } catch (Exception e) {
        e.printStackTrace();
        recentWins = new ArrayList<>(); // 에러 시 빈 리스트로 초기화
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
    <title>최근 낙찰 결과 - M4 Auction</title>
    
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
            background: linear-gradient(135deg, #c9961a 0%, #d4af37 100%);
            color: white;
            padding: 80px 0;
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
            font-size: 48px;
            font-weight: 700;
            margin-bottom: 20px;
        }
        
        .hero-subtitle {
            font-size: 20px;
            opacity: 0.9;
            max-width: 600px;
            margin: 0 auto 40px;
        }
        
        .hero-stats {
            display: flex;
            justify-content: center;
            gap: 40px;
            flex-wrap: wrap;
        }
        
        .hero-stat {
            text-align: center;
        }
        
        .hero-stat-number {
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 5px;
        }
        
        .hero-stat-label {
            font-size: 14px;
            opacity: 0.8;
        }
        
        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 20px;
        }
        
        .content-section {
            padding: 60px 0;
        }
        
        .section-header {
            text-align: center;
            margin-bottom: 50px;
        }
        
        .section-title {
            font-family: 'Playfair Display', serif;
            font-size: 36px;
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
        
        .filter-tabs {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-bottom: 40px;
            flex-wrap: wrap;
        }
        
        .filter-tab {
            padding: 12px 24px;
            border: 2px solid #e5e5e5;
            background: white;
            border-radius: 25px;
            font-size: 16px;
            font-weight: 500;
            color: #666;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .filter-tab.active {
            background: #c9961a;
            color: white;
            border-color: #c9961a;
        }
        
        .results-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(400px, 1fr));
            gap: 30px;
            margin-bottom: 40px;
        }
        
        .result-card {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08);
            transition: all 0.3s;
            position: relative;
        }
        
        .result-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        
        .result-image {
            position: relative;
            height: 250px;
            overflow: hidden;
        }
        
        .result-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s;
        }
        
        .result-card:hover .result-image img {
            transform: scale(1.05);
        }
        
        .sold-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background: linear-gradient(135deg, #dc2626 0%, #ef4444 100%);
            color: white;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .price-overlay {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            background: linear-gradient(transparent, rgba(0,0,0,0.7));
            color: white;
            padding: 20px;
        }
        
        .final-price {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 5px;
        }
        
        .price-label {
            font-size: 12px;
            opacity: 0.8;
        }
        
        .result-info {
            padding: 25px;
        }
        
        .result-title {
            font-size: 20px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 8px;
            line-height: 1.4;
        }
        
        .result-artist {
            color: #666;
            font-size: 16px;
            margin-bottom: 20px;
        }
        
        .result-details {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-bottom: 20px;
        }
        
        .detail-item {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }
        
        .detail-label {
            font-size: 12px;
            color: #999;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .detail-value {
            font-size: 14px;
            color: #333;
            font-weight: 500;
        }
        
        .winner-info {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .winner-avatar {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #c9961a 0%, #d4af37 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
        }
        
        .winner-details h4 {
            margin: 0 0 2px 0;
            font-size: 14px;
            color: #333;
        }
        
        .winner-details p {
            margin: 0;
            font-size: 12px;
            color: #666;
        }
        
        .stats-section {
            background: white;
            padding: 50px 0;
            margin: 40px 0;
            border-radius: 12px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08);
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 30px;
        }
        
        .stat-card {
            text-align: center;
            padding: 20px;
        }
        
        .stat-icon {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #c9961a 0%, #d4af37 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 24px;
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
            
            .hero-stats {
                gap: 20px;
            }
            
            .results-grid {
                grid-template-columns: 1fr;
            }
            
            .filter-tabs {
                gap: 5px;
            }
            
            .filter-tab {
                padding: 10px 16px;
                font-size: 14px;
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
                <h1 class="hero-title">Recent Results</h1>
                <p class="hero-subtitle">최근 성공적으로 마무리된 경매들의 결과를 확인해보세요</p>
                
                <div class="hero-stats">
                    <div class="hero-stat">
                        <div class="hero-stat-number"><%=recentWins.size()%></div>
                        <div class="hero-stat-label">최근 낙찰</div>
                    </div>
                    <div class="hero-stat">
                        <div class="hero-stat-number">
                            <%
                                long totalAmount = 0;
                                if (recentWins != null) {
                                    for (ProductDTO win : recentWins) {
                                        if (win != null && win.getFinalPrice() > 0) {
                                            totalAmount += win.getFinalPrice();
                                        }
                                    }
                                }
                            %>
                            <%=recentWins.isEmpty() ? "0" : df.format(totalAmount)%>원
                        </div>
                        <div class="hero-stat-label">총 거래금액</div>
                    </div>
                    <div class="hero-stat">
                        <div class="hero-stat-number">98%</div>
                        <div class="hero-stat-label">성공률</div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Content -->
    <section class="content-section">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">낙찰 결과</h2>
                <p class="section-subtitle">성공적으로 마무리된 경매들의 상세한 결과를 확인하실 수 있습니다</p>
            </div>
            
            <!-- Filter Tabs -->
            <div class="filter-tabs">
                <button class="filter-tab active">전체</button>
                <button class="filter-tab">회화</button>
                <button class="filter-tab">조각</button>
                <button class="filter-tab">판화</button>
                <button class="filter-tab">사진</button>
            </div>
            
            <!-- Results Grid -->
            <% if (recentWins.isEmpty()) { %>
                <div class="empty-state">
                    <i class="fas fa-trophy"></i>
                    <h3>최근 낙찰 결과가 없습니다</h3>
                    <p>경매가 성공적으로 마무리되면 여기에 결과가 표시됩니다.</p>
                    <a href="<%=ctx%>/auction/auctionList.jsp" class="cta-button">진행중인 경매 보기</a>
                </div>
            <% } else { %>
                <div class="results-grid">
                    <% for (ProductDTO result : recentWins) { %>
                        <div class="result-card">
                            <div class="result-image">
                                <% if (result.getImageRenamedName() != null) { %>
                                    <img src="<%=ctx%>/resources/images/<%=result.getImageRenamedName()%>" 
                                         alt="<%=result.getProductName()%>" 
                                         onerror="this.src='<%=ctx%>/resources/images/no-image.jpg'">
                                <% } else { %>
                                    <img src="<%=ctx%>/resources/images/no-image.jpg" alt="No Image">
                                <% } %>
                                
                                <div class="sold-badge">
                                    <i class="fas fa-check"></i> SOLD
                                </div>
                                
                                <div class="price-overlay">
                                    <div class="final-price"><%=df.format(result.getFinalPrice())%>원</div>
                                    <div class="price-label">최종 낙찰가</div>
                                </div>
                            </div>
                            
                            <div class="result-info">
                                <h3 class="result-title"><%=result.getProductName()%></h3>
                                <p class="result-artist"><%=result.getArtistName() != null ? result.getArtistName() : "-"%></p>
                                
                                <div class="result-details">
                                    <div class="detail-item">
                                        <span class="detail-label">경매 번호</span>
                                        <span class="detail-value">#<%=result.getProductId()%></span>
                                    </div>
                                    <div class="detail-item">
                                        <span class="detail-label">낙찰일</span>
                                        <span class="detail-value"><%=result.getRegDate() != null ? dateFormat.format(result.getRegDate()) : "-"%></span>
                                    </div>
                                    <div class="detail-item">
                                        <span class="detail-label">시작가</span>
                                        <span class="detail-value"><%=df.format(result.getStartPrice())%>원</span>
                                    </div>
                                    <div class="detail-item">
                                        <span class="detail-label">상승률</span>
                                        <span class="detail-value">
                                            <% 
                                                int startPrice = result.getStartPrice();
                                                if (startPrice > 0) {
                                                    double increase = ((double)(result.getFinalPrice() - startPrice) / startPrice) * 100;
                                            %>
                                                +<%=String.format("%.1f", increase)%>%
                                            <% } else { %>
                                                -
                                            <% } %>
                                        </span>
                                    </div>
                                </div>
                                
                                <div class="winner-info">
                                    <div class="winner-avatar">
                                        <%= result.getWinnerId() != null ? result.getWinnerId().substring(0, 1).toUpperCase() : "?" %>
                                    </div>
                                    <div class="winner-details">
                                        <h4>낙찰자: <%= result.getWinnerId() != null ? result.getWinnerId() : "정보없음" %></h4>
                                        <p>성공적인 입찰로 작품을 획득했습니다</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </div>
    </section>
    
    <!-- Statistics Section -->
    <section class="stats-section">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">경매 성과</h2>
                <p class="section-subtitle">M4 Auction의 놀라운 성과를 숫자로 확인해보세요</p>
            </div>
            
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-trophy"></i>
                    </div>
                    <div class="stat-number">1,247</div>
                    <div class="stat-label">총 낙찰 건수</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-chart-line"></i>
                    </div>
                    <div class="stat-number">₩18.2B</div>
                    <div class="stat-label">총 거래 금액</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="stat-number">5,683</div>
                    <div class="stat-label">참여 고객 수</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-percentage"></i>
                    </div>
                    <div class="stat-number">98.7%</div>
                    <div class="stat-label">낙찰 성공률</div>
                </div>
            </div>
        </div>
    </section>
    
    <jsp:include page="/layout/footer/luxury-footer.jsp" />
    
    <script>
        // 필터 탭 기능
        document.querySelectorAll('.filter-tab').forEach(tab => {
            tab.addEventListener('click', function() {
                document.querySelectorAll('.filter-tab').forEach(t => t.classList.remove('active'));
                this.classList.add('active');
                
                // TODO: 실제 필터링 로직 구현
                const category = this.textContent;
                console.log('Filtering by:', category);
            });
        });
    </script>
</body>
</html>
