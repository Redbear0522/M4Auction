<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="com.auction.dto.MemberDTO" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %>
<%
    // 관리자 권한 체크
    MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");
    if(loginUser == null || !"admin".equals(loginUser.getMemberId())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    
    String ctx = request.getContextPath();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
    DecimalFormat df = new DecimalFormat("###,###,###");
    
    // 수동 종료 처리
    String action = request.getParameter("action");
    if("close".equals(action)) {
        int productId = Integer.parseInt(request.getParameter("productId"));
        Connection conn = getConnection();
        
        try {
            // 강제로 종료 시간을 현재 시간으로 변경
            String sql = "UPDATE PRODUCT SET END_TIME = SYSDATE WHERE PRODUCT_ID = ? AND STATUS = 'A'";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, productId);
            int result = pstmt.executeUpdate();
            pstmt.close();
            
            if(result > 0) {
                session.setAttribute("alertMsg", "경매가 수동으로 종료 처리되었습니다. 스케줄러가 곧 처리합니다.");
            }
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            close(conn);
        }
        
        response.sendRedirect("auctionManage.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>경매 관리 - M4 Auction Admin</title>
    
    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    
    <!-- Global Styles -->
    <link rel="stylesheet" href="<%=ctx%>/resources/css/luxury-global-style.css">
    
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background: #f8f9fa;
            padding-top: 120px !important;
        }
        
        .admin-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 32px 24px;
        }
        
        .admin-header {
            margin-bottom: 32px;
        }
        
        .admin-title {
            font-size: 32px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 8px;
        }
        
        .admin-subtitle {
            color: #6b7280;
            font-size: 16px;
        }
        
        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 24px;
            margin-bottom: 48px;
        }
        
        .stat-card {
            background: white;
            border: 2px solid #e5e7eb;
            padding: 24px;
            border-radius: 0;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        
        .stat-label {
            font-size: 14px;
            color: #6b7280;
            font-weight: 500;
            margin-bottom: 8px;
        }
        
        .stat-value {
            font-size: 32px;
            font-weight: 700;
            color: #1a1a1a;
        }
        
        /* Table Section */
        .table-section {
            background: white;
            border: 2px solid #e5e7eb;
            border-radius: 0;
            overflow: hidden;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        
        .table-header {
            padding: 24px;
            border-bottom: 2px solid #e5e7eb;
        }
        
        .table-title {
            font-size: 20px;
            font-weight: 600;
            color: #1a1a1a;
        }
        
        .auction-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .auction-table th {
            text-align: left;
            padding: 16px 24px;
            font-size: 12px;
            font-weight: 700;
            color: #6b7280;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            background: #f9fafb;
            border-bottom: 2px solid #e5e7eb;
        }
        
        .auction-table td {
            padding: 16px 24px;
            border-bottom: 1px solid #f3f4f6;
            vertical-align: middle;
        }
        
        .auction-table tr:hover {
            background: #f9fafb;
        }
        
        .product-info {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .product-image {
            width: 48px;
            height: 48px;
            object-fit: cover;
            border-radius: 4px;
        }
        
        .product-details h4 {
            font-size: 14px;
            font-weight: 600;
            color: #1a1a1a;
            margin: 0 0 4px 0;
        }
        
        .product-details p {
            font-size: 12px;
            color: #6b7280;
            margin: 0;
        }
        
        .status-badge {
            display: inline-block;
            padding: 4px 8px;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border: 2px solid;
        }
        
        .status-active {
            background: #000;
            color: #fff;
            border-color: #000;
        }
        
        .status-ended {
            background: #fff;
            color: #666;
            border-color: #666;
        }
        
        .status-failed {
            background: #fee;
            color: #c00;
            border-color: #c00;
        }
        
        .action-btn {
            padding: 6px 12px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            background: #1a1a1a;
            color: white;
            border: 2px solid #1a1a1a;
            cursor: pointer;
            transition: all 0.2s ease;
            text-decoration: none;
            display: inline-block;
        }
        
        .action-btn:hover {
            background: #c9961a;
            border-color: #c9961a;
        }
        
        .action-btn:disabled {
            background: #e5e7eb;
            border-color: #e5e7eb;
            color: #9ca3af;
            cursor: not-allowed;
        }
        
        .time-remaining {
            font-family: monospace;
            font-size: 13px;
            color: #6b7280;
        }
        
        .alert {
            padding: 16px 20px;
            margin-bottom: 24px;
            background: #fef3c7;
            border: 2px solid #fbbf24;
            color: #92400e;
            font-weight: 500;
        }
    </style>
</head>
<body>
    <jsp:include page="/layout/header/luxury-header.jsp" />
    
    <div class="admin-container">
        <div class="admin-header">
            <h1 class="admin-title">경매 관리</h1>
            <p class="admin-subtitle">진행 중인 경매를 관리하고 수동으로 종료할 수 있습니다</p>
        </div>
        
        <% if(session.getAttribute("alertMsg") != null) { %>
        <div class="alert">
            <%= session.getAttribute("alertMsg") %>
            <% session.removeAttribute("alertMsg"); %>
        </div>
        <% } %>
        
        <!-- 통계 카드 -->
        <div class="stats-grid">
            <%
                Connection conn = getConnection();
                try {
                    // 진행중인 경매
                    String activeSql = "SELECT COUNT(*) FROM PRODUCT WHERE STATUS = 'A'";
                    PreparedStatement activePstmt = conn.prepareStatement(activeSql);
                    ResultSet activeRs = activePstmt.executeQuery();
                    int activeCount = 0;
                    if(activeRs.next()) activeCount = activeRs.getInt(1);
                    activeRs.close(); activePstmt.close();
                    
                    // 종료된 경매
                    String endedSql = "SELECT COUNT(*) FROM PRODUCT WHERE STATUS = 'E'";
                    PreparedStatement endedPstmt = conn.prepareStatement(endedSql);
                    ResultSet endedRs = endedPstmt.executeQuery();
                    int endedCount = 0;
                    if(endedRs.next()) endedCount = endedRs.getInt(1);
                    endedRs.close(); endedPstmt.close();
                    
                    // 마감 임박 (1시간 이내)
                    String soonSql = "SELECT COUNT(*) FROM PRODUCT WHERE STATUS = 'A' AND END_TIME <= SYSDATE + 1/24";
                    PreparedStatement soonPstmt = conn.prepareStatement(soonSql);
                    ResultSet soonRs = soonPstmt.executeQuery();
                    int soonCount = 0;
                    if(soonRs.next()) soonCount = soonRs.getInt(1);
                    soonRs.close(); soonPstmt.close();
            %>
            <div class="stat-card">
                <div class="stat-label">진행 중인 경매</div>
                <div class="stat-value"><%= activeCount %></div>
            </div>
            <div class="stat-card">
                <div class="stat-label">종료된 경매</div>
                <div class="stat-value"><%= endedCount %></div>
            </div>
            <div class="stat-card">
                <div class="stat-label">마감 임박 (1시간)</div>
                <div class="stat-value"><%= soonCount %></div>
            </div>
            <%
                } catch(Exception e) {
                    e.printStackTrace();
                }
            %>
        </div>
        
        <!-- 경매 목록 테이블 -->
        <div class="table-section">
            <div class="table-header">
                <h2 class="table-title">진행 중인 경매 목록</h2>
            </div>
            
            <table class="auction-table">
                <thead>
                    <tr>
                        <th>상품정보</th>
                        <th>현재가</th>
                        <th>입찰수</th>
                        <th>남은시간</th>
                        <th>상태</th>
                        <th>관리</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try {
                            String sql = 
                                "SELECT P.*, " +
                                "(SELECT COUNT(*) FROM BID WHERE PRODUCT_ID = P.PRODUCT_ID) AS BID_COUNT " +
                                "FROM PRODUCT P " +
                                "WHERE P.STATUS = 'A' " +
                                "ORDER BY P.END_TIME ASC";
                            
                            PreparedStatement pstmt = conn.prepareStatement(sql);
                            ResultSet rs = pstmt.executeQuery();
                            
                            while(rs.next()) {
                                int productId = rs.getInt("PRODUCT_ID");
                                String productName = rs.getString("PRODUCT_NAME");
                                String artistName = rs.getString("ARTIST_NAME");
                                int currentPrice = rs.getInt("CURRENT_PRICE");
                                if(currentPrice == 0) currentPrice = rs.getInt("START_PRICE");
                                Timestamp endTime = rs.getTimestamp("END_TIME");
                                int bidCount = rs.getInt("BID_COUNT");
                                String imageRenamedName = rs.getString("IMAGE_RENAMED_NAME");
                                
                                // 남은 시간 계산
                                long remainingMs = endTime.getTime() - System.currentTimeMillis();
                                boolean isExpired = remainingMs <= 0;
                    %>
                    <tr>
                        <td>
                            <div class="product-info">
                                <img src="<%=ctx%>/resources/product_images/<%=imageRenamedName%>" 
                                     alt="<%=productName%>" class="product-image">
                                <div class="product-details">
                                    <h4><%=productName%></h4>
                                    <p><%=artistName%></p>
                                </div>
                            </div>
                        </td>
                        <td>₩<%=df.format(currentPrice)%></td>
                        <td><%=bidCount%>회</td>
                        <td>
                            <% if(isExpired) { %>
                                <span class="time-remaining" style="color: #ef4444;">종료 대기중</span>
                            <% } else { %>
                                <span class="time-remaining" data-endtime="<%=endTime%>">계산중...</span>
                            <% } %>
                        </td>
                        <td>
                            <span class="status-badge status-active">진행중</span>
                        </td>
                        <td>
                            <a href="?action=close&productId=<%=productId%>" 
                               class="action-btn"
                               onclick="return confirm('이 경매를 수동으로 종료하시겠습니까?');">
                                수동 종료
                            </a>
                        </td>
                    </tr>
                    <%
                            }
                            rs.close();
                            pstmt.close();
                        } catch(Exception e) {
                            e.printStackTrace();
                        } finally {
                            close(conn);
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
    
    <jsp:include page="/layout/footer/luxury-footer.jsp" />
    
    <script>
        // 실시간 남은 시간 업데이트
        function updateRemainingTimes() {
            document.querySelectorAll('.time-remaining[data-endtime]').forEach(el => {
                const endTime = new Date(el.dataset.endtime);
                const now = new Date();
                const diff = endTime - now;
                
                if(diff > 0) {
                    const hours = Math.floor(diff / (1000 * 60 * 60));
                    const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
                    const seconds = Math.floor((diff % (1000 * 60)) / 1000);
                    
                    if(hours > 24) {
                        const days = Math.floor(hours / 24);
                        el.textContent = `${days}일 ${hours % 24}시간`;
                    } else if(hours > 0) {
                        el.textContent = `${hours}시간 ${minutes}분`;
                    } else if(minutes > 0) {
                        el.textContent = `${minutes}분 ${seconds}초`;
                    } else {
                        el.textContent = `${seconds}초`;
                    }
                    
                    // 1시간 미만이면 빨간색
                    if(diff < 3600000) {
                        el.style.color = '#ef4444';
                    }
                } else {
                    el.textContent = '종료 대기중';
                    el.style.color = '#ef4444';
                }
            });
        }
        
        // 1초마다 업데이트
        updateRemainingTimes();
        setInterval(updateRemainingTimes, 1000);
    </script>
</body>
</html>