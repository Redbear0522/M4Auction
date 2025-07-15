<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>아이디/비밀번호 찾기 - M4 Auction</title>
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700;900&family=Poppins:wght@300;400;500;600;700&family=Noto+Sans+KR:wght@300;400;500;700;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/luxury-global-style.css">

<style>
    /* 헤더 겹침 해결 */
    body {
        padding-top: 120px !important;
        background: #f8f8f8;
        font-family: 'Noto Sans KR', sans-serif;
    }
    
    .find-container {
        max-width: 600px;
        margin: 50px auto;
        padding: 60px;
        background-color: white;
        box-shadow: 0 0 20px rgba(0,0,0,0.05);
    }
    
    h1 {
        font-family: 'Playfair Display', serif;
        text-align: center;
        font-size: 36px;
        color: #1a1a1a;
        margin-bottom: 50px;
    }
    
    .tab-buttons {
        display: flex;
        margin-bottom: 40px;
        border-bottom: 2px solid #f0f0f0;
    }
    
    .tab-button {
        flex: 1;
        padding: 20px;
        background: none;
        border: none;
        color: #999;
        font-size: 16px;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.3s;
        position: relative;
    }
    
    .tab-button:hover {
        color: #1a1a1a;
    }
    
    .tab-button.active {
        color: #1a1a1a;
    }
    
    .tab-button.active::after {
        content: '';
        position: absolute;
        bottom: -2px;
        left: 0;
        right: 0;
        height: 2px;
        background: #c9961a;
    }
    
    .tab-content {
        display: none;
    }
    
    .tab-content.active {
        display: block;
    }
    
    .form-group {
        margin-bottom: 25px;
    }
    
    .form-group label {
        display: block;
        margin-bottom: 10px;
        color: #333;
        font-weight: 600;
        font-size: 14px;
        letter-spacing: 0.5px;
    }
    
    .form-group input {
    width: 100%;
    padding: 15px;
    background-color: #f8f8f8;  /* 좀 더 진한 회색 */
    border: 1px solid #ddd;      /* 테두리도 좀 더 진하게 */
    color: #333;
    font-size: 16px;
    transition: all 0.3s;
}

	.form-group input:focus {
    outline: none;
    border-color: #c9961a;
    background: #fff;  /* 포커스 시에만 흰색 */
    box-shadow: 0 0 0 3px rgba(201, 150, 26, 0.1);  /* 포커스 효과 추가 */
	}

	/* placeholder 색상도 진하게 */
	.form-group input::placeholder {
    color: #999;
	}
    
    .submit-btn {
        width: 100%;
        padding: 18px;
        background-color: #1a1a1a;
        color: white;
        border: none;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
        margin-top: 30px;
        text-transform: uppercase;
        letter-spacing: 1px;
        transition: all 0.3s;
    }
    
    .submit-btn:hover {
        background-color: #c9961a;
    }
    
    .back-link {
        display: block;
        text-align: center;
        margin-top: 30px;
        color: #999;
        font-size: 14px;
        text-decoration: none;
        transition: all 0.3s;
    }
    
    .back-link:hover {
        color: #c9961a;
    }
    
    .result-box {
        margin-top: 30px;
        padding: 25px;
        background-color: #fafafa;
        border-radius: 8px;
        text-align: center;
        display: none;
        font-size: 15px;
    }
    
    .result-box.success {
        border: 2px solid #27ae60;
        background: #f0fdf4;
        color: #1a1a1a;
    }
    
    .result-box.error {
        border: 2px solid #e74c3c;
        background: #fef2f2;
        color: #1a1a1a;
    }
    
    .result-box strong {
        color: #c9961a;
        font-size: 18px;
    }
    
    /* 정보 안내 박스 */
    .info-box {
        background: #faf8f4;
        border-left: 4px solid #c9961a;
        padding: 20px;
        margin-bottom: 30px;
        font-size: 14px;
        color: #666;
    }
    
    .info-box i {
        color: #c9961a;
        margin-right: 8px;
    }
</style>
</head>
<body>
<jsp:include page="/layout/header/luxury-header.jsp" />

