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
    <title>경매 안내 - M4 Auction</title>
    
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
        
        .hero-section {
            background: linear-gradient(135deg, #c9961a 0%, #d4af37 100%);
            color: white;
            padding: 100px 0;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .hero-section::before {
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
        }
        
        .hero-title {
            font-family: 'Playfair Display', serif;
            font-size: 56px;
            font-weight: 700;
            margin-bottom: 20px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        
        .hero-subtitle {
            font-size: 22px;
            opacity: 0.9;
            max-width: 600px;
            margin: 0 auto 40px;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.2);
        }
        
        .cta-button {
            background: white;
            color: #c9961a;
            padding: 15px 40px;
            border-radius: 30px;
            text-decoration: none;
            font-weight: 700;
            font-size: 18px;
            display: inline-block;
            transition: all 0.3s;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }
        
        .cta-button:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.3);
        }
        
        .container {
            max-width: 1200px;
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
            line-height: 1.6;
        }
        
        .process-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 40px;
            margin-bottom: 60px;
        }
        
        .process-card {
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            text-align: center;
            transition: all 0.3s;
            position: relative;
        }
        
        .process-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }
        
        .process-number {
            position: absolute;
            top: -20px;
            left: 50%;
            transform: translateX(-50%);
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #c9961a 0%, #d4af37 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 20px;
            font-weight: 700;
        }
        
        .process-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 20px auto 30px;
            font-size: 36px;
            color: #c9961a;
        }
        
        .process-title {
            font-size: 22px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 15px;
        }
        
        .process-description {
            color: #666;
            line-height: 1.6;
            font-size: 16px;
        }
        
        .rules-section {
            background: white;
            padding: 60px 0;
            margin: 40px 0;
        }
        
        .rules-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 40px;
        }
        
        .rule-card {
            padding: 30px;
            border-left: 4px solid #c9961a;
            background: #f8f9fa;
            border-radius: 0 8px 8px 0;
        }
        
        .rule-title {
            font-size: 20px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .rule-icon {
            color: #c9961a;
            font-size: 24px;
        }
        
        .rule-content {
            color: #555;
            line-height: 1.8;
        }
        
        .rule-content ul {
            margin: 10px 0;
            padding-left: 20px;
        }
        
        .rule-content li {
            margin-bottom: 5px;
        }
        
        .fee-section {
            background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
            color: white;
            padding: 60px 0;
            margin: 40px 0;
        }
        
        .fee-table {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        
        .fee-table table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .fee-table th {
            background: #c9961a;
            color: white;
            padding: 20px;
            text-align: left;
            font-weight: 700;
            font-size: 16px;
        }
        
        .fee-table td {
            padding: 15px 20px;
            border-bottom: 1px solid #f0f0f0;
            color: #333;
        }
        
        .fee-table tr:last-child td {
            border-bottom: none;
        }
        
        .fee-table tr:nth-child(even) {
            background: #f8f9fa;
        }
        
        .highlight {
            background: linear-gradient(135deg, #c9961a 0%, #d4af37 100%);
            color: white;
            padding: 2px 8px;
            border-radius: 4px;
            font-weight: 600;
        }
        
        .tips-section {
            background: #f8f9fa;
            padding: 60px 0;
        }
        
        .tips-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 30px;
        }
        
        .tip-card {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08);
            transition: transform 0.3s;
        }
        
        .tip-card:hover {
            transform: translateY(-5px);
        }
        
        .tip-icon {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #c9961a 0%, #d4af37 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 24px;
            margin-bottom: 20px;
        }
        
        .tip-title {
            font-size: 18px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 10px;
        }
        
        .tip-content {
            color: #666;
            line-height: 1.6;
        }
        
        @media (max-width: 768px) {
            .hero-title {
                font-size: 42px;
            }
            
            .hero-subtitle {
                font-size: 18px;
            }
            
            .process-grid {
                grid-template-columns: 1fr;
                gap: 30px;
            }
            
            .rules-grid {
                grid-template-columns: 1fr;
            }
            
            .fee-table {
                font-size: 14px;
            }
            
            .fee-table th,
            .fee-table td {
                padding: 12px 15px;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/layout/header/luxury-header.jsp" />
    
    <!-- Hero Section -->
    <section class="hero-section">
        <div class="container">
            <div class="hero-content">
                <h1 class="hero-title">Auction Guide</h1>
                <p class="hero-subtitle">M4 Auction의 경매 참여 방법과 규칙을 자세히 안내해드립니다</p>
                <% if (loginUser != null) { %>
                    <a href="<%=ctx%>/auction/auctionList.jsp" class="cta-button">경매 참여하기</a>
                <% } else { %>
                    <a href="<%=ctx%>/member/enroll_step1.jsp" class="cta-button">회원가입하기</a>
                <% } %>
            </div>
        </div>
    </section>
    
    <!-- Process Section -->
    <section class="content-section">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">경매 참여 과정</h2>
                <p class="section-subtitle">간단한 4단계로 경매에 참여하실 수 있습니다</p>
            </div>
            
            <div class="process-grid">
                <div class="process-card">
                    <div class="process-number">1</div>
                    <div class="process-icon">
                        <i class="fas fa-user-plus"></i>
                    </div>
                    <h3 class="process-title">회원가입 및 인증</h3>
                    <p class="process-description">
                        M4 Auction에 가입하고 본인인증을 완료하세요. 
                        휴대폰 인증 또는 이메일 인증으로 간편하게 가입할 수 있습니다.
                    </p>
                </div>
                
                <div class="process-card">
                    <div class="process-number">2</div>
                    <div class="process-icon">
                        <i class="fas fa-coins"></i>
                    </div>
                    <h3 class="process-title">마일리지 충전</h3>
                    <p class="process-description">
                        입찰 참여를 위해 마일리지를 충전하세요. 
                        신용카드, 계좌이체, 무통장입금 등 다양한 결제 방법을 지원합니다.
                    </p>
                </div>
                
                <div class="process-card">
                    <div class="process-number">3</div>
                    <div class="process-icon">
                        <i class="fas fa-search"></i>
                    </div>
                    <h3 class="process-title">작품 선택 및 프리뷰</h3>
                    <p class="process-description">
                        원하는 작품을 선택하고 상세 정보를 확인하세요. 
                        경매 전 프리뷰를 통해 작품을 직접 관람할 수 있습니다.
                    </p>
                </div>
                
                <div class="process-card">
                    <div class="process-number">4</div>
                    <div class="process-icon">
                        <i class="fas fa-gavel"></i>
                    </div>
                    <h3 class="process-title">입찰 참여</h3>
                    <p class="process-description">
                        실시간 경매에 참여하여 입찰하세요. 
                        온라인과 오프라인 모두에서 참여 가능하며, 낙찰 시 즉시 알림을 받습니다.
                    </p>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Rules Section -->
    <section class="rules-section">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">경매 규칙 및 유의사항</h2>
                <p class="section-subtitle">공정하고 투명한 경매를 위한 중요한 규칙들입니다</p>
            </div>
            
            <div class="rules-grid">
                <div class="rule-card">
                    <h3 class="rule-title">
                        <i class="fas fa-clock rule-icon"></i>
                        경매 시간
                    </h3>
                    <div class="rule-content">
                        <ul>
                            <li>온라인 경매: 24시간 진행</li>
                            <li>라이브 경매: 오후 2시 ~ 6시</li>
                            <li>마감 10분 전 입찰 시 10분 연장</li>
                            <li>시스템 점검: 매주 일요일 새벽 2시</li>
                        </ul>
                    </div>
                </div>
                
                <div class="rule-card">
                    <h3 class="rule-title">
                        <i class="fas fa-balance-scale rule-icon"></i>
                        입찰 규칙
                    </h3>
                    <div class="rule-content">
                        <ul>
                            <li>최소 입찰 단위 준수 필수</li>
                            <li>본인 입찰가보다 높은 금액만 입찰 가능</li>
                            <li>마일리지 잔액 이상 입찰 불가</li>
                            <li>입찰 취소는 경매 종료 1시간 전까지</li>
                        </ul>
                    </div>
                </div>
                
                <div class="rule-card">
                    <h3 class="rule-title">
                        <i class="fas fa-trophy rule-icon"></i>
                        낙찰 규칙
                    </h3>
                    <div class="rule-content">
                        <ul>
                            <li>최고 입찰자가 낙찰</li>
                            <li>동일 입찰가 시 먼저 입찰한 사람 우선</li>
                            <li>낙찰 후 7일 이내 결제 완료 필수</li>
                            <li>결제 미완료 시 입찰 제한 조치</li>
                        </ul>
                    </div>
                </div>
                
                <div class="rule-card">
                    <h3 class="rule-title">
                        <i class="fas fa-ban rule-icon"></i>
                        금지사항
                    </h3>
                    <div class="rule-content">
                        <ul>
                            <li>허위 입찰 및 조작 행위</li>
                            <li>타인 명의 도용</li>
                            <li>작품 진위 관련 허위 정보 유포</li>
                            <li>경매 진행 방해 행위</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Fee Section -->
    <section class="fee-section">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">수수료 안내</h2>
                <p class="section-subtitle">투명하고 합리적인 수수료 체계를 운영합니다</p>
            </div>
            
            <div class="fee-table">
                <table>
                    <thead>
                        <tr>
                            <th>구분</th>
                            <th>일반 회원</th>
                            <th>VIP 회원</th>
                            <th>비고</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><strong>구매자 프리미엄</strong></td>
                            <td>낙찰가의 <span class="highlight">15%</span></td>
                            <td>낙찰가의 <span class="highlight">13%</span></td>
                            <td>부가세 별도</td>
                        </tr>
                        <tr>
                            <td><strong>판매자 수수료</strong></td>
                            <td>낙찰가의 <span class="highlight">10%</span></td>
                            <td>낙찰가의 <span class="highlight">8%</span></td>
                            <td>부가세 별도</td>
                        </tr>
                        <tr>
                            <td><strong>마일리지 충전</strong></td>
                            <td colspan="2">수수료 <span class="highlight">무료</span></td>
                            <td>최소 10만원부터</td>
                        </tr>
                        <tr>
                            <td><strong>작품 배송</strong></td>
                            <td colspan="2"><span class="highlight">무료</span></td>
                            <td>전국 무료배송</td>
                        </tr>
                        <tr>
                            <td><strong>보험료</strong></td>
                            <td colspan="2">낙찰가의 <span class="highlight">0.5%</span></td>
                            <td>작품 보호를 위한 필수 보험</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </section>
    
    <!-- Tips Section -->
    <section class="tips-section">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">성공적인 경매 참여 팁</h2>
                <p class="section-subtitle">경매 전문가들이 알려주는 실전 노하우</p>
            </div>
            
            <div class="tips-grid">
                <div class="tip-card">
                    <div class="tip-icon">
                        <i class="fas fa-eye"></i>
                    </div>
                    <h3 class="tip-title">사전 조사가 중요</h3>
                    <p class="tip-content">
                        작품의 시장 가치, 작가 이력, 상태 등을 미리 조사하세요. 
                        프리뷰 관람을 통해 직접 확인하는 것이 좋습니다.
                    </p>
                </div>
                
                <div class="tip-card">
                    <div class="tip-icon">
                        <i class="fas fa-calculator"></i>
                    </div>
                    <h3 class="tip-title">예산 계획 수립</h3>
                    <p class="tip-content">
                        낙찰가 외에 구매자 프리미엄, 보험료 등을 포함한 
                        총 비용을 미리 계산하여 예산을 설정하세요.
                    </p>
                </div>
                
                <div class="tip-card">
                    <div class="tip-icon">
                        <i class="fas fa-stopwatch"></i>
                    </div>
                    <h3 class="tip-title">타이밍이 관건</h3>
                    <p class="tip-content">
                        경매 초반에는 관망하고, 마감 직전에 집중적으로 
                        입찰하는 전략을 활용해보세요.
                    </p>
                </div>
                
                <div class="tip-card">
                    <div class="tip-icon">
                        <i class="fas fa-heart"></i>
                    </div>
                    <h3 class="tip-title">감정 조절</h3>
                    <p class="tip-content">
                        경매 열기에 휩쓸리지 말고 냉정하게 판단하세요. 
                        미리 설정한 최대 입찰가를 지키는 것이 중요합니다.
                    </p>
                </div>
                
                <div class="tip-card">
                    <div class="tip-icon">
                        <i class="fas fa-network-wired"></i>
                    </div>
                    <h3 class="tip-title">인터넷 환경 점검</h3>
                    <p class="tip-content">
                        온라인 경매 참여 시 안정적인 인터넷 연결을 확인하고, 
                        여러 기기를 준비해두세요.
                    </p>
                </div>
                
                <div class="tip-card">
                    <div class="tip-icon">
                        <i class="fas fa-handshake"></i>
                    </div>
                    <h3 class="tip-title">전문가 상담</h3>
                    <p class="tip-content">
                        고가의 작품이나 생소한 작가의 작품은 
                        전문가의 조언을 구하는 것이 좋습니다.
                    </p>
                </div>
            </div>
        </div>
    </section>
    
    <jsp:include page="/layout/footer/luxury-footer.jsp" />
</body>
</html>