<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.auction.dto.MemberDTO" %>
<%
    // 세션에서 로그인 정보 가져오기
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    String ctx = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>사이트맵 - M4 Auction</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Luxury 스타일시트 -->
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700;900&family=Poppins:wght@300;400;500;600;700&family=Noto+Sans+KR:wght@300;400;500;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="<%=ctx%>/resources/css/luxury-global-style.css">

    <style>
        /* 헤더 겹침 해결 */
        body {
            padding-top: 120px !important;
            background: #f8f8f8;
        }

        .sitemap-wrapper {
            min-height: calc(100vh - 320px);
            padding: 60px 0;
        }

        .sitemap-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .sitemap-title {
            font-family: 'Playfair Display', serif;
            font-size: 48px;
            text-align: center;
            margin-bottom: 60px;
            color: #1a1a1a;
        }

        .sitemap-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 30px;
        }

        .sitemap-card {
            background: white;
            padding: 40px;
            box-shadow: 0 0 20px rgba(0,0,0,0.05);
            transition: all 0.3s;
            border-top: 3px solid #c9961a;
        }

        .sitemap-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }

        .sitemap-card-header {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #eee;
        }

        .sitemap-card-header i {
            font-size: 28px;
            color: #c9961a;
        }

        .sitemap-card-header h2 {
            font-family: 'Playfair Display', serif;
            font-size: 24px;
            color: #1a1a1a;
            margin: 0;
        }

        .sitemap-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .sitemap-list li {
            padding: 12px 0;
            border-bottom: 1px solid #f5f5f5;
        }

        .sitemap-list li:last-child {
            border-bottom: none;
        }

        .sitemap-list a {
            color: #666;
            text-decoration: none;
            font-size: 16px;
            display: flex;
            align-items: center;
            gap: 10px;
            transition: all 0.3s;
        }

        .sitemap-list a:before {
            content: '›';
            font-size: 20px;
            color: #c9961a;
        }

        .sitemap-list a:hover {
            color: #c9961a;
            padding-left: 10px;
        }

        /* 반응형 */
        @media (max-width: 768px) {
            .sitemap-title {
                font-size: 36px;
                margin-bottom: 40px;
            }
            
            .sitemap-grid {
                grid-template-columns: 1fr;
                gap: 20px;
            }

            .sitemap-card {
                padding: 30px 20px;
            }
        }
    </style>
</head>

