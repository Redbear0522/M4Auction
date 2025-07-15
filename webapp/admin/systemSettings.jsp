<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.auction.dto.MemberDTO" %>
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
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>시스템 설정 - M4 Auction</title>
    
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
        
        .settings-grid {
            display: grid;
            gap: 24px;
        }
        
        .settings-section {
            background: white;
            border-radius: 12px;
            padding: 32px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        
        .section-header {
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 24px;
            padding-bottom: 16px;
            border-bottom: 2px solid #f3f4f6;
        }
        
        .section-icon {
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
        
        .section-title {
            font-size: 20px;
            font-weight: 700;
            color: #1a1a1a;
            margin: 0;
        }
        
        .section-description {
            font-size: 14px;
            color: #6b7280;
            margin: 0;
        }
        
        .setting-group {
            margin-bottom: 24px;
        }
        
        .setting-group:last-child {
            margin-bottom: 0;
        }
        
        .setting-label {
            display: block;
            font-size: 14px;
            font-weight: 600;
            color: #374151;
            margin-bottom: 8px;
        }
        
        .setting-description {
            font-size: 12px;
            color: #6b7280;
            margin-bottom: 12px;
        }
        
        .setting-input, .setting-select, .setting-textarea {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            font-size: 14px;
            background: white;
            transition: border-color 0.3s;
            box-sizing: border-box;
        }
        
        .setting-input:focus, .setting-select:focus, .setting-textarea:focus {
            outline: none;
            border-color: #c9961a;
        }
        
        .setting-textarea {
            resize: vertical;
            min-height: 100px;
        }
        
        .setting-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }
        
        .toggle-switch {
            position: relative;
            display: inline-block;
            width: 60px;
            height: 34px;
        }
        
        .toggle-switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }
        
        .toggle-slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #ccc;
            transition: .4s;
            border-radius: 34px;
        }
        
        .toggle-slider:before {
            position: absolute;
            content: "";
            height: 26px;
            width: 26px;
            left: 4px;
            bottom: 4px;
            background-color: white;
            transition: .4s;
            border-radius: 50%;
        }
        
        input:checked + .toggle-slider {
            background-color: #c9961a;
        }
        
        input:checked + .toggle-slider:before {
            transform: translateX(26px);
        }
        
        .setting-toggle {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .action-buttons {
            display: flex;
            gap: 12px;
            justify-content: flex-end;
            margin-top: 32px;
            padding-top: 24px;
            border-top: 2px solid #f3f4f6;
        }
        
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-primary {
            background: #c9961a;
            color: white;
        }
        
        .btn-primary:hover {
            background: #ad870e;
        }
        
        .btn-secondary {
            background: #6b7280;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #4b5563;
        }
        
        .btn-danger {
            background: #ef4444;
            color: white;
        }
        
        .btn-danger:hover {
            background: #dc2626;
        }
        
        .warning-box {
            background: #fef3c7;
            border: 2px solid #fbbf24;
            border-radius: 8px;
            padding: 16px;
            margin: 16px 0;
        }
        
        .warning-title {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            font-weight: 700;
            color: #92400e;
            margin-bottom: 8px;
        }
        
        .warning-content {
            color: #92400e;
            font-size: 13px;
            line-height: 1.5;
        }
        
        .info-box {
            background: #e0f2fe;
            border: 2px solid #0284c7;
            border-radius: 8px;
            padding: 16px;
            margin: 16px 0;
        }
        
        .info-title {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            font-weight: 700;
            color: #0369a1;
            margin-bottom: 8px;
        }
        
        .info-content {
            color: #0369a1;
            font-size: 13px;
            line-height: 1.5;
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
            
            .setting-row {
                grid-template-columns: 1fr;
            }
            
            .action-buttons {
                flex-direction: column;
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
                <li><a href="<%=request.getContextPath()%>/admin/siteStatistics.jsp">
                    <i class="fas fa-chart-bar"></i>
                    사이트 통계
                </a></li>
                <li><a href="<%=request.getContextPath()%>/admin/systemSettings.jsp" class="active">
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
                <h1 class="page-title">시스템 설정</h1>
                <p class="page-subtitle">사이트 운영과 관련된 전반적인 설정을 관리합니다</p>
            </div>
            
            <form id="settingsForm" action="<%=request.getContextPath()%>/admin/updateSettings" method="post">
                <div class="settings-grid">
                    <!-- 사이트 기본 설정 -->
                    <div class="settings-section">
                        <div class="section-header">
                            <div class="section-icon">
                                <i class="fas fa-globe"></i>
                            </div>
                            <div>
                                <h2 class="section-title">사이트 기본 설정</h2>
                                <p class="section-description">사이트의 기본 정보와 메타데이터를 설정합니다</p>
                            </div>
                        </div>
                        
                        <div class="setting-group">
                            <label class="setting-label">사이트 제목</label>
                            <p class="setting-description">브라우저 탭과 검색엔진에 표시되는 사이트 제목입니다</p>
                            <input type="text" name="siteTitle" class="setting-input" value="M4 Auction - Premium Art & Luxury Auction House">
                        </div>
                        
                        <div class="setting-row">
                            <div class="setting-group">
                                <label class="setting-label">사이트 로고</label>
                                <p class="setting-description">헤더에 표시될 로고 텍스트입니다</p>
                                <input type="text" name="siteLogo" class="setting-input" value="M4 Auction">
                            </div>
                            <div class="setting-group">
                                <label class="setting-label">사이트 태그라인</label>
                                <p class="setting-description">로고 하단에 표시될 부제목입니다</p>
                                <input type="text" name="siteTagline" class="setting-input" value="Premium Art & Luxury">
                            </div>
                        </div>
                        
                        <div class="setting-group">
                            <label class="setting-label">사이트 설명</label>
                            <p class="setting-description">검색엔진과 소셜미디어에서 사용할 사이트 설명입니다</p>
                            <textarea name="siteDescription" class="setting-textarea">한국 최고의 프리미엄 아트 경매 하우스. 회화, 조각, 고미술품 등 다양한 예술 작품을 온라인 경매로 만나보세요.</textarea>
                        </div>
                        
                        <div class="setting-row">
                            <div class="setting-group">
                                <label class="setting-label">연락처 이메일</label>
                                <input type="email" name="contactEmail" class="setting-input" value="contact@m4auction.co.kr">
                            </div>
                            <div class="setting-group">
                                <label class="setting-label">연락처 전화번호</label>
                                <input type="tel" name="contactPhone" class="setting-input" value="02-1234-5678">
                            </div>
                        </div>
                    </div>
                    
                    <!-- 경매 설정 -->
                    <div class="settings-section">
                        <div class="section-header">
                            <div class="section-icon">
                                <i class="fas fa-gavel"></i>
                            </div>
                            <div>
                                <h2 class="section-title">경매 설정</h2>
                                <p class="section-description">경매 진행과 관련된 설정을 관리합니다</p>
                            </div>
                        </div>
                        
                        <div class="setting-row">
                            <div class="setting-group">
                                <label class="setting-label">기본 경매 기간 (일)</label>
                                <p class="setting-description">새 경매의 기본 진행 기간입니다</p>
                                <input type="number" name="defaultAuctionDays" class="setting-input" value="7" min="1" max="30">
                            </div>
                            <div class="setting-group">
                                <label class="setting-label">최소 입찰 단위 (원)</label>
                                <p class="setting-description">입찰 시 최소 증가 단위입니다</p>
                                <input type="number" name="minBidIncrement" class="setting-input" value="50000" min="1000">
                            </div>
                        </div>
                        
                        <div class="setting-row">
                            <div class="setting-group">
                                <label class="setting-label">수수료율 (%)</label>
                                <p class="setting-description">낙찰가에서 차감할 수수료 비율입니다</p>
                                <input type="number" name="commissionRate" class="setting-input" value="10" min="0" max="30" step="0.1">
                            </div>
                            <div class="setting-group">
                                <label class="setting-label">자동 연장 시간 (분)</label>
                                <p class="setting-description">마감 직전 입찰 시 연장할 시간입니다</p>
                                <input type="number" name="autoExtendMinutes" class="setting-input" value="5" min="1" max="60">
                            </div>
                        </div>
                        
                        <div class="setting-group">
                            <div class="setting-toggle">
                                <label class="toggle-switch">
                                    <input type="checkbox" name="requireApproval" checked>
                                    <span class="toggle-slider"></span>
                                </label>
                                <div>
                                    <label class="setting-label">상품 등록 승인 필요</label>
                                    <p class="setting-description">새로 등록된 상품에 대해 관리자 승인을 받도록 합니다</p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="setting-group">
                            <div class="setting-toggle">
                                <label class="toggle-switch">
                                    <input type="checkbox" name="enableAutoClose" checked>
                                    <span class="toggle-slider"></span>
                                </label>
                                <div>
                                    <label class="setting-label">자동 경매 종료</label>
                                    <p class="setting-description">경매 시간이 만료되면 자동으로 종료하고 낙찰 처리합니다</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- 회원 및 보안 설정 -->
                    <div class="settings-section">
                        <div class="section-header">
                            <div class="section-icon">
                                <i class="fas fa-shield-alt"></i>
                            </div>
                            <div>
                                <h2 class="section-title">회원 및 보안 설정</h2>
                                <p class="section-description">회원가입과 로그인 관련 보안 설정입니다</p>
                            </div>
                        </div>
                        
                        <div class="setting-row">
                            <div class="setting-group">
                                <label class="setting-label">세션 만료 시간 (분)</label>
                                <p class="setting-description">로그인 세션이 유지되는 시간입니다</p>
                                <input type="number" name="sessionTimeout" class="setting-input" value="120" min="30" max="1440">
                            </div>
                            <div class="setting-group">
                                <label class="setting-label">비밀번호 최소 길이</label>
                                <p class="setting-description">회원가입 시 요구되는 최소 비밀번호 길이입니다</p>
                                <input type="number" name="minPasswordLength" class="setting-input" value="8" min="6" max="20">
                            </div>
                        </div>
                        
                        <div class="setting-group">
                            <div class="setting-toggle">
                                <label class="toggle-switch">
                                    <input type="checkbox" name="requireEmailVerification" checked>
                                    <span class="toggle-slider"></span>
                                </label>
                                <div>
                                    <label class="setting-label">이메일 인증 필수</label>
                                    <p class="setting-description">회원가입 시 이메일 인증을 필수로 요구합니다</p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="setting-group">
                            <div class="setting-toggle">
                                <label class="toggle-switch">
                                    <input type="checkbox" name="enableTwoFactor">
                                    <span class="toggle-slider"></span>
                                </label>
                                <div>
                                    <label class="setting-label">2단계 인증</label>
                                    <p class="setting-description">VIP 회원에게 2단계 인증을 활성화합니다</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- 알림 설정 -->
                    <div class="settings-section">
                        <div class="section-header">
                            <div class="section-icon">
                                <i class="fas fa-bell"></i>
                            </div>
                            <div>
                                <h2 class="section-title">알림 설정</h2>
                                <p class="section-description">이메일 및 시스템 알림 관련 설정입니다</p>
                            </div>
                        </div>
                        
                        <div class="setting-row">
                            <div class="setting-group">
                                <label class="setting-label">SMTP 서버</label>
                                <input type="text" name="smtpServer" class="setting-input" value="smtp.gmail.com">
                            </div>
                            <div class="setting-group">
                                <label class="setting-label">SMTP 포트</label>
                                <input type="number" name="smtpPort" class="setting-input" value="587">
                            </div>
                        </div>
                        
                        <div class="setting-row">
                            <div class="setting-group">
                                <label class="setting-label">발신자 이메일</label>
                                <input type="email" name="senderEmail" class="setting-input" value="noreply@m4auction.co.kr">
                            </div>
                            <div class="setting-group">
                                <label class="setting-label">발신자 이름</label>
                                <input type="text" name="senderName" class="setting-input" value="M4 Auction">
                            </div>
                        </div>
                        
                        <div class="setting-group">
                            <div class="setting-toggle">
                                <label class="toggle-switch">
                                    <input type="checkbox" name="enableEmailNotifications" checked>
                                    <span class="toggle-slider"></span>
                                </label>
                                <div>
                                    <label class="setting-label">이메일 알림 활성화</label>
                                    <p class="setting-description">입찰, 낙찰 등 중요 이벤트에 대한 이메일 알림을 발송합니다</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- 시스템 유지보수 -->
                    <div class="settings-section">
                        <div class="section-header">
                            <div class="section-icon">
                                <i class="fas fa-tools"></i>
                            </div>
                            <div>
                                <h2 class="section-title">시스템 유지보수</h2>
                                <p class="section-description">시스템 점검과 데이터 관리 설정입니다</p>
                            </div>
                        </div>
                        
                        <div class="setting-group">
                            <div class="setting-toggle">
                                <label class="toggle-switch">
                                    <input type="checkbox" name="maintenanceMode">
                                    <span class="toggle-slider"></span>
                                </label>
                                <div>
                                    <label class="setting-label">유지보수 모드</label>
                                    <p class="setting-description">사이트를 일시적으로 점검 상태로 전환합니다</p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="warning-box">
                            <div class="warning-title">
                                <i class="fas fa-exclamation-triangle"></i>
                                주의사항
                            </div>
                            <div class="warning-content">
                                유지보수 모드를 활성화하면 관리자를 제외한 모든 사용자의 사이트 접근이 차단됩니다.
                            </div>
                        </div>
                        
                        <div class="setting-row">
                            <div class="setting-group">
                                <label class="setting-label">자동 백업 주기 (일)</label>
                                <p class="setting-description">데이터베이스 자동 백업 주기를 설정합니다</p>
                                <select name="backupInterval" class="setting-select">
                                    <option value="1">매일</option>
                                    <option value="7" selected>매주</option>
                                    <option value="30">매월</option>
                                </select>
                            </div>
                            <div class="setting-group">
                                <label class="setting-label">로그 보관 기간 (일)</label>
                                <p class="setting-description">시스템 로그 파일 보관 기간입니다</p>
                                <input type="number" name="logRetentionDays" class="setting-input" value="90" min="7" max="365">
                            </div>
                        </div>
                        
                        <div class="info-box">
                            <div class="info-title">
                                <i class="fas fa-info-circle"></i>
                                백업 정보
                            </div>
                            <div class="info-content">
                                마지막 백업: 2025-01-08 02:00:00<br>
                                다음 백업: 2025-01-15 02:00:00<br>
                                백업 파일 크기: 2.3GB
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- 액션 버튼 -->
                <div class="action-buttons">
                    <button type="button" class="btn btn-secondary" onclick="resetSettings()">
                        <i class="fas fa-undo"></i> 초기화
                    </button>
                    <button type="button" class="btn btn-danger" onclick="exportSettings()">
                        <i class="fas fa-download"></i> 설정 내보내기
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> 설정 저장
                    </button>
                </div>
            </form>
        </div>
    </div>
    
    <jsp:include page="/layout/footer/luxury-footer.jsp" />
    
    <% if(alertMsg != null) { %>
    <script>
        alert("<%=alertMsg%>");
    </script>
    <% } %>
    
    <script>
        // 설정 폼 제출
        document.getElementById('settingsForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            if (confirm('설정을 저장하시겠습니까?')) {
                // 실제로는 서버로 폼 데이터를 전송
                alert('설정이 저장되었습니다.');
                console.log('설정 저장 요청');
            }
        });
        
        // 설정 초기화
        function resetSettings() {
            if (confirm('모든 설정을 기본값으로 초기화하시겠습니까?\n이 작업은 되돌릴 수 없습니다.')) {
                alert('설정이 초기화되었습니다.');
                location.reload();
            }
        }
        
        // 설정 내보내기
        function exportSettings() {
            alert('설정 파일을 JSON 형식으로 내보냅니다.');
            // 실제로는 설정을 JSON 파일로 다운로드
            console.log('설정 내보내기 요청');
        }
        
        // 유지보수 모드 토글 경고
        document.querySelector('input[name="maintenanceMode"]').addEventListener('change', function() {
            if (this.checked) {
                alert('유지보수 모드를 활성화하면 모든 사용자의 접근이 차단됩니다.');
            }
        });
        
        // 현재 페이지 사이드바 활성화
        document.addEventListener('DOMContentLoaded', function() {
            const currentPath = window.location.pathname;
            const menuItems = document.querySelectorAll('.sidebar-menu a');
            
            menuItems.forEach(item => {
                item.classList.remove('active');
                if (item.getAttribute('href').includes('systemSettings.jsp')) {
                    item.classList.add('active');
                }
            });
        });
    </script>
</body>
</html>