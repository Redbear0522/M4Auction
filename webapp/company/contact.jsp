<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.auction.dto.MemberDTO" %>
<%
    String ctx = request.getContextPath();
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact M4 Auction - 문의하기</title>
    
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
        
        .contact-hero {
            background: linear-gradient(135deg, #1a1a1a 0%, #c9961a 100%);
            color: white;
            padding: 80px 0;
            text-align: center;
        }
        
        .contact-hero h1 {
            font-family: 'Playfair Display', serif;
            font-size: 48px;
            font-weight: 700;
            margin-bottom: 20px;
        }
        
        .contact-hero p {
            font-size: 20px;
            opacity: 0.9;
            max-width: 600px;
            margin: 0 auto;
        }
        
        .contact-content {
            padding: 80px 0;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }
        
        .contact-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 80px;
            margin-top: 40px;
        }
        
        .contact-info {
            padding: 40px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08);
        }
        
        .contact-form {
            padding: 40px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08);
        }
        
        .section-title {
            font-family: 'Playfair Display', serif;
            font-size: 32px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 30px;
            text-align: center;
        }
        
        .info-item {
            display: flex;
            align-items: flex-start;
            margin-bottom: 30px;
        }
        
        .info-icon {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #c9961a 0%, #d4af37 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 18px;
            margin-right: 20px;
            flex-shrink: 0;
        }
        
        .info-content h4 {
            font-size: 18px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 5px;
        }
        
        .info-content p {
            color: #666;
            margin: 0;
            line-height: 1.6;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #1a1a1a;
        }
        
        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 15px;
            border: 1px solid #e5e5e5;
            border-radius: 8px;
            font-size: 16px;
            transition: border-color 0.3s;
            box-sizing: border-box;
            background: #fafafa;
        }
        
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #c9961a;
            background: white;
        }
        
        .form-group textarea {
            resize: vertical;
            min-height: 120px;
        }
        
        .submit-btn {
            background: linear-gradient(135deg, #c9961a 0%, #d4af37 100%);
            color: white;
            padding: 15px 40px;
            border: none;
            border-radius: 8px;
            font-size: 18px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            width: 100%;
        }
        
        .submit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(201, 150, 26, 0.3);
        }
        
        .business-hours {
            background: #f8f9fa;
            padding: 30px;
            border-radius: 8px;
            margin-top: 30px;
        }
        
        .business-hours h4 {
            color: #1a1a1a;
            margin-bottom: 15px;
            font-weight: 600;
        }
        
        .hours-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .hours-list li {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid #e5e5e5;
            color: #666;
        }
        
        .hours-list li:last-child {
            border-bottom: none;
        }
        
        @media (max-width: 768px) {
            .contact-hero h1 {
                font-size: 36px;
            }
            
            .contact-hero p {
                font-size: 18px;
            }
            
            .contact-grid {
                grid-template-columns: 1fr;
                gap: 40px;
            }
            
            .contact-info,
            .contact-form {
                padding: 30px;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/layout/header/luxury-header.jsp" />
    
    <!-- Hero Section -->
    <section class="contact-hero">
        <div class="container">
            <h1>Contact M4 Auction</h1>
            <p>궁금한 점이 있으시면 언제든지 문의해 주세요. 전문 상담원이 도움을 드리겠습니다.</p>
        </div>
    </section>
    
    <!-- Contact Content -->
    <section class="contact-content">
        <div class="container">
            <div class="contact-grid">
                <!-- Contact Information -->
                <div class="contact-info">
                    <h2 style="font-family: 'Playfair Display', serif; font-size: 28px; font-weight: 700; color: #1a1a1a; margin-bottom: 30px;">연락처 정보</h2>
                    
                    <div class="info-item">
                        <div class="info-icon">
                            <i class="fas fa-map-marker-alt"></i>
                        </div>
                        <div class="info-content">
                            <h4>주소</h4>
                            <p>서울특별시 강남구 테헤란로 123<br>M4 아트센터 10층</p>
                        </div>
                    </div>
                    
                    <div class="info-item">
                        <div class="info-icon">
                            <i class="fas fa-phone"></i>
                        </div>
                        <div class="info-content">
                            <h4>전화번호</h4>
                            <p>02-1234-5678<br>고객센터: 1588-0000</p>
                        </div>
                    </div>
                    
                    <div class="info-item">
                        <div class="info-icon">
                            <i class="fas fa-envelope"></i>
                        </div>
                        <div class="info-content">
                            <h4>이메일</h4>
                            <p>info@m4auction.com<br>support@m4auction.com</p>
                        </div>
                    </div>
                    
                    <div class="info-item">
                        <div class="info-icon">
                            <i class="fas fa-fax"></i>
                        </div>
                        <div class="info-content">
                            <h4>팩스</h4>
                            <p>02-1234-5679</p>
                        </div>
                    </div>
                    
                    <!-- Business Hours -->
                    <div class="business-hours">
                        <h4><i class="fas fa-clock" style="margin-right: 8px;"></i>운영시간</h4>
                        <ul class="hours-list">
                            <li><span>월 - 금</span><span>09:00 - 18:00</span></li>
                            <li><span>토요일</span><span>10:00 - 17:00</span></li>
                            <li><span>일요일</span><span>휴무</span></li>
                            <li><span>공휴일</span><span>휴무</span></li>
                        </ul>
                    </div>
                </div>
                
                <!-- Contact Form -->
                <div class="contact-form">
                    <h2 style="font-family: 'Playfair Display', serif; font-size: 28px; font-weight: 700; color: #1a1a1a; margin-bottom: 30px;">문의하기</h2>
                    
                    <form action="<%=ctx%>/company/contactAction.jsp" method="post">
                        <div class="form-group">
                            <label for="name">이름 *</label>
                            <input type="text" id="name" name="name" required 
                                   value="<%= loginUser != null ? loginUser.getMemberName() : "" %>">
                        </div>
                        
                        <div class="form-group">
                            <label for="email">이메일 *</label>
                            <input type="email" id="email" name="email" required 
                                   value="<%= loginUser != null ? loginUser.getEmail() : "" %>">
                        </div>
                        
                        <div class="form-group">
                            <label for="phone">연락처</label>
                            <input type="tel" id="phone" name="phone" 
                                   value="<%= loginUser != null && loginUser.getTel() != null ? loginUser.getTel() : "" %>">
                        </div>
                        
                        <div class="form-group">
                            <label for="category">문의 분류 *</label>
                            <select id="category" name="category" required>
                                <option value="">문의 분류를 선택해주세요</option>
                                <option value="auction">경매 관련</option>
                                <option value="consignment">위탁 문의</option>
                                <option value="bidding">입찰 문의</option>
                                <option value="payment">결제 문의</option>
                                <option value="technical">기술 지원</option>
                                <option value="other">기타</option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="subject">제목 *</label>
                            <input type="text" id="subject" name="subject" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="message">문의 내용 *</label>
                            <textarea id="message" name="message" required 
                                      placeholder="자세한 문의 내용을 작성해 주세요."></textarea>
                        </div>
                        
                        <button type="submit" class="submit-btn">문의 보내기</button>
                    </form>
                </div>
            </div>
        </div>
    </section>
    
    <jsp:include page="/layout/footer/luxury-footer.jsp" />
</body>
</html>