<body>
    <!-- Luxury 헤더 -->
    <jsp:include page="/layout/header/luxury-header.jsp" />

    <div class="sitemap-wrapper">
        <div class="sitemap-container">
            <h1 class="sitemap-title">Site Map</h1>

            <div class="sitemap-grid">
                <!-- 계정 관련 -->
                <% if(loginUser == null) { %>
                <div class="sitemap-card">
                    <div class="sitemap-card-header">
                        <i class="fas fa-user-circle"></i>
                        <h2>회원 서비스</h2>
                    </div>
                    <ul class="sitemap-list">
                        <li><a href="<%=ctx%>/member/luxury-login.jsp">로그인</a></li>
                        <li><a href="<%=ctx%>/member/enroll_step1.jsp">회원가입</a></li>
                        <li><a href="<%=ctx%>/member/findIdPwForm.jsp">아이디/비밀번호 찾기</a></li>
                    </ul>
                </div>
                <% } else { %>
                <div class="sitemap-card">
                    <div class="sitemap-card-header">
                        <i class="fas fa-user-cog"></i>
                        <h2>마이페이지</h2>
                    </div>
                    <ul class="sitemap-list">
                        <li><a href="<%=ctx%>/mypage/myPage.jsp">대시보드</a></li>
                        <li><a href="<%=ctx%>/mypage/updateMemberForm.jsp">회원정보 수정</a></li>
                        <li><a href="<%=ctx%>/mypage/changePwdForm.jsp">비밀번호 변경</a></li>
                        <li><a href="<%=ctx%>/mypage/chargeForm.jsp">마일리지 충전</a></li>
                    </ul>
                </div>
                <% } %>

                <!-- 경매 서비스 -->
                <div class="sitemap-card">
                    <div class="sitemap-card-header">
                        <i class="fas fa-gavel"></i>
                        <h2>경매 서비스</h2>
                    </div>
                    <ul class="sitemap-list">
                        <li><a href="<%=ctx%>/index.jsp">메인 페이지</a></li>
                        <li><a href="<%=ctx%>/auction/auctionList.jsp">진행중인 경매</a></li>
                        <li><a href="<%=ctx%>/auction/auction.jsp">Live Auction</a></li>
                        <li><a href="<%=ctx%>/auction/recent_bid.jsp">최근 낙찰 결과</a></li>
                    </ul>
                </div>

                <!-- 상품 관리 -->
                <div class="sitemap-card">
                    <div class="sitemap-card-header">
                        <i class="fas fa-palette"></i>
                        <h2>상품 관리</h2>
                    </div>
                    <ul class="sitemap-list">
                        <li><a href="<%=ctx%>/product/productList.jsp">전체 상품 목록</a></li>
                        <li><a href="<%=ctx%>/product/productEnrollForm.jsp">상품 등록</a></li>
                        <li><a href="<%=ctx%>/product/productManage.jsp">상품 관리</a></li>
                    </ul>
                </div>

                <!-- 고객 지원 -->
                <div class="sitemap-card">
                    <div class="sitemap-card-header">
                        <i class="fas fa-headset"></i>
                        <h2>고객 지원</h2>
                    </div>
                    <ul class="sitemap-list">
                        <li><a href="<%=ctx%>/company/about.jsp">회사 소개</a></li>
                        <li><a href="<%=ctx%>/support/faq.jsp">Q&A</a></li>
                        <li><a href="<%=ctx%>/guide/auctionGuide.jsp">경매 안내</a></li>
                        <li><a href="<%=ctx%>/legal/terms.jsp">이용 약관</a></li>
                    </ul>
                </div>

                <!-- 서비스 안내 -->
                <div class="sitemap-card">
                    <div class="sitemap-card-header">
                        <i class="fas fa-concierge-bell"></i>
                        <h2>서비스 안내</h2>
                    </div>
                    <ul class="sitemap-list">
                        <li><a href="<%=ctx%>/guide/auctionGuide.jsp">위탁 안내</a></li>
                        <li><a href="<%=ctx%>/guide/auctionGuide.jsp">작품 감정</a></li>
                        <li><a href="<%=ctx%>/guide/auctionGuide.jsp">프라이빗 세일</a></li>
                        <li><a href="<%=ctx%>/guide/auctionGuide.jsp">전시 대관</a></li>
                    </ul>
                </div>

                <!-- 정보 -->
                <div class="sitemap-card">
                    <div class="sitemap-card-header">
                        <i class="fas fa-info-circle"></i>
                        <h2>정보</h2>
                    </div>
                    <ul class="sitemap-list">
                        <li><a href="<%=ctx%>/legal/privacy.jsp">개인정보처리방침</a></li>
                        <li><a href="<%=ctx%>/legal/onlineTerms.jsp">온라인경매약관</a></li>
                        <li><a href="<%=ctx%>/legal/liveTerms.jsp">라이브경매약관</a></li>
                        <li><a href="<%=ctx%>/sitemap.jsp">사이트맵</a></li>
                    </ul>
                </div>
                
                <!-- 관리자 전용 -->
                <% if(loginUser != null && "admin".equals(loginUser.getMemberId())) { %>
                <div class="sitemap-card">
                    <div class="sitemap-card-header">
                        <i class="fas fa-user-shield"></i>
                        <h2>관리자</h2>
                    </div>
                    <ul class="sitemap-list">
                        <li><a href="<%=ctx%>/admin/adminPage.jsp">관리자 대시보드</a></li>
                        <li><a href="<%=ctx%>/admin/chargeRequestList.jsp">충전 요청 관리</a></li>
                        <li><a href="<%=ctx%>/admin/auctionManage.jsp">경매 관리</a></li>
                        <li><a href="<%=ctx%>/admin/testProducts.jsp">상품 관리</a></li>
                    </ul>
                </div>
                <% } %>
            </div>
        </div>
    </div>

    <!-- Luxury 푸터 -->
    <jsp:include page="/layout/footer/luxury-footer.jsp" />
</body>
</html>