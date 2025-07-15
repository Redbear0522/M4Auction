<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.auction.dto.MemberDTO" %>

<%
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    String ctx = request.getContextPath();
%>

<header class="luxury-header">
    <!-- Top Bar -->
    <div class="header-top">
        <div class="container">
            <div class="top-left">
                <% if (loginUser != null) { %>
                    <span class="welcome-text">
                        Welcome, <%= loginUser.getMemberName() %>님
                        <% if (loginUser.isVip()) { %>
                            <span class="vip-badge" style="background: linear-gradient(45deg, #c9961a, #d4af37); color: white; padding: 2px 8px; border-radius: 12px; font-size: 11px; margin-left: 8px;">
                                <i class="fas fa-crown"></i> VIP
                            </span>
                        <% } %>
                    </span>
                <% } else { %>
                    <span class="welcome-text">Welcome to M4 Auction</span>
                <% } %>
            </div>
            <div class="top-right">
                <% if (loginUser != null) { %>
    					<a href="<%=ctx%>/mypage/myPage.jsp" class="user-link">
        				<i class="fas fa-user"></i> <%= loginUser.getMemberName() %>님
    					</a>
                    <% if("admin".equals(loginUser.getMemberId())) { %>
                    <span class="divider">|</span>
                    <a href="<%=ctx%>/admin/adminPage.jsp" class="admin-link">
                        <i class="fas fa-cog"></i> 관리자페이지
                    </a>
                    <% } %>
                    <span class="divider">|</span>
                    <a href="<%=ctx%>/member/logout.jsp">로그아웃</a>
                <% } else { %>
                    <a href="#" onclick="openLoginModal(); return false;">LOGIN</a>
                    <span class="divider">|</span>
                    <a href="<%=request.getContextPath()%>/member/enroll_step1.jsp">JOIN</a>
                <% } %>
            </div>
        </div>
    </div>
    
    <!-- Main Header -->
    <div class="header-main">
        <div class="container">
            <div class="header-wrapper">
                <!-- Logo -->
                <div class="logo">
                    <a href="<%=ctx%>/index.jsp">
                        <span class="logo-text">M4 Auction</span>
                        <span class="logo-tagline">Premium Art & Luxury</span>
                    </a>
                </div>
                
                <!-- Navigation -->
                <nav class="main-nav">
                    <ul>
                        <li class="has-mega-menu">
                            <a href="<%=ctx%>/auction/auction.jsp">Auction</a>
                            <div class="mega-menu">
                                <div class="mega-menu-inner">
                                    <div class="menu-column">
                                        <h4>경매 일정</h4>
                                        <ul>
                                            <li><a href="<%=ctx%>/auction/auctionSchedule.jsp">전체 경매 일정</a></li>
                                            <li><a href="<%=ctx%>/auction/auctionList.jsp?status=upcoming">예정 경매</a></li>
                                            <li><a href="<%=ctx%>/auction/auctionList.jsp?status=past">지난 경매</a></li>
                                        </ul>
                                    </div>
                                    <div class="menu-column">
                                        <h4>카테고리별</h4>
                                        <ul>
                                            <li><a href="<%=ctx%>/category/categoryList.jsp?category=회화">회화</a></li>
                                            <li><a href="<%=ctx%>/category/categoryList.jsp?category=조각">조각</a></li>
                                            <li><a href="<%=ctx%>/category/categoryList.jsp?category=고미술">고미술</a></li>
                                        </ul>
                                    </div>
                                    <div class="menu-column">
                                        <h4>경매 안내</h4>
                                        <ul>
                                            <li><a href="<%=ctx%>/guide/biddingGuide.jsp">응찰 방법</a></li>
                                            <li><a href="<%=ctx%>/support/faq.jsp">FAQ</a></li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </li>
                        <li class="has-mega-menu">
                            <a href="<%=ctx%>/auction/auctionList.jsp">Online Auction</a>
                            <div class="mega-menu">
                                <div class="mega-menu-inner">
                                    <div class="menu-column">
                                        <h4>진행중인 경매</h4>
                                        <ul>
                                            <li><a href="<%=ctx%>/auction/auctionList.jsp?type=premium">프리미엄 온라인</a></li>
                                            <li><a href="<%=ctx%>/auction/auctionList.jsp?type=weekly">위클리 온라인</a></li>
                                            <li><a href="<%=ctx%>/auction/auctionList.jsp?type=zerobase">제로베이스</a></li>
                                        </ul>
                                    </div>
                                    <div class="menu-column">
                                        <h4>카테고리</h4>
                                        <ul>
                                            <li><a href="<%=ctx%>/category/categoryList.jsp?category=회화">회화</a></li>
                                            <li><a href="<%=ctx%>/category/categoryList.jsp?category=판화">판화</a></li>
                                            <li><a href="<%=ctx%>/category/categoryList.jsp?category=사진">사진</a></li>
                                            <li><a href="<%=ctx%>/category/categoryList.jsp?category=추상화">추상화</a></li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </li>
                        <li><a href="<%=ctx%>/guide/biddingGuide.jsp">How To</a></li>
                        <li><a href="<%=ctx%>/news/newsList.jsp">News</a></li>
                        <li class="has-mega-menu">
                            <a href="#">Services</a>
                            <div class="mega-menu">
                                <div class="mega-menu-inner">
                                    <div class="menu-column">
                                        <h4>위탁 안내</h4>
                                        <ul>
                                            <li><a href="<%=ctx%>/guide/auctionGuide.jsp">위탁 절차</a></li>
                                            <li><a href="<%=ctx%>/product/productEnrollForm.jsp">위탁 신청</a></li>
                                            <li><a href="<%=ctx%>/guide/biddingGuide.jsp">수수료 안내</a></li>
                                        </ul>
                                    </div>
                                    <div class="menu-column">
                                        <h4>기타 서비스</h4>
                                        <ul>
                                            <li><a href="<%=ctx%>/guide/auctionGuide.jsp">작품 감정</a></li>
                                            <li><a href="<%=ctx%>/guide/auctionGuide.jsp">프라이빗 세일</a></li>
                                            <li><a href="<%=ctx%>/guide/auctionGuide.jsp">아트 컨설팅</a></li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </li>
                        <li><a href="<%=ctx%>/company/about.jsp">About</a></li>
                        <li><a href="<%=ctx%>/company/contact.jsp">Contact</a></li>
                        <li><a href="<%=ctx%>/sitemap.jsp">Sitemap</a></li>
                    </ul>
                </nav>
                
                <!-- Header Actions -->
                <div class="header-actions">
                    <button class="search-toggle">
                        <i class="fas fa-search"></i>
                    </button>
                    <% if (loginUser != null) { %>
                        <a href="<%=ctx%>/wishlist/wishlistPage.jsp" class="wishlist-link">
                            <i class="far fa-heart"></i>
                            <span class="count" id="wishlistCount">0</span>
                        </a>
                    <% } else { %>
                        <a href="#" onclick="openLoginModal(); return false;" class="wishlist-link">
                            <i class="far fa-heart"></i>
                            <span class="count">0</span>
                        </a>
                    <% } %>
                    <button class="mobile-menu-toggle">
                        <span></span>
                        <span></span>
                        <span></span>
                    </button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Search Bar (Hidden by default) -->
    
        <div class="search-bar">
    	<div class="container">
        	<form class="search-form" action="<%=ctx%>/search/searchResult.jsp" method="get">
            	<input type="text" name="keyword" placeholder="작가명, 작품명, 경매번호를 입력하세요" autocomplete="off">
            	<button type="submit"><i class="fas fa-search"></i></button>
        	</form>
        <button type="button" class="search-close"><i class="fas fa-times"></i></button>
        <div class="search-suggestions">
            <h4>인기 검색어</h4>
            <div class="tag-list">
                <a href="<%=ctx%>/search/searchResult.jsp?keyword=김환기" class="tag">김환기</a>
                <a href="<%=ctx%>/search/searchResult.jsp?keyword=이우환" class="tag">이우환</a>
                <a href="<%=ctx%>/search/searchResult.jsp?keyword=박수근" class="tag">박수근</a>
                <a href="<%=ctx%>/search/searchResult.jsp?keyword=이중섭" class="tag">이중섭</a>
                <a href="<%=ctx%>/search/searchResult.jsp?keyword=천경자" class="tag">천경자</a>
            </div>
        </div>
    </div>