<div class="find-container">
    <h1>아이디/비밀번호 찾기</h1>
    
    <div class="tab-buttons">
        <button class="tab-button active" onclick="showTab('findId')">아이디 찾기</button>
        <button class="tab-button" onclick="showTab('findPw')">비밀번호 찾기</button>
    </div>
    
    <!-- 아이디 찾기 -->
    <div id="findId" class="tab-content active">
        <div class="info-box">
            <i class="fas fa-info-circle"></i>
            가입 시 등록한 이름과 이메일을 입력해주세요.
        </div>
        
        <form onsubmit="findId(event)">
            <div class="form-group">
                <label for="nameForId">이름</label>
                <input type="text" id="nameForId" required>
            </div>
            <div class="form-group">
                <label for="emailForId">이메일</label>
                <input type="email" id="emailForId" required>
            </div>
            <button type="submit" class="submit-btn">아이디 찾기</button>
        </form>
        <div id="idResult" class="result-box"></div>
    </div>
    
    <!-- 비밀번호 찾기 -->
    <div id="findPw" class="tab-content">
        <div class="info-box">
            <i class="fas fa-info-circle"></i>
            임시 비밀번호가 가입하신 이메일로 발송됩니다.
        </div>
        
        <form onsubmit="findPw(event)">
            <div class="form-group">
                <label for="idForPw">아이디</label>
                <input type="text" id="idForPw" required>
            </div>
            <div class="form-group">
                <label for="nameForPw">이름</label>
                <input type="text" id="nameForPw" required>
            </div>
            <div class="form-group">
                <label for="emailForPw">이메일</label>
                <input type="email" id="emailForPw" required>
            </div>
            <button type="submit" class="submit-btn">비밀번호 재설정</button>
        </form>
        <div id="pwResult" class="result-box"></div>
    </div>
    
    <a href="luxury-login.jsp" class="back-link">
        <i class="fas fa-arrow-left"></i> 로그인 페이지로 돌아가기
    </a>
</div>

<jsp:include page="/layout/footer/luxury-footer.jsp" />

<script>
function showTab(tabName) {
    // 모든 탭 숨기기
    document.querySelectorAll('.tab-content').forEach(tab => {
        tab.classList.remove('active');
    });
    document.querySelectorAll('.tab-button').forEach(btn => {
        btn.classList.remove('active');
    });
    
    // 선택한 탭 보이기
    document.getElementById(tabName).classList.add('active');
    event.target.classList.add('active');
}

function findId(event) {
    event.preventDefault();
    
    const name = document.getElementById('nameForId').value;
    const email = document.getElementById('emailForId').value;
    
    // AJAX로 아이디 찾기
    const xhr = new XMLHttpRequest();
    xhr.open('POST', 'findIdAction.jsp', true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    
    xhr.onreadystatechange = function() {
        if(xhr.readyState == 4 && xhr.status == 200) {
            const result = xhr.responseText.trim();
            const resultBox = document.getElementById('idResult');
            
            if(result !== 'N') {
                resultBox.className = 'result-box success';
                resultBox.innerHTML = '<i class="fas fa-check-circle" style="color: #27ae60; font-size: 48px; margin-bottom: 20px;"></i><br>찾은 아이디: <strong>' + result + '</strong>';
            } else {
                resultBox.className = 'result-box error';
                resultBox.innerHTML = '<i class="fas fa-times-circle" style="color: #e74c3c; font-size: 48px; margin-bottom: 20px;"></i><br>일치하는 회원 정보를 찾을 수 없습니다.';
            }
            resultBox.style.display = 'block';
        }
    };
    
    xhr.send('name=' + encodeURIComponent(name) + '&email=' + encodeURIComponent(email));
}

function findPw(event) {
    event.preventDefault();
    
    const id = document.getElementById('idForPw').value;
    const name = document.getElementById('nameForPw').value;
    const email = document.getElementById('emailForPw').value;
    
    // AJAX로 비밀번호 찾기
    const xhr = new XMLHttpRequest();
    xhr.open('POST', 'findPwAction.jsp', true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    
    xhr.onreadystatechange = function() {
        if(xhr.readyState == 4 && xhr.status == 200) {
            const result = xhr.responseText.trim();
            const resultBox = document.getElementById('pwResult');
            
            if(result === 'Y') {
                resultBox.className = 'result-box success';
                resultBox.innerHTML = '<i class="fas fa-envelope" style="color: #27ae60; font-size: 48px; margin-bottom: 20px;"></i><br>임시 비밀번호가 이메일로 발송되었습니다.<br>로그인 후 비밀번호를 변경해주세요.';
            } else {
                resultBox.className = 'result-box error';
                resultBox.innerHTML = '<i class="fas fa-times-circle" style="color: #e74c3c; font-size: 48px; margin-bottom: 20px;"></i><br>일치하는 회원 정보를 찾을 수 없습니다.';
            }
            resultBox.style.display = 'block';
        }
    };
    
    xhr.send('id=' + encodeURIComponent(id) + '&name=' + encodeURIComponent(name) + '&email=' + encodeURIComponent(email));
}
</script>

</body>
</html>