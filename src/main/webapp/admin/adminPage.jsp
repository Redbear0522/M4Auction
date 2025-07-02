<%-- File: WebContent/admin/adminPage.jsp --%>
<%-- 역할: 관리자페이지 (순수 스크립틀릿 버전) --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="com.auction.vo.ChargeRequestDTO" %>
<%@ page import="com.auction.vo.MemberDTO" %>
<%@ page import="com.auction.vo.ProductDTO" %>
<%@ page import="com.auction.dao.AdminDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %>
<%
    // 1) 로그인 & 관리자 체크
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null || !"admin".equals(loginUser.getMemberId())) {
        session.setAttribute("alertMsg", "관리자 로그인 후 이용 가능한 서비스입니다.");
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    // 2) 알림 메시지
    String alertMsg = (String) session.getAttribute("alertMsg");
    session.removeAttribute("alertMsg"); // 가져온 후에는 바로 제거

    // 3) DB에서 데이터 조회
    Connection conn = getConnection();
    AdminDAO aDao = new AdminDAO();

    // 3-1) 통계 데이터
    int totalProducts   = aDao.selectTotalProducts(conn);
    int pendingCount    = aDao.selectPendingProducts(conn);
    int totalBids       = aDao.selectTotalBids(conn);
    long totalRevenue   = aDao.selectTotalRevenue(conn);

    // 3-2) 승인 대기 상품 목록
    List<ProductDTO> pendingList = aDao.selectPendingProductsList(conn);
    List<ChargeRequestDTO> chargeList = aDao.getAllChargeRequests(conn);

    close(conn);

    // 4) 숫자 포맷팅을 위한 DecimalFormat 객체 생성
    DecimalFormat dfCount = new DecimalFormat("###,###");
    DecimalFormat dfAmt   = new DecimalFormat("###,###,###");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Art Auction - 관리자 페이지</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;700&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/layout.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/login.css">
</head>
<body>
<jsp:include page="/layout/header/header.jsp" />
    <%-- alert 창 처리는 기존 스크립틀릿 방식 유지 --%>
    <% if (alertMsg != null) { %>
    <script>alert("<%= alertMsg %>");</script>
    <% } %>
    <div class="dashboard">
        <h2>관리자 대시보드</h2>
        <div class="stats">
            <%-- DecimalFormat을 사용하여 숫자 포맷팅 --%>
            <div>전체 상품: <strong><%= dfCount.format(totalProducts) %>건</strong></div>
            <div>승인 대기 상품: <strong><%= dfCount.format(pendingCount) %>건</strong></div>
            <div>전체 입찰 건수: <strong><%= dfCount.format(totalBids) %>건</strong></div>
            <div>총 낙찰 금액: <strong>₩ <%= dfAmt.format(totalRevenue) %></strong></div>
        </div>
    </div>

    <section class="pending-section">
        <h3>승인 대기 상품 목록</h3>
        <div class="product-list">
            <%-- if-else와 for문을 사용한 스크립틀릿 방식의 목록 처리 --%>
            <% if (pendingList.isEmpty()) { %>
                <p>승인 대기 중인 상품이 없습니다.</p>
            <% } else { %>
                <% for (ProductDTO p : pendingList) { %>
                    <div class="product-card">
                        <a href="<%= request.getContextPath() %>/product/auctionDetail.jsp?id=<%= p.getProductId() %>">
                            <img src="<%= request.getContextPath() %>/resources/product_images/<%= p.getImageRenamedName() %>" alt="<%= p.getProductName() %>">
                            <div class="info">
                                <h4><%= p.getProductName() %></h4>
                                <p>등록자: <%= p.getSellerId() %></p>
                                <p>시작가: ₩ <%= dfAmt.format(p.getStartPrice()) %></p>
                            </div>
                        </a>
                        <div class="actions">
                            <a class="approve-btn"
                               href="<%= request.getContextPath() %>/admin/approveProduct.jsp?productId=<%= p.getProductId() %>">
                                승인
                            </a>
                            <a class="reject-btn"
                               href="<%= request.getContextPath() %>/admin/rejectProduct.jsp?productId=<%= p.getProductId() %>">
                                거부
                            </a>
                        </div>
                    </div>
                <% } %>
            <% } %>
        </div>
    </section>
   <section class="pending-section">
	    <h3>마일리지 충전 요청 대기 목록</h3>
	    <div class="product-list">
	        <%-- 충전 대기 요청이 없을 경우 --%>
	        <% if (chargeList == null || chargeList.isEmpty()) { %>
	            <p>현재 충전 대기 요청이 없습니다.</p>
	        <% } else { %>
	            <% for (ChargeRequestDTO req : chargeList) { %>
	                <div class="product-card">
	                    <div class="info">
	                        <h4>회원 ID: <%= req.getMemberId() %></h4>
	                        <p>충전 요청 금액: ₩ <%= dfAmt.format(req.getAmount()) %></p>
	                        <p>요청일: <%= req.getRequestDate() %></p>
	                    </div>
	                    <div class="actions">
	                        <a class="approve-btn"
	                           href="<%= request.getContextPath() %>/admin/chargeAction?reqId=<%= req.getReqId() %>&action=approve">
	                            승인
	                        </a>
	                        <a class="reject-btn"
	                           href="<%= request.getContextPath() %>/admin/chargeAction?reqId=<%= req.getReqId() %>&action=reject">
	                            거부
	                        </a>
	                    </div>
	                </div>
	            <% } %>
	        <% } %>
	    </div>
	</section>

    <footer class="footer">
        <p>&copy; 2025 Art Auction. All Rights Reserved.</p>
    </footer>
</body>
</html>