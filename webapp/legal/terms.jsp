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
    <title>이용약관 - M4 Auction</title>
    
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
            line-height: 1.7;
        }
        
        .page-header {
            background: linear-gradient(135deg, #2d2d2d 0%, #1a1a1a 100%);
            color: white;
            padding: 60px 0;
            text-align: center;
        }
        
        .page-title {
            font-family: 'Playfair Display', serif;
            font-size: 42px;
            font-weight: 700;
            margin-bottom: 15px;
            background: linear-gradient(45deg, #c9961a, #d4af37);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .page-subtitle {
            font-size: 18px;
            opacity: 0.9;
            max-width: 600px;
            margin: 0 auto;
        }
        
        .container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 0 20px;
        }
        
        .content-wrapper {
            padding: 60px 0;
        }
        
        .terms-nav {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08);
            margin-bottom: 30px;
            padding: 30px;
        }
        
        .nav-title {
            font-size: 20px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .nav-icon {
            color: #c9961a;
            font-size: 24px;
        }
        
        .nav-list {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 15px;
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .nav-item {
            background: #f8f9fa;
            border-radius: 8px;
            transition: all 0.3s;
        }
        
        .nav-item:hover {
            background: #e9ecef;
            transform: translateY(-2px);
        }
        
        .nav-link {
            display: block;
            padding: 15px 20px;
            color: #333;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s;
        }
        
        .nav-link:hover {
            color: #c9961a;
        }
        
        .terms-content {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08);
            padding: 50px;
        }
        
        .section-title {
            font-size: 28px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 30px;
            border-bottom: 3px solid #c9961a;
            padding-bottom: 10px;
        }
        
        .article {
            margin-bottom: 40px;
        }
        
        .article-title {
            font-size: 20px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .article-number {
            background: #c9961a;
            color: white;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
            font-weight: 700;
        }
        
        .article-content {
            color: #555;
            margin-left: 40px;
        }
        
        .article-content h4 {
            font-size: 16px;
            font-weight: 600;
            color: #333;
            margin: 20px 0 10px 0;
        }
        
        .article-content p {
            margin-bottom: 15px;
        }
        
        .article-content ul,
        .article-content ol {
            margin: 15px 0;
            padding-left: 20px;
        }
        
        .article-content li {
            margin-bottom: 8px;
        }
        
        .highlight {
            background: #fff3cd;
            padding: 2px 6px;
            border-radius: 3px;
            font-weight: 600;
        }
        
        .important {
            background: #d4edda;
            border: 1px solid #c3e6cb;
            border-radius: 8px;
            padding: 15px;
            margin: 20px 0;
        }
        
        .important .important-title {
            font-weight: 700;
            color: #155724;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .important .important-content {
            color: #155724;
        }
        
        .contact-info {
            background: linear-gradient(135deg, #c9961a 0%, #d4af37 100%);
            color: white;
            padding: 30px;
            border-radius: 12px;
            margin-top: 40px;
            text-align: center;
        }
        
        .contact-title {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 15px;
        }
        
        .contact-details {
            display: flex;
            justify-content: center;
            gap: 30px;
            flex-wrap: wrap;
        }
        
        .contact-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 16px;
        }
        
        .last-updated {
            text-align: center;
            color: #666;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e9ecef;
        }
        
        @media (max-width: 768px) {
            .terms-content {
                padding: 30px 20px;
            }
            
            .nav-list {
                grid-template-columns: 1fr;
            }
            
            .contact-details {
                flex-direction: column;
                gap: 15px;
            }
            
            .article-content {
                margin-left: 0;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/layout/header/luxury-header.jsp" />
    
    <!-- Page Header -->
    <section class="page-header">
        <div class="container">
            <h1 class="page-title">이용약관</h1>
            <p class="page-subtitle">M4 Auction 서비스 이용에 관한 약관입니다</p>
        </div>
    </section>
    
    <!-- Content -->
    <section class="content-wrapper">
        <div class="container">
            <!-- Navigation -->
            <div class="terms-nav">
                <h2 class="nav-title">
                    <i class="fas fa-list nav-icon"></i>
                    약관 목록
                </h2>
                <ul class="nav-list">
                    <li class="nav-item">
                        <a href="#general" class="nav-link">일반 이용약관</a>
                    </li>
                    <li class="nav-item">
                        <a href="#auction" class="nav-link">경매 이용약관</a>
                    </li>
                    <li class="nav-item">
                        <a href="#privacy" class="nav-link">개인정보처리방침</a>
                    </li>
                    <li class="nav-item">
                        <a href="#payment" class="nav-link">결제 및 환불약관</a>
                    </li>
                </ul>
            </div>
            
            <!-- Terms Content -->
            <div class="terms-content">
                <h1 class="section-title">M4 Auction 서비스 이용약관</h1>
                
                <div class="article">
                    <h2 class="article-title">
                        <span class="article-number">1</span>
                        총칙
                    </h2>
                    <div class="article-content">
                        <h4>제1조 (목적)</h4>
                        <p>
                            이 약관은 M4 Auction(이하 "회사")이 제공하는 온라인 경매 서비스(이하 "서비스")의 
                            이용에 관한 회사와 이용자 간의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.
                        </p>
                        
                        <h4>제2조 (정의)</h4>
                        <p>이 약관에서 사용하는 용어의 의미는 다음과 같습니다:</p>
                        <ul>
                            <li><span class="highlight">"서비스"</span>: 회사가 제공하는 온라인 경매 플랫폼</li>
                            <li><span class="highlight">"이용자"</span>: 서비스에 접속하여 이 약관에 따라 회사가 제공하는 서비스를 받는 회원 및 비회원</li>
                            <li><span class="highlight">"회원"</span>: 회사와 서비스 이용계약을 체결한 자</li>
                            <li><span class="highlight">"경매"</span>: 회사가 주최하는 미술품 등의 매매를 위한 경매</li>
                        </ul>
                        
                        <h4>제3조 (약관의 효력 및 변경)</h4>
                        <p>
                            이 약관은 서비스 화면에 게시하거나 기타의 방법으로 이용자에게 공지함으로써 효력이 발생합니다. 
                            회사는 합리적인 사유가 발생할 경우 이 약관을 변경할 수 있으며, 변경된 약관은 공지 후 7일이 경과한 날부터 효력이 발생합니다.
                        </p>
                    </div>
                </div>
                
                <div class="article">
                    <h2 class="article-title">
                        <span class="article-number">2</span>
                        회원가입 및 관리
                    </h2>
                    <div class="article-content">
                        <h4>제4조 (회원가입)</h4>
                        <p>회원가입은 다음 절차에 따라 진행됩니다:</p>
                        <ol>
                            <li>이용약관 및 개인정보처리방침에 동의</li>
                            <li>본인인증 (휴대폰 인증 또는 이메일 인증)</li>
                            <li>회원정보 입력</li>
                            <li>가입 완료 및 회원 ID 부여</li>
                        </ol>
                        
                        <div class="important">
                            <div class="important-title">
                                <i class="fas fa-exclamation-circle"></i>
                                중요 안내
                            </div>
                            <div class="important-content">
                                회원가입 시 제공하는 정보는 정확하고 최신의 정보여야 하며, 
                                허위 정보 제공 시 서비스 이용에 제한을 받을 수 있습니다.
                            </div>
                        </div>
                        
                        <h4>제5조 (회원정보의 변경)</h4>
                        <p>
                            회원은 개인정보관리화면을 통하여 언제든지 본인의 개인정보를 열람하고 수정할 수 있습니다. 
                            회원은 회원가입 시 기재한 사항이 변경되었을 경우 온라인으로 수정을 하거나 전자우편 기타 방법으로 회사에 그 변경사항을 알려야 합니다.
                        </p>
                    </div>
                </div>
                
                <div class="article">
                    <h2 class="article-title">
                        <span class="article-number">3</span>
                        경매 이용 및 규칙
                    </h2>
                    <div class="article-content">
                        <h4>제6조 (경매 참여 자격)</h4>
                        <p>경매 참여를 위해서는 다음 조건을 충족해야 합니다:</p>
                        <ul>
                            <li>회원 가입 및 본인 인증 완료</li>
                            <li>충분한 마일리지 보유</li>
                            <li>경매 이용 제재 이력이 없을 것</li>
                        </ul>
                        
                        <h4>제7조 (입찰 규칙)</h4>
                        <p>입찰은 다음 규칙에 따라 진행됩니다:</p>
                        <ol>
                            <li>입찰은 최소 입찰 단위에 따라 진행</li>
                            <li>현재 최고가보다 높은 금액으로만 입찰 가능</li>
                            <li>입찰 취소는 경매 종료 1시간 전까지 가능</li>
                            <li>마감 10분 전 입찰 시 자동 연장</li>
                        </ol>
                        
                        <h4>제8조 (낙찰 및 결제)</h4>
                        <p>
                            낙찰자는 경매 종료 후 7일 이내에 낙찰가와 구매자 프리미엄을 결제해야 합니다. 
                            기한 내 미결제 시 낙찰이 취소되며, 향후 경매 참여에 제한을 받을 수 있습니다.
                        </p>
                    </div>
                </div>
                
                <div class="article">
                    <h2 class="article-title">
                        <span class="article-number">4</span>
                        수수료 및 결제
                    </h2>
                    <div class="article-content">
                        <h4>제9조 (수수료)</h4>
                        <p>회사는 다음과 같은 수수료를 부과합니다:</p>
                        <ul>
                            <li>구매자 프리미엄: 낙찰가의 15% (VIP 회원 13%)</li>
                            <li>판매자 수수료: 낙찰가의 10% (VIP 회원 8%)</li>
                            <li>작품 보험료: 낙찰가의 0.5%</li>
                        </ul>
                        
                        <h4>제10조 (결제 수단)</h4>
                        <p>다음 결제 수단을 이용할 수 있습니다:</p>
                        <ul>
                            <li>마일리지 결제</li>
                            <li>신용카드 결제</li>
                            <li>계좌이체</li>
                            <li>무통장 입금</li>
                        </ul>
                    </div>
                </div>
                
                <div class="article">
                    <h2 class="article-title">
                        <span class="article-number">5</span>
                        서비스 이용 제한
                    </h2>
                    <div class="article-content">
                        <h4>제11조 (금지행위)</h4>
                        <p>회원은 다음 행위를 해서는 안 됩니다:</p>
                        <ul>
                            <li>허위 정보 입력 또는 타인의 정보 도용</li>
                            <li>허위 입찰 또는 경매 조작 행위</li>
                            <li>회사의 서비스 운영을 방해하는 행위</li>
                            <li>다른 회원에게 피해를 주는 행위</li>
                            <li>관련 법령을 위반하는 행위</li>
                        </ul>
                        
                        <h4>제12조 (서비스 이용 제한)</h4>
                        <p>
                            회사는 회원이 금지행위를 하거나 약관을 위반한 경우 
                            서비스 이용을 제한하거나 회원 자격을 박탈할 수 있습니다.
                        </p>
                    </div>
                </div>
                
                <div class="article">
                    <h2 class="article-title">
                        <span class="article-number">6</span>
                        책임과 의무
                    </h2>
                    <div class="article-content">
                        <h4>제13조 (회사의 의무)</h4>
                        <p>회사는 다음 의무를 가집니다:</p>
                        <ul>
                            <li>서비스의 안정적인 제공</li>
                            <li>개인정보의 보호</li>
                            <li>공정한 경매 진행</li>
                            <li>작품 정보의 정확한 제공</li>
                        </ul>
                        
                        <h4>제14조 (회원의 의무)</h4>
                        <p>회원은 다음 의무를 가집니다:</p>
                        <ul>
                            <li>정확한 정보 제공</li>
                            <li>약관 및 관련 법령 준수</li>
                            <li>낙찰 시 성실한 결제</li>
                            <li>다른 회원 및 회사에 대한 예의 준수</li>
                        </ul>
                    </div>
                </div>
                
                <div class="article">
                    <h2 class="article-title">
                        <span class="article-number">7</span>
                        기타
                    </h2>
                    <div class="article-content">
                        <h4>제15조 (분쟁 해결)</h4>
                        <p>
                            서비스 이용 중 발생한 분쟁은 우선 당사자 간 협의를 통해 해결하며, 
                            협의가 이루어지지 않을 경우 관련 법령과 관할 법원에 따라 해결합니다.
                        </p>
                        
                        <h4>제16조 (준거법)</h4>
                        <p>이 약관과 서비스 이용에 관한 분쟁에는 대한민국의 법을 적용합니다.</p>
                    </div>
                </div>
                
                <!-- Contact Information -->
                <div class="contact-info">
                    <h3 class="contact-title">문의 및 신고</h3>
                    <div class="contact-details">
                        <div class="contact-item">
                            <i class="fas fa-phone"></i>
                            02-1234-5678
                        </div>
                        <div class="contact-item">
                            <i class="fas fa-envelope"></i>
                            legal@m4auction.com
                        </div>
                        <div class="contact-item">
                            <i class="fas fa-map-marker-alt"></i>
                            서울특별시 강남구 테헤란로 123
                        </div>
                    </div>
                </div>
                
                <div class="last-updated">
                    <p>최종 수정일: 2024년 7월 1일</p>
                    <p>시행일: 2024년 7월 8일</p>
                </div>
            </div>
        </div>
    </section>
    
    <jsp:include page="/layout/footer/luxury-footer.jsp" />
    
    <script>
        // 스무스 스크롤
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                document.querySelector(this.getAttribute('href')).scrollIntoView({
                    behavior: 'smooth'
                });
            });
        });
    </script>
</body>
</html>