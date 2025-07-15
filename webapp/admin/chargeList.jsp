<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="com.auction.dao.AdminDAO" %>
<%@ page import="com.auction.dto.ChargeRequestDTO" %>
<%@ page import="com.auction.dto.MemberDTO" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %>
<%
    // 관리자 로그인 체크
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null || !"admin".equals(loginUser.getMemberId())) {
        session.setAttribute("alertMsg", "관리자 로그인 후 이용 가능한 서비스입니다.");
        response.sendRedirect(request.getContextPath() + "/member/loginForm.jsp");
        return;
    }
    
    String ctx = request.getContextPath();
    Connection conn = getConnection();
    List<ChargeRequestDTO> list = new AdminDAO().getAllChargeRequests(conn);
    close(conn);
    
    DecimalFormat df = new DecimalFormat("###,###");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>마일리지 충전 관리 - M4 Auction</title>
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
        
        .charge-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        
        .charge-table th {
            background: #c9961a;
            color: white;
            padding: 16px;
            text-align: center;
            font-weight: 600;
            font-size: 14px;
        }
        
        .charge-table td {
            padding: 16px;
            text-align: center;
            border-bottom: 1px solid #f0f0f0;
            font-size: 14px;
        }
        
        .charge-table tbody tr:hover {
            background: #f8f9fa;
        }
        
        .status-badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .status-waiting {
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
        
        .amount-text {
            font-weight: 600;
            color: #c9961a;
        }
    </style>
    <script>
        function processCharge(reqId, action) {
            const actionText = action === 'approve' ? '승인' : '거부';
            if(confirm(actionText + ' 처리하시겠습니까?')) {
                location.href = "chargeAction.jsp?reqId=" + reqId + "&action=" + action;
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
            <li><a href="<%=ctx%>/admin/chargeList.jsp" class="active"><i class="fas fa-credit-card"></i> 충전관리</a></li>
            <li><a href="<%=ctx%>/admin/vipRequestList.jsp"><i class="fas fa-crown"></i> VIP 신청관리</a></li>
            <li><a href="<%=ctx%>/admin/siteStatistics.jsp"><i class="fas fa-chart-bar"></i> 통계</a></li>
        </ul>
    </div>

    <!-- 메인 컨텐츠 -->
    <div class="admin-content">
        <h1 class="page-title">마일리지 충전 관리</h1>
        
        <% if(list.isEmpty()) { %>
            <div class="empty-state">
                <i class="fas fa-credit-card"></i>
                <h3>충전 요청 내역이 없습니다</h3>
                <p>현재 처리할 충전 요청이 없습니다.</p>
            </div>
        <% } else { %>
            <table class="charge-table">
                <thead>
                    <tr>
                        <th>요청번호</th>
                        <th>회원 ID</th>
                        <th>충전금액</th>
                        <th>상태</th>
                        <th>요청일</th>
                        <th>승인일</th>
                        <th>처리</th>
                    </tr>
                </thead>
                <tbody>
                    <% for(ChargeRequestDTO dto : list) { %>
                    <tr>
                        <td>#<%= dto.getReqId() %></td>
                        <td><%= dto.getMemberId() %></td>
                        <td class="amount-text">₩ <%= df.format(dto.getAmount()) %></td>
                        <td>
                            <% if("W".equals(dto.getStatus())) { %>
                                <span class="status-badge status-waiting">대기중</span>
                            <% } else if("A".equals(dto.getStatus())) { %>
                                <span class="status-badge status-approved">승인</span>
                            <% } else if("R".equals(dto.getStatus())) { %>
                                <span class="status-badge status-rejected">거부</span>
                            <% } else { %>
                                <span class="status-badge"><%= dto.getStatus() %></span>
                            <% } %>
                        </td>
                        <td><%= dto.getRequestDate() %></td>
                        <td><%= dto.getApproveDate() == null ? "-" : dto.getApproveDate() %></td>
                        <td>
                            <% if("W".equals(dto.getStatus())) { %>
                                <button class="btn-approve" onclick="processCharge(<%= dto.getReqId() %>, 'approve')">
                                    <i class="fas fa-check"></i> 승인
                                </button>
                                <button class="btn-reject" onclick="processCharge(<%= dto.getReqId() %>, 'reject')">
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
