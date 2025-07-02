<%--
  File: WebContent/member/enroll_step2.jsp
  역할: 회원가입 절차의 2단계, 상세 개인정보를 입력받는 페이지입니다.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Art Auction - 회원가입 (정보 입력)</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;700&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/layout.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/enroll.css">
<style>
    body { margin: 0; background-color: #f4f4f4; color: #333; font-family: 'Noto Sans KR', sans-serif; }
    a { text-decoration: none; color: inherit; }
    .container {
        width: 700px;
        margin: 50px auto;
        padding: 40px;
        background-color: #fff;
        border: 1px solid #ddd;
        border-radius: 10px;
    }
    h1 {
        font-family: 'Playfair Display', serif;
        text-align: center;
        font-size: 36px;
        color: #1a1a1a;
        margin-bottom: 40px;
    }
    .form-group {
        margin-bottom: 20px;
    }
    .form-group label {
        display: block;
        font-size: 14px;
        font-weight: bold;
        margin-bottom: 8px;
        color: #555;
    }
    .form-group input[type="text"],
    .form-group input[type="password"],
    .form-group input[type="email"],
    .form-group input[type="tel"],
    .form-group select {
        width: 100%;
        padding: 12px;
        font-size: 16px;
        border: 1px solid #ccc;
        border-radius: 5px;
        box-sizing: border-box;
    }
    .input-with-button {
        display: flex;
        gap: 10px;
    }
    .input-with-button input {
        flex-grow: 1;
    }
    .input-with-button button {
        padding: 0 20px;
        border: 1px solid #555;
        background: #555;
        color: white;
        border-radius: 5px;
        cursor: pointer;
<<<<<<< HEAD
        white-space: nowrap;
=======
        white-space: nowrap; /* 버튼 글자 줄바꿈 방지 */
>>>>>>> 692b283f4bff172ab4f6a2f39dca655088613fa8
    }
    .gender-group label {
        margin-right: 20px;
    }
    .submit-btn {
        display: block;
        width: 100%;
        padding: 15px;
        font-size: 20px;
        font-weight: bold;
        color: #fff;
        background-color: #1a1a1a;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        transition: background-color 0.3s;
        margin-top: 40px;
    }
    .submit-btn:hover {
        background-color: #555;
    }
</style>
<!-- 다음 우편번호 서비스 -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</head>
<body>
<jsp:include page="/layout/header/header.jsp" />
    <div class="container">
        <h1>회원가입</h1>
        
        <form action="enrollAction_detail.jsp" method="post" onsubmit="return validateForm();">
        <input type="hidden" id="memberType" name="memberType"value="<%= request.getParameter("memberType") %>"> 
            <div class="form-group">
                <label for="userId">아이디</label>
                <div class="input-with-button">
                    <input type="text" id="userId" name="userId" required>
                    <button type="button" onclick="checkId()">중복확인</button>
                </div>
            </div>
            <div class="form-group">
                <label for="userPwd">비밀번호</label>
                <input type="password" id="userPwd" name="userPwd" required>
            </div>
            <div class="form-group">
                <label for="userPwdCheck">비밀번호 확인</label>
                <input type="password" id="userPwdCheck" required>
            </div>
            <div class="form-group">
                <label for="userName">이름</label>
                <input type="text" id="userName" name="userName" required>
            </div>
            <div class="form-group">
                <label for="birthdate">생년월일</label>
                <input type="text" id="birthdate" name="birthdate" placeholder="8자리 숫자로 입력 (예: 19920508)" maxlength="8" required>
            </div>
            <div class="form-group gender-group">
                <label>성별</label>
                <input type="radio" id="gender_m" name="gender" value="M" checked> 남자  
                <input type="radio" id="gender_f" name="gender" value="F"> 여자  
            </div>
             <div class="form-group">
                <label for="email">이메일</label>
                <input type="email" id="email" name="email" required>
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
                <label for="tel">휴대전화</label>
                <input type="tel" id="tel" name="tel" placeholder="'-' 없이 숫자만 입력" required>
            </div>
            <!-- 주소 -->
		    <div class="form-group">
		      <label class="form-group">주소</label>
		      <div class="form-group">
		        <div class="form-group">
		          <input type="text" id="zip" name="zip" placeholder="우편번호" readonly class="form-group" required>
		          <button type="button" onclick="execDaumPostcode()" class="form-group">주소 검색</button>
		        </div>
		        <div class="form-group">
		          우편번호를 검색해주세요.
		        </div>
		        <input type="text" id="addr1" name="addr1" placeholder="기본 주소" readonly class="form-group" required>
		        <div class="form-group">
		          주소를 선택해주세요.
		        </div>
		        <input type="text" id="addr2" name="addr2" placeholder="상세 주소 입력" class="form-group" required maxlength="50">
		        <div class="form-group">
		          상세 주소를 입력해주세요.
		        </div>
		      </div>
		    </div>
            
            <button type="submit" class="submit-btn">가입하기</button>
        </form>
    </div>

    <script>
<<<<<<< HEAD
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
            
=======
        // 아이디 중복확인 (지금은 임시로 알림창만 띄웁니다)
        function checkId(){
            const userId = document.getElementById('userId').value;
            if(userId.length < 4){
                alert('아이디는 4자 이상 입력해주세요.');
            } else {
                // 나중에 이 부분에서 DB와 통신하여 실제 중복 여부를 확인하는 로직이 필요합니다.
                alert('사용 가능한 아이디입니다.');
            }
        }

        // 폼 제출 전 유효성 검사
        function validateForm(){
>>>>>>> 692b283f4bff172ab4f6a2f39dca655088613fa8
            const pwd = document.getElementById('userPwd').value;
            const pwdCheck = document.getElementById('userPwdCheck').value;

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
<<<<<<< HEAD
        
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
=======
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
>>>>>>> 692b283f4bff172ab4f6a2f39dca655088613fa8
