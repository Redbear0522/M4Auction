<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %>
<%@ page import="com.auction.dto.MemberDTO" %>
<%
    // 관리자 로그인 체크
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null || !"admin".equals(loginUser.getMemberId())) {
        session.setAttribute("alertMsg", "관리자 로그인 후 이용 가능한 서비스입니다.");
        response.sendRedirect(request.getContextPath() + "/member/loginForm.jsp");
        return;
    }
    
    String ctx = request.getContextPath();

    class VipRequest {
        public int requestId;
        public String memberId;
        public String optionName;
        public Date requestDate;
        public String status;
    }

    List<VipRequest> list = new ArrayList<>();

    Connection conn = getConnection();
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        String sql = "SELECT REQUEST_ID, MEMBER_ID, OPTION_NAME, REQUEST_DATE, STATUS FROM VIP_OPTION_REQUEST ORDER BY REQUEST_DATE DESC";
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();

        while(rs.next()) {
            VipRequest vr = new VipRequest();
            vr.requestId = rs.getInt("REQUEST_ID");
            vr.memberId = rs.getString("MEMBER_ID");
            vr.optionName = rs.getString("OPTION_NAME");
            vr.requestDate = rs.getDate("REQUEST_DATE");
            vr.status = rs.getString("STATUS");
            list.add(vr);
        }

    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        close(rs);
        close(pstmt);
        close(conn);
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>VIP 신청 관리 - M4 Auction</title>
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Noto+Sans+KR:wght@300;400;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%=ctx%>/resources/css/luxury-global-style.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
<style>
    body { margin:0; padding:0; font-family: 'Noto Sans KR', sans-serif; background:#f8f8f8; padding-top: 120px !important;}
    .admin-layout { display: flex; max-width: 1400px; margin: 0 auto; gap: 30px; padding: 40px 20px; }
    .admin-sidebar { width: 280px; background: white; border-radius: 12px; box-shadow: 0 4px 16px rgba(0,0,0,0.08); padding: 0; position: sticky; top: 140px; height: fit-content; }
    .sidebar-header { background: linear-gradient(135deg, #1a1a1a 0%, #c9961a 100%); color: white; padding: 24px; border-radius: 12px 12px 0 0; text-align: center; }
    .sidebar-title { font-family: 'Playfair Display', serif; font-size: 20px; font-weight: 700; margin: 0; }
    .sidebar-subtitle { font-size: 13px; opacity: 0.9; margin-top: 4px; }
    .sidebar-menu { padding: 0; margin: 0; list-style: none; }
    .sidebar-menu li { border-bottom: 1px solid #f0f0f0; }
    .sidebar-menu li:last-child { border-bottom: none; }
    .sidebar-menu a { display: flex; align-items: center; gap: 12px; padding: 16px 24px; color: #333; text-decoration: none; transition: all 0.3s; font-size: 14px; font-weight: 500; }
    .sidebar-menu a:hover { background: #f8f9fa; color: #c9961a; }
    .sidebar-menu a.active { background: #c9961a; color: white; }
    .sidebar-menu i { width: 18px; text-align: center; }
    .admin-content { flex: 1; background: white; border-radius: 12px; box-shadow: 0 4px 16px rgba(0,0,0,0.08); padding: 40px; }
    
    .page-title { font-family: 'Playfair Display', serif; font-size: 32px; color: #1a1a1a; margin-bottom: 30px; }
    
    .vip-table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
        background: white;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 2px 8px rgba(0,0,0,0.05);
    }
    
    .vip-table th {
        background: #c9961a;
        color: white;
        padding: 16px;
        text-align: center;
        font-weight: 600;
        font-size: 14px;
    }
    
    .vip-table td {
        padding: 16px;
        text-align: center;
        border-bottom: 1px solid #f0f0f0;
        font-size: 14px;
    }
    
    .vip-table tbody tr:hover {
        background: #f8f9fa;
    }
    
    .status-badge {
        padding: 4px 12px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 600;
        text-transform: uppercase;
    }
    
    .status-pending {
        background: #fff3cd;
        color: #856404;
    }
    
    .status-approved {
        background: #d1edff;
        color: #0c5460;
    }
    
    .status-rejected {
        background: #f8d7da;
        color: #721c24;
    }
    
    .btn-approve, .btn-reject {
        border: none;
        padding: 8px 16px;
        border-radius: 4px;
        cursor: pointer;
        font-size: 12px;
        font-weight: 600;
        margin: 0 4px;
        transition: all 0.3s;
    }
    
    .btn-approve {
        background: #28a745;
        color: white;
    }
    
    .btn-approve:hover {
        background: #218838;
    }
    
    .btn-reject {
        background: #dc3545;
        color: white;
    }
    
    .btn-reject:hover {
        background: #c82333;
    }
    
    .empty-state {
        text-align: center;
        padding: 60px 20px;
        color: #999;
    }
    
    .empty-state i {
        font-size: 48px;
        margin-bottom: 16px;
        display: block;
        opacity: 0.5;
    }
</style>
<script>
    function processRequest(requestId, action) {
        const actionText = action === 'approve' ? '승인' : '거부';
        if(confirm(actionText + ' 처리하시겠습니까?')) {
            location.href = "vipRequestProcess.jsp?requestId=" + requestId + "&action=" + action;
        }
    }
</script>
</head>
<body>
<jsp:include page="/layout/header/luxury-header.jsp" />

<div class="admin-layout">
    <!-- 사이드바 -->
    <div class="admin-sidebar">
        <div class="sidebar-header">
            <h2 class="sidebar-title">Admin Panel</h2>
            <p class="sidebar-subtitle">관리자 도구</p>
        </div>
        <ul class="sidebar-menu">
            <li><a href="<%=ctx%>/admin/adminPage.jsp"><i class="fas fa-tachometer-alt"></i> 대시보드</a></li>
            <li><a href="<%=ctx%>/admin/allProduct.jsp"><i class="fas fa-box"></i> 전체상품관리</a></li>
            <li><a href="<%=ctx%>/admin/waittingProduct.jsp"><i class="fas fa-clock"></i> 승인대기상품</a></li>
            <li><a href="<%=ctx%>/admin/auctionManage.jsp"><i class="fas fa-gavel"></i> 경매관리</a></li>
            <li><a href="<%=ctx%>/admin/memberManage.jsp"><i class="fas fa-users"></i> 회원관리</a></li>
            <li><a href="<%=ctx%>/admin/chargeList.jsp"><i class="fas fa-credit-card"></i> 충전관리</a></li>
            <li><a href="<%=ctx%>/admin/vipRequestList.jsp" class="active"><i class="fas fa-crown"></i> VIP 신청관리</a></li>
            <li><a href="<%=ctx%>/admin/siteStatistics.jsp"><i class="fas fa-chart-bar"></i> 통계</a></li>
        </ul>
    </div>

    <!-- 메인 컨텐츠 -->
    <div class="admin-content">
        <h1 class="page-title">VIP 신청 관리</h1>
        
        <% if(list.isEmpty()) { %>
            <div class="empty-state">
                <i class="fas fa-crown"></i>
                <h3>VIP 신청 내역이 없습니다</h3>
                <p>현재 처리할 VIP 신청이 없습니다.</p>
            </div>
        <% } else { %>
            <table class="vip-table">
                <thead>
                    <tr>
                        <th>요청 ID</th>
                        <th>회원 ID</th>
                        <th>옵션명</th>
                        <th>신청일</th>
                        <th>상태</th>
                        <th>처리</th>
                    </tr>
                </thead>
                <tbody>
                    <% for(VipRequest vr : list) { %>
                    <tr>
                        <td>#<%= vr.requestId %></td>
                        <td><%= vr.memberId %></td>
                        <td><%= vr.optionName %></td>
                        <td><%= vr.requestDate %></td>
                        <td>
                            <% if("PENDING".equals(vr.status)) { %>
                                <span class="status-badge status-pending">대기중</span>
                            <% } else if("APPROVED".equals(vr.status)) { %>
                                <span class="status-badge status-approved">승인</span>
                            <% } else if("REJECTED".equals(vr.status)) { %>
                                <span class="status-badge status-rejected">거부</span>
                            <% } else { %>
                                <span class="status-badge"><%= vr.status %></span>
                            <% } %>
                        </td>
                        <td>
                            <% if("PENDING".equals(vr.status)) { %>
                                <button class="btn-approve" onclick="processRequest(<%= vr.requestId %>, 'approve')">
                                    <i class="fas fa-check"></i> 승인
                                </button>
                                <button class="btn-reject" onclick="processRequest(<%= vr.requestId %>, 'reject')">
                                    <i class="fas fa-times"></i> 거부
                                </button>
                            <% } else { %>
                                <span style="color: #999;">처리완료</span>
                            <% } %>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
</div>

<jsp:include page="/layout/footer/luxury-footer.jsp" />
</body>
</html>