<%--   
  File: WebContent/index.jsp  
  역할: 페이징, 검색, 카테고리 기능이 적용된 최종 메인 페이지입니다. 
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.auction.vo.MemberDTO" %>
<%@ page import="com.auction.vo.ProductDTO" %>
<%@ page import="com.auction.dao.ProductDAO" %>
<%@ page import="com.auction.common.PageInfo" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %>
<%@ page import="com.auction.dao.ScheduleDAO" %>
<%@ page import="com.auction.vo.ScheduleDTO" %>

<%
    // 세션에서 로그인 유저 정보와 알림 메시지 받아오기
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    String alertMsg = (String) session.getAttribute("alertMsg");

    // 검색 키워드와 카테고리 초기화
    String keyword = request.getParameter("keyword");
    String category = request.getParameter("category");

    if (keyword == null) {
        keyword = "";
    }
    if (category == null) {
        category = "all";
    }

    // 페이징 관련 변수 초기화
    int listCount;

    // 현재 페이지 (기본값 1)
    int currentPage = 1;
    // 한번에 보여줄 페이지 번호 개수
    int pageLimit = 5;
    // 한 페이지에 보여줄 상품 개수
    int boardLimit = 8;

    // DB 연결 및 DAO 생성
    Connection conn = getConnection();
    ProductDAO pDao = new ProductDAO();
    ScheduleDAO sDAO = new ScheduleDAO();

    // 검색어 / 카테고리 조건에 따른 전체 상품 수 조회
    if (!keyword.equals("")) {
        listCount = pDao.searchProductCount(conn, keyword);
    } else if (!category.equals("all")) {
        listCount = pDao.selectProductCountByCategory(conn, category);
    } else {
        listCount = pDao.selectProductCount(conn);
    }

    // 현재 페이지 파라미터 처리
    if (request.getParameter("page") != null) {
        currentPage = Integer.parseInt(request.getParameter("page"));
    }

    // 페이지 정보 객체 생성 (총 상품 수, 현재 페이지, 페이지 번호 개수, 페이지당 상품 개수)
    PageInfo pi = new PageInfo(listCount, currentPage, pageLimit, boardLimit);

    // 조건에 맞는 상품 리스트 조회
    List<ProductDTO> productList;
    if (!keyword.equals("")) {
        productList = pDao.searchProductList(conn, keyword, pi);
    } else if (!category.equals("all")) {
        productList = pDao.selectProductListByCategory(conn, category, pi);
    } else {
        productList = pDao.selectProductList(conn, pi);
    }

    // 경매 일정 전체 조회
    List<ScheduleDTO> scheduleList = sDAO.selectAllSchedules(conn);

    // DB 연결 종료
    close(conn);

    // 날짜 포맷터, 가격 포맷터 준비
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
    SimpleDateFormat sdf2 = new SimpleDateFormat("MM/dd HH:mm");
    DecimalFormat df = new DecimalFormat("###,###,###");

    java.util.Date now = new java.util.Date();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Art Auction - Premium Online Auction</title>
<!-- 구글 폰트 불러오기 -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;700&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">

