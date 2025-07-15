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
    <title>개인정보처리방침 - M4 Auction</title>
    
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
            background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
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
            background: url('https://images.unsplash.com/photo-1450101499163-c8848c66ca85?q=80&w=2000') center/cover;
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
            background: linear-gradient(45deg, #c9961a, #d4af37);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .page-subtitle {
            font-size: 20px;
            opacity: 0.9;
            max-width: 600px;
            margin: 0 auto;
        }
        
        .container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 0 20px;
        }
        
        .content-wrapper {
            padding: 60px 0;
        }
        
        .privacy-nav {
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
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
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
        
        .privacy-content {
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
            background: #d1ecf1;
            border: 1px solid #bee5eb;
            border-radius: 8px;
            padding: 20px;
            margin: 25px 0;
        }
        
        .important .important-title {
            font-weight: 700;
            color: #0c5460;
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 16px;
        }
        
        .important .important-content {
            color: #0c5460;
        }
        
        .table-container {
            overflow-x: auto;
            margin: 25px 0;
        }
        
        .privacy-table {
            width: 100%;
            border-collapse: collapse;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .privacy-table th {
            background: #c9961a;
            color: white;
            padding: 15px;
            text-align: left;
            font-weight: 600;
        }
        
        .privacy-table td {
            padding: 15px;
            border-bottom: 1px solid #e9ecef;
            vertical-align: top;
        }
        
        .privacy-table tr:last-child td {
            border-bottom: none;
        }
        
        .privacy-table tr:nth-child(even) {
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
            
            .privacy-content {
                padding: 30px 20px;
            }
            
            .privacy-nav {
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
                <h1 class="page-title">개인정보처리방침</h1>
                <p class="page-subtitle">M4 Auction의 개인정보 보호 정책입니다</p>
            </div>
        </div>
    </section>
    
    <!-- Content -->
    <section class="content-wrapper">
        <div class="container">
            <!-- Navigation -->
            <div class="privacy-nav">
                <h2 class="nav-title">
                    <i class="fas fa-list nav-icon"></i>
                    목차
                </h2>
                <ul class="nav-list">
                    <li class="nav-item">
                        <a href="#general" class="nav-link">개인정보 처리방침 개요</a>
                    </li>
                    <li class="nav-item">
                        <a href="#collection" class="nav-link">개인정보 수집 및 이용</a>
                    </li>
                    <li class="nav-item">
                        <a href="#provision" class="nav-link">개인정보 제공</a>
                    </li>
                    <li class="nav-item">
                        <a href="#retention" class="nav-link">개인정보 보유 및 이용</a>
                    </li>
                    <li class="nav-item">
                        <a href="#rights" class="nav-link">정보주체의 권리</a>
                    </li>
                    <li class="nav-item">
                        <a href="#security" class="nav-link">개인정보 보호조치</a>
                    </li>
                </ul>
            </div>
            
            <!-- Privacy Content -->
            <div class="privacy-content">
                <h1 class="section-title">M4 Auction 개인정보처리방침</h1>
                
                <div class="article" id="general">
                    <h2 class="article-title">
                        <span class="article-number">1</span>
                        개인정보 처리방침 개요
                    </h2>
                    <div class="article-content">
                        <h4>제1조 (목적)</h4>
                        <p>
                            M4 Auction(이하 "회사")는 정보통신망 이용촉진 및 정보보호 등에 관한 법률, 
                            개인정보보호법 등 관련 법령에 따라 이용자의 개인정보를 보호하고 이와 관련한 
                            고충을 신속하고 원활하게 처리할 수 있도록 하기 위하여 다음과 같이 개인정보처리방침을 수립·공개합니다.
                        </p>
                        
                        <h4>제2조 (개인정보처리방침의 효력 및 변경)</h4>
                        <p>
                            이 개인정보처리방침은 시행일로부터 적용되며, 법령 및 방침에 따른 변경내용의 추가, 
                            삭제 및 정정이 있는 경우에는 변경사항의 시행 7일 전부터 공지사항을 통하여 고지할 것입니다.
                        </p>
                        
                        <div class="important">
                            <div class="important-title">
                                <i class="fas fa-info-circle"></i>
                                중요 안내
                            </div>
                            <div class="important-content">
                                본 개인정보처리방침은 M4 Auction의 모든 서비스에 적용되며, 
                                서비스 이용 시 동의한 것으로 간주됩니다.
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="article" id="collection">
                    <h2 class="article-title">
                        <span class="article-number">2</span>
                        개인정보 수집 및 이용
                    </h2>
                    <div class="article-content">
                        <h4>제3조 (개인정보의 수집 및 이용 목적)</h4>
                        <p>회사는 다음의 목적을 위하여 개인정보를 처리합니다:</p>
                        <ol>
                            <li><span class="highlight">회원 가입 및 관리</span>: 회원 식별, 가입 의사 확인, 회원제 서비스 제공</li>
                            <li><span class="highlight">경매 서비스 제공</span>: 경매 참여, 낙찰 처리, 결제 및 정산</li>
                            <li><span class="highlight">고객 상담</span>: 민원 처리, 공지사항 전달, 고객 문의 응답</li>
                            <li><span class="highlight">마케팅 활용</span>: 신규 서비스 개발, 맞춤형 서비스 제공, 이벤트 정보 제공</li>
                        </ol>
                        
                        <h4>제4조 (수집하는 개인정보의 항목)</h4>
                        <div class="table-container">
                            <table class="privacy-table">
                                <thead>
                                    <tr>
                                        <th>수집 목적</th>
                                        <th>수집 항목</th>
                                        <th>수집 방법</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td><strong>회원가입</strong></td>
                                        <td>아이디, 비밀번호, 이름, 이메일, 휴대폰번호</td>
                                        <td>웹사이트 회원가입</td>
                                    </tr>
                                    <tr>
                                        <td><strong>경매 참여</strong></td>
                                        <td>은행계좌 정보, 신용카드 정보, 배송지 주소</td>
                                        <td>경매 참여 시 입력</td>
                                    </tr>
                                    <tr>
                                        <td><strong>고객 상담</strong></td>
                                        <td>문의 내용, 연락처</td>
                                        <td>고객센터 문의</td>
                                    </tr>
                                    <tr>
                                        <td><strong>서비스 이용</strong></td>
                                        <td>IP주소, 쿠키, 접속 기록, 서비스 이용 기록</td>
                                        <td>자동 수집</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        
                        <h4>제5조 (개인정보의 수집 방법)</h4>
                        <ul>
                            <li>홈페이지 회원가입, 서면양식, 팩스, 전화, 상담게시판, 이메일</li>
                            <li>협력회사로부터의 제공</li>
                            <li>생성정보 수집 툴을 통한 수집</li>
                        </ul>
                    </div>
                </div>
                
                <div class="article" id="provision">
                    <h2 class="article-title">
                        <span class="article-number">3</span>
                        개인정보의 제3자 제공
                    </h2>
                    <div class="article-content">
                        <h4>제6조 (개인정보의 제3자 제공)</h4>
                        <p>
                            회사는 이용자의 개인정보를 원칙적으로 외부에 제공하지 않습니다. 
                            다만, 아래의 경우에는 예외로 합니다:
                        </p>
                        <ul>
                            <li>이용자가 사전에 동의한 경우</li>
                            <li>법령의 규정에 의거하거나, 수사 목적으로 법령에 정해진 절차와 방법에 따라 수사기관의 요구가 있는 경우</li>
                            <li>통계작성, 학술연구 또는 시장조사를 위하여 필요한 경우로서 특정 개인을 알아볼 수 없는 형태로 제공하는 경우</li>
                        </ul>
                        
                        <h4>제7조 (개인정보처리의 위탁)</h4>
                        <div class="table-container">
                            <table class="privacy-table">
                                <thead>
                                    <tr>
                                        <th>위탁 업무</th>
                                        <th>수탁 업체</th>
                                        <th>위탁 업무 내용</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>결제 처리</td>
                                        <td>PG사 (이니시스, KG이니시스 등)</td>
                                        <td>신용카드 결제, 계좌이체 처리</td>
                                    </tr>
                                    <tr>
                                        <td>물류 배송</td>
                                        <td>택배회사 (CJ대한통운, 로젠택배 등)</td>
                                        <td>낙찰 작품 배송</td>
                                    </tr>
                                    <tr>
                                        <td>고객 상담</td>
                                        <td>콜센터 운영업체</td>
                                        <td>전화 상담 서비스</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                
                <div class="article" id="retention">
                    <h2 class="article-title">
                        <span class="article-number">4</span>
                        개인정보 보유 및 이용기간
                    </h2>
                    <div class="article-content">
                        <h4>제8조 (개인정보의 보유 및 이용기간)</h4>
                        <p>
                            회사는 법령에 따른 개인정보 보유·이용기간 또는 정보주체로부터 개인정보를 
                            수집 시에 동의받은 개인정보 보유·이용기간 내에서 개인정보를 처리·보유합니다.
                        </p>
                        
                        <div class="table-container">
                            <table class="privacy-table">
                                <thead>
                                    <tr>
                                        <th>개인정보 유형</th>
                                        <th>보유기간</th>
                                        <th>관련 법령</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>회원 가입 정보</td>
                                        <td>회원 탈퇴 시까지</td>
                                        <td>회원 약관</td>
                                    </tr>
                                    <tr>
                                        <td>계약 또는 청약철회 등에 관한 기록</td>
                                        <td>5년</td>
                                        <td>전자상거래 등에서의 소비자보호에 관한 법률</td>
                                    </tr>
                                    <tr>
                                        <td>대금결제 및 재화 등의 공급에 관한 기록</td>
                                        <td>5년</td>
                                        <td>전자상거래 등에서의 소비자보호에 관한 법률</td>
                                    </tr>
                                    <tr>
                                        <td>소비자의 불만 또는 분쟁처리에 관한 기록</td>
                                        <td>3년</td>
                                        <td>전자상거래 등에서의 소비자보호에 관한 법률</td>
                                    </tr>
                                    <tr>
                                        <td>웹사이트 접속 기록</td>
                                        <td>3개월</td>
                                        <td>통신비밀보호법</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                
                <div class="article" id="rights">
                    <h2 class="article-title">
                        <span class="article-number">5</span>
                        정보주체의 권리·의무 및 행사방법
                    </h2>
                    <div class="article-content">
                        <h4>제9조 (정보주체의 권리)</h4>
                        <p>정보주체는 회사에 대해 언제든지 다음 각 호의 개인정보 보호 관련 권리를 행사할 수 있습니다:</p>
                        <ol>
                            <li><span class="highlight">개인정보 처리현황 통지요구</span></li>
                            <li><span class="highlight">개인정보 열람요구</span></li>
                            <li><span class="highlight">개인정보 정정·삭제요구</span></li>
                            <li><span class="highlight">개인정보 처리정지요구</span></li>
                        </ol>
                        
                        <h4>제10조 (권리행사 방법)</h4>
                        <p>
                            정보주체는 개인정보보호법 시행령 제41조제1항에 따라 서면, 전자우편, 
                            모사전송(FAX) 등을 통하여 하실 수 있으며 회사는 이에 대해 지체없이 조치하겠습니다.
                        </p>
                        
                        <div class="important">
                            <div class="important-title">
                                <i class="fas fa-exclamation-triangle"></i>
                                주의사항
                            </div>
                            <div class="important-content">
                                정보주체가 개인정보의 오류 등에 대한 정정 또는 삭제를 요구한 경우에는 
                                정정 또는 삭제를 완료할 때까지 당해 개인정보를 이용하거나 제공하지 않습니다.
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="article" id="security">
                    <h2 class="article-title">
                        <span class="article-number">6</span>
                        개인정보의 안전성 확보조치
                    </h2>
                    <div class="article-content">
                        <h4>제11조 (개인정보 보호조치)</h4>
                        <p>회사는 개인정보보호법 제29조에 따라 다음과 같이 안전성 확보에 필요한 기술적/관리적 및 물리적 조치를 하고 있습니다:</p>
                        
                        <h4>1. 기술적 조치</h4>
                        <ul>
                            <li>개인정보처리시스템 등의 접근권한 관리</li>
                            <li>접근통제시스템 설치</li>
                            <li>개인정보의 암호화</li>
                            <li>보안프로그램 설치 및 갱신</li>
                        </ul>
                        
                        <h4>2. 관리적 조치</h4>
                        <ul>
                            <li>개인정보 취급직원의 최소화 및 교육</li>
                            <li>개인정보 취급규정 수립 및 시행</li>
                            <li>정기적 자체 감사 실시</li>
                        </ul>
                        
                        <h4>3. 물리적 조치</h4>
                        <ul>
                            <li>전산실, 자료보관실 등의 접근통제</li>
                            <li>개인정보가 포함된 서류, 보조저장매체 등을 잠금장치가 있는 안전한 장소에 보관</li>
                        </ul>
                        
                        <h4>제12조 (개인정보보호책임자)</h4>
                        <p>회사는 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보보호책임자를 지정하고 있습니다:</p>
                        
                        <div class="table-container">
                            <table class="privacy-table">
                                <thead>
                                    <tr>
                                        <th>구분</th>
                                        <th>개인정보보호책임자</th>
                                        <th>개인정보보호담당자</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>성명</td>
                                        <td>김책임</td>
                                        <td>이담당</td>
                                    </tr>
                                    <tr>
                                        <td>직책</td>
                                        <td>정보보호팀장</td>
                                        <td>정보보호팀 과장</td>
                                    </tr>
                                    <tr>
                                        <td>연락처</td>
                                        <td>02-1234-5678<br>privacy@m4auction.com</td>
                                        <td>02-1234-5679<br>privacy@m4auction.com</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                
                <!-- Contact Information -->
                <div class="contact-info">
                    <h3 class="contact-title">개인정보 관련 문의</h3>
                    <div class="contact-details">
                        <div class="contact-item">
                            <i class="fas fa-phone"></i>
                            02-1234-5678
                        </div>
                        <div class="contact-item">
                            <i class="fas fa-envelope"></i>
                            privacy@m4auction.com
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