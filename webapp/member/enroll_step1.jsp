<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>M4 Auction - 회원가입</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;700&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/luxury-global-style.css">

<style>
    /* 회원가입 페이지 전용 - 심플한 디자인 */
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }
    
    body {
        font-family: 'Noto Sans KR', sans-serif;
        background: #f5f5f5;
        color: #333;
    }
    
    /* 심플한 헤더 */
    .simple-header {
        background: white;
        padding: 20px 0;
        border-bottom: 1px solid #e5e5e5;
        text-align: center;
    }
    
    .simple-header h1 {
        font-family: 'Playfair Display', serif;
        font-size: 28px;
        color: #1a1a1a;
    }
    
    .simple-header h1 a {
        color: inherit;
        text-decoration: none;
    }
    
    /* 진행 단계 */
    .progress-wrapper {
        background: white;
        padding: 30px 0;
        border-bottom: 1px solid #e5e5e5;
    }
    
    .progress-steps {
        display: flex;
        justify-content: center;
        align-items: center;
        max-width: 500px;
        margin: 0 auto;
    }
    
    .step {
        flex: 1;
        text-align: center;
        position: relative;
    }
    
    .step:not(:last-child)::after {
        content: '';
        position: absolute;
        top: 15px;
        right: -50%;
        width: 100%;
        height: 2px;
        background: #e5e5e5;
        z-index: -1;
    }
    
    .step.active ~ .step::after {
        background: #e5e5e5;
    }
    
    .step.active::after {
        background: #c9961a;
    }
    
    .step-number {
        width: 30px;
        height: 30px;
        background: #e5e5e5;
        border-radius: 50%;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        font-weight: 700;
        font-size: 14px;
        color: #999;
        margin-bottom: 8px;
    }
    
    .step.active .step-number {
        background: #c9961a;
        color: white;
    }
    
    .step-label {
        font-size: 13px;
        color: #999;
    }
    
    .step.active .step-label {
        color: #333;
        font-weight: 500;
    }
    
    /* 메인 컨테이너 */
    .main-container {
        max-width: 600px;
        margin: 40px auto;
        background: white;
        padding: 50px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }
    
    /* 체크박스 스타일 */
    .checkbox-group {
        margin-bottom: 20px;
    }
    
    .checkbox-wrapper {
        padding: 20px;
        background: #fafafa;
        border: 1px solid #e5e5e5;
        border-radius: 4px;
        margin-bottom: 15px;
        transition: all 0.2s;
    }
    
    .checkbox-wrapper:hover {
        border-color: #c9961a;
    }
    
    .checkbox-wrapper.highlight {
        background: #fffbf0;
        border: 2px solid #c9961a;
    }
    
    .checkbox-wrapper label {
        display: flex;
        align-items: center;
        cursor: pointer;
        font-size: 15px;
        font-weight: 500;
    }
    
    .checkbox-wrapper input[type="checkbox"],
    .checkbox-wrapper input[type="radio"] {
        width: 18px;
        height: 18px;
        margin-right: 10px;
        cursor: pointer;
    }
    
    /* 회원 유형 선택 */
    .member-type-wrapper {
        display: flex;
        gap: 15px;
        margin-bottom: 30px;
    }
    
    .member-type-wrapper .radio-wrapper {
        flex: 1;
        padding: 20px;
        background: #fafafa;
        border: 1px solid #e5e5e5;
        border-radius: 4px;
        text-align: center;
        cursor: pointer;
        transition: all 0.2s;
    }
    
    .member-type-wrapper .radio-wrapper:hover {
        border-color: #c9961a;
    }
    
    .member-type-wrapper .radio-wrapper.selected {
        border-color: #c9961a;
        background: #fffbf0;
    }
    
    .member-type-wrapper label {
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        font-size: 15px;
        font-weight: 500;
    }
    
    .vip-badge {
        background: #c9961a;
        color: white;
        font-size: 10px;
        padding: 2px 8px;
        border-radius: 3px;
        margin-left: 8px;
        font-weight: 700;
    }
    
    /* 약관 박스 */
    .terms-content {
        margin-top: 15px;
        padding: 20px;
        background: white;
        border: 1px solid #e5e5e5;
        border-radius: 4px;
        max-height: 150px;
        overflow-y: auto;
        font-size: 13px;
        line-height: 1.8;
        color: #666;
    }
    
    .terms-content h4 {
        font-size: 14px;
        color: #333;
        margin-bottom: 10px;
    }
    
    /* 스크롤바 */
    .terms-content::-webkit-scrollbar {
        width: 6px;
    }
    
    .terms-content::-webkit-scrollbar-track {
        background: #f5f5f5;
    }
    
    .terms-content::-webkit-scrollbar-thumb {
        background: #ddd;
        border-radius: 3px;
    }
    
    /* 버튼 */
    .submit-btn {
        width: 100%;
        padding: 16px;
        background: #1a1a1a;
        color: white;
        border: none;
        border-radius: 4px;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
        margin-top: 40px;
    }
    
    .submit-btn:hover:not(:disabled) {
        background: #c9961a;
    }
    
    .submit-btn:disabled {
        background: #ccc;
        cursor: not-allowed;
    }
    
    /* 필수/선택 표시 */
    .label-badge {
        font-size: 12px;
        font-weight: 700;
        margin-right: 5px;
    }
    
    .label-badge.required {
        color: #e74c3c;
    }
    
    .label-badge.optional {
        color: #999;
    }