</div>
</header>

<!-- 로그인 모달 -->
<div id="loginModal" class="login-modal">
    <div class="login-modal-content">
        <span class="close-btn" onclick="closeLoginModal()">&times;</span>
        <h2>LOGIN</h2>
        <form action="<%=ctx%>/member/loginAction.jsp" method="post" class="modal-login-form">
            <div class="form-group">
                <input type="text" name="userId" placeholder="아이디" required>
            </div>
            <div class="form-group">
                <input type="password" name="userPwd" placeholder="비밀번호" required>
            </div>
            <div class="login-options">
                <label class="remember-check">
                    <input type="checkbox" name="remember"> 
                    <span>로그인 상태 유지</span>
                </label>
                <div class="find-links">
                    <a href="<%=ctx%>/member/findIdPwForm.jsp">아이디찾기</a>
                    <span class="divider">|</span>
                    <a href="<%=ctx%>/member/findIdPwForm.jsp">비밀번호찾기</a>
                </div>
            </div>
            <button type="submit" class="login-submit">로그인</button>
        </form>
        <div class="login-footer">
            아직 계정이 없으신가요? <a href="<%=ctx%>/member/enroll_step1.jsp" class="signup-link">회원가입</a>
        </div>
    </div>
</div>

<style>
/* 로그인 모달 스타일 */
.login-modal {
    display: none;
    position: fixed;
    z-index: 9999;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0,0,0,0.7);
    animation: fadeIn 0.3s;
}

