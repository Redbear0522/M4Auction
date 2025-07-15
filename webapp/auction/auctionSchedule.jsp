<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.auction.dto.MemberDTO" %>
<%
    String ctx = request.getContextPath();
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    
    SimpleDateFormat monthFormat = new SimpleDateFormat("yyyy년 MM월");
    SimpleDateFormat dateFormat = new SimpleDateFormat("MM.dd");
    SimpleDateFormat dayFormat = new SimpleDateFormat("E");
    
    // 현재 날짜 기준으로 달력 생성
    Calendar cal = Calendar.getInstance();
    int currentYear = cal.get(Calendar.YEAR);
    int currentMonth = cal.get(Calendar.MONTH);
    
    // 이번 달의 첫 날과 마지막 날
    cal.set(currentYear, currentMonth, 1);
    int firstDayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
    int lastDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>경매 일정 - M4 Auction</title>
    
    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    
    <!-- Global Styles -->
    <link rel="stylesheet" href="<%=ctx%>/resources/css/luxury-global-style.css">
    
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background: #f8f9fa;
            padding-top: 120px;
        }
        
        .schedule-hero {
            background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
            color: white;
            padding: 80px 0;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .schedule-hero::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('https://images.unsplash.com/photo-1578321272176-b7bbc0679853?q=80&w=2000') center/cover;
            opacity: 0.1;
        }
        
        .hero-content {
            position: relative;
            z-index: 2;
        }
        
        .hero-title {
            font-family: 'Playfair Display', serif;
            font-size: 48px;
            font-weight: 700;
            margin-bottom: 16px;
            background: linear-gradient(45deg, #c9961a, #d4af37);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .hero-subtitle {
            font-size: 18px;
            opacity: 0.9;
            margin-bottom: 30px;
        }
        
        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 20px;
        }
        
        .schedule-container {
            padding: 60px 0;
        }
        
        .schedule-nav {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-bottom: 40px;
            flex-wrap: wrap;
        }
        
        .nav-btn {
            padding: 12px 24px;
            background: white;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            color: #374151;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .nav-btn:hover,
        .nav-btn.active {
            background: #1a1a1a;
            color: white;
            border-color: #1a1a1a;
        }
        
        .calendar-section {
            background: white;
            border-radius: 16px;
            padding: 40px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
            margin-bottom: 40px;
        }
        
        .calendar-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        
        .calendar-title {
            font-family: 'Playfair Display', serif;
            font-size: 32px;
            font-weight: 700;
            color: #1a1a1a;
        }
        
        .calendar-controls {
            display: flex;
            gap: 12px;
        }
        
        .control-btn {
            width: 40px;
            height: 40px;
            background: #f3f4f6;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s;
        }
        
        .control-btn:hover {
            background: #e5e7eb;
        }
        
        .calendar-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 1px;
            background: #e5e7eb;
            border-radius: 12px;
            overflow: hidden;
        }
        
        .calendar-day-header {
            background: #1a1a1a;
            color: white;
            padding: 16px;
            text-align: center;
            font-weight: 600;
            font-size: 14px;
        }
        
        .calendar-day {
            background: white;
            min-height: 120px;
            padding: 12px;
            position: relative;
        }
        
        .day-number {
            font-size: 14px;
            font-weight: 600;
            color: #374151;
            margin-bottom: 8px;
        }
        
        .day-events {
            font-size: 12px;
        }
        
        .event-item {
            background: #c9961a;
            color: white;
            padding: 4px 8px;
            border-radius: 4px;
            margin-bottom: 4px;
            font-size: 11px;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .event-item:hover {
            background: #b8851a;
            transform: translateY(-1px);
        }
        
        .event-item.live {
            background: #dc2626;
        }
        
        .event-item.online {
            background: #059669;
        }
        
        .calendar-day.other-month {
            background: #f9fafb;
        }
        
        .calendar-day.other-month .day-number {
            color: #9ca3af;
        }
        
        .calendar-day.today {
            background: #fef3c7;
        }
        
        .calendar-day.today .day-number {
            color: #c9961a;
            font-weight: 700;
        }
        
        .schedule-list {
            background: white;
            border-radius: 16px;
            padding: 40px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
        }
        
        .list-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        
        .list-title {
            font-size: 24px;
            font-weight: 700;
            color: #1a1a1a;
        }
        
        .filter-tabs {
            display: flex;
            gap: 8px;
        }
        
        .filter-tab {
            padding: 8px 16px;
            background: #f3f4f6;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
            color: #666;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .filter-tab.active {
            background: #c9961a;
            color: white;
        }
        
        .schedule-items {
            display: grid;
            gap: 16px;
        }
        
        .schedule-item {
            display: flex;
            gap: 20px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 12px;
            transition: all 0.3s;
            cursor: pointer;
        }
        
        .schedule-item:hover {
            background: #e9ecef;
            transform: translateY(-2px);
        }
        
        .schedule-date {
            min-width: 80px;
            text-align: center;
            padding: 12px;
            background: white;
            border-radius: 8px;
        }
        
        .date-month {
            font-size: 12px;
            color: #666;
            text-transform: uppercase;
        }
        
        .date-day {
            font-size: 24px;
            font-weight: 700;
            color: #1a1a1a;
            margin: 4px 0;
        }
        
        .date-weekday {
            font-size: 12px;
            color: #666;
        }
        
        .schedule-content {
            flex: 1;
        }
        
        .schedule-badge {
            display: inline-block;
            padding: 4px 8px;
            background: #c9961a;
            color: white;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 600;
            margin-bottom: 8px;
        }
        
        .schedule-badge.live {
            background: #dc2626;
        }
        
        .schedule-badge.online {
            background: #059669;
        }
        
        .schedule-event-title {
            font-size: 18px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 4px;
        }
        
        .schedule-time {
            font-size: 14px;
            color: #666;
            margin-bottom: 8px;
        }
        
        .schedule-description {
            font-size: 14px;
            color: #666;
            line-height: 1.5;
        }
        
        .legend {
            display: flex;
            justify-content: center;
            gap: 30px;
            margin-top: 30px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 8px;
        }
        
        .legend-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            color: #666;
        }
        
        .legend-color {
            width: 16px;
            height: 16px;
            border-radius: 4px;
        }
        
        .legend-color.live {
            background: #dc2626;
        }
        
        .legend-color.online {
            background: #059669;
        }
        
        .legend-color.special {
            background: #c9961a;
        }
        
        /* 반응형 */
        @media (max-width: 768px) {
            .hero-title {
                font-size: 36px;
            }
            
            .calendar-section {
                padding: 20px;
            }
            
            .calendar-grid {
                gap: 0;
            }
            
            .calendar-day {
                min-height: 80px;
                padding: 8px;
            }
            
            .schedule-item {
                flex-direction: column;
            }
            
            .schedule-nav {
                gap: 10px;
            }
            
            .nav-btn {
                padding: 10px 16px;
                font-size: 14px;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/layout/header/luxury-header.jsp" />
    
    <!-- Hero Section -->
    <section class="schedule-hero">
        <div class="container">
            <div class="hero-content">
                <h1 class="hero-title">경매 일정</h1>
                <p class="hero-subtitle">M4 Auction의 모든 경매 일정을 한눈에 확인하세요</p>
            </div>
        </div>
    </section>
    
    <!-- Schedule Content -->
    <section class="schedule-container">
        <div class="container">
            <!-- Navigation -->
            <div class="schedule-nav">
                <a href="<%=ctx%>/auction/liveAuction.jsp" class="nav-btn">
                    <i class="fas fa-broadcast-tower"></i>
                    라이브 경매
                </a>
                <a href="<%=ctx%>/auction/auctionList.jsp" class="nav-btn">
                    <i class="fas fa-globe"></i>
                    온라인 경매
                </a>
                <a href="#" class="nav-btn active">
                    <i class="fas fa-calendar-alt"></i>
                    전체 일정
                </a>
                <a href="<%=ctx%>/auction/auctionList.jsp?status=past" class="nav-btn">
                    <i class="fas fa-history"></i>
                    지난 경매
                </a>
            </div>
            
            <!-- Calendar Section -->
            <div class="calendar-section">
                <div class="calendar-header">
                    <h2 class="calendar-title"><%=monthFormat.format(cal.getTime())%></h2>
                    <div class="calendar-controls">
                        <button class="control-btn" onclick="changeMonth(-1)">
                            <i class="fas fa-chevron-left"></i>
                        </button>
                        <button class="control-btn" onclick="changeMonth(0)">
                            <i class="fas fa-home"></i>
                        </button>
                        <button class="control-btn" onclick="changeMonth(1)">
                            <i class="fas fa-chevron-right"></i>
                        </button>
                    </div>
                </div>
                
                <div class="calendar-grid">
                    <!-- 요일 헤더 -->
                    <div class="calendar-day-header">일</div>
                    <div class="calendar-day-header">월</div>
                    <div class="calendar-day-header">화</div>
                    <div class="calendar-day-header">수</div>
                    <div class="calendar-day-header">목</div>
                    <div class="calendar-day-header">금</div>
                    <div class="calendar-day-header">토</div>
                    
                    <!-- 날짜 그리드 -->
                    <%
                    // 이전 달의 날짜
                    cal.add(Calendar.MONTH, -1);
                    int prevMonthLastDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
                    cal.add(Calendar.MONTH, 1);
                    
                    for (int i = firstDayOfWeek - 2; i >= 0; i--) {
                    %>
                        <div class="calendar-day other-month">
                            <div class="day-number"><%=prevMonthLastDay - i%></div>
                        </div>
                    <%
                    }
                    
                    // 현재 달의 날짜
                    Calendar today = Calendar.getInstance();
                    for (int day = 1; day <= lastDay; day++) {
                        boolean isToday = (currentYear == today.get(Calendar.YEAR) && 
                                         currentMonth == today.get(Calendar.MONTH) && 
                                         day == today.get(Calendar.DAY_OF_MONTH));
                    %>
                        <div class="calendar-day <%= isToday ? "today" : "" %>">
                            <div class="day-number"><%=day%></div>
                            <div class="day-events">
                                <% if (day == 11 || day == 25) { %>
                                    <div class="event-item live">라이브 경매</div>
                                <% } %>
                                <% if (day == 5 || day == 19) { %>
                                    <div class="event-item online">온라인 경매</div>
                                <% } %>
                                <% if (day == 15) { %>
                                    <div class="event-item">특별 경매</div>
                                <% } %>
                            </div>
                        </div>
                    <%
                    }
                    
                    // 다음 달의 날짜
                    int remainingDays = 42 - (firstDayOfWeek - 1 + lastDay);
                    for (int day = 1; day <= remainingDays; day++) {
                    %>
                        <div class="calendar-day other-month">
                            <div class="day-number"><%=day%></div>
                        </div>
                    <%
                    }
                    %>
                </div>
                
                <!-- 범례 -->
                <div class="legend">
                    <div class="legend-item">
                        <div class="legend-color live"></div>
                        <span>라이브 경매</span>
                    </div>
                    <div class="legend-item">
                        <div class="legend-color online"></div>
                        <span>온라인 경매</span>
                    </div>
                    <div class="legend-item">
                        <div class="legend-color special"></div>
                        <span>특별 경매</span>
                    </div>
                </div>
            </div>
            
            <!-- Schedule List -->
            <div class="schedule-list">
                <div class="list-header">
                    <h3 class="list-title">예정된 경매</h3>
                    <div class="filter-tabs">
                        <button class="filter-tab active" onclick="filterSchedule('all')">전체</button>
                        <button class="filter-tab" onclick="filterSchedule('live')">라이브</button>
                        <button class="filter-tab" onclick="filterSchedule('online')">온라인</button>
                    </div>
                </div>
                
                <div class="schedule-items">
                    <div class="schedule-item" data-type="live">
                        <div class="schedule-date">
                            <div class="date-month">JAN</div>
                            <div class="date-day">11</div>
                            <div class="date-weekday">토</div>
                        </div>
                        <div class="schedule-content">
                            <span class="schedule-badge live">LIVE</span>
                            <h4 class="schedule-event-title">근현대 미술 경매</h4>
                            <p class="schedule-time">오후 2:00 - 6:00</p>
                            <p class="schedule-description">김환기, 이우환, 박수근 등 한국 근현대 거장들의 대표작품 100여점</p>
                        </div>
                    </div>
                    
                    <div class="schedule-item" data-type="special">
                        <div class="schedule-date">
                            <div class="date-month">JAN</div>
                            <div class="date-day">15</div>
                            <div class="date-weekday">수</div>
                        </div>
                        <div class="schedule-content">
                            <span class="schedule-badge">특별</span>
                            <h4 class="schedule-event-title">신년 특별 경매</h4>
                            <p class="schedule-time">오후 7:00 - 9:00</p>
                            <p class="schedule-description">2025년 신년을 맞아 특별히 준비한 프리미엄 컬렉션</p>
                        </div>
                    </div>
                    
                    <div class="schedule-item" data-type="online">
                        <div class="schedule-date">
                            <div class="date-month">JAN</div>
                            <div class="date-day">19</div>
                            <div class="date-weekday">일</div>
                        </div>
                        <div class="schedule-content">
                            <span class="schedule-badge online">ONLINE</span>
                            <h4 class="schedule-event-title">위클리 온라인 경매</h4>
                            <p class="schedule-time">온라인 입찰 마감</p>
                            <p class="schedule-description">판화, 사진, 조각 등 다양한 장르의 작품 온라인 경매</p>
                        </div>
                    </div>
                    
                    <div class="schedule-item" data-type="live">
                        <div class="schedule-date">
                            <div class="date-month">JAN</div>
                            <div class="date-day">25</div>
                            <div class="date-weekday">토</div>
                        </div>
                        <div class="schedule-content">
                            <span class="schedule-badge live">LIVE</span>
                            <h4 class="schedule-event-title">서양화 컬렉션 경매</h4>
                            <p class="schedule-time">오후 2:00 - 5:00</p>
                            <p class="schedule-description">유럽 및 미국 현대 작가들의 회화, 조각 작품 경매</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
    <jsp:include page="/layout/footer/luxury-footer.jsp" />
    
    <script>
        function changeMonth(direction) {
            // 실제 구현에서는 서버에 요청하여 해당 월의 데이터를 가져와야 함
            if (direction === 0) {
                // 오늘로 이동
                location.reload();
            } else {
                console.log('Change month:', direction);
            }
        }
        
        function filterSchedule(type) {
            // 필터 탭 활성화
            document.querySelectorAll('.filter-tab').forEach(tab => {
                tab.classList.remove('active');
            });
            event.target.classList.add('active');
            
            // 일정 필터링
            const items = document.querySelectorAll('.schedule-item');
            items.forEach(item => {
                if (type === 'all' || item.getAttribute('data-type') === type) {
                    item.style.display = 'flex';
                } else {
                    item.style.display = 'none';
                }
            });
        }
        
        // 캘린더 이벤트 클릭 시
        document.querySelectorAll('.event-item').forEach(item => {
            item.addEventListener('click', function() {
                alert('경매 상세 정보 페이지로 이동');
            });
        });
        
        // 일정 아이템 클릭 시
        document.querySelectorAll('.schedule-item').forEach(item => {
            item.addEventListener('click', function() {
                // 해당 경매 페이지로 이동
                window.location.href = '<%=ctx%>/auction/liveAuction.jsp';
            });
        });
    </script>
</body>
</html>