<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String ctx = request.getContextPath();
%>

<footer class="luxury-footer">
    <div class="footer-top">
        <div class="container">
            <div class="footer-grid">
                <!-- Company Info -->
                <div class="footer-column">
                    <h3 class="footer-logo">M4 Auction</h3>
                    <p class="footer-desc">
                        대한민국을 대표하는 미술품 경매 회사로서<br>
                        40년의 전통과 신뢰를 바탕으로<br>
                        최고의 예술 작품을 선보입니다.
                    </p>
                    <div class="social-links">
                        <a href="#" aria-label="Instagram"><i class="fab fa-instagram"></i></a>
                        <a href="#" aria-label="Facebook"><i class="fab fa-facebook-f"></i></a>
                        <a href="#" aria-label="YouTube"><i class="fab fa-youtube"></i></a>
                        <a href="#" aria-label="Naver Blog"><i class="fas fa-blog"></i></a>
                    </div>
                </div>
                
                <!-- Auction -->
                <div class="footer-column">
                    <h4>Auction</h4>
                    <ul>
                        <li><a href="<%=ctx%>/auction/auctionList.jsp">온라인 경매</a></li>
                        <li><a href="<%=ctx%>/auction/auctionSchedule.jsp">경매 일정</a></li>
                        <li><a href="<%=ctx%>/auction/auctionList.jsp?status=past">경매 결과</a></li>
                        <li><a href="<%=ctx%>/guide/biddingGuide.jsp">응찰 안내</a></li>
                    </ul>
                </div>
                
                <!-- Services -->
                <div class="footer-column">
                    <h4>Services</h4>
                    <ul>
                        <li><a href="<%=ctx%>/guide/auctionGuide.jsp">위탁 안내</a></li>
                        <li><a href="<%=ctx%>/guide/auctionGuide.jsp">작품 감정</a></li>
                        <li><a href="<%=ctx%>/guide/auctionGuide.jsp">프라이빗 세일</a></li>
                        <li><a href="<%=ctx%>/guide/auctionGuide.jsp">아트 컨설팅</a></li>
                        <li><a href="<%=ctx%>/guide/auctionGuide.jsp">전시 대관</a></li>
                    </ul>
                </div>
                
                <!-- About -->
                <div class="footer-column">
                    <h4>About</h4>
                    <ul>
                        <li><a href="<%=ctx%>/company/about.jsp">회사 소개</a></li>
                        <li><a href="<%=ctx%>/company/about.jsp">인사말</a></li>
                        <li><a href="<%=ctx%>/company/about.jsp">전문가 소개</a></li>
                        <li><a href="<%=ctx%>/company/contact.jsp">오시는 길</a></li>
                        <li><a href="<%=ctx%>/company/contact.jsp">채용 정보</a></li>
                    </ul>
                </div>
                
                <!-- Contact -->
                <div class="footer-column">
                    <h4>Contact</h4>
                    <ul class="contact-info">
                        <li>
                            <i class="fas fa-map-marker-alt"></i>
                            <span>서울특별시 관악구 남부순환로 1820<br>에그옐로우 14층</span>
                        </li>
                        <li>
                            <i class="fas fa-phone"></i>
                            <span>02-1234-5678</span>
                        </li>
                        <li>
                            <i class="fas fa-fax"></i>
                            <span>02-1234-5679</span>
                        </li>
                        <li>
                            <i class="fas fa-envelope"></i>
                            <span>info@m4auction.com</span>
                        </li>
                        <li>
                            <i class="fas fa-clock"></i>
                            <span>평일 10:00 - 18:00<br>주말 및 공휴일 휴무</span>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    
    <div class="footer-bottom">
        <div class="container">
            <div class="bottom-content">
                <div class="company-info">
                    <p>
                        (주)엠포옥션 | 대표이사: 홍길동 | 사업자등록번호: 123-45-67890<br>
                        통신판매업신고: 제2025-서울관악-0001호 | 개인정보관리책임자: 김철수
                    </p>
                    <p class="copyright">
                        &copy; <%= java.time.Year.now().getValue() %> M4 Auction. All Rights Reserved.
                    </p>
                </div>
                <div class="footer-links">
                    <a href="<%=ctx%>/legal/terms.jsp">이용약관</a>
                    <a href="<%=ctx%>/legal/privacy.jsp">개인정보처리방침</a>
                    <a href="<%=ctx%>/legal/onlineTerms.jsp">온라인경매약관</a>
                    <a href="<%=ctx%>/legal/liveTerms.jsp">라이브경매약관</a>
                    <a href="<%=ctx%>/sitemap.jsp">사이트맵</a>
                </div>
            </div>
        </div>
    </div>
</footer>

<!-- Back to Top Button -->
<button class="back-to-top" aria-label="Back to top">
    <i class="fas fa-chevron-up"></i>
</button>

<script>
    // Back to top functionality
    const backToTop = document.querySelector('.back-to-top');
    
    window.addEventListener('scroll', () => {
        if (window.pageYOffset > 300) {
            backToTop.classList.add('visible');
        } else {
            backToTop.classList.remove('visible');
        }
    });
    
    backToTop.addEventListener('click', () => {
        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });
    });
</script>