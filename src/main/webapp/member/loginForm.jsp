<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Art Auction - 로그인</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;700&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">

<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/layout.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/login.css">
</head>
<body>
    <%-- 페이지 전체를 감싸는 wrapper를 추가하여 구조를 명확히 합니다. --%>
    <div class="page-wrapper">
        <jsp:include page="/layout/header/header.jsp" />
    
        <main class="login-wrapper">
            <div class="login-container">
                <div class="logo">Art Auction</div>
                <form action="<%= request.getContextPath() %>/member/loginAction.jsp" method="post">
                    <div class="form-group">
                        <input type="text" id="userId" name="userId" placeholder="아이디" required>
                    </div>
                    <div class="form-group">
                        <input type="password" id="userPwd" name="userPwd" placeholder="비밀번호" required>
                    </div>
                    <button type="submit" class="submit-btn">로그인</button>
                </form>
                <div class="links">
                    <a href="enroll_step1.jsp">회원가입</a>
<<<<<<< HEAD
                    <a href="findIdPwForm.jsp">아이디/비밀번호 찾기</a>
=======
                    <a href="#">아이디/비밀번호 찾기</a>
>>>>>>> 692b283f4bff172ab4f6a2f39dca655088613fa8
                </div>
            </div>
        </main>
    </div>
</body>
</html>