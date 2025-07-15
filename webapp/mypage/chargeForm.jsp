<%--
  File: WebContent/mypage/chargeForm.jsp
  역할: 사용자가 마일리지를 충전할 금액을 입력하는 페이지입니다.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.auction.dto.MemberDTO" %>
<%
    // 로그인한 사용자만 이 페이지에 접근할 수 있도록 확인합니다.
    MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");

    if(loginUser == null){
        // 로그인이 안되어있으면 로그인 페이지로 보냅니다.
        response.sendRedirect(request.getContextPath() + "/member/loginForm.jsp");
        return;
    }
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mileage Charge - M4 Auction</title>
    
    <!-- Luxury Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700;900&family=Poppins:wght@300;400;500;600;700&family=Noto+Sans+KR:wght@300;400;500;700;900&display=swap" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="<%=ctx%>/resources/css/luxury-global-style.css">

    <style>
        /* 전체 레이아웃 */
        body {
            padding-top: 120px !important;
            background: #f8f8f8;
            font-family: 'Noto Sans KR', sans-serif;
        }

        .charge-wrapper {
            min-height: calc(100vh - 320px);
            padding: 60px 0;
            background: linear-gradient(135deg, #f8f8f8 0%, #ffffff 100%);
        }

        .charge-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 0 20px;
        }

        /* 헤더 섹션 */
        .charge-header {
            text-align: center;
            margin-bottom: 60px;
        }

        .charge-title {
            font-family: 'Playfair Display', serif;
            font-size: 48px;
            color: #1a1a1a;
            margin-bottom: 20px;
            position: relative;
        }

        .charge-title::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 3px;
            background: #c9961a;
        }

        .charge-subtitle {
            font-size: 18px;
            color: #666;
            margin-bottom: 40px;
        }

        /* 현재 마일리지 카드 */
        .current-balance-card {
            background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
            color: white;
            padding: 40px;
            border-radius: 20px;
            margin-bottom: 50px;
            position: relative;
            overflow: hidden;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
        }

        .current-balance-card::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 200px;
            height: 200px;
            background: radial-gradient(circle, rgba(201, 150, 26, 0.1) 0%, transparent 70%);
        }

        .balance-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .balance-label {
            font-size: 16px;
            color: #ccc;
            font-weight: 500;
        }

        .balance-icon {
            width: 50px;
            height: 50px;
            background: #c9961a;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
        }

        .balance-amount {
            font-family: 'Playfair Display', serif;
            font-size: 42px;
            font-weight: 700;
            color: #c9961a;
            text-align: center;
            position: relative;
            z-index: 2;
        }

        .balance-unit {
            font-size: 24px;
            margin-left: 10px;
        }

        /* 충전 폼 섹션 */
        .charge-form-section {
            background: white;
            padding: 50px;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.05);
            margin-bottom: 40px;
        }

        .form-section-title {
            font-family: 'Playfair Display', serif;
            font-size: 28px;
            color: #1a1a1a;
            margin-bottom: 40px;
            text-align: center;
        }

        /* 빠른 선택 버튼 */
        .quick-amounts {
            margin-bottom: 40px;
        }

        .quick-amounts-label {
            font-size: 18px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 20px;
            text-align: center;
        }

        .amount-buttons {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
            margin-bottom: 30px;
        }

        .amount-btn {
            padding: 20px;
            background: #f8f8f8;
            border: 2px solid #e0e0e0;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-align: center;
            font-weight: 600;
            color: #666;
            position: relative;
            overflow: hidden;
        }

        .amount-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(201, 150, 26, 0.1), transparent);
            transition: left 0.5s ease;
        }

        .amount-btn:hover::before {
            left: 100%;
        }

        .amount-btn:hover {
            border-color: #c9961a;
            color: #c9961a;
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(201, 150, 26, 0.1);
        }

        .amount-btn.active {
            background: #c9961a;
            border-color: #c9961a;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 10px 30px rgba(201, 150, 26, 0.3);
        }

        .amount-value {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .amount-label {
            font-size: 12px;
            opacity: 0.8;
        }

        /* 직접 입력 */
        .custom-input-section {
            margin-bottom: 40px;
        }

        .custom-input-label {
            font-size: 18px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 20px;
            text-align: center;
        }

        .custom-amount-wrapper {
            position: relative;
            max-width: 400px;
            margin: 0 auto;
        }

        .custom-amount-input {
            width: 100%;
            padding: 20px 25px;
            font-size: 24px;
            font-weight: 600;
            text-align: center;
            border: 2px solid #e0e0e0;
            border-radius: 15px;
            background: #fafafa;
            color: #1a1a1a;
            transition: all 0.3s ease;
            box-sizing: border-box;
        }

        .custom-amount-input:focus {
            outline: none;
            border-color: #c9961a;
            background: white;
            box-shadow: 0 0 20px rgba(201, 150, 26, 0.1);
        }

        .currency-symbol {
            position: absolute;
            right: 25px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 20px;
            color: #999;
            font-weight: 600;
        }

        /* 충전 버튼 */
        .charge-button {
            width: 100%;
            max-width: 400px;
            margin: 0 auto;
            padding: 20px;
            background: linear-gradient(135deg, #1a1a1a 0%, #333 100%);
            color: white;
            border: none;
            border-radius: 15px;
            font-size: 20px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            display: block;
        }

        .charge-button::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, #c9961a 0%, #b08515 100%);
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .charge-button:hover::before {
            opacity: 1;
        }

        .charge-button:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.2);
        }

        .charge-button span {
            position: relative;
            z-index: 2;
        }

        .charge-button i {
            margin-right: 10px;
            font-size: 18px;
        }

        /* 안내 정보 */
        .info-section {
            background: #faf8f4;
            border: 1px solid #e8e3d8;
            border-radius: 15px;
            padding: 30px;
            margin-top: 40px;
        }

        .info-title {
            display: flex;
            align-items: center;
            font-size: 18px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 20px;
        }

        .info-title i {
            color: #c9961a;
            margin-right: 10px;
            font-size: 20px;
        }

        .info-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .info-list li {
            padding: 8px 0;
            color: #666;
            font-size: 14px;
            position: relative;
            padding-left: 20px;
        }

        .info-list li::before {
            content: '•';
            color: #c9961a;
            position: absolute;
            left: 0;
            font-weight: bold;
        }

        /* 뒤로가기 버튼 */
        .back-button {
            display: inline-flex;
            align-items: center;
            color: #666;
            text-decoration: none;
            font-size: 16px;
            font-weight: 500;
            margin-top: 30px;
            transition: all 0.3s ease;
        }

        .back-button:hover {
            color: #c9961a;
        }

        .back-button i {
            margin-right: 8px;
        }

        /* 애니메이션 */
        @keyframes slideInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .charge-form-section {
            animation: slideInUp 0.6s ease-out;
        }

        .current-balance-card {
            animation: slideInUp 0.6s ease-out 0.2s both;
        }

        /* 반응형 */
        @media (max-width: 768px) {
            body {
                padding-top: 100px !important;
            }

            .charge-title {
                font-size: 36px;
            }

            .charge-form-section {
                padding: 30px 20px;
                margin: 0 10px 40px;
            }

            .current-balance-card {
                margin: 0 10px 40px;
                padding: 30px 20px;
            }

            .balance-amount {
                font-size: 32px;
            }

            .amount-buttons {
                grid-template-columns: repeat(2, 1fr);
                gap: 10px;
            }

            .amount-btn {
                padding: 15px 10px;
            }

            .amount-value {
                font-size: 18px;
            }
        }
    </style>
