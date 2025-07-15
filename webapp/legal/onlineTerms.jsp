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
    <title>온라인경매약관 - M4 Auction</title>
    
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
            line-height: 1.7;
        }
        
        .page-header {
            background: linear-gradient(135deg, #c9961a 0%, #d4af37 100%);
            color: white;
            padding: 80px 0;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .page-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('https://images.unsplash.com/photo-1578662996442-48f60103fc96?q=80&w=2000') center/cover;
            opacity: 0.1;
        }
        
        .header-content {
            position: relative;
            z-index: 2;
        }
        
        .page-title {
            font-family: 'Playfair Display', serif;
            font-size: 48px;
            font-weight: 700;
            margin-bottom: 20px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        
        .page-subtitle {
            font-size: 20px;
            opacity: 0.9;
            max-width: 600px;
            margin: 0 auto;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.2);
        }
        
        .container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 0 20px;
        }
        
        .content-wrapper {
            padding: 60px 0;
        }
        
        .terms-nav {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08);
            margin-bottom: 30px;
            padding: 30px;
            position: sticky;
            top: 140px;
            z-index: 10;
        }
        
        .nav-title {
            font-size: 20px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .nav-icon {
            color: #c9961a;
            font-size: 24px;
        }
        
        .nav-list {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 10px;
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .nav-item {
            background: #f8f9fa;
            border-radius: 8px;
            transition: all 0.3s;
        }
        
        .nav-item:hover {
            background: #e9ecef;
            transform: translateY(-2px);
        }
        
        .nav-link {
            display: block;
            padding: 12px 16px;
            color: #333;
            text-decoration: none;
            font-weight: 500;
            font-size: 14px;
            transition: color 0.3s;
        }
        
        .nav-link:hover {
            color: #c9961a;
        }
        
        .terms-content {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08);
            padding: 50px;
        }
        
        .section-title {
            font-size: 32px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 40px;
            border-bottom: 3px solid #c9961a;
            padding-bottom: 15px;
        }
        
        .article {
            margin-bottom: 50px;
        }
        
        .article-title {
            font-size: 24px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .article-number {
            background: #c9961a;
            color: white;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            font-weight: 700;
        }
        
        .article-content {
            color: #555;
            margin-left: 55px;
        }
        
        .article-content h4 {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin: 25px 0 15px 0;
        }
        
        .article-content p {
            margin-bottom: 18px;
        }
        
        .article-content ul,
        .article-content ol {
            margin: 18px 0;
            padding-left: 25px;
        }
        
        .article-content li {
            margin-bottom: 10px;
        }
        
        .highlight {
            background: #fff3cd;
            padding: 3px 8px;
            border-radius: 4px;
            font-weight: 600;
            color: #856404;
        }
        
        .important {
            background: #f8d7da;
            border: 1px solid #f5c6cb;
            border-radius: 8px;
            padding: 20px;
            margin: 25px 0;
        }
        
        .important .important-title {
            font-weight: 700;
            color: #721c24;
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 16px;
        }
        
        .important .important-content {
            color: #721c24;
        }
        
        .warning {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 8px;
            padding: 20px;
            margin: 25px 0;
        }
        
        .warning .warning-title {
            font-weight: 700;
            color: #856404;
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 16px;
        }
        
        .warning .warning-content {
            color: #856404;
        }
        
        .table-container {
            overflow-x: auto;
            margin: 25px 0;
        }
        
        .terms-table {
            width: 100%;
            border-collapse: collapse;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .terms-table th {
            background: #c9961a;
            color: white;
            padding: 15px;
            text-align: left;
            font-weight: 600;
        }
        
        .terms-table td {
            padding: 15px;
            border-bottom: 1px solid #e9ecef;
            vertical-align: top;
        }
        
        .terms-table tr:last-child td {
            border-bottom: none;
        }
        
        .terms-table tr:nth-child(even) {
            background: #f8f9fa;
        }
        
        .contact-info {
            background: linear-gradient(135deg, #c9961a 0%, #d4af37 100%);
            color: white;
            padding: 40px;
            border-radius: 12px;
            margin-top: 40px;
            text-align: center;
        }
        
        .contact-title {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 20px;
        }
        
        .contact-details {
            display: flex;
            justify-content: center;
            gap: 40px;
            flex-wrap: wrap;
        }
        
        .contact-item {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 16px;
        }
        
        .contact-item i {
            font-size: 20px;
        }
        
        .last-updated {
            text-align: center;
            color: #666;
            margin-top: 40px;
            padding-top: 25px;
            border-top: 1px solid #e9ecef;
            font-size: 14px;
        }
        
        @media (max-width: 768px) {
            .page-title {
                font-size: 36px;
            }
            
            .terms-content {
                padding: 30px 20px;
            }
            
            .terms-nav {
                position: static;
                padding: 20px;
            }
            
            .nav-list {
                grid-template-columns: 1fr;
            }
            
            .contact-details {
                flex-direction: column;
                gap: 20px;
            }
            
            .article-content {
                margin-left: 0;
            }
            
            .article-title {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/layout/header/luxury-header.jsp" />
    
    <!-- Page Header -->
    <section class="page-header">
        <div class="container">
            <div class="header-content">
                <h1 class="page-title">온라인경매약관</h1>
                <p class="page-subtitle">M4 Auction 온라인 경매 서비스 이용약관입니다</p>
            </div>
        </div>
    </section>
    
    <!-- Content -->
    <section class="content-wrapper">
        <div class="container">
            <!-- Navigation -->
            <div class="terms-nav">
                <h2 class="nav-title">
                    <i class="fas fa-list nav-icon"></i>
                    약관 목차
                </h2>
                <ul class="nav-list">
                    <li class="nav-item">
                        <a href="#general" class="nav-link">총칙</a>
                    </li>
                    <li class="nav-item">
                        <a href="#auction" class="nav-link">경매 참여</a>
                    </li>
                    <li class="nav-item">
                        <a href="#bidding" class="nav-link">입찰 및 낙찰</a>
                    </li>
                    <li class="nav-item">
                        <a href="#payment" class="nav-link">결제 및 수수료</a>
                    </li>
                    <li class="nav-item">
                        <a href="#delivery" class="nav-link">인도 및 배송</a>
                    </li>
                    <li class="nav-item">
                        <a href="#responsibility" class="nav-link">책임과 의무</a>
                    </li>
                </ul>
            </div>
            
            <!-- Terms Content -->
            <div class="terms-content">
                <h1 class="section-title">M4 Auction 온라인경매약관</h1>
                
                <div class="article" id="general">
                    <h2 class="article-title">
                        <span class="article-number">1</span>
                        총칙
                    </h2>
                    <div class="article-content">
                        <h4>제1조 (목적)</h4>
                        <p>
                            이 약관은 M4 Auction(이하 "회사")이 제공하는 온라인 경매 서비스의 
                            이용에 관한 회사와 이용자 간의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.
                        </p>
                        
                        <h4>제2조 (정의)</h4>
                        <p>이 약관에서 사용하는 용어의 정의는 다음과 같습니다:</p>
                        <ol>
                            <li><span class="highlight">"온라인 경매"</span>: 인터넷을 통해 실시하는 경매</li>
                            <li><span class="highlight">"입찰자"</span>: 온라인 경매에 참여하여 입찰하는 회원</li>
                            <li><span class="highlight">"낙찰자"</span>: 경매에서 최고가 입찰로 낙찰받은 회원</li>
                            <li><span class="highlight">"위탁자"</span>: 경매 출품을 위해 작품을 위탁한 자</li>
                            <li><span class="highlight">"경매물건"</span>: 경매에 출품된 미술품 및 골동품</li>
                        </ol>
                        
                        <h4>제3조 (약관의 효력 및 변경)</h4>
                        <p>
                            이 약관은 웹사이트에 게시함으로써 효력이 발생하며, 회사는 필요에 따라 
                            약관을 변경할 수 있고, 변경된 약관은 공지 후 7일이 경과한 날부터 효력이 발생합니다.
                        </p>
                        
                        <div class="important">
                            <div class="important-title">
                                <i class="fas fa-exclamation-circle"></i>
                                중요 안내
                            </div>
                            <div class="important-content">
                                온라인 경매 참여 시 본 약관에 동의한 것으로 간주되며, 
                                약관 변경 시 이의가 있는 경우 서비스 이용을 중단할 수 있습니다.
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="article" id="auction">
                    <h2 class="article-title">
                        <span class="article-number">2</span>
                        온라인 경매 참여
                    </h2>
                    <div class="article-content">
                        <h4>제4조 (경매 참여 자격)</h4>
                        <p>온라인 경매에 참여하기 위해서는 다음 조건을 충족해야 합니다:</p>
                        <ul>
                            <li>회사의 정회원으로 가입되어 있을 것</li>
                            <li>본인인증을 완료했을 것</li>
                            <li>충분한 마일리지를 보유하고 있을 것</li>
                            <li>경매 참여 제재 이력이 없을 것</li>
                        </ul>
                        
                        <h4>제5조 (경매 시간 및 진행)</h4>
                        <div class="table-container">
                            <table class="terms-table">
                                <thead>
                                    <tr>
                                        <th>구분</th>
                                        <th>시간</th>
                                        <th>특이사항</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>일반 온라인 경매</td>
                                        <td>24시간 진행</td>
                                        <td>마감 10분 전 입찰 시 10분 연장</td>
                                    </tr>
                                    <tr>
                                        <td>프리미엄 경매</td>
                                        <td>48시간 진행</td>
                                        <td>마감 30분 전 입찰 시 30분 연장</td>
                                    </tr>
                                    <tr>
                                        <td>시스템 점검</td>
                                        <td>매주 일요일 새벽 2시 ~ 4시</td>
                                        <td>경매 진행 중단</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        
                        <h4>제6조 (경매 정보 제공)</h4>
                        <p>회사는 경매물건에 대해 다음 정보를 제공합니다:</p>
                        <ul>
                            <li>작품명, 작가명, 제작연도, 재료, 크기</li>
                            <li>작품 상태 및 보존 정도</li>
                            <li>추정가 및 시작가</li>
                            <li>작품 이미지 (고해상도)</li>
                            <li>출품 배경 및 작품 해설</li>
                        </ul>
                    </div>
                </div>
                
                <div class="article" id="bidding">
                    <h2 class="article-title">
                        <span class="article-number">3</span>
                        입찰 및 낙찰
                    </h2>
                    <div class="article-content">
                        <h4>제7조 (입찰 방법)</h4>
                        <p>온라인 경매의 입찰은 다음과 같이 진행됩니다:</p>
                        <ol>
                            <li>웹사이트에 로그인 후 원하는 경매물건 선택</li>
                            <li>현재 최고가보다 높은 금액으로 입찰</li>
                            <li>입찰 즉시 시스템에 반영</li>
                            <li>경매 종료 시까지 최고 입찰가 유지 시 낙찰</li>
                        </ol>
                        
                        <h4>제8조 (입찰 단위)</h4>
                        <div class="table-container">
                            <table class="terms-table">
                                <thead>
                                    <tr>
                                        <th>현재 입찰가 범위</th>
                                        <th>최소 입찰 단위</th>
                                        <th>예시</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>100만원 미만</td>
                                        <td>1만원</td>
                                        <td>50만원 → 51만원</td>
                                    </tr>
                                    <tr>
                                        <td>100만원 이상 ~ 500만원 미만</td>
                                        <td>5만원</td>
                                        <td>300만원 → 305만원</td>
                                    </tr>
                                    <tr>
                                        <td>500만원 이상 ~ 1,000만원 미만</td>
                                        <td>10만원</td>
                                        <td>800만원 → 810만원</td>
                                    </tr>
                                    <tr>
                                        <td>1,000만원 이상</td>
                                        <td>50만원</td>
                                        <td>2,000만원 → 2,050만원</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        
                        <h4>제9조 (입찰 취소 및 변경)</h4>
                        <p>입찰에 관한 취소 및 변경 규정:</p>
                        <ul>
                            <li>입찰 취소는 경매 종료 1시간 전까지만 가능</li>
                            <li>타인의 입찰이 있는 경우 취소 불가</li>
                            <li>입찰 금액 변경은 더 높은 금액으로만 가능</li>
                            <li>시스템 오류로 인한 오입찰은 별도 문의</li>
                        </ul>
                        
                        <div class="warning">
                            <div class="warning-title">
                                <i class="fas fa-exclamation-triangle"></i>
                                주의사항
                            </div>
                            <div class="warning-content">
                                입찰은 법적 구속력을 가지는 계약 행위입니다. 
                                신중하게 검토 후 입찰하시기 바랍니다.
                            </div>
                        </div>
                        
                        <h4>제10조 (낙찰 및 통지)</h4>
                        <p>낙찰에 관한 규정:</p>
                        <ol>
                            <li>경매 종료 시 최고 입찰자가 낙찰</li>
                            <li>동일 입찰가의 경우 먼저 입찰한 자가 우선</li>
                            <li>낙찰 즉시 SMS 및 이메일로 통지</li>
                            <li>낙찰자는 7일 이내 결제 완료 의무</li>
                        </ol>
                    </div>
                </div>
                
                <div class="article" id="payment">
                    <h2 class="article-title">
                        <span class="article-number">4</span>
                        결제 및 수수료
                    </h2>
                    <div class="article-content">
                        <h4>제11조 (결제 의무)</h4>
                        <p>낙찰자는 다음 금액을 결제해야 합니다:</p>
                        <ul>
                            <li><span class="highlight">낙찰가</span>: 최종 입찰 성공 금액</li>
                            <li><span class="highlight">구매자 프리미엄</span>: 낙찰가의 15% (VIP 회원 13%)</li>
                            <li><span class="highlight">부가세</span>: 구매자 프리미엄의 10%</li>
                            <li><span class="highlight">배송비</span>: 전국 무료 (직접 수령 시 불필요)</li>
                        </ul>
                        
                        <h4>제12조 (결제 방법 및 기한)</h4>
                        <div class="table-container">
                            <table class="terms-table">
                                <thead>
                                    <tr>
                                        <th>결제 방법</th>
                                        <th>처리 시간</th>
                                        <th>수수료</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>마일리지 결제</td>
                                        <td>즉시</td>
                                        <td>무료</td>
                                    </tr>
                                    <tr>
                                        <td>신용카드 결제</td>
                                        <td>즉시</td>
                                        <td>카드사 수수료</td>
                                    </tr>
                                    <tr>
                                        <td>계좌이체</td>
                                        <td>1-2시간</td>
                                        <td>무료</td>
                                    </tr>
                                    <tr>
                                        <td>무통장입금</td>
                                        <td>확인 후 처리</td>
                                        <td>무료</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        
                        <p><strong>결제 기한:</strong> 낙찰 후 7일 이내 (휴일 제외)</p>
                        
                        <h4>제13조 (결제 불이행 시 조치)</h4>
                        <p>결제 기한 내 미결제 시 다음 조치가 취해집니다:</p>
                        <ol>
                            <li><strong>1일차:</strong> SMS/이메일 결제 독촉</li>
                            <li><strong>3일차:</strong> 전화 연락 및 최종 통보</li>
                            <li><strong>7일차:</strong> 낙찰 취소 및 재경매 진행</li>
                            <li><strong>조치:</strong> 3개월 경매 참여 제한</li>
                        </ol>
                        
                        <div class="important">
                            <div class="important-title">
                                <i class="fas fa-credit-card"></i>
                                결제 안내
                            </div>
                            <div class="important-content">
                                결제 완료 후에는 취소가 불가능하므로 신중하게 결제하시기 바랍니다. 
                                단, 작품 하자 발견 시에는 별도 협의 가능합니다.
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="article" id="delivery">
                    <h2 class="article-title">
                        <span class="article-number">5</span>
                        인도 및 배송
                    </h2>
                    <div class="article-content">
                        <h4>제14조 (작품 인도 방법)</h4>
                        <p>낙찰 작품의 인도는 다음 방법 중 선택할 수 있습니다:</p>
                        <ul>
                            <li><span class="highlight">직접 수령</span>: 회사 사무실에서 직접 수령 (예약 필수)</li>
                            <li><span class="highlight">택배 배송</span>: 전국 무료 배송 (영업일 기준 2-3일)</li>
                            <li><span class="highlight">전문 배송</span>: 고가 작품 전문 배송 (별도 비용)</li>
                        </ul>
                        
                        <h4>제15조 (배송 및 보험)</h4>
                        <p>배송에 관한 세부 사항:</p>
                        <ul>
                            <li>모든 작품은 전문 포장재로 안전하게 포장</li>
                            <li>배송 중 파손에 대비한 운송보험 가입</li>
                            <li>고가 작품(1,000만원 이상)은 별도 보험 가입</li>
                            <li>배송 추적 서비스 제공</li>
                        </ul>
                        
                        <h4>제16조 (작품 확인 및 이의제기)</h4>
                        <p>작품 수령 후 확인 절차:</p>
                        <ol>
                            <li>작품 수령 즉시 외관 및 상태 확인</li>
                            <li>손상 발견 시 즉시 사진 촬영 및 신고</li>
                            <li>수령 후 3일 이내 이의제기 가능</li>
                            <li>정당한 이의제기 시 교환 또는 환불 처리</li>
                        </ol>
                        
                        <div class="warning">
                            <div class="warning-title">
                                <i class="fas fa-shipping-fast"></i>
                                배송 주의사항
                            </div>
                            <div class="warning-content">
                                작품 수령 후 3일 이후에는 이의제기가 불가능하므로 
                                반드시 수령 즉시 상태를 확인해주시기 바랍니다.
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="article" id="responsibility">
                    <h2 class="article-title">
                        <span class="article-number">6</span>
                        책임과 의무
                    </h2>
                    <div class="article-content">
                        <h4>제17조 (회사의 의무)</h4>
                        <p>회사는 다음 의무를 성실히 이행합니다:</p>
                        <ul>
                            <li>온라인 경매 시스템의 안정적 운영</li>
                            <li>경매물건에 대한 정확한 정보 제공</li>
                            <li>공정하고 투명한 경매 진행</li>
                            <li>개인정보 및 거래정보 보호</li>
                            <li>고객 문의 및 불만 신속 처리</li>
                        </ul>
                        
                        <h4>제18조 (이용자의 의무)</h4>
                        <p>이용자는 다음 의무를 준수해야 합니다:</p>
                        <ul>
                            <li>정확한 개인정보 제공 및 변경사항 신고</li>
                            <li>약관 및 관련 법령 준수</li>
                            <li>입찰 시 신중한 판단</li>
                            <li>낙찰 시 성실한 결제 이행</li>
                            <li>타 이용자에 대한 방해 금지</li>
                        </ul>
                        
                        <h4>제19조 (면책 조항)</h4>
                        <p>회사는 다음 경우에 대해 책임을 지지 않습니다:</p>
                        <ol>
                            <li>천재지변, 정전, 통신장애 등 불가항력적 사유</li>
                            <li>이용자의 고의 또는 과실로 인한 손해</li>
                            <li>제3자가 제공하는 서비스의 장애</li>
                            <li>경매물건의 투자가치 변동</li>
                        </ol>
                        
                        <h4>제20조 (분쟁 해결)</h4>
                        <p>
                            온라인 경매 관련 분쟁이 발생한 경우 다음 절차에 따라 해결합니다:
                        </p>
                        <ol>
                            <li><strong>1단계:</strong> 고객센터를 통한 협의</li>
                            <li><strong>2단계:</strong> 사내 분쟁조정위원회 조정</li>
                            <li><strong>3단계:</strong> 소비자분쟁조정위원회 조정</li>
                            <li><strong>4단계:</strong> 관할 법원 소송</li>
                        </ol>
                    </div>
                </div>
                
                <!-- Contact Information -->
                <div class="contact-info">
                    <h3 class="contact-title">온라인 경매 문의</h3>
                    <div class="contact-details">
                        <div class="contact-item">
                            <i class="fas fa-phone"></i>
                            02-1234-5678
                        </div>
                        <div class="contact-item">
                            <i class="fas fa-envelope"></i>
                            auction@m4auction.com
                        </div>
                        <div class="contact-item">
                            <i class="fas fa-clock"></i>
                            평일 09:00 - 18:00
                        </div>
                    </div>
                </div>
                
                <div class="last-updated">
                    <p><strong>시행일자:</strong> 2024년 7월 1일</p>
                    <p><strong>최종 개정일:</strong> 2024년 7월 8일</p>
                </div>
            </div>
        </div>
    </section>
    
    <jsp:include page="/layout/footer/luxury-footer.jsp" />
    
    <script>
        // 스무스 스크롤
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });
    </script>
</body>
</html>