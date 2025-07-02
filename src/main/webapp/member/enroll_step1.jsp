<%--
  File: WebContent/member/enroll_step1.jsp
  역할: 회원가입 절차의 1단계, 이용약관 및 개인정보 수집 동의를 받는 페이지입니다. (다크 테마 적용)
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Art Auction - 회원가입 (약관 동의)</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;700&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/layout.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/enroll.css">
</head>
<body>
<jsp:include page="/layout/header/header.jsp" /><br>
    <div class="page-wrapper">
    <div class="container">
        <h1>회원가입</h1>
        
        <form id="enrollForm" action="enroll_step2.jsp" method="post" onsubmit="return validateTerms();">
            <div class="check-group">
                <input type="checkbox" id="check_all">
                <label for="check_all">모두 동의합니다.</label>
            </div>
			<div class="check-group">
		        <label for="default" require>
		            <input type="radio" id="default" name="memberType" value="1"> 일반회원
		        </label>
		        <label for="vip">
		            <input type="radio" id="vip" name="memberType" value="2"> VIP 회원
		        </label>
		    </div>
			

            <div class="check-group">
                <input type="checkbox" class="check-required" id="terms_agree">
                <label for="terms_agree">(필수) 이용약관 동의</label>
                <div class="terms-box">
                    <strong>제1조 (목적)</strong><br>
                    이 약관은 아트 옥션 회사(전자상거래 사업자)가 운영하는 아트 옥션 사이버 몰(이하 “몰”이라 한다)에서 제공하는 인터넷 관련 서비스(이하 “서비스”라 한다)를 이용함에 있어 사이버 몰과 이용자의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.<br><br>
                    <strong>제2조 (정의)</strong><br>
                    “몰”이란 아트 옥션 회사가 재화 또는 용역(이하 “재화 등”이라 함)을 이용자에게 제공하기 위하여 컴퓨터 등 정보통신설비를 이용하여 재화 등을 거래할 수 있도록 설정한 가상의 영업장을 말하며, 아울러 사이버몰을 운영하는 사업자의 의미로도 사용합니다.<br>
                    ... (이하 약관 내용 생략) ...
                </div>
            </div>

            <div class="check-group">
                <input type="checkbox" class="check-required" id="privacy_agree">
                <label for="privacy_agree">(필수) 개인정보 수집 및 이용 동의</label>
                <div class="terms-box">
                    <strong>1. 수집하는 개인정보 항목</strong><br>
                    회사는 회원가입, 상담, 서비스 신청 등등을 위해 아래와 같은 개인정보를 수집하고 있습니다.<br>
                    - 수집항목 : 이름 , 생년월일 , 성별 , 로그인ID , 비밀번호 , 자택 전화번호 , 휴대전화번호 , 이메일 , 14세미만인 경우 법정대리인 정보<br><br>
                    <strong>2. 개인정보의 수집 및 이용목적</strong><br>
                    회사는 수집한 개인정보를 다음의 목적을 위해 활용합니다.<br>
                    - 서비스 제공에 관한 계약 이행 및 서비스 제공에 따른 요금정산 콘텐츠 제공 , 구매 및 요금 결제 , 물품배송 또는 청구지 등 발송 , 금융거래 본인 인증 및 금융 서비스<br>
                    ... (이하 약관 내용 생략) ...
                </div>
            </div>
            
            <div class="check-group">
                <input type="checkbox" class="check-optional" id="event_agree">
                <label for="event_agree">(선택) 이벤트 및 혜택 알림 동의</label>
            </div>
            
             <button type="submit" id="submitBtn" class="submit-btn" disabled>다음</button>
        </form>
    </div>
    </div>
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        const form      = document.getElementById('enrollForm');
        const vipRadio  = document.getElementById('vip');
        const submitBtn = document.getElementById('submitBtn');
        const requiredChecks = document.querySelectorAll('.check-required');
        const optionalCheck  = document.querySelector('.check-optional');
        const checkAll       = document.getElementById('check_all');
    // 모두 동의 클릭
    checkAll.addEventListener('click', function() {
        const isChecked = this.checked;
        requiredChecks.forEach(c => c.checked = isChecked);
        optionalCheck.checked = isChecked;
        toggleSubmitButton();
    });

    // 필수/선택 항목 클릭
    document.querySelectorAll('.check-required, .check-optional')
        .forEach(c => c.addEventListener('click', function() {
            let allAgreed = [...requiredChecks].every(rc => rc.checked)
                            && optionalCheck.checked;
            checkAll.checked = allAgreed;
            toggleSubmitButton();
        }));

    // 버튼 활성화 로직
    function toggleSubmitButton() {
        const allRequired = [...requiredChecks].every(c => c.checked);
        submitBtn.disabled = !allRequired;
    }

    // 폼 제출 전 검증
     window.validateTerms = function() {
        // 1) 필수 약관 체크 여부 검사
        const allRequired = [...requiredChecks].every(c => c.checked);
        if (!allRequired) {
            alert('필수 약관에 모두 동의해주셔야 합니다.');
            return false;
        };
	
     //회원 유형(라디오) 선택 여부 검사
     const memberType = document.querySelector('input[name="memberType"]:checked');
     if (!memberType) {
           alert('회원 유형을 선택해 주세요.');
           return false;
        }
    // VIP 클릭 시 이동
        if (vipRadio.checked) {
            form.action = 'enroll_Vip.jsp'; // 혹은 enroll_vip_step2.jsp
        } else {
            form.action = 'enroll_step2.jsp';
        }
        return true;
    };

});
</script>

</body>
</html>
