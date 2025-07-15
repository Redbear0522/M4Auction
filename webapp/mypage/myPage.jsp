<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.util.List" %>
<%@ page import="com.auction.dto.MemberDTO" %>
<%@ page import="com.auction.dto.ProductDTO" %>
<%@ page import="com.auction.dao.ProductDAO" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %>
<%
    MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");
    if(loginUser == null){
        session.setAttribute("alertMsg", "로그인 후 이용 가능한 서비스입니다.");
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    String alertMsg = (String)session.getAttribute("alertMsg");

    Connection conn = getConnection();
    ProductDAO pDao = new ProductDAO();
    List<ProductDTO> myProducts = pDao.selectProductsBySeller(conn, loginUser.getMemberId());
    List<ProductDTO> myBids = pDao.selectProductsByBidder(conn, loginUser.getMemberId());
    List<ProductDTO> myWonProducts = pDao.selectWonProducts(conn, loginUser.getMemberId());
    close(conn);

    boolean isVip = false;
    try (Connection conn2 = getConnection()) {
        String sql = "SELECT 1 FROM VIP_INFO WHERE MEMBER_ID = ?";
        PreparedStatement ps = conn2.prepareStatement(sql);
        ps.setString(1, loginUser.getMemberId());
        ResultSet rs = ps.executeQuery();
        if(rs.next()) isVip = true;
        rs.close(); ps.close();
    } catch(Exception e) { e.printStackTrace(); }

    DecimalFormat df = new DecimalFormat("###,###,###");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지 - M4 경매</title>

    <!-- Professional Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Lora:wght@400;500;600&display=swap" rel="stylesheet">
    
    <!-- Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    
    <!-- Global Styles -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/luxury-global-style.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/common-utilities.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/mypage.css">

</head>
<body class="mp-body">
    <!-- Header -->
    <jsp:include page="/layout/header/luxury-header.jsp" />

    <div class="mp-dashboard">
        <!-- Dashboard Header -->
        <div class="mp-dashboard-header">
            <h1 class="mp-page-title">마이페이지</h1>
            <p class="mp-page-subtitle">경매, 입찰, 계정 설정을 관리하세요</p>
        </div>

        <!-- Dashboard Grid -->
        <div class="mp-dashboard-grid">
            <!-- Sidebar -->
            <aside class="mp-sidebar">
                <!-- User Profile -->
                <div class="mp-user-profile">
                    <div class="mp-profile-avatar">
                        <i class="fas fa-user"></i>
                        <% if(isVip) { %>
                            <span class="mp-user-badge">
                                <i class="fas fa-crown" style="font-size: 9px;"></i>
                                VIP
                            </span>
                        <% } %>
                    </div>
                    <h3 class="mp-profile-name"><%= loginUser.getMemberName() %></h3>
                    <p class="mp-profile-email">@<%= loginUser.getMemberId() %></p>
                </div>
                
                <!-- Navigation -->
                <nav class="mp-nav-menu">
                    <a href="#overview" class="mp-nav-item active" onclick="showSection('overview', event)">
                        <i class="fas fa-chart-line"></i>개요
                    </a>
                    <a href="#my-items" class="mp-nav-item" onclick="showSection('my-items', event)">
                        <i class="fas fa-tag"></i>내 상품
                    </a>
                    <a href="#bids" class="mp-nav-item" onclick="showSection('bids', event)">
                        <i class="fas fa-gavel"></i>입찰 현황
                    </a>
                    <a href="#won" class="mp-nav-item" onclick="showSection('won', event)">
                        <i class="fas fa-trophy"></i>낙찰 상품
                    </a>
                    <a href="updateMemberForm.jsp" class="mp-nav-item">
                        <i class="fas fa-user-edit"></i>프로필 설정
                    </a>
                    <a href="changePwdForm.jsp" class="mp-nav-item">
                        <i class="fas fa-lock"></i>보안 설정
                    </a>
                    <a href="chargeForm.jsp" class="mp-nav-item">
                        <i class="fas fa-coins"></i>마일리지 충전
                    </a>
                    <% if(isVip) { %>
                    <a href="#vip-benefits" class="mp-nav-item" onclick="showVipOptions(event)">
                        <i class="fas fa-crown"></i>VIP 혜택
                    </a>
                    <% } %>
                </nav>
                
                <!-- VIP Benefits Section (VIP만 표시) -->
                <% if(isVip) { %>
                <div class="mp-vip-section" id="vip-section" style="display: none;">
                    <div class="mp-section-header">
                        <h4>VIP 혜택 선택</h4>
                    </div>
                    <form action="<%= request.getContextPath() %>/mypage/vipOptionRequest.jsp" method="post" class="mp-vip-form-sidebar">
                        <select name="option" class="mp-vip-select-sidebar" required>
                            <option value="">등급 선택</option>
                            <option value="골드">골드 (5% 보너스)</option>
                            <option value="다이아">다이아 (10% 보너스)</option>
                        </select>
                        <button type="submit" class="mp-vip-submit-sidebar">적용</button>
                    </form>
                </div>
                <% } %>
            </aside>

            <!-- Main Content -->
            <main class="mp-main-content">
                <!-- Overview Section -->
                <div id="overview-section" class="mp-content-section">
                    <div class="mp-content-header">
                        <h2 class="mp-mp-content-title">계정 개요</h2>
                        <p class="mp-mp-content-subtitle">경매 활동을 한눈에 확인하세요</p>
                    </div>

                    <div class="mp-content-body">
                        <!-- Stats Grid -->
                        <div class="mp-stats-grid">
                            <div class="mp-stat-card">
                                <div class="mp-stat-header">
                                    <span class="mp-stat-title">보유 마일리지</span>
                                    <div class="mp-stat-icon">
                                        <i class="fas fa-coins"></i>
                                    </div>
                                </div>
                                <div class="mp-stat-value"><%= df.format(loginUser.getMileage()) %><span class="mp-currency-unit">P</span></div>
                                <div class="mp-stat-actions" style="display: flex; gap: 8px; margin-top: 12px;">
                                    <button onclick="window.location.href='chargeForm.jsp'" class="u-flex-1 u-btn-primary">충전</button>
                                    <button onclick="window.location.href='mileageHistory.jsp'" class="u-flex-1 u-btn-secondary">내역</button>
                                </div>
                            </div>
                            
                            <div class="mp-stat-card mp-clickable" onclick="showSection('bids')">
                                <div class="mp-stat-header">
                                    <span class="mp-stat-title">활성 입찰</span>
                                    <div class="mp-stat-icon">
                                        <i class="fas fa-gavel"></i>
                                    </div>
                                </div>
                                <div class="mp-stat-value"><%= myBids.size() %></div>
                                <div class="mp-stat-change">참여 중 • 클릭하여 보기</div>
                            </div>
                            
                            <div class="mp-stat-card mp-clickable" onclick="showSection('won')">
                                <div class="mp-stat-header">
                                    <span class="mp-stat-title">낙찰 성공</span>
                                    <div class="mp-stat-icon">
                                        <i class="fas fa-trophy"></i>
                                    </div>
                                </div>
                                <div class="mp-stat-value"><%= myWonProducts.size() %></div>
                                <div class="mp-stat-change">성공적으로 획득 • 클릭하여 보기</div>
                            </div>
                            
                            <div class="mp-stat-card mp-clickable" onclick="showSection('my-items')">
                                <div class="mp-stat-header">
                                    <span class="mp-stat-title">등록 상품</span>
                                    <div class="mp-stat-icon">
                                        <i class="fas fa-tag"></i>
                                    </div>
                                </div>
                                <div class="mp-stat-value"><%= myProducts.size() %></div>
                                <div class="mp-stat-change">판매 중 • 클릭하여 관리</div>
                            </div>
                        </div>


                        <!-- Recent Activity -->
                        <div class="mp-section">
                            <div class="mp-section-header">
                                <h3 class="mp-section-title">최근 활동</h3>
                                <a href="#bids" class="mp-section-action" onclick="showSection('bids')">모든 입찰 보기 →</a>
                            </div>
                            
                            <% if(!myBids.isEmpty()) { %>
                                <table class="mp-product-table">
                                    <thead>
                                        <tr>
                                            <th style="width: 40%;">상품</th>
                                            <th style="width: 20%;">현재 입찰가</th>
                                            <th style="width: 20%;">상태</th>
                                            <th style="width: 20%;">남은 시간</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% 
                                        int count = 0;
                                        java.util.Date currentTime = new java.util.Date();
                                        for(ProductDTO p : myBids) { 
                                            if(count >= 5) break; // 최대 5개만 미리보기
                                            
                                            // 각 상품의 실제 상태 확인
                                            boolean isActive = false;
                                            String status = "종료";
                                            String statusClass = "ended";
                                            
                                            if (p.getEndTime() != null) {
                                                isActive = p.getEndTime().after(currentTime);
                                                if (isActive) {
                                                    status = "진행중";
                                                    statusClass = "active";
                                                }
                                            }
                                        %>
                                        <tr>
                                            <td>
                                                <div class="mp-product-info">
                                                    <img src="<%= request.getContextPath() %>/resources/product_images/<%= p.getImageRenamedName() %>" 
                                                         alt="<%= p.getProductName() %>" class="mp-product-image">
                                                    <div class="mp-product-details">
                                                        <h4 class="mp-product-name"><%= p.getProductName() %></h4>
                                                        <p><%= p.getArtistName() %></p>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="mp-product-price">₩<%= df.format(p.getCurrentPrice()) %></div>
                                            </td>
                                            <td>
                                                <span class="mp-status-badge mp-status-<%= statusClass %>"><%= status %></span>
                                            </td>
                                            <td>
                                                <div class="mp-auction-timer" data-endtime="<%= p.getEndTime() %>">
                                                    <span class="mp-time-remaining mp-font-mono">로딩중...</span>
                                                </div>
                                            </td>
                                        </tr>
                                        <% 
                                            count++;
                                        } %>
                                    </tbody>
                                </table>
                            <% } else { %>
                                <div class="mp-empty-state">
                                    <i class="fas fa-gavel"></i>
                                    <h3>활성 입찰 없음</h3>
                                    <p>아직 입찰에 참여하지 않았습니다. 경매를 둘러보고 시작해보세요.</p>
                                    <a href="<%= request.getContextPath() %>/index.jsp" class="u-btn-primary">
                                        <i class="fas fa-search"></i>경매 둘러보기
                                    </a>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>

                <!-- My Items Section -->
                <div id="my-items-section" class="mp-content-section" style="display: none;">
                    <div class="mp-content-header">
                        <h2 class="mp-content-title">내 등록 상품</h2>
                        <p class="mp-content-subtitle">경매에 등록한 상품들</p>
                    </div>

                    <div class="mp-content-body">
                        <!-- 상품 등록 버튼 (항상 표시) -->
                        <div class="mp-section-actions">
                            <a href="<%= request.getContextPath() %>/product/productEnrollForm.jsp" class="u-btn-primary">
                                <i class="fas fa-plus"></i>새 상품 등록하기
                            </a>
                        </div>
                        
                        <% if(!myProducts.isEmpty()) { %>
                            <table class="mp-product-table">
                                <thead>
                                    <tr>
                                        <th style="width: 40%;">상품</th>
                                        <th style="width: 20%;">현재 입찰가</th>
                                        <th style="width: 20%;">상태</th>
                                        <th style="width: 20%;">마감</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for(ProductDTO p : myProducts) { %>
                                    <tr>
                                        <td>
                                            <div class="mp-product-info">
                                                <img src="<%= request.getContextPath() %>/resources/product_images/<%= p.getImageRenamedName() %>" 
                                                     alt="<%= p.getProductName() %>" class="mp-product-image">
                                                <div class="mp-product-details">
                                                    <h4><%= p.getProductName() %></h4>
                                                    <p><%= p.getArtistName() %></p>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="mp-product-price">₩<%= df.format(p.getCurrentPrice()) %></div>
                                        </td>
                                        <td>
                                            <span class="mp-status-badge mp-status-active">등록됨</span>
                                        </td>
                                        <td>
                                            <div class="mp-auction-timer" data-endtime="<%= p.getEndTime() %>">
                                                <span class="mp-time-remaining mp-font-mono">Loading...</span>
                                            </div>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        <% } else { %>
                            <div class="mp-empty-state">
                                <i class="fas fa-tag"></i>
                                <h3>등록된 상품 없음</h3>
                                <p>아직 경매에 등록한 상품이 없습니다. 위의 버튼을 클릭하여 첫 상품을 등록해보세요!</p>
                            </div>
                        <% } %>
                    </div>
                </div>

                <!-- Active Bids Section -->
                <div id="bids-section" class="mp-content-section" style="display: none;">
                    <div class="mp-content-header">
                        <h2 class="mp-content-title">활성 입찰</h2>
                        <p class="mp-content-subtitle">현재 참여하고 있는 경매</p>
                    </div>

                    <div class="mp-content-body">
                        <% if(!myBids.isEmpty()) { %>
                            <table class="mp-product-table">
                                <thead>
                                    <tr>
                                        <th style="width: 40%;">상품</th>
                                        <th style="width: 20%;">현재 입찰가</th>
                                        <th style="width: 20%;">상태</th>
                                        <th style="width: 20%;">남은 시간</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for(ProductDTO p : myBids) { %>
                                    <tr>
                                        <td>
                                            <div class="mp-product-info">
                                                <img src="<%= request.getContextPath() %>/resources/product_images/<%= p.getImageRenamedName() %>" 
                                                     alt="<%= p.getProductName() %>" class="mp-product-image">
                                                <div class="mp-product-details">
                                                    <h4><%= p.getProductName() %></h4>
                                                    <p><%= p.getArtistName() %></p>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="mp-product-price">₩<%= df.format(p.getCurrentPrice()) %></div>
                                        </td>
                                        <td>
                                            <span class="mp-status-badge mp-status-active">입찰중</span>
                                        </td>
                                        <td>
                                            <div class="mp-auction-timer" data-endtime="<%= p.getEndTime() %>">
                                                <span class="mp-time-remaining mp-font-mono">Loading...</span>
                                            </div>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        <% } else { %>
                            <div class="mp-empty-state">
                                <i class="fas fa-gavel"></i>
                                <h3>활성 입찰 없음</h3>
                                <p>아직 입찰에 참여하지 않았습니다. 경매를 둘러보고 시작해보세요.</p>
                                <a href="<%= request.getContextPath() %>/index.jsp" class="u-btn-primary">
                                    <i class="fas fa-search"></i>경매 둘러보기
                                </a>
                            </div>
                        <% } %>
                    </div>
                </div>

                <!-- Won Items Section -->
                <div id="won-section" class="mp-content-section" style="display: none;">
                    <div class="mp-content-header">
                        <h2 class="mp-content-title">낙찰 상품</h2>
                        <p class="mp-content-subtitle">성공적으로 획득한 상품들</p>
                    </div>

                    <div class="mp-content-body">
                        <% if(!myWonProducts.isEmpty()) { %>
                            <table class="mp-product-table">
                                <thead>
                                    <tr>
                                        <th style="width: 40%;">상품</th>
                                        <th style="width: 20%;">최종 가격</th>
                                        <th style="width: 20%;">상태</th>
                                        <th style="width: 20%;">낙찰일</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for(ProductDTO p : myWonProducts) { %>
                                    <tr>
                                        <td>
                                            <div class="mp-product-info">
                                                <img src="<%= request.getContextPath() %>/resources/product_images/<%= p.getImageRenamedName() %>" 
                                                     alt="<%= p.getProductName() %>" class="mp-product-image">
                                                <div class="mp-product-details">
                                                    <h4><%= p.getProductName() %></h4>
                                                    <p><%= p.getArtistName() %></p>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="mp-product-price">₩<%= df.format(p.getFinalPrice()) %></div>
                                        </td>
                                        <td>
                                            <span class="mp-status-badge mp-status-sold">낙찰</span>
                                        </td>
                                        <td>
                                            <span class="mp-font-mono">최근</span>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        <% } else { %>
                            <div class="mp-empty-state">
                                <i class="fas fa-trophy"></i>
                                <h3>낙찰 상품 없음</h3>
                                <p>아직 낙찰받은 상품이 없습니다. 계속 입찰하여 원하는 상품을 획득하세요!</p>
                                <a href="<%= request.getContextPath() %>/index.jsp" class="u-btn-primary">
                                    <i class="fas fa-gavel"></i>경매 참여하기
                                </a>
                            </div>
                        <% } %>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Footer -->
    <jsp:include page="/layout/footer/luxury-footer.jsp" />
    
    <% if(alertMsg != null) { 
        session.removeAttribute("alertMsg");
    %>
    <script>
        alert("<%= alertMsg %>");
    </script>
    <% } %>
    
    <script>
        // VIP Options Toggle
        function showVipOptions(event) {
            event.preventDefault();
            const vipSection = document.getElementById('vip-section');
            if (vipSection.style.display === 'none') {
                vipSection.style.display = 'block';
            } else {
                vipSection.style.display = 'none';
            }
        }
        
        // Section Navigation
        function showSection(sectionName, event) {
            // Prevent default action if event exists
            if (event) {
                event.preventDefault();
            }
            
            // Hide all sections
            document.querySelectorAll('.mp-content-section').forEach(section => {
                section.style.display = 'none';
            });
            
            // Remove active class from all nav items
            document.querySelectorAll('.mp-nav-item').forEach(item => {
                item.classList.remove('active');
            });
            
            // Show selected section
            const targetSection = document.getElementById(sectionName + '-section');
            if (targetSection) {
                targetSection.style.display = 'block';
            }
            
            // Add active class to corresponding nav item
            const navItems = document.querySelectorAll('.mp-nav-item');
            navItems.forEach(item => {
                const href = item.getAttribute('href');
                if (href && href.includes('#' + sectionName)) {
                    item.classList.add('active');
                }
            });
        }

        // Real-time Auction Timer
        function updateAuctionTimers() {
            const timers = document.querySelectorAll('.mp-auction-timer');
            
            timers.forEach(timer => {
                const endTime = new Date(timer.dataset.endtime);
                const now = new Date();
                const diff = endTime - now;
                
                const timeSpan = timer.querySelector('.mp-time-remaining');
                
                if (diff > 0) {
                    const days = Math.floor(diff / (1000 * 60 * 60 * 24));
                    const hours = Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                    const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
                    
                    let timeText = '';
                    if (days > 0) {
                        timeText = `${days}d ${hours}h`;
                    } else if (hours > 0) {
                        timeText = `${hours}h ${minutes}m`;
                    } else {
                        timeText = `${minutes}m`;
                    }
                    
                    timeSpan.textContent = timeText;
                    
                    // Change status based on time remaining
                    const statusElement = timer.closest('tr')?.querySelector('.mp-status-badge');
                    if (statusElement && hours < 1) {
                        statusElement.className = 'mp-status-badge mp-status-waiting';
                        statusElement.textContent = '곧 마감';
                    }
                } else {
                    timeSpan.textContent = '종료';
                    timer.style.color = '#6b7280';
                    
                    // 서버에서 이미 올바른 상태를 설정했으므로 JavaScript에서는 상태를 변경하지 않음
                    // const statusElement = timer.closest('tr')?.querySelector('.mp-status-badge');
                    // if (statusElement) {
                    //     statusElement.className = 'mp-status-badge mp-status-sold';
                    //     statusElement.textContent = '종료';
                    // }
                }
            });
        }

        // Initialize
        document.addEventListener('DOMContentLoaded', function() {
            // Start timers
            updateAuctionTimers();
            setInterval(updateAuctionTimers, 60000); // Update every minute
            
            // Handle navigation
            document.querySelectorAll('.mp-nav-item[onclick]').forEach(item => {
                item.addEventListener('click', function(e) {
                    e.preventDefault();
                });
            });
        });
    </script>
</body>
</html>