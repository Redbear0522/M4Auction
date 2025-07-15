<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.auction.dto.MemberDTO" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
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

    DecimalFormat df = new DecimalFormat("###,###,###");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>사이트 통계 - M4 Auction</title>
    
    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
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
        
        .date-selector {
            background: white;
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        
        .date-row {
            display: flex;
            gap: 16px;
            align-items: center;
            flex-wrap: wrap;
        }
        
        .date-group {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .date-label {
            font-size: 14px;
            font-weight: 600;
            color: #374151;
            min-width: 60px;
        }
        
        .date-input, .date-select {
            padding: 8px 12px;
            border: 2px solid #e5e7eb;
            border-radius: 6px;
            font-size: 14px;
            background: white;
        }
        
        .apply-btn {
            background: #c9961a;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .apply-btn:hover {
            background: #ad870e;
        }
        
        .stats-overview {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 24px;
            margin-bottom: 32px;
        }
        
        .stat-card {
            background: white;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            position: relative;
            overflow: hidden;
        }
        
        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(135deg, #c9961a 0%, #d4af37 100%);
        }
        
        .stat-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
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
        }
        
        .stat-trend {
            font-size: 12px;
            font-weight: 600;
            padding: 4px 8px;
            border-radius: 4px;
        }
        
        .trend-up {
            background: #d1fae5;
            color: #065f46;
        }
        
        .trend-down {
            background: #fee2e2;
            color: #991b1b;
        }
        
        .stat-value {
            font-size: 32px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 4px;
        }
        
        .stat-label {
            font-size: 14px;
            color: #6b7280;
            margin-bottom: 8px;
        }
        
        .stat-details {
            font-size: 12px;
            color: #9ca3af;
        }
        
        .charts-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 24px;
            margin-bottom: 32px;
        }
        
        .chart-card {
            background: white;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        
        .chart-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }
        
        .chart-title {
            font-size: 18px;
            font-weight: 700;
            color: #1a1a1a;
        }
        
        .chart-filter {
            font-size: 14px;
            color: #6b7280;
            border: 1px solid #e5e7eb;
            border-radius: 6px;
            padding: 4px 8px;
            background: white;
        }
        
        .chart-container {
            position: relative;
            height: 300px;
        }
        
        .table-section {
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
        
        .stats-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .stats-table th,
        .stats-table td {
            padding: 16px 24px;
            text-align: left;
            border-bottom: 1px solid #f3f4f6;
        }
        
        .stats-table th {
            background: #f9fafb;
            font-weight: 600;
            color: #374151;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .stats-table td {
            font-size: 14px;
            color: #374151;
        }
        
        .metric-value {
            font-weight: 600;
            color: #c9961a;
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
            
            .charts-grid {
                grid-template-columns: 1fr;
            }
            
            .date-row {
                flex-direction: column;
                align-items: stretch;
            }
        }
        
        @media (max-width: 600px) {
            .stats-overview {
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
                <li><a href="<%=request.getContextPath()%>/admin/bidHistory.jsp">
                    <i class="fas fa-list"></i>
                    입찰 내역 관리
                </a></li>
                <li><a href="<%=request.getContextPath()%>/admin/siteStatistics.jsp" class="active">
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
                <h1 class="page-title">사이트 통계</h1>
                <p class="page-subtitle">사이트 운영 현황과 주요 지표를 확인합니다</p>
            </div>
            
            <!-- 날짜 선택 -->
            <div class="date-selector">
                <div class="date-row">
                    <div class="date-group">
                        <span class="date-label">기간</span>
                        <select class="date-select" id="periodSelect">
                            <option value="today">오늘</option>
                            <option value="week">이번 주</option>
                            <option value="month" selected>이번 달</option>
                            <option value="quarter">이번 분기</option>
                            <option value="year">올해</option>
                            <option value="custom">직접 설정</option>
                        </select>
                    </div>
                    <div class="date-group" id="customDateRange" style="display: none;">
                        <input type="date" class="date-input" id="startDate">
                        <span>~</span>
                        <input type="date" class="date-input" id="endDate">
                    </div>
                    <button class="apply-btn" onclick="applyDateFilter()">
                        <i class="fas fa-sync-alt"></i> 적용
                    </button>
                </div>
            </div>
            
            <!-- 주요 지표 -->
            <div class="stats-overview">
                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-icon">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="stat-trend trend-up">+12.5%</div>
                    </div>
                    <div class="stat-value">1,247</div>
                    <div class="stat-label">총 방문자</div>
                    <div class="stat-details">이전 기간 대비 156명 증가</div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-icon">
                            <i class="fas fa-gavel"></i>
                        </div>
                        <div class="stat-trend trend-up">+8.3%</div>
                    </div>
                    <div class="stat-value">89</div>
                    <div class="stat-label">성사된 경매</div>
                    <div class="stat-details">이전 기간 대비 7건 증가</div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-icon">
                            <i class="fas fa-coins"></i>
                        </div>
                        <div class="stat-trend trend-up">+15.7%</div>
                    </div>
                    <div class="stat-value">₩28억</div>
                    <div class="stat-label">총 거래액</div>
                    <div class="stat-details">이전 기간 대비 3.8억 증가</div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-icon">
                            <i class="fas fa-user-plus"></i>
                        </div>
                        <div class="stat-trend trend-down">-2.1%</div>
                    </div>
                    <div class="stat-value">23</div>
                    <div class="stat-label">신규 회원</div>
                    <div class="stat-details">이전 기간 대비 1명 감소</div>
                </div>
            </div>
            
            <!-- 차트 섹션 -->
            <div class="charts-grid">
                <!-- 매출 차트 -->
                <div class="chart-card">
                    <div class="chart-header">
                        <h3 class="chart-title">월별 매출 현황</h3>
                        <select class="chart-filter">
                            <option value="6months">최근 6개월</option>
                            <option value="12months">최근 12개월</option>
                        </select>
                    </div>
                    <div class="chart-container">
                        <canvas id="revenueChart"></canvas>
                    </div>
                </div>
                
                <!-- 카테고리별 매출 -->
                <div class="chart-card">
                    <div class="chart-header">
                        <h3 class="chart-title">카테고리별 매출</h3>
                    </div>
                    <div class="chart-container">
                        <canvas id="categoryChart"></canvas>
                    </div>
                </div>
            </div>
            
            <!-- 상세 통계 테이블 -->
            <div class="table-section">
                <div class="table-header">
                    <h2 class="table-title">상세 통계</h2>
                </div>
                
                <table class="stats-table">
                    <thead>
                        <tr>
                            <th>지표</th>
                            <th>오늘</th>
                            <th>이번 주</th>
                            <th>이번 달</th>
                            <th>전체</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><strong>페이지 뷰</strong></td>
                            <td class="metric-value">3,892</td>
                            <td class="metric-value">24,567</td>
                            <td class="metric-value">98,234</td>
                            <td class="metric-value">1,234,567</td>
                        </tr>
                        <tr>
                            <td><strong>순 방문자</strong></td>
                            <td class="metric-value">234</td>
                            <td class="metric-value">1,847</td>
                            <td class="metric-value">8,234</td>
                            <td class="metric-value">45,678</td>
                        </tr>
                        <tr>
                            <td><strong>회원가입</strong></td>
                            <td class="metric-value">5</td>
                            <td class="metric-value">23</td>
                            <td class="metric-value">89</td>
                            <td class="metric-value">1,247</td>
                        </tr>
                        <tr>
                            <td><strong>상품 등록</strong></td>
                            <td class="metric-value">12</td>
                            <td class="metric-value">67</td>
                            <td class="metric-value">234</td>
                            <td class="metric-value">3,456</td>
                        </tr>
                        <tr>
                            <td><strong>입찰 건수</strong></td>
                            <td class="metric-value">89</td>
                            <td class="metric-value">456</td>
                            <td class="metric-value">1,789</td>
                            <td class="metric-value">23,456</td>
                        </tr>
                        <tr>
                            <td><strong>성사된 거래</strong></td>
                            <td class="metric-value">3</td>
                            <td class="metric-value">18</td>
                            <td class="metric-value">89</td>
                            <td class="metric-value">1,234</td>
                        </tr>
                        <tr>
                            <td><strong>평균 거래액</strong></td>
                            <td class="metric-value">₩3,200,000</td>
                            <td class="metric-value">₩2,890,000</td>
                            <td class="metric-value">₩3,140,000</td>
                            <td class="metric-value">₩2,870,000</td>
                        </tr>
                        <tr>
                            <td><strong>마일리지 충전</strong></td>
                            <td class="metric-value">₩12,500,000</td>
                            <td class="metric-value">₩78,900,000</td>
                            <td class="metric-value">₩345,600,000</td>
                            <td class="metric-value">₩5,678,900,000</td>
                        </tr>
                    </tbody>
                </table>
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
        // 매출 차트
        const revenueCtx = document.getElementById('revenueChart').getContext('2d');
        const revenueChart = new Chart(revenueCtx, {
            type: 'line',
            data: {
                labels: ['7월', '8월', '9월', '10월', '11월', '12월'],
                datasets: [{
                    label: '매출 (억원)',
                    data: [15, 23, 18, 31, 28, 35],
                    borderColor: '#c9961a',
                    backgroundColor: 'rgba(201, 150, 26, 0.1)',
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return value + '억';
                            }
                        }
                    }
                },
                plugins: {
                    legend: {
                        display: false
                    }
                }
            }
        });
        
        // 카테고리별 매출 차트
        const categoryCtx = document.getElementById('categoryChart').getContext('2d');
        const categoryChart = new Chart(categoryCtx, {
            type: 'doughnut',
            data: {
                labels: ['회화', '조각', '고미술', '판화', '사진', '기타'],
                datasets: [{
                    data: [35, 25, 20, 10, 7, 3],
                    backgroundColor: [
                        '#c9961a',
                        '#d4af37',
                        '#1a1a1a',
                        '#6b7280',
                        '#9ca3af',
                        '#e5e7eb'
                    ],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            usePointStyle: true,
                            padding: 20
                        }
                    }
                }
            }
        });
        
        // 날짜 필터 처리
        document.getElementById('periodSelect').addEventListener('change', function() {
            const customDateRange = document.getElementById('customDateRange');
            if (this.value === 'custom') {
                customDateRange.style.display = 'flex';
            } else {
                customDateRange.style.display = 'none';
            }
        });
        
        // 날짜 필터 적용
        function applyDateFilter() {
            const period = document.getElementById('periodSelect').value;
            const startDate = document.getElementById('startDate').value;
            const endDate = document.getElementById('endDate').value;
            
            console.log('날짜 필터 적용:', { period, startDate, endDate });
            alert('날짜 필터가 적용되었습니다. (실제로는 서버에서 데이터를 다시 조회합니다)');
        }
        
        // 현재 페이지 사이드바 활성화
        document.addEventListener('DOMContentLoaded', function() {
            const currentPath = window.location.pathname;
            const menuItems = document.querySelectorAll('.sidebar-menu a');
            
            menuItems.forEach(item => {
                item.classList.remove('active');
                if (item.getAttribute('href').includes('siteStatistics.jsp')) {
                    item.classList.add('active');
                }
            });
        });
    </script>
</body>
</html>