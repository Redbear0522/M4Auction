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
    
    .step.completed::after {
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
    
    .step.active .step-number,
    .step.completed .step-number {
        background: #c9961a;
        color: white;
    }
    
    .step-label {
        font-size: 13px;
        color: #999;
    }
    
    .step.active .step-label,
    .step.completed .step-label {
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
    
    /* 폼 그룹 */
    .form-group {
        margin-bottom: 25px;
    }
    
    .form-group label {
        display: block;
        font-size: 14px;
        font-weight: 600;
        color: #333;
        margin-bottom: 8px;
    }
    
    .form-group label .required {
        color: #e74c3c;
        margin-left: 3px;
    }
    
    .form-group input[type="text"],
    .form-group input[type="password"],
    .form-group input[type="email"],
    .form-group input[type="tel"],
    .form-group select {
        width: 100%;
        padding: 12px 15px;
        font-size: 15px;
        border: 1px solid #e5e5e5;
        border-radius: 4px;
        transition: all 0.3s;
        background: #fafafa;
    }
    
    .form-group input:focus,
    .form-group select:focus {
        outline: none;
        border-color: #c9961a;
        background: white;
    }
    
    .form-group input[readonly] {
        background: #f0f0f0;
        cursor: not-allowed;
    }
    
    /* 입력 그룹 */
    .input-group {
        display: flex;
        gap: 10px;
    }
    
    .input-group input {
        flex: 1;
    }
    
    .input-group button {
        padding: 0 25px;
        background: #1a1a1a;
        color: white;
        border: none;
        border-radius: 4px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
        white-space: nowrap;
    }
    
    .input-group button:hover {
        background: #c9961a;
    }
    
    /* 성별 선택 */
    .gender-group {
        display: flex;
        gap: 30px;
        padding: 10px 0;
    }
    
    .gender-group label {
        display: flex;
        align-items: center;
        gap: 8px;
        font-weight: 400;
        cursor: pointer;
    }
    
    .gender-group input[type="radio"] {
        width: 16px;
        height: 16px;
        cursor: pointer;
    }
    
    /* 도움말 텍스트 */
    .help-text {
        font-size: 12px;
        color: #999;
        margin-top: 5px;
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
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }
    
    .submit-btn:hover {
        background: #c9961a;
    }
    
    /* 주소 입력 */
    #zip {
        width: 150px;
    }
</style>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</head>
<body>
    <jsp:include page="/layout/header/luxury-header.jsp" />
    
    <!-- 진행 단계 -->
    <div class="progress-wrapper">
        <div class="progress-steps">
            <div class="step completed">
                <div class="step-number">1</div>
                <div class="step-label">약관동의</div>
            </div>
            <div class="step active">
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
        <form action="enrollAction_detail.jsp" method="post" onsubmit="return validateForm();">
            <input type="hidden" id="memberType" name="memberType" value="<%= request.getParameter("memberType") %>">
            
            <!-- 아이디/비밀번호 -->
            <div class="form-group">
                <label for="userId">아이디 <span class="required">*</span></label>
                <div class="input-group">
                    <input type="text" id="userId" name="userId" placeholder="4자 이상 입력" required>
                    <button type="button" onclick="checkId()">중복확인</button>
                </div>
            </div>
            
            <div class="form-group">
                <label for="userPwd">비밀번호 <span class="required">*</span></label>
                <input type="password" id="userPwd" name="userPwd" placeholder="8자 이상 입력" required>
                <p class="help-text">영문, 숫자, 특수문자 조합 권장</p>
            </div>
            
            <div class="form-group">
                <label for="userPwdCheck">비밀번호 확인 <span class="required">*</span></label>
                <input type="password" id="userPwdCheck" placeholder="비밀번호 재입력" required>
            </div>
            
            <!-- 개인정보 -->
            <div class="form-group">
                <label for="userName">이름 <span class="required">*</span></label>
                <input type="text" id="userName" name="userName" placeholder="실명 입력" required>
            </div>
            
            <div class="form-group">
                <label for="birthdate">생년월일 <span class="required">*</span></label>
                <input type="text" id="birthdate" name="birthdate" placeholder="8자리 숫자로 입력 (예: 19920508)" maxlength="8" required>
            </div>
            
            <div class="form-group">
                <label>성별 <span class="required">*</span></label>
                <div class="gender-group">
                    <label>
                        <input type="radio" name="gender" value="M" checked>
                        <span>남자</span>
                    </label>
                    <label>
                        <input type="radio" name="gender" value="F">
                        <span>여자</span>
                    </label>
                </div>
            </div>
            
            <!-- 연락처 -->
            <div class="form-group">
                <label for="email">이메일 <span class="required">*</span></label>
                <input type="email" id="email" name="email" placeholder="example@email.com" required>
            </div>
            
            <div class="form-group">
                <label for="mobileCarrier">통신사</label>
                <select id="mobileCarrier" name="mobileCarrier">
                    <option value="SKT">SKT</option>
                    <option value="KT">KT</option>
                    <option value="LG U+">LG U+</option>
                    <option value="SKT 알뜰폰">SKT 알뜰폰</option>
                    <option value="KT 알뜰폰">KT 알뜰폰</option>
                    <option value="LG U+ 알뜰폰">LG U+ 알뜰폰</option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="tel">휴대전화 <span class="required">*</span></label>
                <input type="tel" id="tel" name="tel" placeholder="'-' 없이 숫자만 입력" required>
            </div>
            
            <!-- 주소 -->
            <div class="form-group">
                <label>주소 <span class="required">*</span></label>
                <div class="input-group" style="margin-bottom: 10px;">
                    <input type="text" id="zip" name="zip" placeholder="우편번호" readonly required>
                    <button type="button" onclick="execDaumPostcode()">주소 검색</button>
                </div>
                <input type="text" id="addr1" name="addr1" placeholder="기본 주소" readonly required style="margin-bottom: 10px;">
                <input type="text" id="addr2" name="addr2" placeholder="상세 주소 입력" required maxlength="50">
            </div>
            
            <button type="submit" class="submit-btn">회원가입 완료</button>
        </form>
    </div>

<script>
    // 중복확인 했는지 체크하는 변수
    var isIdChecked = false;
    
    // 아이디 중복확인 함수
    function checkId(){
        const userId = document.getElementById('userId').value;
        
        if(userId.length < 4){
            alert('아이디는 4자 이상 입력해주세요.');
            return;
        }
        
        // AJAX로 중복 확인
        const xhr = new XMLHttpRequest();
        xhr.open('GET', 'checkId.jsp?userId=' + userId, true);
        
        xhr.onreadystatechange = function() {
            if(xhr.readyState == 4 && xhr.status == 200) {
                if(xhr.responseText.trim() === 'Y') {
                    alert('사용 가능한 아이디입니다!');
                    isIdChecked = true;
                } else {
                    alert('이미 사용중인 아이디입니다.');
                    isIdChecked = false;
                    document.getElementById('userId').value = '';
                    document.getElementById('userId').focus();
                }
            }
        };
        
        xhr.send();
    }
    
    // 아이디 입력칸이 바뀌면 다시 체크하도록
    document.getElementById('userId').addEventListener('change', function() {
        isIdChecked = false;
    });

    // 폼 제출 전 유효성 검사
    function validateForm(){
        // 아이디 중복확인 했는지 체크
        if(!isIdChecked) {
            alert('아이디 중복확인을 해주세요!');
            return false;
        }
        
        const pwd = document.getElementById('userPwd').value;
        const pwdCheck = document.getElementById('userPwdCheck').value;

        if(pwd.length < 8) {
            alert('비밀번호는 8자 이상 입력해주세요.');
            return false;
        }

        if(pwd !== pwdCheck){
            alert('비밀번호가 일치하지 않습니다.');
            document.getElementById('userPwd').value = '';
            document.getElementById('userPwdCheck').value = '';
            document.getElementById('userPwd').focus();
            return false;
        }
        
        // 생년월일이 8자리 숫자인지 확인
        const birthdate = document.getElementById('birthdate').value;
        if(birthdate.length !== 8 || isNaN(birthdate)){
            alert('생년월일을 8자리 숫자로 정확히 입력해주세요.');
            return false;
        }

        return true;
    }
    
    // 다음 주소검색
    function execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                document.getElementById('zip').value = data.zonecode;
                document.getElementById('addr1').value = data.roadAddress;
                document.getElementById('addr2').focus();
            }
        }).open();
    }
</script>

</body>
</html>