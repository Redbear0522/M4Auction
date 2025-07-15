<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.auction.dto.MemberDTO" %>
<%
    MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");
    if(loginUser == null){
        response.sendRedirect(request.getContextPath() + "/member/luxury-login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원정보 수정 - M4 Auction</title>

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
    
    .update-wrapper {
        max-width: 700px;
        margin: 50px auto;
        background: white;
        padding: 60px;
        box-shadow: 0 0 20px rgba(0,0,0,0.05);
    }
    
    .page-title {
        font-family: 'Playfair Display', serif;
        font-size: 36px;
        text-align: center;
        color: #1a1a1a;
        margin-bottom: 50px;
    }
    
    .form-group {
        margin-bottom: 30px;
    }
    
    .form-group label {
        display: block;
        font-size: 14px;
        font-weight: 600;
        color: #333;
        margin-bottom: 10px;
        letter-spacing: 0.5px;
    }
    
    .form-group input[type="text"],
    .form-group input[type="email"],
    .form-group input[type="tel"] {
        width: 100%;
        padding: 15px;
        font-size: 16px;
        border: 1px solid #e5e5e5;
        transition: all 0.3s;
        background: #fafafa;
    }
    
    .form-group input:focus {
        outline: none;
        border-color: #c9961a;
        background: white;
    }
    
    .form-group input[readonly] {
        background: #f0f0f0;
        color: #999;
        cursor: not-allowed;
    }
    
    .info-text {
        font-size: 13px;
        color: #999;
        margin-top: 5px;
    }
    
    .btn-group {
        display: flex;
        gap: 10px;
        margin-top: 50px;
    }
    
    .btn {
        flex: 1;
        padding: 18px;
        font-size: 16px;
        font-weight: 600;
        letter-spacing: 0.5px;
        text-transform: uppercase;
        border: none;
        cursor: pointer;
        transition: all 0.3s;
    }
    
    .btn-primary {
        background: #1a1a1a;
        color: white;
    }
    
    .btn-primary:hover {
        background: #c9961a;
    }
    
    .btn-secondary {
        background: white;
        color: #1a1a1a;
        border: 2px solid #e5e5e5;
    }
    
    .btn-secondary:hover {
        border-color: #1a1a1a;
    }
    
    /* 주소 입력 부분 - 수정됨! */
    .address-group {
        margin-bottom: 30px;
    }
    
    .address-group label {
        display: block;
        font-size: 14px;
        font-weight: 600;
        color: #333;
        margin-bottom: 10px;
        letter-spacing: 0.5px;
    }
    
    .input-with-button {
        display: flex;
        gap: 10px;
        margin-bottom: 10px;
    }
    
    #zip {
        width: 150px !important;
        padding: 15px;
        font-size: 16px;
        border: 1px solid #e5e5e5;
        background: #f0f0f0;
    }
    
    #addr1, #addr2 {
        width: 100%;
        padding: 15px;
        font-size: 16px;
        border: 1px solid #e5e5e5;
        background: #fafafa;
        margin-bottom: 10px;
    }
    
    #addr1 {
        background: #f0f0f0;
    }
    
    #addr2:focus {
        outline: none;
        border-color: #c9961a;
        background: white;
    }
    
    .input-with-button button {
        padding: 0 30px;
        background: #1a1a1a;
        color: white;
        border: none;
        cursor: pointer;
        font-weight: 600;
        transition: all 0.3s;
        white-space: nowrap;
    }
    
    .input-with-button button:hover {
        background: #c9961a;
    }
</style>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</head>
<body>
    <jsp:include page="/layout/header/luxury-header.jsp" />
    
    <div class="update-wrapper">
        <h1 class="page-title">회원정보 수정</h1>
        
        <form action="updateMember.jsp" method="post" onsubmit="return validateForm();">
            <div class="form-group">
                <label>아이디</label>
                <input type="text" value="<%= loginUser.getMemberId() %>" readonly>
                <p class="info-text">아이디는 변경할 수 없습니다.</p>
            </div>
            
            <div class="form-group">
                <label for="updateName">이름 *</label>
                <input type="text" id="updateName" name="updateName" value="<%= loginUser.getMemberName() %>" required>
            </div>
            
            <div class="form-group">
                <label for="updateEmail">이메일 *</label>
                <input type="email" id="updateEmail" name="updateEmail" value="<%= loginUser.getEmail() %>" required>
            </div>
            
            <div class="form-group">
                <label for="updateTel">휴대전화 *</label>
                <input type="tel" id="updateTel" name="updateTel" value="<%= loginUser.getTel() %>" placeholder="'-' 없이 숫자만 입력" required>
            </div>
            
            <!-- 주소 추가 -->
            <div class="address-group">
                <label>주소</label>
                <div class="input-with-button">
                    <input type="text" id="zip" name="updateZip" 
                           value="<%= loginUser.getZip() != null ? loginUser.getZip() : "" %>" 
                           placeholder="우편번호" readonly>
                    <button type="button" onclick="execDaumPostcode()">주소 검색</button>
                </div>
                <input type="text" id="addr1" name="updateAddr1" 
                       value="<%= loginUser.getAddr1() != null ? loginUser.getAddr1() : "" %>" 
                       placeholder="기본 주소" readonly>
                <input type="text" id="addr2" name="updateAddr2" 
                       value="<%= loginUser.getAddr2() != null ? loginUser.getAddr2() : "" %>" 
                       placeholder="상세 주소">
            </div>
            
            <div class="form-group">
                <label>생년월일</label>
                <input type="text" value="<%= loginUser.getBirthdate() %>" readonly>
                <p class="info-text">생년월일은 변경할 수 없습니다.</p>
            </div>
            
            <div class="form-group">
                <label>성별</label>
                <input type="text" value="<%= loginUser.getGender().equals("M") ? "남성" : "여성" %>" readonly>
                <p class="info-text">성별은 변경할 수 없습니다.</p>
            </div>
            
            <div class="form-group">
                <label>회원 유형</label>
                <input type="text" value="<%= loginUser.getMemberType() == 2 ? "VIP 회원" : "일반 회원" %>" readonly>
            </div>
            
            <div class="btn-group">
                <button type="submit" class="btn btn-primary">정보 수정</button>
                <button type="button" class="btn btn-secondary" onclick="location.href='myPage.jsp'">취소</button>
            </div>
        </form>
    </div>
    
    <jsp:include page="/layout/footer/luxury-footer.jsp" />
    
    <script>
        function validateForm() {
            const tel = document.getElementById('updateTel').value;
            
            // 전화번호 숫자만 입력했는지 확인
            if(isNaN(tel)) {
                alert('전화번호는 숫자만 입력해주세요.');
                return false;
            }
            
            return confirm('회원정보를 수정하시겠습니까?');
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