</head>
<body>
    <!-- Luxury Header -->
    <jsp:include page="/layout/header/luxury-header.jsp" />

    <div class="charge-wrapper">
        <div class="charge-container">
            <!-- Header Section -->
            <div class="charge-header">
                <h1 class="charge-title">Mileage Charge</h1>
                <p class="charge-subtitle">프리미엄 경매를 위한 마일리지를 충전하세요</p>
            </div>

            <!-- Current Balance Card -->
            <div class="current-balance-card">
                <div class="balance-header">
                    <div class="balance-label">현재 보유 마일리지</div>
                    <div class="balance-icon">
                        <i class="fas fa-coins"></i>
                    </div>
                </div>
                <div class="balance-amount">
                    <%= String.format("%,d", loginUser.getMileage()) %><span class="balance-unit">P</span>
                </div>
            </div>

            <!-- Charge Form Section -->
            <div class="charge-form-section">
                <h2 class="form-section-title">충전 금액 선택</h2>

                <form action="chargeMileage.jsp" method="post" onsubmit="return validateForm();">
                    <!-- Quick Amount Selection -->
                    <div class="quick-amounts">
                        <div class="quick-amounts-label">빠른 선택</div>
                        <div class="amount-buttons">
                            <div class="amount-btn" onclick="setAmount(10000)">
                                <div class="amount-value">10,000</div>
                                <div class="amount-label">원</div>
                            </div>
                            <div class="amount-btn" onclick="setAmount(30000)">
                                <div class="amount-value">30,000</div>
                                <div class="amount-label">원</div>
                            </div>
                            <div class="amount-btn" onclick="setAmount(50000)">
                                <div class="amount-value">50,000</div>
                                <div class="amount-label">원</div>
                            </div>
                            <div class="amount-btn" onclick="setAmount(100000)">
                                <div class="amount-value">100,000</div>
                                <div class="amount-label">원</div>
                            </div>
                            <div class="amount-btn" onclick="setAmount(200000)">
                                <div class="amount-value">200,000</div>
                                <div class="amount-label">원</div>
                            </div>
                            <div class="amount-btn" onclick="setAmount(500000)">
                                <div class="amount-value">500,000</div>
                                <div class="amount-label">원</div>
                            </div>
                        </div>
                    </div>

                    <!-- Custom Amount Input -->
                    <div class="custom-input-section">
                        <div class="custom-input-label">직접 입력</div>
                        <div class="custom-amount-wrapper">
                            <input type="number" 
                                   id="amount" 
                                   name="amount" 
                                   min="1000" 
                                   step="1000" 
                                   placeholder="충전할 금액"
                                   class="custom-amount-input"
                                   oninput="clearAmountSelection()"
                                   required>
                            <span class="currency-symbol">원</span>
                        </div>
                    </div>

                    <!-- Charge Button -->
                    <button type="submit" class="charge-button">
                        <span>
                            <i class="fas fa-credit-card"></i>
                            충전하기
                        </span>
                    </button>
                </form>

                <!-- Info Section -->
                <div class="info-section">
                    <div class="info-title">
                        <i class="fas fa-info-circle"></i>
                        충전 안내사항
                    </div>
                    <ul class="info-list">
                        <li>최소 충전 금액은 1,000원이며, 1,000원 단위로 충전 가능합니다</li>
                        <li>충전된 마일리지는 경매 입찰 및 즉시구매에 사용됩니다</li>
                        <li>충전 요청 후 관리자 승인까지 1-2일 소요될 수 있습니다</li>
                        <li>VIP 회원은 충전 시 보너스 마일리지가 적립됩니다</li>
                        <li>마일리지는 현금으로 환불되지 않으니 신중하게 충전해주세요</li>
                    </ul>
                </div>

                <!-- Back Button -->
                <a href="myPage.jsp" class="back-button">
                    <i class="fas fa-arrow-left"></i>
                    마이페이지로 돌아가기
                </a>
            </div>
        </div>
    </div>

    <!-- Luxury Footer -->
    <jsp:include page="/layout/footer/luxury-footer.jsp" />

    <script>
        function setAmount(value) {
            // 입력 필드에 값 설정
            document.getElementById('amount').value = value;
            
            // 모든 버튼에서 active 클래스 제거
            document.querySelectorAll('.amount-btn').forEach(btn => {
                btn.classList.remove('active');
            });
            
            // 클릭한 버튼에 active 클래스 추가
            event.target.classList.add('active');
        }

        function clearAmountSelection() {
            // 직접 입력 시 모든 빠른 선택 버튼 비활성화
            document.querySelectorAll('.amount-btn').forEach(btn => {
                btn.classList.remove('active');
            });
        }

        function validateForm() {
            const amount = parseInt(document.getElementById('amount').value);
            
            if(!amount || amount < 1000) {
                alert('최소 충전 금액은 1,000원입니다.');
                return false;
            }
            
            if(amount % 1000 !== 0) {
                alert('1,000원 단위로 입력해주세요.');
                return false;
            }

            if(amount > 10000000) {
                alert('1회 최대 충전 금액은 10,000,000원입니다.');
                return false;
            }
            
            const formattedAmount = new Intl.NumberFormat('ko-KR').format(amount);
            return confirm(`${formattedAmount}원을 충전하시겠습니까?\n\n충전 후 관리자 승인까지 1-2일 소요됩니다.`);
        }

        // 숫자 입력 시 천단위 콤마 표시
        document.getElementById('amount').addEventListener('input', function(e) {
            let value = e.target.value.replace(/[^0-9]/g, '');
            if(value) {
                e.target.value = parseInt(value);
            }
        });

        // 페이지 로드 시 애니메이션 효과
        document.addEventListener('DOMContentLoaded', function() {
            const cards = document.querySelectorAll('.amount-btn');
            cards.forEach((card, index) => {
                setTimeout(() => {
                    card.style.opacity = '0';
                    card.style.transform = 'translateY(20px)';
                    card.style.transition = 'all 0.3s ease';
                    
                    setTimeout(() => {
                        card.style.opacity = '1';
                        card.style.transform = 'translateY(0)';
                    }, 50);
                }, index * 100);
            });
        });
    </script>
</body>
</html>