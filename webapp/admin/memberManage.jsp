<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.auction.dto.MemberDTO" %>
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

    // 검색 파라미터
    String filter = request.getParameter("filter");
    String keyword = request.getParameter("keyword");
    
    if (filter == null) filter = "all";
    if (keyword == null) keyword = "";

    // 데이터 조회
    List<MemberDTO> memberList = new java.util.ArrayList<>();
    int totalMembers = 0;
    int todayJoins = 0;
    int vipMembers = 0;
    
    Connection conn = null;
    try {
        conn = getConnection();
        AdminDAO aDao = new AdminDAO();
        
        // 통계 데이터
        totalMembers = aDao.getTotalMemberCount(conn);
        todayJoins = aDao.getTodayJoinCount(conn);
        vipMembers = aDao.getVipMemberCount(conn);
        
        // 회원 목록 조회
        if ("vip".equals(filter)) {
            memberList = aDao.getVipMembers(conn);
        } else if (!"".equals(keyword)) {
            memberList = aDao.searchMembers(conn, keyword);
        } else {
            memberList = aDao.getAllMembers(conn);
        }
        
    } catch(Exception e) {
        e.printStackTrace();
        // 오류 발생 시 빈 리스트 사용
        memberList = new java.util.ArrayList<>();
    } finally {
        if(conn != null) close(conn);
    }

    DecimalFormat df = new DecimalFormat("###,###,###");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원 관리 - M4 Auction</title>
    
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
        
        .filter-form {
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
        
        .members-table {
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
        
        .table-count {
            font-size: 14px;
            color: #6b7280;
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
        
        .member-info {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .member-avatar {
            width: 40px;
            height: 40px;
            background: #f3f4f6;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #6b7280;
            font-size: 16px;
        }
        
        .member-details h4 {
            font-size: 14px;
            font-weight: 600;
            color: #1a1a1a;
            margin: 0 0 2px 0;
        }
        
        .member-details p {
            font-size: 12px;
            color: #6b7280;
            margin: 0;
        }
        
        .member-badge {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            background: #c9961a;
            color: white;
            font-size: 10px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            padding: 4px 8px;
            border-radius: 12px;
        }
        
        .mileage-amount {
            font-weight: 600;
            color: #c9961a;
        }
        
        .join-date {
            font-family: monospace;
            font-size: 13px;
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
            
            .stats-grid {
                grid-template-columns: 1fr 1fr;
            }
            
            .filter-form {
                flex-direction: column;
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
                <li><a href="<%=request.getContextPath()%>/admin/memberManage.jsp" class="active">
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
                <h1 class="page-title">회원 관리</h1>
                <p class="page-subtitle">등록된 회원들을 관리하고 모니터링합니다</p>
            </div>
            
            <!-- 통계 카드 -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="stat-value"><%=df.format(totalMembers)%></div>
                    <div class="stat-label">전체 회원</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-user-plus"></i>
                    </div>
                    <div class="stat-value"><%=df.format(todayJoins)%></div>
                    <div class="stat-label">오늘 가입</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-crown"></i>
                    </div>
                    <div class="stat-value"><%=df.format(vipMembers)%></div>
                    <div class="stat-label">VIP 회원</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-percentage"></i>
                    </div>
                    <div class="stat-value"><%=totalMembers > 0 ? Math.round((double)vipMembers / totalMembers * 100) : 0%>%</div>
                    <div class="stat-label">VIP 비율</div>
                </div>
            </div>
            
            <!-- 필터 섹션 -->
            <div class="filter-section">
                <form class="filter-form" method="get">
                    <div class="filter-group">
                        <span class="filter-label">필터</span>
                        <select class="filter-select" name="filter">
                            <option value="all" <%="all".equals(filter) ? "selected" : ""%>>전체 회원</option>
                            <option value="vip" <%="vip".equals(filter) ? "selected" : ""%>>VIP 회원만</option>
                        </select>
                    </div>
                    <div class="filter-group">
                        <span class="filter-label">검색</span>
                        <input type="text" class="filter-input" name="keyword" value="<%=keyword%>" placeholder="회원ID, 이름, 이메일 검색">
                    </div>
                    <button type="submit" class="filter-btn">
                        <i class="fas fa-search"></i> 검색
                    </button>
                    <% if (!"".equals(keyword) || !"all".equals(filter)) { %>
                    <a href="<%=request.getContextPath()%>/admin/memberManage.jsp" class="filter-btn" style="background: #6b7280; text-decoration: none;">
                        <i class="fas fa-times"></i> 초기화
                    </a>
                    <% } %>
                </form>
            </div>
            
            <!-- 회원 목록 -->
            <div class="members-table">
                <div class="table-header">
                    <h2 class="table-title">
                        <% if ("vip".equals(filter)) { %>
                            VIP 회원 목록
                        <% } else if (!"".equals(keyword)) { %>
                            검색 결과
                        <% } else { %>
                            전체 회원 목록
                        <% } %>
                    </h2>
                    <div class="table-count">총 <%=memberList.size()%>명</div>
                </div>
                
                <% if (memberList.isEmpty()) { %>
                <div class="empty-state">
                    <i class="fas fa-users"></i>
                    <h3>
                        <% if (!"".equals(keyword)) { %>
                            검색 결과가 없습니다
                        <% } else { %>
                            회원이 없습니다
                        <% } %>
                    </h3>
                    <p>
                        <% if (!"".equals(keyword)) { %>
                            다른 검색어로 시도해보세요.
                        <% } else { %>
                            등록된 회원이 없습니다.
                        <% } %>
                    </p>
                </div>
                <% } else { %>
                <table>
                    <thead>
                        <tr>
                            <th>회원 정보</th>
                            <th>연락처</th>
                            <th>마일리지</th>
                            <th>가입일</th>
                            <th>상태</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (MemberDTO member : memberList) { %>
                        <tr>
                            <td>
                                <div class="member-info">
                                    <div class="member-avatar">
                                        <i class="fas fa-user"></i>
                                    </div>
                                    <div class="member-details">
                                        <h4><%=member.getMemberName()%> <% if (member.isVip()) { %><span class="member-badge"><i class="fas fa-crown"></i> VIP</span><% } %></h4>
                                        <p>@<%=member.getMemberId()%></p>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <div><%=member.getEmail()%></div>
                                <div style="font-size: 12px; color: #6b7280; margin-top: 2px;"><%=member.getTel() != null ? member.getTel() : "-"%></div>
                            </td>
                            <td>
                                <span class="mileage-amount">₩<%=df.format(member.getMileage())%></span>
                            </td>
                            <td>
                                <span class="join-date"><%=sdf.format(member.getEnrollDate())%></span>
                            </td>
                            <td>
                                <span style="color: #10b981; font-weight: 600;">활성</span>
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
        // 현재 페이지 사이드바 활성화
        document.addEventListener('DOMContentLoaded', function() {
            const currentPath = window.location.pathname;
            const menuItems = document.querySelectorAll('.sidebar-menu a');
            
            menuItems.forEach(item => {
                item.classList.remove('active');
                if (item.getAttribute('href').includes('memberManage.jsp')) {
                    item.classList.add('active');
                }
            });
        });
    </script>
</body>
</html>