<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.auction.dto.MemberDTO" %>
<%
    String ctx = request.getContextPath();
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About M4 Auction - 회사 소개</title>
    
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
        
        .about-hero {
            background: linear-gradient(135deg, #1a1a1a 0%, #c9961a 100%);
            color: white;
            padding: 80px 0;
            text-align: center;
        }
        
        .about-hero h1 {
            font-family: 'Playfair Display', serif;
            font-size: 48px;
            font-weight: 700;
            margin-bottom: 20px;
        }
        
        .about-hero p {
            font-size: 20px;
            opacity: 0.9;
            max-width: 600px;
            margin: 0 auto;
        }
        
        .about-content {
            padding: 80px 0;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }
        
        .section {
            margin-bottom: 80px;
        }
        
        .section-title {
            font-family: 'Playfair Display', serif;
            font-size: 32px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 30px;
            text-align: center;
        }
        
        .section-content {
            font-size: 16px;
            line-height: 1.8;
            color: #555;
            text-align: center;
            max-width: 800px;
            margin: 0 auto;
        }
        
        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 40px;
            margin-top: 60px;
        }
        
        .feature-card {
            background: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08);
            text-align: center;
            transition: transform 0.3s;
        }
        
        .feature-card:hover {
            transform: translateY(-5px);
        }
        
        .feature-icon {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #c9961a 0%, #d4af37 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            color: white;
            font-size: 24px;
        }
        
        .feature-title {
            font-size: 20px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 15px;
        }
        
        .feature-desc {
            color: #666;
            line-height: 1.6;
        }
        
        .stats-section {
            background: #1a1a1a;
            color: white;
            padding: 80px 0;
            text-align: center;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 40px;
            margin-top: 40px;
        }
        
        .stat-item {
            text-align: center;
        }
        
        .stat-number {
            font-size: 48px;
            font-weight: 700;
            color: #c9961a;
            margin-bottom: 10px;
        }
        
        .stat-label {
            font-size: 16px;
            opacity: 0.9;
        }
        
        .cta-section {
            background: white;
            padding: 80px 0;
            text-align: center;
        }
        
        .cta-button {
            background: linear-gradient(135deg, #c9961a 0%, #d4af37 100%);
            color: white;
            padding: 15px 40px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            font-size: 18px;
            display: inline-block;
            transition: all 0.3s;
            border: none;
            cursor: pointer;
        }
        
        .cta-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(201, 150, 26, 0.3);
        }
        
        @media (max-width: 768px) {
            .about-hero h1 {
                font-size: 36px;
            }
            
            .about-hero p {
                font-size: 18px;
            }
            
            .features-grid {
                grid-template-columns: 1fr;
                gap: 30px;
            }
            
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/layout/header/luxury-header.jsp" />
    
    <!-- Hero Section -->
    <section class="about-hero">
        <div class="container">
            <h1>About M4 Auction</h1>
            <p>프리미엄 아트 경매의 새로운 기준을 제시하는 M4 Auction입니다.</p>
        </div>
    </section>
    
    <!-- About Content -->
    <section class="about-content">
        <div class="container">
            <!-- Company Introduction -->
            <div class="section">
                <h2 class="section-title">회사 소개</h2>
                <div class="section-content">
                    <p>M4 Auction은 2024년 설립된 프리미엄 아트 경매 하우스입니다. 우리는 현대 미술과 클래식 아트의 만남을 통해 고객들에게 최고의 경매 경험을 제공합니다.</p>
                    <p>전문적인 큐레이션과 투명한 경매 시스템을 바탕으로 작가와 컬렉터를 연결하는 신뢰할 수 있는 플랫폼을 구축하고 있습니다.</p>
                </div>
            </div>
            
            <!-- Features -->
            <div class="section">
                <h2 class="section-title">우리의 강점</h2>
                <div class="features-grid">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-shield-alt"></i>
                        </div>
                        <h3 class="feature-title">신뢰성</h3>
                        <p class="feature-desc">모든 작품은 전문가의 감정을 거쳐 진품 보장과 함께 거래됩니다.</p>
                    </div>
                    
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-eye"></i>
                        </div>
                        <h3 class="feature-title">투명성</h3>
                        <p class="feature-desc">모든 경매 과정이 투명하게 공개되어 공정한 거래를 보장합니다.</p>
                    </div>
                    
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-users"></i>
                        </div>
                        <h3 class="feature-title">전문성</h3>
                        <p class="feature-desc">미술 전문가들이 큐레이션한 고품질 작품만을 선별합니다.</p>
                    </div>
                    
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-globe"></i>
                        </div>
                        <h3 class="feature-title">접근성</h3>
                        <p class="feature-desc">온라인과 오프라인을 결합한 하이브리드 경매 시스템을 운영합니다.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Stats Section -->
    <section class="stats-section">
        <div class="container">
            <h2 class="section-title" style="color: white;">M4 Auction과 함께한 성과</h2>
            <div class="stats-grid">
                <div class="stat-item">
                    <div class="stat-number">1,500+</div>
                    <div class="stat-label">성공한 경매</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">5,000+</div>
                    <div class="stat-label">등록 회원</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">98%</div>
                    <div class="stat-label">고객 만족도</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">24/7</div>
                    <div class="stat-label">고객 지원</div>
                </div>
            </div>
        </div>
    </section>
    
    <!-- CTA Section -->
    <section class="cta-section">
        <div class="container">
            <h2 class="section-title">지금 바로 시작하세요</h2>
            <p class="section-content">M4 Auction과 함께 특별한 아트 경매 경험을 시작해보세요.</p>
            <div style="margin-top: 40px;">
                <% if (loginUser != null) { %>
                    <a href="<%=ctx%>/auction/auctionList.jsp" class="cta-button">경매 참여하기</a>
                <% } else { %>
                    <a href="<%=ctx%>/member/enroll_step1.jsp" class="cta-button">회원가입하기</a>
                <% } %>
            </div>
        </div>
    </section>
    
    <jsp:include page="/layout/footer/luxury-footer.jsp" />
</body>
</html>