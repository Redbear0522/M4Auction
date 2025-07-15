<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.auction.dto.ChargeRequestDTO" %>
<%@ page import="com.auction.dto.MemberDTO" %>
<%@ page import="com.auction.dao.AdminDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
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
    List<ChargeRequestDTO> chargeList = new ArrayList<>();
    Connection conn = null;
    try {
        conn = getConnection();
        AdminDAO aDao = new AdminDAO();
        chargeList = aDao.getAllChargeRequests(conn);
    } catch(Exception e) {
        e.printStackTrace();
        // 테이블이 없거나 에러 발생 시 빈 리스트 사용
        chargeList = new ArrayList<>();
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
    <title>마일리지 충전 관리 - M4 Auction</title>
    
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
        
        .charge-table {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        
        .table-header {
            background: #f9fafb;
            padding: 20px 24px;
            border-bottom: 2px solid #e5e7eb;
        }
        
        .table-title {
            font-size: 18px;
            font-weight: 700;
            color: #1a1a1a;
            margin: 0;
        }
        
        .table-stats {
            font-size: 14px;
            color: #6b7280;
            margin-top: 4px;
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
        
        .status-badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .status-pending {
            background: #fef3c7;
            color: #92400e;
        }
        
        .status-approved {
            background: #d1fae5;
            color: #065f46;
        }
        
        .status-rejected {
            background: #fee2e2;
            color: #991b1b;
        }
        
        .amount {
            font-weight: 600;
            color: #c9961a;
            font-size: 15px;
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
        
        .pagination {
            display: flex;
            justify-content: center;
            gap: 8px;
            margin-top: 32px;
        }
        
        .pagination a {
            padding: 10px 16px;
            background: white;
            border: 2px solid #e5e7eb;
            color: #6b7280;
            text-decoration: none;
            border-radius: 6px;
            font-weight: 500;
            transition: all 0.3s;
        }
        
        .pagination a:hover,
        .pagination a.active {
            background: #1a1a1a;
            color: white;
            border-color: #1a1a1a;
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
            
            .filter-row {
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
                <li><a href="<%=request.getContextPath()%>/admin/chargeRequestList.jsp" class="active">
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
                <h1 class="page-title">마일리지 충전 관리</h1>
                <p class="page-subtitle">회원들의 마일리지 충전 요청을 관리합니다</p>
            </div>
            
            <!-- 필터 섹션 -->
            <div class="filter-section">
                <div class="filter-row">
                    <div class="filter-group">
                        <span class="filter-label">상태</span>
                        <select class="filter-select" id="statusFilter">
                            <option value="">전체</option>
                            <option value="W">대기중</option>
                            <option value="A">승인됨</option>
                            <option value="R">거부됨</option>
                        </select>
                    </div>
                    <div class="filter-group">
                        <span class="filter-label">회원 ID</span>
                        <input type="text" class="filter-input" id="memberFilter" placeholder="회원 ID 검색">
                    </div>
                    <div class="filter-group">
                        <span class="filter-label">금액 범위</span>
                        <select class="filter-select" id="amountFilter">
                            <option value="">전체</option>
                            <option value="0-100000">10만원 이하</option>
                            <option value="100000-500000">10만원 - 50만원</option>
                            <option value="500000-1000000">50만원 - 100만원</option>
                            <option value="1000000-">100만원 이상</option>
                        </select>
                    </div>
                    <button class="filter-btn" onclick="applyFilters()">
                        <i class="fas fa-search"></i> 검색
                    </button>
                </div>
            </div>
            
            <!-- 충전 요청 테이블 -->
            <div class="charge-table">
                <div class="table-header">
                    <h2 class="table-title">충전 요청 목록</h2>
                    <div class="table-stats">
                        총 <%=chargeList.size()%>건의 충전 요청
                    </div>
                </div>
                
                <% if (chargeList.isEmpty()) { %>
                <div class="empty-state">
                    <i class="fas fa-coins"></i>
                    <h3>충전 요청이 없습니다</h3>
                    <p>아직 등록된 충전 요청이 없습니다.</p>
                </div>
                <% } else { %>
                <table>
                    <thead>
                        <tr>
                            <th>요청 ID</th>
                            <th>회원 ID</th>
                            <th>충전 금액</th>
                            <th>요청일</th>
                            <th>처리일</th>
                            <th>상태</th>
                            <th>관리</th>
                        </tr>
                    </thead>
                    <tbody id="chargeTableBody">
                        <% for (ChargeRequestDTO req : chargeList) { %>
                        <tr data-status="<%=req.getStatus()%>" data-member="<%=req.getMemberId()%>" data-amount="<%=req.getAmount()%>">
                            <td><%=req.getReqId()%></td>
                            <td>
                                <strong><%=req.getMemberId()%></strong>
                            </td>
                            <td class="amount">₩<%=df.format(req.getAmount())%></td>
                            <td><%=sdf.format(req.getRequestDate())%></td>
                            <td>
                                <% if (req.getApproveDate() != null) { %>
                                    <%=sdf.format(req.getApproveDate())%>
                                <% } else { %>
                                    <span style="color: #9ca3af;">-</span>
                                <% } %>
                            </td>
                            <td>
                                <% 
                                    String status = req.getStatus();
                                    String statusClass = "";
                                    String statusText = "";
                                    if ("W".equals(status)) {
                                        statusClass = "status-pending";
                                        statusText = "대기중";
                                    } else if ("A".equals(status)) {
                                        statusClass = "status-approved";
                                        statusText = "승인됨";
                                    } else if ("R".equals(status)) {
                                        statusClass = "status-rejected";
                                        statusText = "거부됨";
                                    }
                                %>
                                <span class="status-badge <%=statusClass%>"><%=statusText%></span>
                            </td>
                            <td>
                                <div class="actions">
                                    <% if ("W".equals(req.getStatus())) { %>
                                    <a href="<%=request.getContextPath()%>/admin/chargeAction.jsp?reqId=<%=req.getReqId()%>&action=approve" 
                                       class="action-btn approve-btn"
                                       onclick="return confirm('충전 요청을 승인하시겠습니까?')">
                                        승인
                                    </a>
                                    <a href="<%=request.getContextPath()%>/admin/chargeAction.jsp?reqId=<%=req.getReqId()%>&action=reject" 
                                       class="action-btn reject-btn"
                                       onclick="return confirm('충전 요청을 거부하시겠습니까?')">
                                        거부
                                    </a>
                                    <% } else { %>
                                    <a href="#" class="action-btn view-btn" onclick="viewDetails(<%=req.getReqId()%>)">
                                        상세보기
                                    </a>
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
            const memberFilter = document.getElementById('memberFilter').value.toLowerCase();
            const amountFilter = document.getElementById('amountFilter').value;
            const rows = document.querySelectorAll('#chargeTableBody tr');
            
            rows.forEach(row => {
                let show = true;
                
                // 상태 필터
                if (statusFilter && row.dataset.status !== statusFilter) {
                    show = false;
                }
                
                // 회원 ID 필터
                if (memberFilter && !row.dataset.member.toLowerCase().includes(memberFilter)) {
                    show = false;
                }
                
                // 금액 필터
                if (amountFilter) {
                    const amount = parseInt(row.dataset.amount);
                    const [min, max] = amountFilter.split('-').map(v => v ? parseInt(v) : null);
                    
                    if (min !== null && max !== null && (amount < min || amount > max)) {
                        show = false;
                    } else if (min !== null && max === null && amount < min) {
                        show = false;
                    }
                }
                
                row.style.display = show ? '' : 'none';
            });
        }
        
        // 상세보기 함수
        function viewDetails(reqId) {
            alert('충전 요청 ' + reqId + '번의 상세 정보를 조회합니다.');
            // 실제로는 상세 페이지로 이동하거나 모달을 띄웁니다
        }
        
        // 현재 페이지 사이드바 활성화
        document.addEventListener('DOMContentLoaded', function() {
            const currentPath = window.location.pathname;
            const menuItems = document.querySelectorAll('.sidebar-menu a');
            
            menuItems.forEach(item => {
                item.classList.remove('active');
                if (item.getAttribute('href').includes('chargeRequestList.jsp')) {
                    item.classList.add('active');
                }
            });
        });
    </script>
</body>
</html>