<%--
  File: WebContent/product/productEnrollForm.jsp
  역할: 판매자가 경매에 올릴 상품 정보를 입력하고, 이미지를 업로드하는 폼을 제공합니다. (다크 테마 적용)
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.auction.vo.MemberDTO" %>
<%
    MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");
    if(loginUser == null){
        session.setAttribute("alertMsg", "로그인 후 이용 가능한 서비스입니다.");
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Art Auction - 상품 등록</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;700&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">
<style>
    /* ======== 수정된 부분! 메인 페이지와 동일한 다크 테마 적용 ======== */
    body { margin: 0; background-color: #1a1a1a; color: #e0e0e0; font-family: 'Noto Sans KR', sans-serif; }
    a { text-decoration: none; color: inherit; }
    .header { display: flex; justify-content: space-between; align-items: center; padding: 20px 50px; background-color: rgba(0,0,0,0.3); border-bottom: 1px solid #333; }
    .header .logo { font-family: 'Playfair Display', serif; font-size: 28px; color: #d4af37; }
    .header .nav a { margin-left: 25px; font-size: 16px; transition: color 0.3s; }
    .header .nav a:hover { color: #d4af37; }
    .footer { text-align: center; padding: 40px; margin-top: 50px; background-color: #000; color: #777; font-size: 14px; }

    /* 상품 등록 폼 컨테이너 */
    .enroll-form-container {
        max-width: 800px;
        margin: 50px auto;
        padding: 40px;
        background-color: #2b2b2b;
        border-radius: 10px;
    }
    .enroll-form-container h1 {
        font-family: 'Playfair Display', serif;
        text-align: center;
        font-size: 36px;
        color: #fff;
        margin-bottom: 40px;
    }
    .form-group {
        margin-bottom: 25px;
    }
    .form-group label {
        display: block;
        font-size: 16px;
        font-weight:bold;
        margin-bottom: 8px;
        color: #ccc;
    }
    .form-group input[type="text"],
    .form-group input[type="number"],
    .form-group input[type="datetime-local"],
    .form-group textarea,
    .form-group select {
        width: 100%;
        padding: 12px;
        font-size: 16px;
        background-color: #1a1a1a;
        border: 1px solid #555;
        color: #fff;
        border-radius: 5px;
        box-sizing: border-box;
    }
    .form-group textarea {
        height: 150px;
        resize: vertical;
    }
    .form-group input[type="file"] {
        padding: 10px;
        background-color: #1a1a1a;
        border: 1px solid #555;
        border-radius: 5px;
    }
    .submit-btn {
        display: block;
        width: 100%;
        padding: 15px;
        font-size: 20px;
        font-weight: bold;
        color: #1a1a1a;
        background-color: #d4af37;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        transition: background-color 0.3s;
        margin-top: 40px;
    }
    .submit-btn:hover {
        background-color: #e6c567;
    }
</style>
</head>
<body>

    <!-- 헤더 -->
    <header class="header">
        <div class="logo"><a href="<%= request.getContextPath() %>/index.jsp">Art Auction</a></div>
        <nav class="nav">
            <span><%= loginUser.getMemberName() %>님 환영합니다.</span>
            <a href="<%= request.getContextPath() %>/product/productEnrollForm.jsp">상품등록</a>
            <a href="<%= request.getContextPath() %>/mypage/myPage.jsp">마이페이지</a>
            <a href="<%= request.getContextPath() %>/member/logout.jsp">로그아웃</a>
        </nav>
    </header>

    <div class="enroll-form-container">
        <h1>경매 상품 등록</h1>
        
        <form action="productEnrollAction.jsp" method="post" enctype="multipart/form-data">
            <div class="form-group">
                <label for="productName">작품명</label>
                <input type="text" id="productName" name="productName" required>
            </div>
            <div class="form-group">
                <label for="artistName">작가명</label>
                <input type="text" id="artistName" name="artistName" required>
            </div>
            <div class="form-group">
                <label for="startPrice">경매 시작가 (원)</label>
                <input type="number" id="startPrice" name="startPrice" min="1000" step="1000" required>
            </div>
            <div class="form-group">
                <label for="buyNowPrice">즉시 구매가 (원) - 선택사항</label>
                <input type="number" id="buyNowPrice" name="buyNowPrice" min="1000" step="1000" placeholder="미입력 시 즉시 구매 불가">
            </div>
            <div class="form-group">
                <label for="endTime">경매 마감일</label>
                <input type="datetime-local" id="endTime" name="endTime" required>
            </div>
            <div class="form-group">
                <label for="category">카테고리</label>
                <select name="category" id="category" required>
                    <option value="" disabled selected>-- 카테고리를 선택하세요 --</option>
                    <option value="서양화">서양화</option>
                    <option value="동양화">동양화</option>
                    <option value="조각">조각</option>
                    <option value="판화">판화</option>
                    <option value="사진">사진</option>
                    <option value="고미술">고미술</option>
                </select>
            </div>
            <div class="form-group">
                <label for="productImage">작품 이미지</label>
                <input type="file" id="productImage" name="productImage" accept="image/*" required>
            </div>
            <div class="form-group">
                <label for="productDesc">작품 상세 설명</label>
                <textarea id="productDesc" name="productDesc" required></textarea>
            </div>
            <button type="submit" class="submit-btn">상품 등록하기</button>
        </form>
    </div>

    <!-- 푸터 -->
    <footer class="footer">
        <p>&copy; 2025 Art Auction. All Rights Reserved.</p>
    </footer>

</body>
</html>
