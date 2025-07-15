<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.auction.dto.MemberDTO" %>
<%@ page import="com.auction.dto.BidDTO" %>
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
    List<BidDTO> bidList = new java.util.ArrayList<>();
    int todayBidCount = 0;
    int completedAuctionCount = 0;
    long totalBidAmount = 0L;
    int totalBidCount = 0;
    
    Connection conn = null;
    try {
        conn = getConnection();
        AdminDAO aDao = new AdminDAO();
        
        // 입찰 목록 조회
        bidList = aDao.getAllBids(conn);
        
        // 통계 데이터 조회
        todayBidCount = aDao.getTodayBidCount(conn);
        completedAuctionCount = aDao.getCompletedAuctionCount(conn);
        totalBidAmount = aDao.getTotalBidAmount(conn);
        totalBidCount = aDao.selectTotalBids(conn);
        
    } catch(Exception e) {
        e.printStackTrace();
        // 에러 발생 시 빈 데이터 사용
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
    <title>입찰 내역 관리 - M4 Auction</title>
    
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
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 24px;
            margin-bottom: 32px;
        }
        
        .stat-card {
            background: white;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            text-align: center;
        }
        
        .stat-icon {
            width: 48px;
            height: 48px;
            background: linear-gradient(135deg, #c9961a 0%, #d4af37 100%);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 20px;
            margin: 0 auto 16px;
        }
        
        .stat-value {
            font-size: 24px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 4px;
        }
        
        .stat-label {
            font-size: 14px;
            color: #6b7280;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .filter-section {
            background: white;
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        
        .filter-row {
            display: flex;
            gap: 16px;
            align-items: center;
            flex-wrap: wrap;
        }
        
        .filter-group {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .filter-label {
            font-size: 14px;
            font-weight: 600;
            color: #374151;
            min-width: 60px;
        }
        
        .filter-select, .filter-input {
            padding: 8px 12px;
            border: 2px solid #e5e7eb;
            border-radius: 6px;
            font-size: 14px;
            background: white;
            min-width: 120px;
        }
        
        .filter-btn {
            background: #1a1a1a;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .filter-btn:hover {
            background: #c9961a;
        }
        
        .bid-table {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        
        .table-header {
            background: #f9fafb;
            padding: 20px 24px;
            border-bottom: 2px solid #e5e7eb;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .table-title {
            font-size: 18px;
            font-weight: 700;
            color: #1a1a1a;
            margin: 0;
        }
        
        .table-actions {
            display: flex;
            gap: 12px;
        }
        
        .export-btn {
            background: #6b7280;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .export-btn:hover {
            background: #4b5563;
        }
        
        .refresh-btn {
            background: #c9961a;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .refresh-btn:hover {
            background: #ad870e;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        th, td {
            padding: 16px 24px;
            text-align: left;
            border-bottom: 1px solid #f3f4f6;
        }
        
        th {
            background: #f9fafb;
            font-weight: 600;
            color: #374151;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        td {
            font-size: 14px;
            color: #374151;
        }
        
        .product-info {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .product-image {
            width: 50px;
            height: 50px;
            border-radius: 8px;
            object-fit: cover;
            background: #f3f4f6;
        }
        
        .product-name {
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 4px;
        }
        
        .product-id {
            font-size: 12px;
            color: #6b7280;
        }
        
        .bid-amount {
            font-weight: 700;
            color: #c9961a;
            font-size: 16px;
        }
        
        .previous-bid {
            font-size: 12px;
            color: #6b7280;
        }
        
        .bidder-info {
            font-weight: 600;
            color: #1a1a1a;
        }
        
        .status-badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .status-valid {
            background: #d1fae5;
            color: #065f46;
        }
        
        .status-outbid {
            background: #fee2e2;
            color: #991b1b;
        }
        
        .status-winning {
            background: #fef3c7;
            color: #92400e;
        }
        
        .actions {
            display: flex;
            gap: 8px;
        }
        
        .action-btn {
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.3s;
            text-transform: uppercase;
        }
        
        .view-btn {
            background: #3b82f6;
            color: white;
        }
        
        .view-btn:hover {
            background: #2563eb;
        }
        
        .cancel-btn {
            background: #ef4444;
            color: white;
        }
        
        .cancel-btn:hover {
            background: #dc2626;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 40px;
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
            
            .stats-grid {
                grid-template-columns: 1fr 1fr;
            }
            
            .filter-row {
                flex-direction: column;
                align-items: stretch;
            }
            
            .table-header {
                flex-direction: column;
                gap: 16px;
                align-items: stretch;
            }
            
            table {
                font-size: 12px;
            }
            
            th, td {
                padding: 12px 8px;
            }
        }
        
        @media (max-width: 600px) {
            .stats-grid {
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
                <li><a href="<%=request.getContextPath()%>/admin/bidHistory.jsp" class="active">
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
                <h1 class="page-title">입찰 내역 관리</h1>
                <p class="page-subtitle">모든 입찰 기록을 관리하고 모니터링합니다</p>
            </div>
            
            <!-- 통계 카드 -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-gavel"></i>
                    </div>
                    <div class="stat-value"><%=df.format(totalBidCount)%></div>
                    <div class="stat-label">총 입찰 건수</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-fire"></i>
                    </div>
                    <div class="stat-value"><%=df.format(todayBidCount)%></div>
                    <div class="stat-label">오늘 입찰</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-trophy"></i>
                    </div>
                    <div class="stat-value"><%=df.format(completedAuctionCount)%></div>
                    <div class="stat-label">낙찰 완료</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-coins"></i>
                    </div>
                    <div class="stat-value">₩<%=df.format(totalBidAmount)%></div>
                    <div class="stat-label">총 입찰 금액</div>
                </div>
            </div>
            
            <!-- 필터 섹션 -->
            <div class="filter-section">
                <div class="filter-row">
                    <div class="filter-group">
                        <span class="filter-label">상태</span>
                        <select class="filter-select" id="statusFilter">
                            <option value="">전체</option>
                            <option value="VALID">유효</option>
                            <option value="OUTBID">경합패배</option>
                            <option value="WINNING">낙찰예정</option>
                        </select>
                    </div>
                    <div class="filter-group">
                        <span class="filter-label">상품명</span>
                        <input type="text" class="filter-input" id="productFilter" placeholder="상품명 검색">
                    </div>
                    <div class="filter-group">
                        <span class="filter-label">입찰자</span>
                        <input type="text" class="filter-input" id="bidderFilter" placeholder="입찰자 ID 검색">
                    </div>
                    <div class="filter-group">
                        <span class="filter-label">금액 범위</span>
                        <select class="filter-select" id="amountFilter">
                            <option value="">전체</option>
                            <option value="0-100000">10만원 이하</option>
                            <option value="100000-1000000">10만원 - 100만원</option>
                            <option value="1000000-10000000">100만원 - 1천만원</option>
                            <option value="10000000-">1천만원 이상</option>
                        </select>
                    </div>
                    <button class="filter-btn" onclick="applyFilters()">
                        <i class="fas fa-search"></i> 검색
                    </button>
                </div>
            </div>
            
            <!-- 입찰 내역 테이블 -->
            <div class="bid-table">
                <div class="table-header">
                    <h2 class="table-title">입찰 내역 목록</h2>
                    <div class="table-actions">
                        <button class="export-btn" onclick="exportBids()">
                            <i class="fas fa-download"></i> 내보내기
                        </button>
                        <button class="refresh-btn" onclick="refreshData()">
                            <i class="fas fa-sync-alt"></i> 새로고침
                        </button>
                    </div>
                </div>
                
                <% if (bidList.isEmpty()) { %>
                <div class="empty-state">
                    <i class="fas fa-gavel"></i>
                    <h3>입찰 내역이 없습니다</h3>
                    <p>아직 등록된 입찰 내역이 없습니다.</p>
                </div>
                <% } else { %>
                <table>
                    <thead>
                        <tr>
                            <th>상품 정보</th>
                            <th>입찰자</th>
                            <th>입찰 금액</th>
                            <th>입찰 시간</th>
                            <th>상태</th>
                            <th>관리</th>
                        </tr>
                    </thead>
                    <tbody id="bidTableBody">
                        <% for (BidDTO bid : bidList) { 
                            // 입찰 상태 결정
                            String statusClass = "status-valid";
                            String statusText = "유효";
                            String productStatus = bid.getProductStatus();
                            
                            if ("E".equals(productStatus) || "F".equals(productStatus)) {
                                // 경매 종료된 상품
                                if (bid.getBidPrice() >= bid.getCurrentPrice()) {
                                    statusClass = "status-winning";
                                    statusText = "낙찰예정";
                                } else {
                                    statusClass = "status-outbid";
                                    statusText = "경합패배";
                                }
                            } else if ("A".equals(productStatus)) {
                                // 진행중인 경매
                                if (bid.getBidPrice() >= bid.getCurrentPrice()) {
                                    statusClass = "status-winning";
                                    statusText = "최고가";
                                } else {
                                    statusClass = "status-outbid";
                                    statusText = "경합중";
                                }
                            }
                        %>
                        <tr data-product="<%=bid.getProductName()%>" data-bidder="<%=bid.getMemberId()%>" data-amount="<%=bid.getBidPrice()%>">
                            <td>
                                <div class="product-info">
                                    <% if (bid.getImageRenamedName() != null && !bid.getImageRenamedName().isEmpty()) { %>
                                        <img src="<%=request.getContextPath()%>/resources/product_images/<%=bid.getImageRenamedName()%>" alt="<%=bid.getProductName()%>" class="product-image">
                                    <% } else { %>
                                        <div class="product-image" style="background: #f3f4f6; display: flex; align-items: center; justify-content: center;">
                                            <i class="fas fa-image" style="color: #9ca3af; font-size: 24px;"></i>
                                        </div>
                                    <% } %>
                                    <div>
                                        <div class="product-name"><%=bid.getProductName()%></div>
                                        <div class="product-id">ID: P<%=String.format("%03d", bid.getProductId())%></div>
                                    </div>
                                </div>
                            </td>
                            <td class="bidder-info"><%=bid.getMemberId()%></td>
                            <td>
                                <div class="bid-amount">₩<%=df.format(bid.getBidPrice())%></div>
                                <div class="previous-bid">현재가: ₩<%=df.format(bid.getCurrentPrice())%></div>
                            </td>
                            <td><%=sdf.format(bid.getBidTime())%></td>
                            <td><span class="status-badge <%=statusClass%>"><%=statusText%></span></td>
                            <td>
                                <div class="actions">
                                    <a href="<%=request.getContextPath()%>/product/productDetail.jsp?productId=<%=bid.getProductId()%>" class="action-btn view-btn">상세</a>
                                    <% if ("A".equals(productStatus)) { %>
                                    <a href="#" class="action-btn cancel-btn" onclick="return cancelBid(<%=bid.getBidId()%>)">취소</a>
                                    <% } %>
                                </div>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
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
        // 필터 적용 함수
        function applyFilters() {
            const statusFilter = document.getElementById('statusFilter').value;
            const productFilter = document.getElementById('productFilter').value.toLowerCase();
            const bidderFilter = document.getElementById('bidderFilter').value.toLowerCase();
            const amountFilter = document.getElementById('amountFilter').value;
            
            console.log('필터 적용:', { statusFilter, productFilter, bidderFilter, amountFilter });
            alert('필터가 적용되었습니다. (실제로는 서버에서 데이터를 다시 조회합니다)');
        }
        
        // 입찰 내역 내보내기 함수
        function exportBids() {
            alert('입찰 내역을 Excel 파일로 내보냅니다.');
            // 실제로는 서버로 요청을 보내 Excel 파일을 생성하고 다운로드
        }
        
        // 데이터 새로고침 함수
        function refreshData() {
            alert('데이터를 새로고침합니다.');
            // 실제로는 페이지를 다시 로드하거나 AJAX로 데이터를 업데이트
            location.reload();
        }
        
        // 입찰 취소 함수
        function cancelBid(bidId) {
            if (confirm('정말로 이 입찰을 취소하시겠습니까?\n\n주의: 이 작업은 되돌릴 수 없습니다.')) {
                // 실제로는 서버로 요청을 보내 입찰을 취소
                alert('입찰 ID ' + bidId + '번이 취소되었습니다.');
                // location.href = '<%=request.getContextPath()%>/admin/cancelBid?bidId=' + bidId;
                refreshData();
                return true;
            }
            return false;
        }
        
        // 현재 페이지 사이드바 활성화
        document.addEventListener('DOMContentLoaded', function() {
            const currentPath = window.location.pathname;
            const menuItems = document.querySelectorAll('.sidebar-menu a');
            
            menuItems.forEach(item => {
                item.classList.remove('active');
                if (item.getAttribute('href').includes('bidHistory.jsp')) {
                    item.classList.add('active');
                }
            });
        });
    </script>
</body>
</html>