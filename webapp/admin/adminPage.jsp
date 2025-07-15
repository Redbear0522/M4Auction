<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.auction.dto.ChargeRequestDTO" %>
<%@ page import="com.auction.dto.MemberDTO" %>
<%@ page import="com.auction.dto.ProductDTO" %>
<%@ page import="com.auction.dao.ProductDAO" %>
<%@ page import="com.auction.dao.AdminDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %>
<%
    // 관리자 로그인 체크
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null || !"admin".equals(loginUser.getMemberId())) {
        session.setAttribute("alertMsg", "관리자 로그인 후 이용 가능한 서비스입니다.");
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    String alertMsg = (String) session.getAttribute("alertMsg");
    session.removeAttribute("alertMsg");

    // 데이터 조회
    Connection conn = getConnection();
    AdminDAO aDao = new AdminDAO();
    ProductDAO pDAO = new ProductDAO();

    int totalProducts   = aDao.selectTotalProducts(conn);
    int pendingCount    = aDao.selectPendingProducts(conn);
    int totalBids       = aDao.selectTotalBids(conn);
    long totalRevenue   = aDao.selectTotalRevenue(conn);

    List<ProductDTO> pendingList = aDao.selectPendingProductsList(conn);
    List<ChargeRequestDTO> chargeList = aDao.getAllChargeRequests(conn);
    List<ProductDTO> allList = pDAO.selectAllProducts(conn);

    close(conn);

    DecimalFormat dfCount = new DecimalFormat("###,###");
    DecimalFormat dfAmt   = new DecimalFormat("###,###,###");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>관리자 페이지 - M4 Auction</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Noto+Sans+KR:wght@300;400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/luxury-global-style.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/common-utilities.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/admin-page.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
</head>
<body class="adm-body">
<jsp:include page="/layout/header/luxury-header.jsp" />

<div class="adm-layout">
    <!-- 사이드바 -->
    <div class="adm-sidebar">
        <div class="adm-sidebar-header">
            <h2>관리자 패널</h2>
            <p>Admin Panel</p>
        </div>
        <ul class="adm-sidebar-menu">
            <li><a href="<%=request.getContextPath()%>/admin/adminPage.jsp" class="active">
                <i class="fas fa-tachometer-alt"></i>
                대시보드
            </a></li>
            <li><a href="<%=request.getContextPath()%>/admin/waittingProduct.jsp">
                <i class="fas fa-clock"></i>
                상품 승인 관리
            </a></li>
            <li><a href="<%=request.getContextPath()%>/admin/allProduct.jsp">
                <i class="fas fa-box"></i>
                전체 상품 관리
            </a></li>
            <li><a href="<%=request.getContextPath()%>/admin/auctionManage.jsp">
                <i class="fas fa-gavel"></i>
                경매 관리
            </a></li>
            <li><a href="<%=request.getContextPath()%>/admin/chargeRequestList.jsp">
                <i class="fas fa-coins"></i>
                마일리지 충전 관리
            </a></li>
            <li><a href="<%=request.getContextPath()%>/admin/vipRequestList.jsp">
                <i class="fas fa-crown"></i>
                VIP 신청 관리
            </a></li>
            <li><a href="<%=request.getContextPath()%>/admin/memberManage.jsp">
                <i class="fas fa-users"></i>
                회원 관리
            </a></li>
            <li><a href="<%=request.getContextPath()%>/admin/bidHistory.jsp">
                <i class="fas fa-list"></i>
                입찰 내역 관리
            </a></li>
            <li><a href="<%=request.getContextPath()%>/admin/siteStatistics.jsp">
                <i class="fas fa-chart-bar"></i>
                사이트 통계
            </a></li>
            <li><a href="<%=request.getContextPath()%>/admin/systemSettings.jsp">
                <i class="fas fa-cog"></i>
                시스템 설정
            </a></li>
            <li><a href="<%=request.getContextPath()%>/index.jsp">
                <i class="fas fa-home"></i>
                메인 페이지로
            </a></li>
        </ul>
    </div>
    
    <!-- 메인 컨텐츠 -->
    <div class="adm-main-content">
        <div class="admin-wrapper">

    <!-- 대시보드 카드 -->
    <div class="adm-dashboard-cards">
        <div class="adm-card">
            <div class="adm-card-icon"><i class="fas fa-box"></i></div>
            <h3>전체 상품</h3>
            <p><%= dfCount.format(totalProducts) %> 건</p>
            <a class="card-link" href="<%=request.getContextPath()%>/admin/allProduct.jsp">전체 상품 보기</a>
        </div>
        <div class="adm-card">
            <div class="adm-card-icon"><i class="fas fa-clock"></i></div>
            <h3>승인 대기 상품</h3>
            <p><%= dfCount.format(pendingCount) %> 건</p>
            <a class="card-link" href="<%=request.getContextPath()%>/admin/waittingProduct.jsp">대기 목록 보기</a>
        </div>
        <div class="adm-card">
            <div class="adm-card-icon"><i class="fas fa-gavel"></i></div>
            <h3>전체 입찰 건수</h3>
            <p><%= dfCount.format(totalBids) %> 건</p>
            <a class="card-link" href="<%=request.getContextPath()%>/admin/bidHistory.jsp">입찰 내역</a>
        </div>
        <div class="adm-card">
            <div class="adm-card-icon"><i class="fas fa-coins"></i></div>
            <h3>총 낙찰 금액</h3>
            <p>₩ <%= dfAmt.format(totalRevenue) %></p>
        </div>
    </div>

    <!-- 승인 대기 상품 목록 -->
    <div class="adm-section">
        <h2>승인 대기 상품 목록</h2>
        <% if (pendingList.isEmpty()) { %>
            <div class="empty-state">
                <i class="fas fa-box-open"></i><br>
                승인 대기 중인 상품이 없습니다.
            </div>
        <% } else { %>
            <div class="adm-product-grid">
                <% 
                int pendingDisplayCount = 0;
                for (ProductDTO p : pendingList) { 
                    if (pendingDisplayCount >= 6) break;
                    pendingDisplayCount++;
                %>
                <div class="adm-product-card">
                    <a href="<%= request.getContextPath() %>/product/productDetail.jsp?productId=<%= p.getProductId() %>">
                        <img src="<%= request.getContextPath() %>/resources/product_images/<%= p.getImageRenamedName() %>" alt="<%= p.getProductName() %>" class="product-image">
                    </a>
                    <div class="product-info">
                        <h4><%= p.getProductName() %></h4>
                        <div class="adm-product-seller">등록자: <%= p.getSellerId() %></div>
                        <p>시작가 ₩ <%= dfAmt.format(p.getStartPrice()) %></p>
                        <div class="actions">
                            <a class="adm-btn-success" href="<%= request.getContextPath() %>/admin/approveProduct.jsp?productId=<%= p.getProductId() %>">승인</a>
                            <a class="reject-btn" href="<%= request.getContextPath() %>/admin/rejectProduct.jsp?productId=<%= p.getProductId() %>">거부</a>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
            <% if (pendingList.size() > 6) { %>
            <div class="adm-text-center">
                <a href="<%= request.getContextPath() %>/admin/waittingProduct.jsp" class="adm-btn-success adm-btn-large">
                    <i class="fas fa-plus"></i> 더보기 (<%= pendingList.size() - 6 %>개 더)
                </a>
            </div>
            <% } %>
        <% } %>
    </div>

    <!-- 전체 상품 목록 -->
    <div class="adm-section">
        <h2>전체 상품 목록</h2>
        <% if (allList.isEmpty()) { %>
            <div class="empty-state">
                <i class="fas fa-cube"></i><br>
                상품이 없습니다.
            </div>
        <% } else { %>
            <div class="adm-product-grid">
                <% 
                int allDisplayCount = 0;
                for (ProductDTO p : allList) { 
                    if (allDisplayCount >= 6) break;
                    allDisplayCount++;
                %>
                <div class="adm-product-card">
                    <a href="<%= request.getContextPath() %>/product/productDetail.jsp?productId=<%= p.getProductId() %>">
                        <img src="<%= request.getContextPath() %>/resources/product_images/<%= p.getImageRenamedName() %>" alt="<%= p.getProductName() %>" class="product-image">
                    </a>
                    <div class="product-info">
                        <h4><%= p.getProductName() %></h4>
                        <div class="adm-product-seller">등록자: <%= p.getSellerId() %></div>
                        <p>시작가 <%= dfAmt.format(p.getStartPrice()) %></p>
                        <p>현재가 <%= dfAmt.format(p.getCurrentPrice()) %></p>
                        <div class="adm-status">
                            상태
                            <%
                                String status = p.getStatus();
                                String statusText = "기타";
                                if ("A".equals(status)) statusText = "진행중";
                                else if ("E".equals(status)) statusText = "마감";
                                else if ("P".equals(status)) statusText = "보류";
                                else if ("C".equals(status)) statusText = "취소";
                                else if ("F".equals(status)) statusText = "종료(낙찰)";
                            %>
                            <%= statusText %>
                        </div>
                        <div>
                            낙찰일
                            <% if (p.getEndTime() != null) { %>
                                <%= p.getEndTime() %>
                            <% } else { %>
                                -
                            <% } %>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
            <% if (allList.size() > 6) { %>
            <div class="adm-text-center">
                <a href="<%= request.getContextPath() %>/admin/allProduct.jsp" class="adm-btn-success adm-btn-large">
                    <i class="fas fa-plus"></i> 더보기 (<%= allList.size() - 6 %>개 더)
                </a>
            </div>
            <% } %>
        <% } %>
    </div>

    <!-- 마일리지 충전 요청 목록 -->
    <div class="adm-section">
        <h2>마일리지 충전 요청 대기 목록</h2>
        <% boolean hasCharge = false;
           for (ChargeRequestDTO req : chargeList) {
               if ("W".equals(req.getStatus())) { hasCharge=true; break;}
           }
           if (!hasCharge) { %>
            <div class="empty-state">
                <i class="fas fa-coins"></i><br>
                현재 충전 대기 요청이 없습니다.
            </div>
        <% } else { %>
            <div class="adm-product-grid">
                <% for (ChargeRequestDTO req : chargeList) {
                    if ("W".equals(req.getStatus())) { %>
                    <div class="adm-charge-card">
                        <div class="adm-charge-info">
                            <div>회원 ID</div>
                            <div><%= req.getMemberId() %></div>
                            <div class="adm-charge-amount">충전 요청 금액</div>
                            <div>₩ <%= dfAmt.format(req.getAmount()) %></div>
                            <div>요청일</div>
                            <div class="adm-charge-status"><%= req.getRequestDate() %></div>
                        </div>
                        <div class="charge-actions">
                            <a class="adm-btn-success" href="<%= request.getContextPath() %>/admin/chargeAction.jsp?reqId=<%= req.getReqId() %>&action=approve">승인</a>
                            <a class="charge-btn reject-btn" href="<%= request.getContextPath() %>/admin/chargeAction.jsp?reqId=<%= req.getReqId() %>&action=reject">거부</a>
                        </div>
                    </div>
                <% }} %>
            </div>
        <% } %>
        <a class="vip-link" href="<%= request.getContextPath() %>/admin/vipRequestList.jsp"><i class="fas fa-crown"></i> VIP 신청 관리</a>
    </div>
        </div>
    </div>
</div>

<jsp:include page="/layout/footer/luxury-footer.jsp" />
<% if(alertMsg != null) { %>
<script>
    alert("<%= alertMsg %>");
</script>
<% } %>

<script>
// 현재 페이지에 맞는 사이드바 메뉴 활성화
document.addEventListener('DOMContentLoaded', function() {
    const currentPath = window.location.pathname;
    const menuItems = document.querySelectorAll('.adm-sidebar-menu a');
    
    menuItems.forEach(item => {
        item.classList.remove('active');
        if (item.getAttribute('href').includes(currentPath.split('/').pop())) {
            item.classList.add('active');
        }
    });
    
    // 대시보드가 기본 활성화
    if (currentPath.includes('adminPage.jsp')) {
        document.querySelector('.adm-sidebar-menu a[href*="adminPage.jsp"]').classList.add('active');
    }
});
</script>
</body>
</html>