</style>
</head>
<body>
<jsp:include page="/layout/header/luxury-header.jsp" />
    
    <!-- 진행 단계 -->
    <div class="progress-wrapper">
        <div class="progress-steps">
            <div class="step active">
                <div class="step-number">1</div>
                <div class="step-label">약관동의</div>
            </div>
            <div class="step">
                <div class="step-number">2</div>
                <div class="step-label">정보입력</div>
            </div>
            <div class="step">
                <div class="step-number">3</div>
                <div class="step-label">가입완료</div>
            </div>
        </div>
    </div>
    
    <!-- 메인 컨텐츠 -->
    <div class="main-container">
        <form id="enrollForm" action="enroll_step2.jsp" method="post" onsubmit="return validateTerms();">
            
            <!-- 모두 동의 -->
            <div class="checkbox-wrapper highlight">
                <label>
                    <input type="checkbox" id="check_all">
                    <span>모든 약관에 동의합니다</span>
                </label>
            </div>
            
            <!-- 회원 유형 선택 -->
            <div class="member-type-wrapper">
                <div class="radio-wrapper selected">
                    <label>
                        <input type="radio" name="memberType" value="1" checked>
                        <span>일반회원</span>
                    </label>
                </div>
                <div class="radio-wrapper">
                    <label>
                        <input type="radio" id="vip" name="memberType" value="2">
                        <span>VIP 회원</span>
                        <span class="vip-badge">PREMIUM</span>
                    </label>
                </div>
            </div>
            
            <!-- 필수 약관들 -->
            <div class="checkbox-group">
                <div class="checkbox-wrapper">
                    <label>
                        <input type="checkbox" class="check-required" id="terms_agree">
                        <span><span class="label-badge required">[필수]</span>이용약관 동의</span>
                    </label>
                    <div class="terms-content">
                        <h4>제1조 (목적)</h4>
                        이 약관은 M4 Auction(전자상거래 사업자)가 운영하는 M4 Auction 사이버 몰(이하 "몰"이라 한다)에서 제공하는 인터넷 관련 서비스(이하 "서비스"라 한다)를 이용함에 있어 사이버 몰과 이용자의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.
                        
                        <h4>제2조 (정의)</h4>
                        "몰"이란 M4 Auction이 재화 또는 용역(이하 "재화 등"이라 함)을 이용자에게 제공하기 위하여 컴퓨터 등 정보통신설비를 이용하여 재화 등을 거래할 수 있도록 설정한 가상의 영업장을 말합니다.
                    </div>
                </div>
                
                <div class="checkbox-wrapper">
                    <label>
                        <input type="checkbox" class="check-required" id="privacy_agree">
                        <span><span class="label-badge required">[필수]</span>개인정보 수집 및 이용 동의</span>
                    </label>
                    <div class="terms-content">
                        <h4>1. 수집하는 개인정보 항목</h4>
                        회사는 회원가입, 상담, 서비스 신청 등을 위해 아래와 같은 개인정보를 수집하고 있습니다.
                        - 수집항목: 이름, 생년월일, 성별, 로그인ID, 비밀번호, 휴대전화번호, 이메일
                        
                        <h4>2. 개인정보의 수집 및 이용목적</h4>
                        회사는 수집한 개인정보를 다음의 목적을 위해 활용합니다.
                        - 서비스 제공에 관한 계약 이행 및 서비스 제공에 따른 요금정산
                    </div>
                </div>
                
                <div class="checkbox-wrapper">
                    <label>
                        <input type="checkbox" class="check-optional" id="marketing_agree">
                        <span><span class="label-badge optional">[선택]</span>마케팅 정보 수신 동의</span>
                    </label>
                </div>
            </div>
            
            <button type="submit" id="submitBtn" class="submit-btn" disabled>다음</button>
        </form>
    </div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('enrollForm');
    const vipRadio = document.getElementById('vip');
    const submitBtn = document.getElementById('submitBtn');
    const requiredChecks = document.querySelectorAll('.check-required');
    const optionalCheck = document.querySelector('.check-optional');
    const checkAll = document.getElementById('check_all');
    
    // 라디오 버튼 선택 시 스타일 변경
    document.querySelectorAll('input[name="memberType"]').forEach(radio => {
        radio.addEventListener('change', function() {
            document.querySelectorAll('.radio-wrapper').forEach(wrapper => {
                wrapper.classList.remove('selected');
            });
            this.closest('.radio-wrapper').classList.add('selected');
        });
    });
    
    // 모두 동의
    checkAll.addEventListener('click', function() {
        const isChecked = this.checked;
        requiredChecks.forEach(c => c.checked = isChecked);
        optionalCheck.checked = isChecked;
        toggleSubmitButton();
    });
    
    // 개별 체크박스
    document.querySelectorAll('.check-required, .check-optional').forEach(c => {
        c.addEventListener('click', function() {
            let allAgreed = [...requiredChecks].every(rc => rc.checked) && optionalCheck.checked;
            checkAll.checked = allAgreed;
            toggleSubmitButton();
        });
    });
    
    // 버튼 활성화
    function toggleSubmitButton() {
        const allRequired = [...requiredChecks].every(c => c.checked);
        submitBtn.disabled = !allRequired;
    }
    
    // 폼 검증
    window.validateTerms = function() {
        const allRequired = [...requiredChecks].every(c => c.checked);
        if (!allRequired) {
            alert('필수 약관에 모두 동의해주셔야 합니다.');
            return false;
        }
        
        if (vipRadio.checked) {
            form.action = 'enroll_Vip.jsp';
        } else {
            form.action = 'enroll_step2.jsp';
        }
        return true;
    };
});
</script>

</body>
</html>