@keyframes fadeIn {
    from { opacity: 0; }
    to { opacity: 1; }
}

.login-modal-content {
    background-color: #fff;
    margin: 8% auto;
    padding: 50px;
    width: 450px;
    box-shadow: 0 10px 40px rgba(0,0,0,0.3);
    position: relative;
    animation: slideDown 0.3s;
}

@keyframes slideDown {
    from { transform: translateY(-50px); opacity: 0; }
    to { transform: translateY(0); opacity: 1; }
}

.login-modal-content h2 {
    font-family: 'Playfair Display', serif;
    text-align: center;
    margin-bottom: 35px;
    font-size: 32px;
    color: #1a1a1a;
}

.modal-login-form .form-group {
    margin-bottom: 20px;
}

.modal-login-form input {
    width: 100%;
    padding: 15px;
    border: 1px solid #e5e5e5;
    font-size: 15px;
    background: #fafafa;
    transition: all 0.3s;
    box-sizing: border-box;
}

.modal-login-form input:focus {
    outline: none;
    border-color: #c9961a;
    background: #fff;
}

.login-options {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 25px;
    font-size: 14px;
}

.remember-check {
    display: flex;
    align-items: center;
    gap: 5px;
    cursor: pointer;
    color: #666;
}

.remember-check input[type="checkbox"] {
    width: 16px;
    height: 16px;
    cursor: pointer;
}

.find-links a {
    color: #666;
    text-decoration: none;
    transition: color 0.3s;
}

.find-links a:hover {
    color: #c9961a;
}

.find-links .divider {
    color: #ddd;
    margin: 0 5px;
}

.login-submit {
    width: 100%;
    padding: 18px;
    background: #1a1a1a;
    color: white;
    border: none;
    font-size: 16px;
    font-weight: 600;
    cursor: pointer;
    text-transform: uppercase;
    letter-spacing: 1px;
    transition: all 0.3s;
}

.login-submit:hover {
    background: #c9961a;
}

.close-btn {
    position: absolute;
    right: 25px;
    top: 25px;
    font-size: 35px;
    cursor: pointer;
    color: #999;
    transition: color 0.3s;
}

.close-btn:hover {
    color: #333;
}

.login-footer {
    text-align: center;
    margin-top: 30px;
    padding-top: 30px;
    border-top: 1px solid #eee;
    font-size: 14px;
    color: #666;
}

.signup-link {
    color: #c9961a;
    font-weight: 600;
    text-decoration: none;
    margin-left: 5px;
}

.signup-link:hover {
    text-decoration: underline;
}


/* 반응형 */
@media (max-width: 576px) {
    .login-modal-content {
        width: 90%;
        margin: 20% auto;
        padding: 30px;
    }
}
</style>

<script>
    // Search toggle
    document.querySelector('.search-toggle').addEventListener('click', function() {
        document.querySelector('.search-bar').classList.add('active');
        document.querySelector('.search-form input').focus();
    });
    
    document.querySelector('.search-close').addEventListener('click', function() {
        document.querySelector('.search-bar').classList.remove('active');
    });
    
    // Mobile menu toggle
    document.querySelector('.mobile-menu-toggle').addEventListener('click', function() {
        this.classList.toggle('active');
        document.querySelector('.main-nav').classList.toggle('active');
    });
    
    
    // 로그인 모달 함수들
    function openLoginModal() {
        document.getElementById('loginModal').style.display = 'block';
        document.body.style.overflow = 'hidden'; // 스크롤 방지
    }
    
    function closeLoginModal() {
        document.getElementById('loginModal').style.display = 'none';
        document.body.style.overflow = 'auto'; // 스크롤 복원
    }
    
    // 모달 외부 클릭시 닫기
    window.onclick = function(event) {
        const modal = document.getElementById('loginModal');
        if (event.target == modal) {
            closeLoginModal();
        }
    }
    
    // ESC 키로 모달 닫기
    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape') {
            closeLoginModal();
        }
    });
</script>

