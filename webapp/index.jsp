<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="com.auction.dto.ProductDTO" %>
<%@ page import="com.auction.dao.ProductDAO" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %>
<%
    String sid = (String) session.getAttribute("sid");
    String ctx = request.getContextPath();
    
    // 로그인 사용자 정보 가져오기
    com.auction.dto.MemberDTO loginUser = (com.auction.dto.MemberDTO) session.getAttribute("loginUser");
    boolean isLoggedIn = (loginUser != null);
    boolean isAdmin = isLoggedIn && "admin".equals(loginUser.getMemberId());
    boolean isVip = isLoggedIn && loginUser.isVip();
    
    // 날짜 포맷터
    SimpleDateFormat dateFormat = new SimpleDateFormat("MM.dd");
    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
    SimpleDateFormat fullDateFormat = new SimpleDateFormat("MM월 dd일 E요일");
    DecimalFormat df = new DecimalFormat("###,###,###");
    Date now = new Date();
    
    // 데이터베이스에서 경매 목록 조회
    List<ProductDTO> activeAuctions = new ArrayList<>();
    List<ProductDTO> upcomingAuctions = new ArrayList<>();
    List<ProductDTO> featuredProducts = new ArrayList<>();
    
    Connection conn = null;
    try {
        conn = getConnection();
        ProductDAO productDao = new ProductDAO();
        
        // 활성 경매 목록 (상태 'A')
        activeAuctions = productDao.selectActiveAuctions(conn, 6);
        
        // 예정 경매 목록 (상태 'P' - 승인됨)
        upcomingAuctions = productDao.selectUpcomingAuctions(conn, "P", 6);
        
        // 추천 작품 목록 (활성 경매 중 일부)
        featuredProducts = productDao.selectActiveAuctions(conn, 8);
        
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (conn != null) close(conn);
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>M4 Auction - Premium Art & Luxury Auction House</title>
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700;900&family=Poppins:wght@300;400;500;600;700&family=Noto+Sans+KR:wght@300;400;500;700;900&display=swap" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    
    <!-- Swiper CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="<%=ctx%>/resources/css/luxury-global-style.css">
    <link rel="stylesheet" href="<%=ctx%>/resources/css/common-utilities.css">
    <link rel="stylesheet" href="<%=ctx%>/resources/css/index-page.css">
</head>
<body>
    <!-- Header -->
    <jsp:include page="/layout/header/luxury-header.jsp" />
    
    <!-- Main Hero Section -->
    <section class="main-hero">
        <div class="hero-slider swiper">
            <div class="swiper-wrapper">
                <!-- Slide 1 -->
                <div class="swiper-slide">
                    <div class="hero-slide idx-hero-slide-1">
                        <div class="hero-overlay"></div>
                        <div class="hero-content">
                            <span class="hero-category">JULY ONLINE AUCTION</span>
                            <h1 class="hero-title">현대미술 특별 경매</h1>
                            <p class="hero-desc">김환기, 이우환 등 한국 현대미술의 거장들</p>
                            <div class="hero-info">
                                <div class="info-item">
                                    <span class="label">프리뷰</span>
                                    <span class="value">07.12 ~ 07.23</span>
                                </div>
                                <div class="info-item">
                                    <span class="label">경매</span>
                                    <span class="value">07.23 TUE 4pm</span>
                                </div>
                            </div>
                            <div class="hero-actions">
                                <a href="<%=ctx%>/auction/auctionList.jsp" class="btn btn-primary">도록 보기</a>
                                <% if (isLoggedIn) { %>
                                    <a href="<%= request.getContextPath() %>/auction/auction.jsp" class="btn btn-outline">경매 참여</a>
                                <% } else { %>
                                    <a href="<%=ctx%>/member/loginForm.jsp" class="btn btn-outline">로그인 후 참여</a>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Slide 2 -->
                <div class="swiper-slide">
                    <div class="hero-slide idx-hero-slide-2">
                        <div class="hero-overlay"></div>
                        <div class="hero-content">
                            <span class="hero-category">PREMIUM COLLECTION</span>
                            <h1 class="hero-title">프리미엄 온라인 경매</h1>
                            <p class="hero-desc">엄선된 근현대 미술품과 골동품 컬렉션</p>
                            <div class="hero-info">
                                <div class="info-item">
                                    <span class="label">프리뷰</span>
                                    <span class="value">07.12 ~ 07.22</span>
                                </div>
                                <div class="info-item">
                                    <span class="label">경매</span>
                                    <span class="value">07.22 MON 4pm</span>
                                </div>
                            </div>
                            <div class="hero-actions">
                                <a href="<%=ctx%>/auction/auctionList.jsp" class="btn btn-primary">도록 보기</a>
                                <% if (isLoggedIn) { %>
                                    <a href="<%=request.getContextPath() %>/auction/auction.jsp" class="btn btn-outline">온라인 응찰</a>
                                <% } else { %>
                                    <a href="<%=ctx%>/member/loginForm.jsp" class="btn btn-outline">로그인 후 응찰</a>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Slide 3 -->
                <div class="swiper-slide">
                    <div class="hero-slide idx-hero-slide-3">
                        <div class="hero-overlay"></div>
                        <div class="hero-content">
                            <span class="hero-category">WEEKLY AUCTION</span>
                            <h1 class="hero-title">위클리 온라인 경매</h1>
                            <p class="hero-desc">매주 새로운 작품을 만나보세요</p>
                            <div class="hero-info">
                                <div class="info-item">
                                    <span class="label">프리뷰</span>
                                    <span class="value">07.12 ~ 07.24</span>
                                </div>
                                <div class="info-item">
                                    <span class="label">경매</span>
                                    <span class="value">순차 마감</span>
                                </div>
                            </div>
                            <div class="hero-actions">
                                <a href="<%=ctx%>/auction/auctionList.jsp" class="btn btn-primary">작품 보기</a>
                                <% if (isLoggedIn) { %>
                                    <a href="<%=ctx%>/guide/biddingGuide.jsp" class="btn btn-outline">응찰 가이드</a>
                                <% } else { %>
                                    <a href="<%=ctx%>/member/loginForm.jsp" class="btn btn-outline">로그인 후 참여</a>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="swiper-pagination"></div>
            <div class="swiper-button-prev"></div>
            <div class="swiper-button-next"></div>
        </div>
    </section>
    
    <!-- Quick Links -->
    <section class="quick-links">
        <div class="container">
            <div class="links-grid">
                <a href="<%= request.getContextPath() %>/auction/auction.jsp" class="link-item">
				    <i class="fas fa-gavel"></i>
				    <span>Auction</span>
				</a>
                <a href="<%=ctx%>/auction/auction.jsp" class="link-item">
                    <i class="fas fa-laptop"></i>
                    <span>Online Auction</span>
                </a>
                <a href="<%=ctx%>/auction/auctionList.jsp" class="link-item">
                    <i class="fas fa-calendar-alt"></i>
                    <span>Auction Schedule</span>
                </a>
                <% if (isLoggedIn) { %>
                    <a href="<%=ctx%>/mypage/myPage.jsp" class="link-item">
                        <i class="fas fa-user-circle"></i>
                        <span>My Page</span>
                    </a>
                <% } else { %>
                    <a href="<%=ctx%>/member/loginForm.jsp" class="link-item">
                        <i class="fas fa-sign-in-alt"></i>
                        <span>Login</span>
                    </a>
                <% } %>
            </div>
        </div>
    </section>
    
    <!-- Upcoming Auctions -->
    <section class="upcoming-auctions">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">Upcoming Auctions</h2>
                <a href="<%=ctx%>/auction/auctionList.jsp" class="view-all">전체보기 <i class="fas fa-arrow-right"></i></a>
            </div>
            
            <div class="auction-tabs">
                <button class="tab-btn active" data-tab="major">Major</button>
                <button class="tab-btn" data-tab="premium">Premium</button>
                <button class="tab-btn" data-tab="weekly">Weekly</button>
            </div>
            
            <div class="auction-content">
                <!-- Major Auctions -->
                <div class="tab-content active" id="major">
                    <div class="auction-grid">
                        <% 
                        // 활성 경매 목록 표시
                        int displayCount = 0;
                        for (ProductDTO product : activeAuctions) {
                            if (displayCount >= 3) break;
                            
                            // 경매 상태 뱃지 결정
                            String badgeClass = "online";
                            String badgeText = "Online";
                            
                            // 경매 시간 포맷 (START_TIME이 없으면 END_TIME 사용)
                            String auctionDate = "";
                            String auctionTime = "";
                            if (product.getEndTime() != null) {
                                auctionDate = fullDateFormat.format(product.getEndTime());
                                auctionTime = timeFormat.format(product.getEndTime());
                            }
                            
                            // 현재 가격 계산
                            int currentPrice = product.getCurrentPrice() > 0 ? product.getCurrentPrice() : product.getStartPrice();
                        %>
                        <div class="auction-card">
                            <div class="auction-image">
                                <% if (product.getImageRenamedName() != null) { %>
                                    <img src="<%=ctx%>/resources/product_images/<%=product.getImageRenamedName()%>" alt="<%=product.getProductName()%>">
                                <% } else { %>
                                    <img src="https://images.unsplash.com/photo-1578321272176-b7bbc0679853?q=80&w=600" alt="<%=product.getProductName()%>">
                                <% } %>
                                <button class="wishlist-btn" data-product-id="<%=product.getProductId()%>" title="찜 추가">
                                    <i class="far fa-heart"></i>
                                </button>
                            </div>
                            <div class="auction-info">
                                <span class="auction-date"><%=auctionDate%></span>
                                <h3 class="auction-title"><%=product.getProductName()%></h3>
                                <p class="auction-desc">
                                    <% if (product.getArtistName() != null) { %>
                                        <%=product.getArtistName()%>
                                    <% } else { %>
                                        예술 작품
                                    <% } %>
                                </p>
                                <div class="auction-price">
                                    <div class="price-info">
                                        <span class="start-price">시작가: ₩<%=df.format(product.getStartPrice())%></span>
                                        <% if (product.getCurrentPrice() > 0 && product.getCurrentPrice() != product.getStartPrice()) { %>
                                            <span class="current-price">현재가: ₩<%=df.format(product.getCurrentPrice())%></span>
                                        <% } %>
                                    </div>
                                </div>
                                <div class="auction-meta">
                                    <span class="time"><i class="far fa-clock"></i> <%=auctionTime%></span>
                                    <span class="lots"><i class="fas fa-list"></i> <a href="<%=ctx%>/product/productDetail.jsp?productId=<%=product.getProductId()%>">상세보기</a></span>
                                </div>
                            </div>
                        </div>
                        <% 
                            displayCount++;
                        }
                        
                        // 데이터가 부족하면 기본 카드 표시
                        while (displayCount < 3) {
                        %>
                        <div class="auction-card">
                            <div class="auction-image">
                                <img src="https://images.unsplash.com/photo-1578321272176-b7bbc0679853?q=80&w=600" alt="경매">
                            </div>
                            <div class="auction-info">
                                <span class="auction-date">경매 준비중</span>
                                <h3 class="auction-title">새로운 경매</h3>
                                <p class="auction-desc">곧 시작될 예정입니다</p>
                                <div class="auction-meta">
                                    <span class="time"><i class="far fa-clock"></i> TBD</span>
                                    <span class="lots"><i class="fas fa-list"></i> 준비중</span>
                                </div>
                            </div>
                        </div>
                        <% 
                            displayCount++;
                        }
                        %>
                    </div>
                </div>
                
                <!-- Premium Auctions -->
                <div class="tab-content" id="premium">
                    <div class="auction-grid">
                        <% 
                        // 예정 경매 목록 표시 (Premium)
                        displayCount = 0;
                        for (ProductDTO product : upcomingAuctions) {
                            if (displayCount >= 3) break;
                            
                            String auctionDate = "";
                            String auctionTime = "";
                            if (product.getEndTime() != null) {
                                auctionDate = fullDateFormat.format(product.getEndTime());
                                auctionTime = timeFormat.format(product.getEndTime());
                            }
                            
                            int currentPrice = product.getCurrentPrice() > 0 ? product.getCurrentPrice() : product.getStartPrice();
                        %>
                        <div class="auction-card">
                            <div class="auction-image">
                                <% if (product.getImageRenamedName() != null) { %>
                                    <img src="<%=ctx%>/resources/product_images/<%=product.getImageRenamedName()%>" alt="<%=product.getProductName()%>">
                                <% } else { %>
                                    <img src="https://images.unsplash.com/photo-1549887534-1541e9326642?q=80&w=600" alt="<%=product.getProductName()%>">
                                <% } %>
                            </div>
                            <div class="auction-info">
                                <span class="auction-date"><%=auctionDate%></span>
                                <h3 class="auction-title"><%=product.getProductName()%></h3>
                                <p class="auction-desc">
                                    <% if (product.getArtistName() != null) { %>
                                        <%=product.getArtistName()%>
                                    <% } else { %>
                                        예술 작품
                                    <% } %>
                                </p>
                                <div class="auction-price">
                                    <div class="price-info">
                                        <span class="start-price">시작가: ₩<%=df.format(product.getStartPrice())%></span>
                                        <% if (product.getCurrentPrice() > 0 && product.getCurrentPrice() != product.getStartPrice()) { %>
                                            <span class="current-price">현재가: ₩<%=df.format(product.getCurrentPrice())%></span>
                                        <% } %>
                                    </div>
                                </div>
                                <div class="auction-meta">
                                    <span class="time"><i class="far fa-clock"></i> <%=auctionTime%></span>
                                    <span class="lots"><i class="fas fa-list"></i> <a href="<%=ctx%>/product/productDetail.jsp?productId=<%=product.getProductId()%>">상세보기</a></span>
                                </div>
                            </div>
                        </div>
                        <% 
                            displayCount++;
                        }
                        
                        // 데이터가 부족하면 기본 카드 표시
                        while (displayCount < 3) {
                        %>
                        <div class="auction-card">
                            <div class="auction-image">
                                <img src="https://images.unsplash.com/photo-1549887534-1541e9326642?q=80&w=600" alt="경매">
                            </div>
                            <div class="auction-info">
                                <span class="auction-date">프리미엄 경매 준비중</span>
                                <h3 class="auction-title">새로운 프리미엄 경매</h3>
                                <p class="auction-desc">곧 시작될 예정입니다</p>
                                <div class="auction-meta">
                                    <span class="time"><i class="far fa-clock"></i> TBD</span>
                                    <span class="lots"><i class="fas fa-list"></i> 준비중</span>
                                </div>
                            </div>
                        </div>
                        <% 
                            displayCount++;
                        }
                        %>
                    </div>
                </div>
                
                <!-- Weekly Auctions -->
                <div class="tab-content" id="weekly">
                    <div class="auction-grid">
                        <% 
                        // 활성 경매 목록의 나머지 표시 (Weekly)
                        displayCount = 0;
                        for (ProductDTO product : activeAuctions) {
                            if (displayCount >= 3) break;
                            
                            String auctionDate = "";
                            String auctionTime = "";
                            if (product.getEndTime() != null) {
                                auctionDate = fullDateFormat.format(product.getEndTime());
                                auctionTime = "순차마감";
                            } else {
                                auctionDate = "경매 일정 미정";
                                auctionTime = "순차마감";
                            }
                            
                            int currentPrice = product.getCurrentPrice() > 0 ? product.getCurrentPrice() : product.getStartPrice();
                        %>
                        <div class="auction-card">
                            <div class="auction-image">
                                <% if (product.getImageRenamedName() != null) { %>
                                    <img src="<%=ctx%>/resources/product_images/<%=product.getImageRenamedName()%>" alt="<%=product.getProductName()%>">
                                <% } else { %>
                                    <img src="https://images.unsplash.com/photo-1576086477369-b5ee4eec20d6?q=80&w=600" alt="<%=product.getProductName()%>">
                                <% } %>
                            </div>
                            <div class="auction-info">
                                <span class="auction-date"><%=auctionDate%></span>
                                <h3 class="auction-title"><%=product.getProductName()%></h3>
                                <p class="auction-desc">
                                    <% if (product.getArtistName() != null) { %>
                                        <%=product.getArtistName()%>
                                    <% } else { %>
                                        예술 작품
                                    <% } %>
                                </p>
                                <div class="auction-price">
                                    <div class="price-info">
                                        <span class="start-price">시작가: ₩<%=df.format(product.getStartPrice())%></span>
                                        <% if (product.getCurrentPrice() > 0 && product.getCurrentPrice() != product.getStartPrice()) { %>
                                            <span class="current-price">현재가: ₩<%=df.format(product.getCurrentPrice())%></span>
                                        <% } %>
                                    </div>
                                </div>
                                <div class="auction-meta">
                                    <span class="time"><i class="far fa-clock"></i> <%=auctionTime%></span>
                                    <span class="lots"><i class="fas fa-list"></i> <a href="<%=ctx%>/product/productDetail.jsp?productId=<%=product.getProductId()%>">상세보기</a></span>
                                </div>
                            </div>
                        </div>
                        <% 
                            displayCount++;
                        }
                        
                        // 데이터가 부족하면 기본 카드 표시
                        while (displayCount < 3) {
                        %>
                        <div class="auction-card">
                            <div class="auction-image">
                                <img src="https://images.unsplash.com/photo-1576086477369-b5ee4eec20d6?q=80&w=600" alt="경매">
                            </div>
                            <div class="auction-info">
                                <span class="auction-date">위클리 경매 준비중</span>
                                <h3 class="auction-title">새로운 위클리 경매</h3>
                                <p class="auction-desc">곧 시작될 예정입니다</p>
                                <div class="auction-meta">
                                    <span class="time"><i class="far fa-clock"></i> 순차마감</span>
                                    <span class="lots"><i class="fas fa-list"></i> 준비중</span>
                                </div>
                            </div>
                        </div>
                        <% 
                            displayCount++;
                        }
                        %>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Featured Artworks -->
    <section class="featured-artworks">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">Featured Artworks</h2>
                <a href="<%=ctx%>/auction/auctionList.jsp" class="view-all">전체보기 <i class="fas fa-arrow-right"></i></a>
            </div>
            
            <div class="artworks-slider swiper">
                <div class="swiper-wrapper">
                    <% 
                    // Featured Artworks 표시
                    int lotNumber = 1;
                    for (ProductDTO product : featuredProducts) {
                        int currentPrice = product.getCurrentPrice() > 0 ? product.getCurrentPrice() : product.getStartPrice();
                        int estimateMin = (int)(currentPrice * 0.8);
                        int estimateMax = (int)(currentPrice * 1.5);
                    %>
                    <div class="swiper-slide">
                        <div class="artwork-card">
                            <div class="artwork-image">
                                <% if (product.getImageRenamedName() != null) { %>
                                    <img src="<%=ctx%>/resources/product_images/<%=product.getImageRenamedName()%>" alt="<%=product.getProductName()%>">
                                <% } else { %>
                                    <img src="https://images.unsplash.com/photo-1578321272176-b7bbc0679853?q=80&w=400" alt="<%=product.getProductName()%>">
                                <% } %>
                                <div class="artwork-overlay">
                                    <button class="wishlist-btn" data-product-id="<%=product.getProductId()%>" title="찜 추가"><i class="far fa-heart"></i></button>
                                    <a href="<%=ctx%>/product/productDetail.jsp?productId=<%=product.getProductId()%>" class="btn-view">상세보기</a>
                                </div>
                            </div>
                            <div class="artwork-info">
                                <span class="lot-number">LOT <%=String.format("%03d", lotNumber)%></span>
                                <h4 class="artist-name">
                                    <% if (product.getArtistName() != null) { %>
                                        <%=product.getArtistName()%>
                                    <% } else { %>
                                        <%=product.getSellerId()%>
                                    <% } %>
                                </h4>
                                <p class="artwork-title"><%=product.getProductName()%></p>
                                <p class="artwork-details">
                                    <% if (product.getCategory() != null) { %>
                                        <%=product.getCategory()%>
                                    <% } else { %>
                                        경매 작품
                                    <% } %>
                                </p>
                                <div class="artwork-estimate">
                                    <span class="label">현재가</span>
                                    <span class="price">KRW <%=df.format(currentPrice)%></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <% 
                        lotNumber++;
                    }
                    
                    // 데이터가 부족하면 기본 카드 표시
                    while (lotNumber <= 6) {
                        String[] defaultImages = {
                            "https://images.unsplash.com/photo-1578321272176-b7bbc0679853?q=80&w=400",
                            "https://images.unsplash.com/photo-1561214115-f2f134cc4912?q=80&w=400",
                            "https://images.unsplash.com/photo-1549887534-1541e9326642?q=80&w=400"
                        };
                        String[] defaultArtists = {"김환기", "이우환", "박수근"};
                        String[] defaultTitles = {"무제", "From Point", "빨래터"};
                        
                        int index = (lotNumber - 1) % 3;
                    %>
                    <div class="swiper-slide">
                        <div class="artwork-card">
                            <div class="artwork-image">
                                <img src="<%=defaultImages[index]%>" alt="<%=defaultTitles[index]%>">
                                <div class="artwork-overlay">
                                    <button class="btn-wish"><i class="far fa-heart"></i></button>
                                    <a href="<%=ctx%>/auction/auctionList.jsp" class="btn-view">상세보기</a>
                                </div>
                            </div>
                            <div class="artwork-info">
                                <span class="lot-number">LOT <%=String.format("%03d", lotNumber)%></span>
                                <h4 class="artist-name"><%=defaultArtists[index]%></h4>
                                <p class="artwork-title"><%=defaultTitles[index]%></p>
                                <p class="artwork-details">경매 준비중</p>
                                <div class="artwork-estimate">
                                    <span class="label">추정가</span>
                                    <span class="price">TBA</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <% 
                        lotNumber++;
                    }
                    %>
                </div>
                <div class="swiper-button-prev"></div>
                <div class="swiper-button-next"></div>
            </div>
        </div>
    </section>
    
    <!-- Categories -->
    <section class="categories">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">Categories</h2>
            </div>
            
            <div class="category-grid">
                <a href="<%=ctx%>/category/categoryList.jsp?category=회화" class="category-item">
                    <div class="category-image">
                        <img src="https://images.unsplash.com/photo-1578321272176-b7bbc0679853?q=80&w=400" alt="회화">
                        <div class="category-overlay">
                            <h3>회화</h3>
                            <span>Painting</span>
                        </div>
                    </div>
                </a>
                
                <a href="<%=ctx%>/category/categoryList.jsp?category=고미술" class="category-item">
                    <div class="category-image">
                        <img src="<%=ctx%>/resources/product_images/category_antique.png" alt="고미술">
                        <div class="category-overlay">
                            <h3>고미술</h3>
                            <span>Ancient Art</span>
                        </div>
                    </div>
                </a>
                
                <a href="<%=ctx%>/category/categoryList.jsp?category=조각" class="category-item">
                    <div class="category-image">
                        <img src="https://images.unsplash.com/photo-1561214115-f2f134cc4912?q=80&w=400" alt="조각">
                        <div class="category-overlay">
                            <h3>조각</h3>
                            <span>Sculpture</span>
                        </div>
                    </div>
                </a>
                
                <a href="<%=ctx%>/category/categoryList.jsp?category=판화" class="category-item">
                    <div class="category-image">
                        <img src="<%=ctx%>/resources/product_images/photography.jpg" alt="판화">
                        <div class="category-overlay">
                            <h3>판화</h3>
                            <span>Printmaking</span>
                        </div>
                    </div>
                </a>
                
                <a href="<%=ctx%>/category/categoryList.jsp?category=사진" class="category-item">
                    <div class="category-image">
                        <img src="https://images.unsplash.com/photo-1606760227091-3dd870d97f1d?q=80&w=400" alt="사진">
                        <div class="category-overlay">
                            <h3>사진</h3>
                            <span>Photography</span>
                        </div>
                    </div>
                </a>
                
                <a href="<%=ctx%>/category/categoryList.jsp?category=추상화" class="category-item">
                    <div class="category-image">
                        <img src="https://images.unsplash.com/photo-1552519507-da3b142c6e3d?q=80&w=400" alt="추상화">
                        <div class="category-overlay">
                            <h3>추상화</h3>
                            <span>Abstract Art</span>
                        </div>
                    </div>
                </a>
            </div>
        </div>
    </section>
    
    <!-- Services -->
    <section class="services">
        <div class="container">
            <div class="service-grid">
                <div class="service-item">
                    <div class="service-icon">
                        <i class="fas fa-certificate"></i>
                    </div>
                    <h3>전문가 감정</h3>
                    <p>40년 경력의 전문가들이 작품의 진위와 가치를 정확하게 평가합니다</p>
                </div>
                
                <div class="service-item">
                    <div class="service-icon">
                        <i class="fas fa-shipping-fast"></i>
                    </div>
                    <h3>안전한 배송</h3>
                    <p>전문 미술품 운송 시스템으로 작품을 안전하게 배송해드립니다</p>
                </div>
                
                <div class="service-item">
                    <div class="service-icon">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <h3>작품 보증</h3>
                    <p>모든 경매 작품에 대해 진품 보증서를 발급해드립니다</p>
                </div>
                
                <div class="service-item">
                    <div class="service-icon">
                        <i class="fas fa-headset"></i>
                    </div>
                    <h3>전문 상담</h3>
                    <p>컬렉션 구성부터 투자 상담까지 맞춤형 서비스를 제공합니다</p>
                </div>
            </div>
        </div>
    </section>
    
    <!-- News & Events -->
    <section class="news-events">
        <div class="container">
            <div class="news-grid">
                <div class="news-main">
                    <h2 class="section-title">News & Events</h2>
                    <div class="news-list">
                        <article class="news-item">
                            <span class="news-date">2025.01.03</span>
                            <h3><a href="<%=ctx%>/news/newsList.jsp">2025년 상반기 경매 일정 안내</a></h3>
                            <p>M4 Auction의 2025년 상반기 주요 경매 일정을 안내드립니다.</p>
                        </article>
                        
                        <article class="news-item">
                            <span class="news-date">2024.12.28</span>
                            <h3><a href="<%=ctx%>/news/newsList.jsp">김환기 작품 최고가 경신</a></h3>
                            <p>12월 메이저 경매에서 김환기 화백의 작품이 52억원에 낙찰되었습니다.</p>
                        </article>
                        
                        <article class="news-item">
                            <span class="news-date">2024.12.20</span>
                            <h3><a href="<%=ctx%>/news/newsList.jsp">신규 VIP 멤버십 혜택 안내</a></h3>
                            <p>2025년부터 적용되는 새로운 VIP 멤버십 프로그램을 소개합니다.</p>
                        </article>
                    </div>
                    <a href="<%=ctx%>/news/newsList.jsp" class="btn-more">더보기 <i class="fas fa-arrow-right"></i></a>
                </div>
                
                <div class="event-banner">
                    <h3>Special Exhibition</h3>
                    <div class="event-image">
                        <img src="https://images.unsplash.com/photo-1561214115-f2f134cc4912?q=80&w=600" alt="전시">
                    </div>
                    <div class="event-info">
                        <h4>한국 단색화의 거장들</h4>
                        <p>2025.01.15 - 02.28</p>
                        <p>M4 Gallery</p>
                        <a href="<%=ctx%>/news/newsList.jsp" class="btn btn-outline-white">자세히 보기</a>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Newsletter -->
    <section class="newsletter">
        <div class="container">
            <div class="newsletter-content">
                <div class="newsletter-text">
                    <h2>Newsletter</h2>
                    <p>M4 Auction의 최신 경매 소식과 전시 정보를 받아보세요</p>
                </div>
                <form class="newsletter-form">
                    <input type="email" placeholder="이메일 주소를 입력하세요" required>
                    <button type="submit">구독하기</button>
                </form>
            </div>
        </div>
    </section>
    
    <!-- Footer -->
    <jsp:include page="/layout/footer/luxury-footer.jsp" />
    
    <!-- Swiper JS -->
    <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
    
    <!-- Custom JS -->
    <script>
        // 이미지 로드 실패시 대체 이미지로 변경
        document.addEventListener('DOMContentLoaded', function() {
            const images = document.querySelectorAll('img');
            images.forEach(img => {
                img.onerror = function() {
                    // alt 텍스트를 기반으로 적절한 대체 이미지 선택
                    const altText = this.alt || '';
                    let fallbackSrc = '';
                    
                    if (altText.includes('판화') || altText.includes('Printmaking')) {
                        fallbackSrc = 'https://images.unsplash.com/photo-1549887534-1541e9326642?q=80&w=400';
                    } else if (altText.includes('고미술') || altText.includes('Ancient')) {
                        fallbackSrc = 'https://images.unsplash.com/photo-1569096651661-820d0de9b8ab?q=80&w=400';
                    } else if (altText.includes('회화') || altText.includes('Painting')) {
                        fallbackSrc = 'https://images.unsplash.com/photo-1578321272176-b7bbc0679853?q=80&w=400';
                    } else if (altText.includes('조각') || altText.includes('Sculpture')) {
                        fallbackSrc = 'https://images.unsplash.com/photo-1561214115-f2f134cc4912?q=80&w=400';
                    } else if (altText.includes('사진') || altText.includes('Photography')) {
                        fallbackSrc = 'https://images.unsplash.com/photo-1606760227091-3dd870d97f1d?q=80&w=400';
                    } else if (altText.includes('추상화') || altText.includes('Abstract')) {
                        fallbackSrc = 'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?q=80&w=400';
                    } else {
                        // 기본 랜덤 placeholder 이미지
                        const placeholders = [
                            'https://images.unsplash.com/photo-1578321272176-b7bbc0679853?q=80&w=600',
                            'https://images.unsplash.com/photo-1549887534-1541e9326642?q=80&w=600',
                            'https://images.unsplash.com/photo-1576086477369-b5ee4eec20d6?q=80&w=600',
                            'https://images.unsplash.com/photo-1569096651661-820d0de9b8ab?q=80&w=600'
                        ];
                        const randomIndex = Math.floor(Math.random() * placeholders.length);
                        fallbackSrc = placeholders[randomIndex];
                    }
                    
                    this.src = fallbackSrc;
                    this.onerror = null; // 무한 루프 방지
                };
            });
        });
    </script>
    <script>
        // Hero Slider
        const heroSlider = new Swiper('.hero-slider', {
            loop: true,
            autoplay: {
                delay: 5000,
                disableOnInteraction: false,
            },
            pagination: {
                el: '.swiper-pagination',
                clickable: true,
            },
            navigation: {
                nextEl: '.swiper-button-next',
                prevEl: '.swiper-button-prev',
            },
            effect: 'fade',
            fadeEffect: {
                crossFade: true
            }
        });
        
        // Artworks Slider
        const artworksSlider = new Swiper('.artworks-slider', {
            slidesPerView: 1,
            spaceBetween: 20,
            loop: true,
            navigation: {
                nextEl: '.artworks-slider .swiper-button-next',
                prevEl: '.artworks-slider .swiper-button-prev',
            },
            breakpoints: {
                640: {
                    slidesPerView: 2,
                },
                768: {
                    slidesPerView: 3,
                },
                1024: {
                    slidesPerView: 4,
                }
            }
        });
        
        // Tab functionality
        const tabBtns = document.querySelectorAll('.tab-btn');
        const tabContents = document.querySelectorAll('.tab-content');
        
        tabBtns.forEach(btn => {
            btn.addEventListener('click', () => {
                const tabId = btn.getAttribute('data-tab');
                
                // Remove active class from all
                tabBtns.forEach(b => b.classList.remove('active'));
                tabContents.forEach(c => c.classList.remove('active'));
                
                // Add active class to clicked
                btn.classList.add('active');
                document.getElementById(tabId).classList.add('active');
            });
        });
        
        // Smooth scroll
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                const href = this.getAttribute('href');
                // '#'만 있거나 빈 href는 무시
                if (!href || href === '#' || href.length <= 1) {
                    return;
                }
                e.preventDefault();
                const target = document.querySelector(href);
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });
        
    </script>
    
    <!-- 찜 기능 JavaScript -->
    <script src="<%=ctx%>/resources/js/wishlist.js"></script>
    
</body>
</html>