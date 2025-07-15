<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.auction.dto.MemberDTO" %>
<%
    // 로그인한 사용자만 접근 가능
    MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");
    if(loginUser == null){
        response.sendRedirect(request.getContextPath() + "/member/loginForm.jsp");
        return;
    }
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Art Auction - 비밀번호 변경</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;700&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%=ctx%>/resources/css/luxury-global-style.css">
<link rel="stylesheet" href="<%= ctx %>/resources/css/layout.css" />
<style>
body { margin: 0; background-color: #f4f4f4; color: #333; font-family: 'Noto Sans KR', sans-serif; }
.pwd-main {
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: calc(100vh - 200px);
    padding: 40px 0;
}
.pwd-container {
    width: 500px;
    padding: 40px;
    background-color: #fff;
    border: 1px solid #ddd;
    border-radius: 10px;
    text-align: center;
    box-shadow: 0 5px 15px rgba(0,0,0,0.1);
}
h1 {
    font-family: 'Playfair Display', serif;
    font-size: 32px;
    color: #1a1a1a;
    margin-top: 0;
    margin-bottom: 30px;
}
.pwd-form input {
    width: 100%;
    padding: 15px;
    font-size: 18px;
    text-align: center;
    border: 1px solid #ccc;
    border-radius: 5px;
    box-sizing: border-box;
    margin-bottom: 20px;
}
.pwd-btn {
    width: 100%;
    padding: 15px;
    font-size: 20px;
    font-weight: bold;
    color: #fff;
    background-color: #d4af37;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    transition: background-color 0.3s;
}
.pwd-btn:hover { background-color: #c8a02a; }
.info-box {
    background: #f8f6f1;
    border: 1px solid #e5dfc8;
    border-radius: 8px;
    margin: 25px 0 15px 0;
    padding: 20px;
    text-align: left;
}
.info-box h4 { color: #c8a02a; font-size: 18px; margin-bottom: 10px; }
.info-box ul { margin: 0; padding-left: 16px; }
.info-box li { font-size: 15px; margin-bottom: 4px; }
.back-link {
    display: inline-block; margin-top: 20px;
    color: #888; text-decoration: none;
}
.back-link i { margin-right: 4px; }
</style>
</head>
<body>
<jsp:include page="/layout/header/luxury-header.jsp" />

<div class="pwd-main">
    <div class="pwd-container">
        <h1>비밀번호 변경</h1>
        <form action="changePwdAction.jsp" method="post" class="pwd-form" onsubmit="return validatePwd();">
            <div class="form-group">
                <label for="currentPwd">현재 비밀번호</label>
                <input type="password" id="currentPwd" name="currentPwd" required>
            </div>
            <div class="form-group">
                <label for="newPwd">새 비밀번호</label>
                <input type="password" id="newPwd" name="newPwd" required onkeyup="checkPasswordStrength()">
                <div class="password-strength">
                    <div class="strength-bar" id="strengthBar" style="height: 6px; background: #e5e5e5; border-radius: 3px; margin-top:6px;"></div>
                </div>
                <p class="strength-text" id="strengthText" style="margin:0; font-size:13px; text-align:left"></p>
            </div>
            <div class="form-group">
                <label for="newPwdCheck">새 비밀번호 확인</label>
                <input type="password" id="newPwdCheck" name="newPwdCheck" required>
            </div>
            <div class="info-box">
                <h4>안전한 비밀번호 만들기</h4>
                <ul>
                    <li>최소 8자 이상 입력해주세요</li>
                    <li>영문 대/소문자를 혼합하여 사용하세요</li>
                    <li>숫자와 특수문자를 포함하세요</li>
                    <li>개인정보와 관련된 단어는 피하세요</li>
                </ul>
            </div>
            <button type="submit" class="pwd-btn">변경하기</button>
            <a href="myPage.jsp" class="back-link"><i class="fas fa-arrow-left"></i> 마이페이지로 돌아가기</a>
        </form>
    </div>
</div>

<jsp:include page="/layout/footer/luxury-footer.jsp" />
<!-- Font Awesome 아이콘 사용 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" crossorigin="anonymous" />
<script>
function checkPasswordStrength() {
    const password = document.getElementById('newPwd').value;
    const strengthBar = document.getElementById('strengthBar');
    const strengthText = document.getElementById('strengthText');
    let strength = 0;
    if (password.length >= 8) strength++;
    if (password.length >= 12) strength++;
    if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength++;
    if (/\d/.test(password)) strength++;
    if (/[!@#$%^&*(),.?":{}|<>]/.test(password)) strength++;

    // 시각적 표시
    strengthBar.style.width = (strength * 20) + '%';
    if (strength <= 2) {
        strengthBar.style.background = '#e74c3c';
        strengthText.textContent = '약함';
        strengthText.style.color = '#e74c3c';
    } else if (strength <= 4) {
        strengthBar.style.background = '#f39c12';
        strengthText.textContent = '보통';
        strengthText.style.color = '#f39c12';
    } else {
        strengthBar.style.background = '#27ae60';
        strengthText.textContent = '강함';
        strengthText.style.color = '#27ae60';
    }
}

function validatePwd() {
    const currentPwd = document.getElementById('currentPwd').value;
    const newPwd = document.getElementById('newPwd').value;
    const newPwdCheck = document.getElementById('newPwdCheck').value;

    if (newPwd.length < 8) {
        alert('새 비밀번호는 8자 이상 입력해주세요.');
        return false;
    }
    if (currentPwd === newPwd) {
        alert('현재 비밀번호와 새 비밀번호가 동일합니다.');
        return false;
    }
    if (newPwd !== newPwdCheck) {
        alert('새 비밀번호가 일치하지 않습니다.');
        document.getElementById('newPwd').value = '';
        document.getElementById('newPwdCheck').value = '';
        document.getElementById('newPwd').focus();
        return false;
    }
    return confirm('비밀번호를 변경하시겠습니까?');
}
</script>
</body>
</html>