<style>
    /* 기본 바디 및 텍스트 스타일 */
    body { margin: 0; background-color: #1a1a1a; color: #e0e0e0; font-family: 'Noto Sans KR', sans-serif; }
    a { text-decoration: none; color: inherit; }

    /* 헤더 스타일 */
    .header { display: flex; justify-content: space-between; align-items: center; padding: 20px 50px; background-color: rgba(0,0,0,0.3); border-bottom: 1px solid #333; }
    .header .logo { font-family: 'Playfair Display', serif; font-size: 28px; color: #d4af37; }
    .header .nav a { margin-left: 25px; font-size: 16px; transition: color 0.3s; }
    .header .nav a:hover { color: #d4af37; }

    /* 메인 컨텐츠와 사이드바 레이아웃 */
    .content-wrapper { display: flex; padding: 40px 50px; gap: 40px; }
    .main-container { flex-grow: 1; }
    .sidebar { width: 250px; flex-shrink: 0; background-color: #2b2b2b; padding: 20px; border-radius: 8px; height: fit-content; }

    /* 검색폼 스타일 */
    .sidebar .search-form { display: flex; margin-bottom: 30px; }
    .sidebar .search-form input { width: 100%; padding: 10px 15px; border: 1px solid #555; border-right: none; background-color: #1a1a1a; color: #fff; border-radius: 5px 0 0 5px; outline: none; }
    .sidebar .search-form button { padding: 10px; border: 1px solid #d4af37; background-color: #d4af37; color: #1a1a1a; font-weight: bold; cursor: pointer; border-radius: 0 5px 5px 0; }

    /* 카테고리 리스트 스타일 */
    .sidebar-title { font-size: 22px; font-weight: 700; color: #fff; border-bottom: 2px solid #d4af37; padding-bottom: 10px; margin: 0 0 20px 0; }
    .category-list { list-style: none; padding: 0; margin: 0; }
    .category-list li a { display: block; padding: 12px 15px; color: #ccc; border-radius: 5px; transition: background-color 0.3s, color 0.3s; }
    .category-list li a:hover, .category-list li a.active { background-color: rgba(212, 175, 55, 0.1); color: #d4af37; font-weight: bold; }

    /* 섹션 타이틀 */
    .section-title { font-size: 32px; font-weight: 700; margin-bottom: 30px; color: #fff; border-left: 5px solid #d4af37; padding-left: 15px; }

    /* 상품 그리드 스타일 */
    .product-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 30px; min-height: 500px; }

    /* 상품 카드 스타일 */
    .product-card { background-color: #2b2b2b; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.2); transition: transform 0.3s, box-shadow 0.3s; cursor: pointer; }
    .product-card:hover { transform: translateY(-10px); box-shadow: 0 10px 25px rgba(212, 175, 55, 0.2); }
    .product-card img { width: 100%; height: 250px; object-fit: cover; }
    .product-info { padding: 20px; }
    .product-info h3 { margin: 0 0 10px 0; font-size: 20px; color: #fff; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;}
    .product-info .artist { color: #aaa; margin-bottom: 20px; }
    .product-info .price-label { font-size: 14px; color: #aaa; }
    .product-info .price { font-size: 22px; font-weight: 700; color: #d4af37; }
    .product-info .timer { margin-top: 15px; padding: 10px; background-color: rgba(0,0,0,0.3); border-radius: 5px; text-align: center; font-size: 20px; color: #ff6b6b; }
    .product-info .ended { color: #777; }

    /* 푸터 */
    .footer { text-align: center; padding: 40px; margin-top: 50px; background-color: #000; color: #777; font-size: 14px; }

    /* 페이징 버튼 스타일 */
    .paging-area { display: flex; justify-content: center; margin-top: 50px; }
    .paging-area a { padding: 8px 15px; margin: 0 5px; border: 1px solid #555; border-radius: 5px; color: #ccc; transition: all 0.3s; }
    .paging-area a:hover, .paging-area a.current-page { background-color: #d4af37; color: #1a1a1a; border-color: #d4af37; font-weight: bold; }
</style>
</head>
<body>
<jsp:include page="/layout/header/header.jsp" />

<%-- 알림 메시지가 있을 경우 alert 출력 --%>
<% if (alertMsg != null) { %>
<script>
    alert("<%= alertMsg %>");
</script>
<% session.removeAttribute("alertMsg"); %>
<% } %>

<header class="header">
    <%-- 헤더 내부 내용 필요시 여기에 작성 --%>
</header>

<div class="content-wrapper">
    <!-- 메인 콘텐츠 영역 -->
    <main class="main-container">
        <h2 class="section-title">Now Bidding</h2>

        <div class="product-grid">
            <%-- 상품 목록이 없으면 안내 문구 출력 --%>
            <% if (productList.isEmpty()) { %>
                <p>조회된 상품이 없습니다.</p>
            <% } else { %>
                <%-- 상품 목록 반복 출력 --%>
                <% for (ProductDTO p : productList) { %>
                    <a href="<%= request.getContextPath() %>/product/productDetail.jsp?productId=<%= p.getProductId() %>">
                        <div class="product-card">
                            <% if (p.getImageRenamedName() != null) { %>
                                <img src="<%= request.getContextPath() %>/resources/product_images/<%= p.getImageRenamedName() %>" alt="<%= p.getProductName() %>">
                            <% } else { %>
                                <%-- 이미지가 없으면 플레이스홀더 이미지 출력 (작품명 텍스트 포함) --%>
                                <img src="https://placehold.co/600x400/2b2b2b/e0e0e0?text=<%= URLEncoder.encode(p.getProductName(), "UTF-8") %>" alt="<%= p.getProductName() %>">
                            <% } %>
                            <div class="product-info">
                                <h3><%= p.getProductName() %></h3>
                                <p class="artist"><%= p.getArtistName() %></p>
                                <span class="price-label">현재가</span>
                                <p class="price">₩ <%= df.format(p.getCurrentPrice() == 0 ? p.getStartPrice() : p.getCurrentPrice()) %></p>
                                <div class="timer" data-endtime="<%= sdf.format(p.getEndTime()) %>"></div>
                            </div>
                        </div>
                    </a>
                <% } %>
            <% } %>
        </div>

        <%-- 페이징 버튼 영역 --%>
        <div class="paging-area">
            <%
                // 페이징 시 검색어와 카테고리 파라미터 유지용 URL 인코딩 포함
                String urlParams = "&keyword=" + URLEncoder.encode(keyword, "UTF-8") + "&category=" + URLEncoder.encode(category, "UTF-8");

                // 이전 페이지 버튼 (현재 페이지가 1보다 클 때만 노출)
                if (pi.getCurrentPage() > 1) {
            %>
                <a href="index.jsp?page=<%= pi.getCurrentPage() - 1 %><%= urlParams %>">&lt;</a>
            <% } %>

            <%-- 페이지 번호 버튼 반복 출력 --%>
            <% for (int i = pi.getStartPage(); i <= pi.getEndPage(); i++) { %>
                <% if (i == pi.getCurrentPage()) { %>
                    <a href="#" class="current-page"><%= i %></a>
                <% } else { %>
                    <a href="index.jsp?page=<%= i %><%= urlParams %>"><%= i %></a>
                <% } %>
            <% } %>

            <%-- 다음 페이지 버튼 (현재 페이지가 최대 페이지보다 작을 때만 노출) --%>
            <% if (pi.getCurrentPage() < pi.getMaxPage()) { %>
                <a href="index.jsp?page=<%= pi.getCurrentPage() + 1 %><%= urlParams %>">&gt;</a>
            <% } %>
        </div>
    </main>

    <!-- 사이드바 -->
    <aside class="sidebar">
        <!-- 검색 폼 -->
        <form action="<%= request.getContextPath() %>/index.jsp" method="get" class="search-form">
            <input type="text" name="keyword" placeholder="작품/작가명 검색" value="<%= keyword %>">
            <button type="submit">&#128269;</button>
        </form>

        <!-- 카테고리 목록 -->
        <h3 class="sidebar-title">Category</h3>
        <ul class="category-list">
            <li><a href="index.jsp?category=all" class="<%= category.equals("all") ? "active" : "" %>">전체보기</a></li>
            <li><a href="index.jsp?category=서양화" class="<%= category.equals("서양화") ? "active" : "" %>">서양화</a></li>
            <li><a href="index.jsp?category=동양화" class="<%= category.equals("동양화") ? "active" : "" %>">동양화</a></li>
            <li><a href="index.jsp?category=조각" class="<%= category.equals("조각") ? "active" : "" %>">조각</a></li>
            <li><a href="index.jsp?category=판화" class="<%= category.equals("판화") ? "active" : "" %>">판화</a></li>
            <li><a href="index.jsp?category=사진" class="<%= category.equals("사진") ? "active" : "" %>">사진</a></li>
            <li><a href="index.jsp?category=고미술" class="<%= category.equals("고미술") ? "active" : "" %>">고미술</a></li>
        </ul>

        <!-- 경매 일정 -->
        <div style="margin-top: 30px;">
            <h3 class="sidebar-title">경매 일정</h3>
            <ul style="list-style: none; padding: 0; font-size: 14px;">
                <%
                    int count = 0;
                    for (ScheduleDTO sched : scheduleList) {
                        if (count++ >= 5) break; // 최대 5개까지만 출력

                        String status;
                        if (now.before(sched.getStartTime())) {
                            status = "대기중";
                        } else if (!now.before(sched.getStartTime()) && !now.after(sched.getEndTime())) {
                            status = "진행중";
                        } else {
                            status = "종료";
                        }

                        String statusColor = "#fff";
                        if ("대기중".equals(status)) statusColor = "#4a90e2";       // 파란색
                        else if ("진행중".equals(status)) statusColor = "#7ed321";  // 연두색
                        else if ("종료".equals(status)) statusColor = "#d0021b";    // 빨간색
                %>
                    <li style="margin-bottom: 10px;">
                        <span style="color: <%= statusColor %>;">
                            [<%= status %>] <%= sdf2.format(sched.getStartTime()) %> ~ <%= sdf2.format(sched.getEndTime()) %>
                        </span>
                    </li>
                <%
                    }
                    if (count == 0) {
                %>
                    <li style="color: #4a90e2;">등록된 일정 없음</li>
                <%
                    }
                %>
            </ul>
        </div>
    </aside>
</div>

<footer class="footer">
    <p>&copy; 2025 Art Auction. All Rights Reserved.</p>
</footer>

<script>
    // 타이머 표시 스크립트: 각 상품의 경매 종료 시간 카운트다운 처리
    document.addEventListener('DOMContentLoaded', function() {
        const timers = document.querySelectorAll('.timer');
        timers.forEach(timer => {
            const endTimeString = timer.dataset.endtime;
            if(!endTimeString) return;

            const endTime = new Date(endTimeString).getTime();

            const interval = setInterval(function() {
                const now = new Date().getTime();
               
