<%--
  File: WebContent/mypage/chargeForm.jsp
  역할: 사용자가 마일리지를 충전할 금액을 입력하는 페이지입니다.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.auction.vo.MemberDTO" %>
<%
    // 로그인한 사용자만 이 페이지에 접근할 수 있도록 확인합니다.
    MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");

    if(loginUser == null){
        // 로그인이 안되어있으면 로그인 페이지로 보냅니다.
        response.sendRedirect(request.getContextPath() + "/member/loginForm.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Art Auction - 마일리지 충전</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;700&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">
<style>
    body { 
        margin: 0; 
        background-color: #f4f4f4; 
        color: #333; 
        font-family: 'Noto Sans KR', sans-serif; 
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
    }
    .container {
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
    .charge-form input {
        width: 100%;
        padding: 15px;
        font-size: 18px;
        text-align: center;
        border: 1px solid #ccc;
        border-radius: 5px;
        box-sizing: border-box;
        margin-bottom: 20px;
    }
    .charge-btn {
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
    .charge-btn:hover {
        background-color: #c8a02a;
    }
</style>
</head>
<body>
    <div class="container">
        <h1>마일리지 충전</h1>
        <form action="chargeMileage.jsp" method="post" class="charge-form">
            <input type="number" name="amount" min="1000" step="1000" placeholder="충전할 금액" required>
            <button type="submit" class="charge-btn">충전하기</button>
        </form>
    </div>
</body>
</html>
