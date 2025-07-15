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
    <title>FAQ - 자주 묻는 질문 - M4 Auction</title>
    
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
            background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
            color: white;
            padding: 80px 0;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .page-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('https://images.unsplash.com/photo-1450101499163-c8848c66ca85?q=80&w=2000') center/cover;
            opacity: 0.1;
        }
        
        .header-content {
            position: relative;
            z-index: 2;
        }
        
        .page-title {
            font-family: 'Playfair Display', serif;
            font-size: 48px;
            font-weight: 700;
            margin-bottom: 20px;
            background: linear-gradient(45deg, #c9961a, #d4af37);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .page-subtitle {
            font-size: 20px;
            opacity: 0.9;
            max-width: 600px;
            margin: 0 auto;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }
        
        .content-wrapper {
            padding: 60px 0;
        }
        
        .faq-controls {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08);
            margin-bottom: 40px;
        }
        
        .search-box {
            position: relative;
            max-width: 500px;
            margin: 0 auto 30px;
        }
        
        .search-input {
            width: 100%;
            padding: 15px 50px 15px 20px;
            border: 2px solid #e5e5e5;
            border-radius: 25px;
            font-size: 16px;
            transition: border-color 0.3s;
            box-sizing: border-box;
        }
        
        .search-input:focus {
            outline: none;
            border-color: #c9961a;
        }
        
        .search-btn {
            position: absolute;
            right: 5px;
            top: 50%;
            transform: translateY(-50%);
            background: linear-gradient(135deg, #c9961a 0%, #d4af37 100%);
            color: white;
            border: none;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .search-btn:hover {
            transform: translateY(-50%) scale(1.1);
        }
        
        .category-tabs {
            display: flex;
            justify-content: center;
            gap: 10px;
            flex-wrap: wrap;
        }
        
        .category-tab {
            padding: 10px 20px;
            border: 2px solid #e5e5e5;
            background: white;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 500;
            color: #666;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .category-tab.active {
            background: #c9961a;
            color: white;
            border-color: #c9961a;
        }
        
        .faq-section {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08);
            overflow: hidden;
            margin-bottom: 30px;
        }
        
        .section-header {
            background: #f8f9fa;
            padding: 20px 30px;
            border-bottom: 1px solid #e5e5e5;
        }
        
        .section-title {
            font-size: 20px;
            font-weight: 700;
            color: #1a1a1a;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .section-icon {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #c9961a 0%, #d4af37 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 18px;
        }
        
        .faq-list {
            padding: 0;
            margin: 0;
            list-style: none;
        }
        
        .faq-item {
            border-bottom: 1px solid #f5f5f5;
        }
        
        .faq-item:last-child {
            border-bottom: none;
        }
        
        .faq-question {
            padding: 25px 30px;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-weight: 600;
            color: #333;
        }
        
        .faq-question:hover {
            background: #f8f9fa;
        }
        
        .faq-question.active {
            background: #f0f8ff;
            color: #c9961a;
        }
        
        .question-text {
            flex: 1;
            font-size: 16px;
            line-height: 1.5;
        }
        
        .question-toggle {
            font-size: 20px;
            transition: transform 0.3s;
        }
        
        .question-toggle.active {
            transform: rotate(180deg);
        }
        
        .faq-answer {
            padding: 0 30px;
            max-height: 0;
            overflow: hidden;
            transition: all 0.3s;
            background: #f8f9fa;
        }
        
        .faq-answer.active {
            max-height: 500px;
            padding: 25px 30px;
        }
        
        .answer-content {
            color: #555;
            line-height: 1.8;
            font-size: 15px;
        }
        
        .answer-content p {
            margin: 0 0 15px 0;
        }
        
        .answer-content p:last-child {
            margin-bottom: 0;
        }
        
        .answer-content ul {
            padding-left: 20px;
            margin: 10px 0;
        }
        
        .answer-content li {
            margin-bottom: 5px;
        }
        
        .help-section {
            background: linear-gradient(135deg, #c9961a 0%, #d4af37 100%);
            color: white;
            padding: 60px 30px;
            border-radius: 12px;
            text-align: center;
            margin-top: 40px;
        }
        
        .help-title {
            font-family: 'Playfair Display', serif;
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 15px;
        }
        
        .help-text {
            font-size: 18px;
            opacity: 0.9;
            margin-bottom: 30px;
        }
        
        .contact-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .contact-btn {
            background: white;
            color: #c9961a;
            padding: 12px 25px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .contact-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }
        
        @media (max-width: 768px) {
            .page-title {
                font-size: 36px;
            }
            
            .faq-controls {
                padding: 20px;
            }
            
            .category-tabs {
                gap: 5px;
            }
            
            .category-tab {
                padding: 8px 16px;
                font-size: 12px;
            }
            
            .faq-question {
                padding: 20px;
            }
            
            .faq-answer.active {
                padding: 20px;
            }
            
            .contact-buttons {
                flex-direction: column;
                align-items: center;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/layout/header/luxury-header.jsp" />
    
    <!-- Page Header -->
    <section class="page-header">
        <div class="container">
            <div class="header-content">
                <h1 class="page-title">FAQ</h1>
                <p class="page-subtitle">자주 묻는 질문들에 대한 답변을 확인하세요</p>
            </div>
        </div>
    </section>
    
    <!-- Content -->
    <section class="content-wrapper">
        <div class="container">
            <!-- Search and Filter -->
            <div class="faq-controls">
                <div class="search-box">
                    <input type="text" class="search-input" placeholder="궁금한 것을 검색해보세요..." id="searchInput">
                    <button class="search-btn" onclick="searchFAQ()">
                        <i class="fas fa-search"></i>
                    </button>
                </div>
                
                <div class="category-tabs">
                    <button class="category-tab active" onclick="filterFAQ('all')">전체</button>
                    <button class="category-tab" onclick="filterFAQ('account')">회원/계정</button>
                    <button class="category-tab" onclick="filterFAQ('auction')">경매 참여</button>
                    <button class="category-tab" onclick="filterFAQ('payment')">결제/정산</button>
                    <button class="category-tab" onclick="filterFAQ('technical')">기술 지원</button>
                    <button class="category-tab" onclick="filterFAQ('other')">기타</button>
                </div>
            </div>
            
            <!-- FAQ Sections -->
            
            <!-- 회원/계정 관련 -->
            <div class="faq-section" data-category="account">
                <div class="section-header">
                    <h2 class="section-title">
                        <div class="section-icon">
                            <i class="fas fa-user"></i>
                        </div>
                        회원가입 및 계정 관리
                    </h2>
                </div>
                <ul class="faq-list">
                    <li class="faq-item">
                        <div class="faq-question" onclick="toggleAnswer(this)">
                            <span class="question-text">회원가입은 어떻게 하나요?</span>
                            <span class="question-toggle">▼</span>
                        </div>
                        <div class="faq-answer">
                            <div class="answer-content">
                                <p>M4 Auction 회원가입은 다음과 같은 단계로 진행됩니다:</p>
                                <ul>
                                    <li>홈페이지 상단의 'JOIN' 버튼을 클릭</li>
                                    <li>이용약관 및 개인정보처리방침 동의</li>
                                    <li>본인인증 (휴대폰 또는 이메일)</li>
                                    <li>회원정보 입력 및 가입 완료</li>
                                </ul>
                                <p>가입 과정에서 문제가 발생하면 고객센터로 연락해주세요.</p>
                            </div>
                        </div>
                    </li>
                    <li class="faq-item">
                        <div class="faq-question" onclick="toggleAnswer(this)">
                            <span class="question-text">비밀번호를 잊어버렸어요</span>
                            <span class="question-toggle">▼</span>
                        </div>
                        <div class="faq-answer">
                            <div class="answer-content">
                                <p>비밀번호를 찾는 방법:</p>
                                <ul>
                                    <li>로그인 페이지에서 '비밀번호 찾기' 클릭</li>
                                    <li>가입 시 등록한 이메일 주소 입력</li>
                                    <li>이메일로 전송된 임시 비밀번호로 로그인</li>
                                    <li>마이페이지에서 새 비밀번호로 변경</li>
                                </ul>
                                <p>이메일이 도착하지 않으면 스팸함을 확인해보세요.</p>
                            </div>
                        </div>
                    </li>
                    <li class="faq-item">
                        <div class="faq-question" onclick="toggleAnswer(this)">
                            <span class="question-text">VIP 회원이 되려면 어떻게 해야 하나요?</span>
                            <span class="question-toggle">▼</span>
                        </div>
                        <div class="faq-answer">
                            <div class="answer-content">
                                <p>VIP 회원 자격 조건:</p>
                                <ul>
                                    <li>연간 경매 참여 횟수 10회 이상</li>
                                    <li>누적 거래금액 1,000만원 이상</li>
                                    <li>경매 낙찰 성공률 70% 이상</li>
                                </ul>
                                <p>VIP 회원 혜택으로는 수수료 할인, 프리뷰 우선 관람, 전담 상담사 배정 등이 있습니다.</p>
                            </div>
                        </div>
                    </li>
                </ul>
            </div>
            
            <!-- 경매 참여 관련 -->
            <div class="faq-section" data-category="auction">
                <div class="section-header">
                    <h2 class="section-title">
                        <div class="section-icon">
                            <i class="fas fa-gavel"></i>
                        </div>
                        경매 참여 및 입찰
                    </h2>
                </div>
                <ul class="faq-list">
                    <li class="faq-item">
                        <div class="faq-question" onclick="toggleAnswer(this)">
                            <span class="question-text">경매에 참여하려면 어떻게 해야 하나요?</span>
                            <span class="question-toggle">▼</span>
                        </div>
                        <div class="faq-answer">
                            <div class="answer-content">
                                <p>경매 참여 방법:</p>
                                <ul>
                                    <li>회원가입 및 본인인증 완료</li>
                                    <li>마일리지 충전 (입찰 보증금 역할)</li>
                                    <li>원하는 경매 작품 선택</li>
                                    <li>입찰가 입력 후 입찰 참여</li>
                                </ul>
                                <p>경매 시작 전 프리뷰를 통해 작품을 직접 확인하실 수 있습니다.</p>
                            </div>
                        </div>
                    </li>
                    <li class="faq-item">
                        <div class="faq-question" onclick="toggleAnswer(this)">
                            <span class="question-text">입찰 단위는 어떻게 정해지나요?</span>
                            <span class="question-toggle">▼</span>
                        </div>
                        <div class="faq-answer">
                            <div class="answer-content">
                                <p>입찰 단위 기준:</p>
                                <ul>
                                    <li>100만원 미만: 1만원 단위</li>
                                    <li>100만원 이상 ~ 500만원 미만: 5만원 단위</li>
                                    <li>500만원 이상 ~ 1,000만원 미만: 10만원 단위</li>
                                    <li>1,000만원 이상: 50만원 단위</li>
                                </ul>
                                <p>경매 진행 상황에 따라 입찰 단위가 조정될 수 있습니다.</p>
                            </div>
                        </div>
                    </li>
                    <li class="faq-item">
                        <div class="faq-question" onclick="toggleAnswer(this)">
                            <span class="question-text">낙찰되면 어떻게 되나요?</span>
                            <span class="question-toggle">▼</span>
                        </div>
                        <div class="faq-answer">
                            <div class="answer-content">
                                <p>낙찰 후 절차:</p>
                                <ul>
                                    <li>낙찰 확정 및 SMS/이메일 알림</li>
                                    <li>구매자 프리미엄 (낙찰가의 15%) 결제</li>
                                    <li>작품 수령 방법 선택 (배송 또는 직접 수령)</li>
                                    <li>결제 완료 후 작품 인도</li>
                                </ul>
                                <p>낙찰 후 7일 이내 결제를 완료해야 합니다.</p>
                            </div>
                        </div>
                    </li>
                </ul>
            </div>
            
            <!-- 결제/정산 관련 -->
            <div class="faq-section" data-category="payment">
                <div class="section-header">
                    <h2 class="section-title">
                        <div class="section-icon">
                            <i class="fas fa-credit-card"></i>
                        </div>
                        결제 및 정산
                    </h2>
                </div>
                <ul class="faq-list">
                    <li class="faq-item">
                        <div class="faq-question" onclick="toggleAnswer(this)">
                            <span class="question-text">마일리지는 어떻게 충전하나요?</span>
                            <span class="question-toggle">▼</span>
                        </div>
                        <div class="faq-answer">
                            <div class="answer-content">
                                <p>마일리지 충전 방법:</p>
                                <ul>
                                    <li>마이페이지 > 마일리지 충전 메뉴 이용</li>
                                    <li>충전 금액 선택 (최소 10만원부터)</li>
                                    <li>결제 수단 선택 (신용카드, 계좌이체, 무통장입금)</li>
                                    <li>관리자 승인 후 충전 완료</li>
                                </ul>
                                <p>무통장입금의 경우 확인까지 1-2시간이 소요됩니다.</p>
                            </div>
                        </div>
                    </li>
                    <li class="faq-item">
                        <div class="faq-question" onclick="toggleAnswer(this)">
                            <span class="question-text">수수료는 얼마인가요?</span>
                            <span class="question-toggle">▼</span>
                        </div>
                        <div class="faq-answer">
                            <div class="answer-content">
                                <p>수수료 안내:</p>
                                <ul>
                                    <li>구매자 프리미엄: 낙찰가의 15%</li>
                                    <li>판매자 수수료: 낙찰가의 10%</li>
                                    <li>VIP 회원: 각각 2% 할인</li>
                                    <li>배송료: 전국 무료 (직접 수령 시 불필요)</li>
                                </ul>
                                <p>모든 수수료는 부가세 별도입니다.</p>
                            </div>
                        </div>
                    </li>
                </ul>
            </div>
            
            <!-- 기술 지원 관련 -->
            <div class="faq-section" data-category="technical">
                <div class="section-header">
                    <h2 class="section-title">
                        <div class="section-icon">
                            <i class="fas fa-laptop"></i>
                        </div>
                        기술 지원
                    </h2>
                </div>
                <ul class="faq-list">
                    <li class="faq-item">
                        <div class="faq-question" onclick="toggleAnswer(this)">
                            <span class="question-text">모바일에서도 경매에 참여할 수 있나요?</span>
                            <span class="question-toggle">▼</span>
                        </div>
                        <div class="faq-answer">
                            <div class="answer-content">
                                <p>네, 모바일에서도 모든 경매 기능을 이용하실 수 있습니다.</p>
                                <ul>
                                    <li>반응형 웹 디자인으로 모바일 최적화</li>
                                    <li>실시간 입찰 및 알림 기능</li>
                                    <li>터치 친화적인 인터페이스</li>
                                    <li>안정적인 모바일 결제 시스템</li>
                                </ul>
                                <p>권장 브라우저: Chrome, Safari, Samsung Internet</p>
                            </div>
                        </div>
                    </li>
                    <li class="faq-item">
                        <div class="faq-question" onclick="toggleAnswer(this)">
                            <span class="question-text">사이트 접속이 안 되거나 느려요</span>
                            <span class="question-toggle">▼</span>
                        </div>
                        <div class="faq-answer">
                            <div class="answer-content">
                                <p>접속 문제 해결 방법:</p>
                                <ul>
                                    <li>브라우저 새로고침 (Ctrl + F5)</li>
                                    <li>브라우저 캐시 및 쿠키 삭제</li>
                                    <li>다른 브라우저로 접속 시도</li>
                                    <li>인터넷 연결 상태 확인</li>
                                </ul>
                                <p>문제가 지속되면 고객센터로 문의해주세요.</p>
                            </div>
                        </div>
                    </li>
                </ul>
            </div>
            
            <!-- Help Section -->
            <div class="help-section">
                <h2 class="help-title">더 궁금한 점이 있으신가요?</h2>
                <p class="help-text">FAQ에서 답을 찾지 못하셨다면 언제든지 연락주세요</p>
                <div class="contact-buttons">
                    <a href="<%=ctx%>/company/contact.jsp" class="contact-btn">
                        <i class="fas fa-envelope"></i>
                        문의하기
                    </a>
                    <a href="tel:02-1234-5678" class="contact-btn">
                        <i class="fas fa-phone"></i>
                        전화상담
                    </a>
                    <a href="#" class="contact-btn">
                        <i class="fas fa-comments"></i>
                        라이브채팅
                    </a>
                </div>
            </div>
        </div>
    </section>
    
    <jsp:include page="/layout/footer/luxury-footer.jsp" />
    
    <script>
        function toggleAnswer(element) {
            const answer = element.nextElementSibling;
            const toggle = element.querySelector('.question-toggle');
            
            // 다른 열린 답변들 닫기
            document.querySelectorAll('.faq-answer.active').forEach(item => {
                if (item !== answer) {
                    item.classList.remove('active');
                    item.previousElementSibling.classList.remove('active');
                    item.previousElementSibling.querySelector('.question-toggle').classList.remove('active');
                }
            });
            
            // 현재 답변 토글
            answer.classList.toggle('active');
            element.classList.toggle('active');
            toggle.classList.toggle('active');
        }
        
        function filterFAQ(category) {
            const tabs = document.querySelectorAll('.category-tab');
            const sections = document.querySelectorAll('.faq-section');
            
            // 탭 활성화
            tabs.forEach(tab => tab.classList.remove('active'));
            event.target.classList.add('active');
            
            // 섹션 필터링
            sections.forEach(section => {
                if (category === 'all' || section.dataset.category === category) {
                    section.style.display = 'block';
                } else {
                    section.style.display = 'none';
                }
            });
        }
        
        function searchFAQ() {
            const searchTerm = document.getElementById('searchInput').value.toLowerCase();
            const faqItems = document.querySelectorAll('.faq-item');
            
            faqItems.forEach(item => {
                const questionText = item.querySelector('.question-text').textContent.toLowerCase();
                const answerText = item.querySelector('.answer-content').textContent.toLowerCase();
                
                if (questionText.includes(searchTerm) || answerText.includes(searchTerm)) {
                    item.style.display = 'block';
                } else {
                    item.style.display = 'none';
                }
            });
        }
        
        // 검색 입력 시 실시간 검색
        document.getElementById('searchInput').addEventListener('input', searchFAQ);
    </script>
</body>
</html>