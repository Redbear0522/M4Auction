<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.auction.vo.MemberDTO" %>
<%
    MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");
    // alertMsg는 이제 각 페이지에서 처리하므로 여기서는 제거합니다.
%>
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/layout.css">
<header class="header">
    <div class="logo">
        <a href="<%= request.getContextPath() %>/index.jsp">Art Auction</a>
    </div>
    <nav class="nav">
        <% if(loginUser == null) { %>
            <a href="<%= request.getContextPath() %>/member/loginForm.jsp">로그인</a>
            <a href="<%= request.getContextPath() %>/member/enroll_step1.jsp">회원가입</a>
        <% } else if ("admin".equals(loginUser.getMemberId())) { %>
            <span><%= loginUser.getMemberName() %>님(관리자) 환영합니다.</span>
            <a href="<%= request.getContextPath() %>/admin/adminPage.jsp">관리자 페이지</a>
            <a href="<%= request.getContextPath() %>/member/logout.jsp">로그아웃</a>
        <% } else { %>
            <span><%= loginUser.getMemberName() %>님 환영합니다.</span>
            <a href="<%= request.getContextPath() %>/mypage/myPage.jsp">마이페이지</a>
            <a href="<%= request.getContextPath() %>/member/logout.jsp">로그아웃</a>
            <a href="<%= request.getContextPath() %>/product/productEnrollForm.jsp">상품등록</a>
        <% } %>
        	<a href="<%= request.getContextPath() %>/bid/bid.jsp">경매장</a>
        	<a href="<%= request.getContextPath() %>/bid/lastBid.jsp">최근낙찰</a>
        	<a href="<%= request.getContextPath() %>/bid/favoriteBid.jsp">인기경매</a>
    </nav>
</header>