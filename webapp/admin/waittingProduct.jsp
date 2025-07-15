<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.auction.dto.MemberDTO" %>
<%@ page import="com.auction.dto.ProductDTO" %>
<%@ page import="com.auction.dao.AdminDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
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
    List<ProductDTO> pendingList = new java.util.ArrayList<>();
    Connection conn = null;
    try {
        conn = getConnection();
        AdminDAO aDao = new AdminDAO();
        pendingList = aDao.selectPendingProductsList(conn);
    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        if(conn != null) close(conn);
    }

    DecimalFormat df = new DecimalFormat("###,###,###");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상품 승인 관리 - M4 Auction</title>
    
    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    
    <!-- Global Styles -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/luxury-global-style.css">
    
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background: #f8f9fa;
            padding-top: 120px !important;
            line-height: 1.6;
        }
        
        .admin-layout {
            display: flex;
            max-width: 1400px;
            margin: 0 auto;
            gap: 30px;
            padding: 40px 20px;
        }
        
        .admin-sidebar {
            width: 280px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08);
            padding: 0;
            position: sticky;
            top: 140px;
            height: fit-content;
        }
        
        .sidebar-header {
            background: linear-gradient(135deg, #1a1a1a 0%, #c9961a 100%);
            color: white;
            padding: 24px;
            border-radius: 12px 12px 0 0;
            text-align: center;
        }
        
        .sidebar-title {
            font-family: 'Playfair Display', serif;
            font-size: 20px;
            font-weight: 700;
            margin: 0;
        }
        
        .sidebar-subtitle {
            font-size: 13px;
            opacity: 0.9;
            margin-top: 4px;
        }
        
        .sidebar-menu {
            padding: 0;
            margin: 0;
            list-style: none;
        }
        
        .sidebar-menu li {
            border-bottom: 1px solid #f0f0f0;
        }
        
        .sidebar-menu li:last-child {
            border-bottom: none;
        }
        
        .sidebar-menu a {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 16px 24px;
            color: #333;
            text-decoration: none;
            transition: all 0.3s;
            font-size: 14px;
            font-weight: 500;
        }
        
        .sidebar-menu a:hover {
            background: #f8f9fa;
            color: #c9961a;
        }
        
        .sidebar-menu a.active {
            background: #c9961a;
            color: white;
        }
        
        .sidebar-menu i {
            width: 18px;
            text-align: center;
        }
        
        .admin-content {
            flex: 1;
        }
        
        .page-header {
            background: white;
            border-radius: 12px;
            padding: 32px;
            margin-bottom: 32px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        
        .page-title {
            font-family: 'Playfair Display', serif;
            font-size: 32px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 8px;
        }
        
        .page-subtitle {
            color: #6b7280;
            font-size: 16px;
            margin: 0;
        }
        
        .stats-bar {
            background: white;
            border-radius: 12px;
            padding: 24px 32px;
            margin-bottom: 32px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .stat-item {
            text-align: center;
        }
        
        .stat-number {
            font-size: 24px;
            font-weight: 700;
            color: #c9961a;
            display: block;
        }
        
        .stat-label {
            font-size: 14px;
            color: #6b7280;
            margin-top: 4px;
        }
        
        .products-section {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        
        .section-header {
            background: #f9fafb;
            padding: 20px 32px;
            border-bottom: 1px solid #e5e7eb;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .section-title {
            font-size: 18px;
            font-weight: 700;
            color: #1a1a1a;
            margin: 0;
        }
        
        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 24px;
            padding: 32px;
        }
        
        .product-card {
            background: #fafafa;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            overflow: hidden;
            transition: all 0.3s ease;
        }
        
        .product-card:hover {
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            transform: translateY(-2px);
        }
        
        .product-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
            background: #f3f4f6;
        }
        
        .product-info {
            padding: 20px;
        }
        
        .product-name {
            font-size: 16px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 8px;
            line-height: 1.4;
        }
        
        .product-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
        }
        
        .product-seller {
            font-size: 14px;
            color: #6b7280;
        }
        
        .product-id {
            font-size: 12px;
            color: #9ca3af;
            font-family: monospace;
        }
        
        .product-price {
            font-size: 18px;
            font-weight: 700;
            color: #c9961a;
            margin-bottom: 16px;
        }
        
        .product-actions {
            display: flex;
            gap: 8px;
        }
        
        .action-btn {
            flex: 1;
            padding: 10px 16px;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            text-align: center;
            transition: all 0.3s;
            display: inline-block;
        }
        
        .approve-btn {
            background: #10b981;
            color: white;
        }
        
        .approve-btn:hover {
            background: #059669;
        }
        
        .reject-btn {
            background: #ef4444;
            color: white;
        }
        
        .reject-btn:hover {
            background: #dc2626;
        }
        
        .view-btn {
            background: #6b7280;
            color: white;
        }
        
        .view-btn:hover {
            background: #4b5563;
        }
        
        .empty-state {
            text-align: center;
            padding: 80px 40px;
            color: #9ca3af;
        }
        
        .empty-state i {
            font-size: 64px;
            margin-bottom: 20px;
            opacity: 0.5;
        }
        
        .empty-state h3 {
            font-size: 20px;
            margin-bottom: 8px;
            color: #6b7280;
        }
        
        .empty-state p {
            font-size: 14px;
        }
        
        /* 반응형 */
        @media (max-width: 1000px) {
            .admin-layout {
                flex-direction: column;
            }
            
            .admin-sidebar {
                width: 100%;
                position: relative;
                top: auto;
            }
            
            .products-grid {
                grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
                gap: 16px;
                padding: 20px;
            }
            
            .stats-bar {
                flex-direction: column;
                gap: 16px;
            }
        }
        
        @media (max-width: 600px) {
            .products-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/layout/header/luxury-header.jsp" />
    
    <div class="admin-layout">
        <!-- 사이드바 -->
        <div class="admin-sidebar">
            <div class="sidebar-header">
                <div class="sidebar-title">관리자 패널</div>
                <div class="sidebar-subtitle">Admin Panel</div>
            </div>
            <ul class="sidebar-menu">
                <li><a href="<%=request.getContextPath()%>/admin/adminPage.jsp">
                    <i class="fas fa-tachometer-alt"></i>
                    대시보드
                </a></li>
                <li><a href="<%=request.getContextPath()%>/admin/waittingProduct.jsp" class="active">
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
        <div class="admin-content">
            <!-- 페이지 헤더 -->
            <div class="page-header">
                <h1 class="page-title">상품 승인 관리</h1>
                <p class="page-subtitle">등록된 상품의 승인 및 거부를 관리합니다</p>
            </div>
            
            <!-- 통계 바 -->
            <div class="stats-bar">
                <div class="stat-item">
                    <span class="stat-number"><%=pendingList.size()%></span>
                    <div class="stat-label">승인 대기</div>
                </div>
                <div class="stat-item">
                    <span class="stat-number">0</span>
                    <div class="stat-label">오늘 승인</div>
                </div>
                <div class="stat-item">
                    <span class="stat-number">0</span>
                    <div class="stat-label">오늘 거부</div>
                </div>
            </div>
            
            <!-- 상품 목록 -->
            <div class="products-section">
                <div class="section-header">
                    <h2 class="section-title">승인 대기 상품</h2>
                </div>
                
                <% if (pendingList.isEmpty()) { %>
                <div class="empty-state">
                    <i class="fas fa-clock"></i>
                    <h3>승인 대기 상품이 없습니다</h3>
                    <p>현재 승인 대기 중인 상품이 없습니다.</p>
                </div>
                <% } else { %>
                <div class="products-grid">
                    <% for (ProductDTO p : pendingList) { %>
                    <div class="product-card">
                        <% if (p.getImageRenamedName() != null && !p.getImageRenamedName().isEmpty()) { %>
                            <img src="<%=request.getContextPath()%>/resources/product_images/<%=p.getImageRenamedName()%>" alt="<%=p.getProductName()%>" class="product-image">
                        <% } else { %>
                            <div class="product-image" style="display: flex; align-items: center; justify-content: center; background: #f3f4f6;">
                                <i class="fas fa-image" style="font-size: 48px; color: #d1d5db;"></i>
                            </div>
                        <% } %>
                        
                        <div class="product-info">
                            <h3 class="product-name"><%=p.getProductName()%></h3>
                            <div class="product-meta">
                                <span class="product-seller"><%=p.getSellerId()%></span>
                                <span class="product-id">ID: <%=p.getProductId()%></span>
                            </div>
                            <div class="product-price">시작가 ₩<%=df.format(p.getStartPrice())%></div>
                            
                            <div class="product-actions">
                                <button class="action-btn approve-btn" onclick="approveProduct(<%=p.getProductId()%>)">
                                    <i class="fas fa-check"></i> 승인
                                </button>
                                <button class="action-btn reject-btn" onclick="rejectProduct(<%=p.getProductId()%>)">
                                    <i class="fas fa-times"></i> 거부
                                </button>
                                <a href="<%=request.getContextPath()%>/product/productDetail.jsp?productId=<%=p.getProductId()%>" class="action-btn view-btn">
                                    <i class="fas fa-eye"></i> 상세
                                </a>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
                <% } %>
            </div>
        </div>
    </div>
    
    <jsp:include page="/layout/footer/luxury-footer.jsp" />
    
    <% if(alertMsg != null) { %>
    <script>
        alert("<%=alertMsg%>");
    </script>
    <% } %>
    
    <script>
        // 상품 승인 함수
        function approveProduct(productId) {
            if (confirm('이 상품을 승인하시겠습니까?\\n\\n승인 후 경매가 시작됩니다.')) {
                // 실제로는 서버로 요청을 보내 상품을 승인
                window.location.href = '<%=request.getContextPath()%>/admin/productAction.jsp?action=approve&productId=' + productId;
            }
        }
        
        // 상품 거부 함수
        function rejectProduct(productId) {
            if (confirm('이 상품을 거부하시겠습니까?\\n\\n거부된 상품은 판매자에게 통보됩니다.')) {
                // 실제로는 서버로 요청을 보내 상품을 거부
                window.location.href = '<%=request.getContextPath()%>/admin/productAction.jsp?action=reject&productId=' + productId;
            }
        }
        
        // 현재 페이지 사이드바 활성화
        document.addEventListener('DOMContentLoaded', function() {
            const currentPath = window.location.pathname;
            const menuItems = document.querySelectorAll('.sidebar-menu a');
            
            menuItems.forEach(item => {
                item.classList.remove('active');
                if (item.getAttribute('href').includes('waittingProduct.jsp')) {
                    item.classList.add('active');
                }
            });
        });
    </script>
</body>
</html>