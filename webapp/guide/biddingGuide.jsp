<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.auction.dto.MemberDTO" %>
<%
    String ctx = request.getContextPath();
    MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>응찰 가이드 - M4 Auction</title>
    
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
        
        .guide-container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 40px 24px;
        }
        
        .guide-header {
            text-align: center;
            margin-bottom: 48px;
        }
        
        .guide-title {
            font-family: 'Playfair Display', serif;
            font-size: 48px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 16px;
        }
        
        .guide-subtitle {
            color: #6b7280;
            font-size: 18px;
            margin: 0;
        }
        
        .guide-nav {
            background: white;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 40px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        
        .nav-title {
            font-size: 16px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 16px;
        }
        
        .nav-list {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 12px;
        }
        
        .nav-item {
            color: #6b7280;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            padding: 8px 12px;
            border-radius: 6px;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .nav-item:hover {
            background: #f3f4f6;
            color: #1a1a1a;
        }
        
        .section {
            background: white;
            border: 2px solid #e5e7eb;
            border-radius: 16px;
            padding: 40px;
            margin-bottom: 32px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        
        .section-title {
            font-family: 'Playfair Display', serif;
            font-size: 32px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 24px;
            padding-bottom: 16px;
            border-bottom: 3px solid #c9961a;
            display: flex;
            align-items: center;
            gap: 16px;
        }
        
        .section-icon {
            width: 48px;
            height: 48px;
            background: linear-gradient(135deg, #c9961a 0%, #d4af37 100%);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 20px;
        }
        
        .step-list {
            display: grid;
            gap: 24px;
        }
        
        .step-item {
            display: flex;
            gap: 20px;
            padding: 24px;
            background: #f9fafb;
            border: 2px solid #f3f4f6;
            border-radius: 12px;
            transition: all 0.3s ease;
        }
        
        .step-item:hover {
            border-color: #e5e7eb;
            background: white;
        }
        
        .step-number {
            width: 40px;
            height: 40px;
            background: #1a1a1a;
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 16px;
            flex-shrink: 0;
        }
        
        .step-content {
            flex: 1;
        }
        
        .step-title {
            font-size: 18px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 8px;
        }
        
        .step-description {
            color: #6b7280;
            font-size: 14px;
            line-height: 1.6;
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 24px;
        }
        
        .info-card {
            background: #f9fafb;
            border: 2px solid #f3f4f6;
            border-radius: 12px;
            padding: 24px;
            text-align: center;
        }
        
        .info-icon {
            width: 64px;
            height: 64px;
            background: linear-gradient(135deg, #1a1a1a 0%, #c9961a 100%);
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 24px;
            margin: 0 auto 16px;
        }
        
        .info-title {
            font-size: 16px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 8px;
        }
        
        .info-description {
            color: #6b7280;
            font-size: 13px;
            line-height: 1.5;
        }
        
        .warning-box {
            background: #fef3c7;
            border: 2px solid #fbbf24;
            border-radius: 12px;
            padding: 20px;
            margin: 24px 0;
        }
        
        .warning-title {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 16px;
            font-weight: 700;
            color: #92400e;
            margin-bottom: 8px;
        }
        
        .warning-content {
            color: #92400e;
            font-size: 14px;
            line-height: 1.5;
        }
        
        .cta-section {
            background: linear-gradient(135deg, #1a1a1a 0%, #c9961a 100%);
            color: white;
            text-align: center;
            padding: 48px;
            border-radius: 16px;
            margin-top: 48px;
        }
        
        .cta-title {
            font-family: 'Playfair Display', serif;
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 16px;
        }
        
        .cta-description {
            font-size: 16px;
            opacity: 0.9;
            margin-bottom: 32px;
        }
        
        .cta-buttons {
            display: flex;
            justify-content: center;
            gap: 16px;
            flex-wrap: wrap;
        }
        
        .cta-btn {
            background: rgba(255,255,255,0.2);
            color: white;
            border: 2px solid rgba(255,255,255,0.3);
            padding: 14px 28px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .cta-btn:hover {
            background: rgba(255,255,255,0.3);
            border-color: rgba(255,255,255,0.5);
            transform: translateY(-2px);
        }
        
        .cta-btn.primary {
            background: white;
            color: #1a1a1a;
            border-color: white;
        }
        
        .cta-btn.primary:hover {
            background: #f3f4f6;
            color: #1a1a1a;
            border-color: #f3f4f6;
        }
        
        /* 반응형 */
        @media (max-width: 768px) {
            body {
                padding-top: 100px !important;
            }
            
            .guide-container {
                padding: 20px 16px;
            }
            
            .guide-title {
                font-size: 36px;
            }
            
            .section {
                padding: 24px;
            }
            
            .section-title {
                font-size: 24px;
            }
            
            .nav-list {
                grid-template-columns: 1fr;
            }
            
            .step-item {
                flex-direction: column;
                text-align: center;
            }
            
            .cta-section {
                padding: 32px 24px;
            }
            
            .cta-title {
                font-size: 24px;
            }
            
            .cta-buttons {
                flex-direction: column;
                align-items: center;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/layout/header/luxury-header.jsp" />
    
    <div class="guide-container">
        <!-- Header -->
        <div class="guide-header">
            <h1 class="guide-title">응찰 가이드</h1>
            <p class="guide-subtitle">M4 Auction에서 성공적인 경매 참여를 위한 완벽 가이드</p>
        </div>
        
        <!-- Navigation -->
        <div class="guide-nav">
            <h3 class="nav-title">가이드 목차</h3>
            <div class="nav-list">
                <a href="#registration" class="nav-item">
                    <i class="fas fa-user-plus"></i>
                    회원가입 및 인증
                </a>
                <a href="#mileage" class="nav-item">
                    <i class="fas fa-coins"></i>
                    마일리지 충전
                </a>
                <a href="#bidding" class="nav-item">
                    <i class="fas fa-gavel"></i>
                    경매 참여 방법
                </a>
                <a href="#payment" class="nav-item">
                    <i class="fas fa-credit-card"></i>
                    결제 및 수령
                </a>
            </div>
        </div>
        
        <!-- Registration Section -->
        <section id="registration" class="section">
            <h2 class="section-title">
                <div class="section-icon">
                    <i class="fas fa-user-plus"></i>
                </div>
                회원가입 및 인증
            </h2>
            
            <div class="step-list">
                <div class="step-item">
                    <div class="step-number">1</div>
                    <div class="step-content">
                        <h3 class="step-title">회원가입</h3>
                        <p class="step-description">
                            M4 Auction 홈페이지에서 회원가입을 진행하세요. 
                            기본 정보 입력 후 이메일 인증을 완료해야 합니다.
                        </p>
                    </div>
                </div>
                
                <div class="step-item">
                    <div class="step-number">2</div>
                    <div class="step-content">
                        <h3 class="step-title">본인인증</h3>
                        <p class="step-description">
                            경매 참여를 위해서는 본인인증이 필요합니다. 
                            휴대폰 인증 또는 아이핀 인증을 통해 본인임을 확인해주세요.
                        </p>
                    </div>
                </div>
                
                <div class="step-item">
                    <div class="step-number">3</div>
                    <div class="step-content">
                        <h3 class="step-title">약관 동의</h3>
                        <p class="step-description">
                            경매 이용약관 및 개인정보 처리방침에 동의해주세요. 
                            모든 약관에 동의해야 경매 참여가 가능합니다.
                        </p>
                    </div>
                </div>
            </div>
        </section>
        
        <!-- Mileage Section -->
        <section id="mileage" class="section">
            <h2 class="section-title">
                <div class="section-icon">
                    <i class="fas fa-coins"></i>
                </div>
                마일리지 충전
            </h2>
            
            <div class="info-grid">
                <div class="info-card">
                    <div class="info-icon">
                        <i class="fas fa-credit-card"></i>
                    </div>
                    <h3 class="info-title">충전 방법</h3>
                    <p class="info-description">
                        신용카드, 계좌이체, 무통장입금을 통해 
                        마일리지를 충전할 수 있습니다.
                    </p>
                </div>
                
                <div class="info-card">
                    <div class="info-icon">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <h3 class="info-title">보증금 시스템</h3>
                    <p class="info-description">
                        입찰 시 마일리지가 보증금으로 사용되며, 
                        낙찰되지 않으면 자동으로 반환됩니다.
                    </p>
                </div>
                
                <div class="info-card">
                    <div class="info-icon">
                        <i class="fas fa-history"></i>
                    </div>
                    <h3 class="info-title">이용 내역</h3>
                    <p class="info-description">
                        마이페이지에서 마일리지 충전 및 
                        사용 내역을 확인할 수 있습니다.
                    </p>
                </div>
            </div>
            
            <div class="warning-box">
                <div class="warning-title">
                    <i class="fas fa-exclamation-triangle"></i>
                    주의사항
                </div>
                <div class="warning-content">
                    입찰 참여 전 충분한 마일리지를 보유하고 있는지 확인하세요. 
                    낙찰 시 즉시 결제가 진행되므로 잔액 부족으로 인한 문제가 발생할 수 있습니다.
                </div>
            </div>
        </section>
        
        <!-- Bidding Section -->
        <section id="bidding" class="section">
            <h2 class="section-title">
                <div class="section-icon">
                    <i class="fas fa-gavel"></i>
                </div>
                경매 참여 방법
            </h2>
            
            <div class="step-list">
                <div class="step-item">
                    <div class="step-number">1</div>
                    <div class="step-content">
                        <h3 class="step-title">작품 선택</h3>
                        <p class="step-description">
                            관심 있는 작품을 찾아 상세 정보를 확인하세요. 
                            작품의 상태, 추정가, 경매 마감 시간을 꼼꼼히 살펴보세요.
                        </p>
                    </div>
                </div>
                
                <div class="step-item">
                    <div class="step-number">2</div>
                    <div class="step-content">
                        <h3 class="step-title">입찰가 결정</h3>
                        <p class="step-description">
                            현재 최고가보다 높은 금액으로 입찰해야 합니다. 
                            본인의 예산 범위 내에서 신중하게 입찰가를 결정하세요.
                        </p>
                    </div>
                </div>
                
                <div class="step-item">
                    <div class="step-number">3</div>
                    <div class="step-content">
                        <h3 class="step-title">입찰 참여</h3>
                        <p class="step-description">
                            '입찰하기' 버튼을 클릭하여 경매에 참여하세요. 
                            입찰 즉시 마일리지가 보증금으로 예치됩니다.
                        </p>
                    </div>
                </div>
                
                <div class="step-item">
                    <div class="step-number">4</div>
                    <div class="step-content">
                        <h3 class="step-title">경매 결과 확인</h3>
                        <p class="step-description">
                            경매 마감 후 낙찰 여부를 확인하세요. 
                            낙찰 시 결제 절차가 자동으로 진행됩니다.
                        </p>
                    </div>
                </div>
            </div>
        </section>
        
        <!-- Payment Section -->
        <section id="payment" class="section">
            <h2 class="section-title">
                <div class="section-icon">
                    <i class="fas fa-credit-card"></i>
                </div>
                결제 및 수령
            </h2>
            
            <div class="info-grid">
                <div class="info-card">
                    <div class="info-icon">
                        <i class="fas fa-money-check-alt"></i>
                    </div>
                    <h3 class="info-title">자동 결제</h3>
                    <p class="info-description">
                        낙찰 시 보유 마일리지에서 
                        자동으로 결제가 진행됩니다.
                    </p>
                </div>
                
                <div class="info-card">
                    <div class="info-icon">
                        <i class="fas fa-file-invoice"></i>
                    </div>
                    <h3 class="info-title">구매 확인서</h3>
                    <p class="info-description">
                        결제 완료 후 구매 확인서가 
                        이메일로 발송됩니다.
                    </p>
                </div>
                
                <div class="info-card">
                    <div class="info-icon">
                        <i class="fas fa-shipping-fast"></i>
                    </div>
                    <h3 class="info-title">작품 수령</h3>
                    <p class="info-description">
                        직접 수령 또는 배송 서비스를 
                        선택할 수 있습니다.
                    </p>
                </div>
            </div>
        </section>
        
        <!-- CTA Section -->
        <div class="cta-section">
            <h2 class="cta-title">지금 경매에 참여해보세요</h2>
            <p class="cta-description">
                전 세계 최고 품질의 예술 작품들이 여러분을 기다리고 있습니다
            </p>
            <div class="cta-buttons">
                <% if(loginUser == null) { %>
                <a href="<%=ctx%>/member/enroll_step1.jsp" class="cta-btn primary">
                    <i class="fas fa-user-plus"></i>
                    회원가입하기
                </a>
                <a href="<%=ctx%>/member/luxury-login.jsp" class="cta-btn">
                    <i class="fas fa-sign-in-alt"></i>
                    로그인
                </a>
                <% } else { %>
                <a href="<%=ctx%>/auction/auctionList.jsp" class="cta-btn primary">
                    <i class="fas fa-gavel"></i>
                    경매 참여하기
                </a>
                <a href="<%=ctx%>/mypage/myPage.jsp" class="cta-btn">
                    <i class="fas fa-user"></i>
                    마이페이지
                </a>
                <% } %>
            </div>
        </div>
    </div>
    
    <jsp:include page="/layout/footer/luxury-footer.jsp" />
    
    <script>
        // 부드러운 스크롤
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });
        
        // 섹션 활성화 표시
        window.addEventListener('scroll', function() {
            const sections = document.querySelectorAll('.section');
            const navItems = document.querySelectorAll('.nav-item');
            
            let current = '';
            sections.forEach(section => {
                const sectionTop = section.offsetTop;
                const sectionHeight = section.clientHeight;
                if (pageYOffset >= sectionTop - 150) {
                    current = section.getAttribute('id');
                }
            });
            
            navItems.forEach(item => {
                item.style.background = '';
                item.style.color = '';
                if (item.getAttribute('href') === '#' + current) {
                    item.style.background = '#f3f4f6';
                    item.style.color = '#1a1a1a';
                }
            });
        });
    </script>
</body>
</html>