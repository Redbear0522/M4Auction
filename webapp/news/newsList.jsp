<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.auction.dto.MemberDTO" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%
    String ctx = request.getContextPath();
    MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>뉴스 & 공지사항 - M4 Auction</title>
    
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
        
        .news-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 40px 24px;
        }
        
        .news-header {
            text-align: center;
            margin-bottom: 48px;
        }
        
        .news-title {
            font-family: 'Playfair Display', serif;
            font-size: 48px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 16px;
        }
        
        .news-subtitle {
            color: #6b7280;
            font-size: 18px;
            margin: 0;
        }
        
        .news-tabs {
            display: flex;
            justify-content: center;
            gap: 0;
            margin-bottom: 40px;
            background: white;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            padding: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        
        .tab-btn {
            padding: 12px 32px;
            background: transparent;
            border: none;
            font-size: 14px;
            font-weight: 600;
            color: #6b7280;
            cursor: pointer;
            border-radius: 8px;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .tab-btn.active {
            background: #1a1a1a;
            color: white;
        }
        
        .news-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 40px;
            margin-bottom: 48px;
        }
        
        .main-news {
            display: grid;
            gap: 32px;
        }
        
        .featured-news {
            background: white;
            border: 2px solid #e5e7eb;
            border-radius: 16px;
            overflow: hidden;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .featured-news:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 32px rgba(0,0,0,0.1);
        }
        
        .featured-image {
            width: 100%;
            height: 300px;
            background: linear-gradient(135deg, #1a1a1a 0%, #c9961a 100%);
            position: relative;
            overflow: hidden;
        }
        
        .featured-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .featured-badge {
            position: absolute;
            top: 20px;
            left: 20px;
            background: rgba(201, 150, 26, 0.9);
            color: white;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            backdrop-filter: blur(10px);
        }
        
        .featured-content {
            padding: 32px;
        }
        
        .featured-category {
            font-size: 11px;
            color: #c9961a;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            margin-bottom: 12px;
            font-weight: 600;
        }
        
        .featured-title {
            font-family: 'Playfair Display', serif;
            font-size: 28px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 16px;
            line-height: 1.3;
        }
        
        .featured-excerpt {
            color: #6b7280;
            font-size: 16px;
            line-height: 1.6;
            margin-bottom: 24px;
        }
        
        .featured-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 12px;
            color: #9ca3af;
        }
        
        .news-list {
            display: grid;
            gap: 24px;
        }
        
        .news-item {
            background: white;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            padding: 24px;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .news-item:hover {
            border-color: #d1d5db;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08);
        }
        
        .news-item-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 12px;
        }
        
        .news-item-category {
            font-size: 10px;
            color: #c9961a;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            font-weight: 700;
        }
        
        .news-item-date {
            font-size: 11px;
            color: #9ca3af;
        }
        
        .news-item-title {
            font-size: 16px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 8px;
            line-height: 1.4;
        }
        
        .news-item-excerpt {
            color: #6b7280;
            font-size: 13px;
            line-height: 1.5;
        }
        
        .sidebar {
            display: grid;
            gap: 32px;
        }
        
        .sidebar-section {
            background: white;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            padding: 24px;
        }
        
        .sidebar-title {
            font-size: 18px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 20px;
            padding-bottom: 12px;
            border-bottom: 2px solid #f3f4f6;
        }
        
        .popular-list {
            display: grid;
            gap: 16px;
        }
        
        .popular-item {
            display: flex;
            gap: 12px;
            padding: 12px;
            border-radius: 8px;
            transition: background 0.3s ease;
            cursor: pointer;
        }
        
        .popular-item:hover {
            background: #f9fafb;
        }
        
        .popular-rank {
            width: 24px;
            height: 24px;
            background: #c9961a;
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 11px;
            font-weight: 700;
            flex-shrink: 0;
        }
        
        .popular-content {
            flex: 1;
        }
        
        .popular-title {
            font-size: 13px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 4px;
            line-height: 1.3;
        }
        
        .popular-date {
            font-size: 11px;
            color: #9ca3af;
        }
        
        .notice-banner {
            background: linear-gradient(135deg, #1a1a1a 0%, #c9961a 100%);
            color: white;
            padding: 24px;
            border-radius: 12px;
            text-align: center;
        }
        
        .notice-banner h3 {
            font-size: 16px;
            font-weight: 700;
            margin-bottom: 8px;
        }
        
        .notice-banner p {
            font-size: 13px;
            opacity: 0.9;
            margin-bottom: 16px;
        }
        
        .notice-btn {
            background: rgba(255,255,255,0.2);
            color: white;
            border: 2px solid rgba(255,255,255,0.3);
            padding: 8px 16px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-block;
        }
        
        .notice-btn:hover {
            background: rgba(255,255,255,0.3);
            border-color: rgba(255,255,255,0.5);
        }
        
        /* 반응형 */
        @media (max-width: 768px) {
            body {
                padding-top: 100px !important;
            }
            
            .news-container {
                padding: 20px 16px;
            }
            
            .news-title {
                font-size: 36px;
            }
            
            .news-tabs {
                flex-wrap: wrap;
                gap: 8px;
            }
            
            .tab-btn {
                padding: 8px 16px;
                font-size: 12px;
            }
            
            .news-grid {
                grid-template-columns: 1fr;
                gap: 32px;
            }
            
            .featured-content {
                padding: 24px;
            }
            
            .featured-title {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/layout/header/luxury-header.jsp" />
    
    <div class="news-container">
        <!-- Header -->
        <div class="news-header">
            <h1 class="news-title">뉴스 & 공지사항</h1>
            <p class="news-subtitle">M4 Auction의 최신 소식과 경매 정보를 확인하세요</p>
        </div>
        
        <!-- Tabs -->
        <div class="news-tabs">
            <button class="tab-btn active" onclick="switchTab('all')">전체</button>
            <button class="tab-btn" onclick="switchTab('news')">뉴스</button>
            <button class="tab-btn" onclick="switchTab('notice')">공지사항</button>
            <button class="tab-btn" onclick="switchTab('auction')">경매소식</button>
        </div>
        
        <!-- Content -->
        <div class="news-grid">
            <!-- Main News -->
            <div class="main-news">
                <!-- Featured News -->
                <article class="featured-news" onclick="viewNews(1)">
                    <div class="featured-image">
                        <div class="featured-badge">Hot</div>
                        <!-- 실제 이미지가 있을 때 사용 -->
                        <!-- <img src="news-image.jpg" alt="뉴스 이미지"> -->
                    </div>
                    <div class="featured-content">
                        <div class="featured-category">경매 소식</div>
                        <h2 class="featured-title">2025년 상반기 메이저 경매 일정 발표</h2>
                        <p class="featured-excerpt">
                            올해 상반기 진행될 주요 경매 일정이 확정되었습니다. 국내외 유명 작가들의 작품이 
                            대거 출품될 예정이며, 특히 근현대 미술품에 대한 관심이 높아질 것으로 예상됩니다.
                        </p>
                        <div class="featured-meta">
                            <span>편집부</span>
                            <span><%=sdf.format(new Date())%></span>
                        </div>
                    </div>
                </article>
                
                <!-- News List -->
                <div class="news-list">
                    <article class="news-item" onclick="viewNews(2)">
                        <div class="news-item-header">
                            <span class="news-item-category">경매 결과</span>
                            <span class="news-item-date">2025.01.05</span>
                        </div>
                        <h3 class="news-item-title">김환기 작품, 역대 최고가 경신</h3>
                        <p class="news-item-excerpt">
                            지난 주말 진행된 근현대미술 경매에서 김환기의 '어디서 무엇이 되어 다시 만나랴' 작품이 
                            15억원에 낙찰되며 작가 개인 최고가를 경신했습니다.
                        </p>
                    </article>
                    
                    <article class="news-item" onclick="viewNews(3)">
                        <div class="news-item-header">
                            <span class="news-item-category">공지사항</span>
                            <span class="news-item-date">2025.01.03</span>
                        </div>
                        <h3 class="news-item-title">신규 VIP 멤버십 혜택 안내</h3>
                        <p class="news-item-excerpt">
                            새해를 맞아 VIP 멤버십 혜택이 대폭 확대됩니다. 
                            프리뷰 우선 관람권, 전용 상담 서비스 등 다양한 혜택을 만나보세요.
                        </p>
                    </article>
                    
                    <article class="news-item" onclick="viewNews(4)">
                        <div class="news-item-header">
                            <span class="news-item-category">전시 안내</span>
                            <span class="news-item-date">2025.01.01</span>
                        </div>
                        <h3 class="news-item-title">신년 특별 전시 '모던 아트 컬렉션' 개최</h3>
                        <p class="news-item-excerpt">
                            새해 첫 특별 전시로 20세기 모던 아트 걸작들을 한자리에서 만나볼 수 있는 
                            전시가 1월 15일부터 시작됩니다.
                        </p>
                    </article>
                    
                    <article class="news-item" onclick="viewNews(5)">
                        <div class="news-item-header">
                            <span class="news-item-category">시장 동향</span>
                            <span class="news-item-date">2024.12.28</span>
                        </div>
                        <h3 class="news-item-title">2024년 아트마켓 결산 보고서</h3>
                        <p class="news-item-excerpt">
                            지난 한 해 국내 아트마켓의 주요 동향과 성과를 분석한 
                            종합 보고서가 발간되었습니다.
                        </p>
                    </article>
                </div>
            </div>
            
            <!-- Sidebar -->
            <aside class="sidebar">
                <!-- Popular News -->
                <div class="sidebar-section">
                    <h3 class="sidebar-title">인기 뉴스</h3>
                    <div class="popular-list">
                        <div class="popular-item" onclick="viewNews(6)">
                            <div class="popular-rank">1</div>
                            <div class="popular-content">
                                <h4 class="popular-title">박수근 작품 경매 화제</h4>
                                <span class="popular-date">2025.01.04</span>
                            </div>
                        </div>
                        <div class="popular-item" onclick="viewNews(7)">
                            <div class="popular-rank">2</div>
                            <div class="popular-content">
                                <h4 class="popular-title">해외 컬렉터 국내 작품 관심 증가</h4>
                                <span class="popular-date">2025.01.02</span>
                            </div>
                        </div>
                        <div class="popular-item" onclick="viewNews(8)">
                            <div class="popular-rank">3</div>
                            <div class="popular-content">
                                <h4 class="popular-title">온라인 경매 참여 방법 가이드</h4>
                                <span class="popular-date">2024.12.30</span>
                            </div>
                        </div>
                        <div class="popular-item" onclick="viewNews(9)">
                            <div class="popular-rank">4</div>
                            <div class="popular-content">
                                <h4 class="popular-title">아트 투자 전문가 인터뷰</h4>
                                <span class="popular-date">2024.12.28</span>
                            </div>
                        </div>
                        <div class="popular-item" onclick="viewNews(10)">
                            <div class="popular-rank">5</div>
                            <div class="popular-content">
                                <h4 class="popular-title">2025년 주목할 신진 작가들</h4>
                                <span class="popular-date">2024.12.25</span>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Notice Banner -->
                <div class="notice-banner">
                    <h3>경매 참여 안내</h3>
                    <p>온라인 경매 참여를 위한<br>가이드를 확인하세요</p>
                    <a href="<%=ctx%>/auction/auctionList.jsp" class="notice-btn">
                        경매 참여하기
                    </a>
                </div>
                
                <!-- Quick Links -->
                <div class="sidebar-section">
                    <h3 class="sidebar-title">빠른 링크</h3>
                    <div class="popular-list">
                        <div class="popular-item" onclick="location.href='<%=ctx%>/auction/auctionList.jsp'">
                            <div class="popular-content">
                                <h4 class="popular-title">진행중인 경매</h4>
                            </div>
                        </div>
                        <div class="popular-item" onclick="location.href='<%=ctx%>/category/categoryList.jsp'">
                            <div class="popular-content">
                                <h4 class="popular-title">카테고리별 보기</h4>
                            </div>
                        </div>
                        <div class="popular-item" onclick="location.href='<%=ctx%>/product/productEnrollForm.jsp'">
                            <div class="popular-content">
                                <h4 class="popular-title">상품 등록하기</h4>
                            </div>
                        </div>
                        <div class="popular-item" onclick="location.href='<%=ctx%>/mypage/myPage.jsp'">
                            <div class="popular-content">
                                <h4 class="popular-title">마이페이지</h4>
                            </div>
                        </div>
                    </div>
                </div>
            </aside>
        </div>
    </div>
    
    <jsp:include page="/layout/footer/luxury-footer.jsp" />
    
    <script>
        function switchTab(tab) {
            // 탭 활성화
            document.querySelectorAll('.tab-btn').forEach(btn => {
                btn.classList.remove('active');
            });
            event.target.classList.add('active');
            
            // 실제 구현에서는 서버에서 해당 카테고리의 뉴스를 가져와야 함
            console.log('Switching to tab:', tab);
        }
        
        function viewNews(newsId) {
            // 뉴스 상세 페이지로 이동
            alert('뉴스 ' + newsId + '번 상세보기 (실제로는 상세 페이지로 이동)');
        }
    </script>
</body>
</html>