<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.*" %>
<%@ page import="com.auction.dto.MemberDTO" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %>
<%
    // 로그인 체크
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null) {
        session.setAttribute("alertMsg", "로그인 후 이용 가능한 서비스입니다.");
        response.sendRedirect(request.getContextPath() + "/member/loginForm.jsp");
        return;
    }
    
    String ctx = request.getContextPath();
    String memberId = loginUser.getMemberId();
    
    // 거래 내역 조회
    class TransactionRecord {
        public int logId;
        public String transactionType;
        public long amount;
        public java.util.Date transactionTime;
        public Integer relatedItemId;
        public String description;
    }
    
    List<TransactionRecord> transactionList = new ArrayList<>();
    long currentMileage = loginUser.getMileage();
    
    Connection conn = getConnection();
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        // 먼저 테이블 존재 여부 확인
        String checkTableSql = "SELECT COUNT(*) FROM USER_TABLES WHERE TABLE_NAME = 'TRANSACTION_LOG'";
        pstmt = conn.prepareStatement(checkTableSql);
        rs = pstmt.executeQuery();
        
        boolean tableExists = false;
        if (rs.next() && rs.getInt(1) > 0) {
            tableExists = true;
        }
        rs.close();
        pstmt.close();
        
        if (tableExists) {
            String sql = "SELECT LOG_ID, TRANSACTION_TYPE, AMOUNT, TRANSACTION_TIME, RELATED_ITEM_ID " +
                         "FROM TRANSACTION_LOG WHERE MEMBER_ID = ? ORDER BY TRANSACTION_TIME DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, memberId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                TransactionRecord tr = new TransactionRecord();
                tr.logId = rs.getInt("LOG_ID");
                tr.transactionType = rs.getString("TRANSACTION_TYPE") != null ? rs.getString("TRANSACTION_TYPE") : "N/A";
                tr.amount = rs.getLong("AMOUNT");
                
                // Timestamp null 체크
                java.sql.Timestamp timestamp = rs.getTimestamp("TRANSACTION_TIME");
                tr.transactionTime = timestamp != null ? new java.util.Date(timestamp.getTime()) : null;
                
                tr.relatedItemId = rs.getObject("RELATED_ITEM_ID") != null ? rs.getInt("RELATED_ITEM_ID") : null;
                tr.description = null; // DESCRIPTION 컬럼이 없으므로 null로 설정
                transactionList.add(tr);
            }
        } else {
            System.out.println("TRANSACTION_LOG 테이블이 존재하지 않습니다.");
        }
    } catch (Exception e) {
        e.printStackTrace();
        System.out.println("마일리지 거래 내역 조회 중 오류: " + e.getMessage());
    } finally {
        close(rs);
        close(pstmt);
        close(conn);
    }
    
    DecimalFormat df = new DecimalFormat("###,###");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마일리지 거래 내역 - M4 Auction</title>
    
    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    
    <!-- Global Styles -->
    <link rel="stylesheet" href="<%=ctx%>/resources/css/luxury-global-style.css">
    
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background: #f8f9fa;
            padding-top: 120px !important;
            line-height: 1.6;
        }
        
        .mileage-container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 40px 24px;
        }
        
        .mileage-header {
            text-align: center;
            margin-bottom: 48px;
        }
        
        .mileage-title {
            font-family: 'Playfair Display', serif;
            font-size: 42px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 12px;
        }
        
        .mileage-subtitle {
            color: #6b7280;
            font-size: 18px;
            margin-bottom: 24px;
        }
        
        .current-balance {
            background: linear-gradient(135deg, #c9961a 0%, #d4af37 100%);
            color: white;
            padding: 24px;
            border-radius: 16px;
            text-align: center;
            max-width: 400px;
            margin: 0 auto;
        }
        
        .balance-label {
            font-size: 14px;
            opacity: 0.9;
            margin-bottom: 8px;
        }
        
        .balance-amount {
            font-size: 32px;
            font-weight: 700;
        }
        
        .history-section {
            background: white;
            border: 2px solid #e5e7eb;
            border-radius: 16px;
            padding: 48px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.05);
            margin-top: 32px;
        }
        
        .section-title {
            font-size: 24px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 32px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .section-title i {
            color: #c9961a;
        }
        
        .transaction-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        .transaction-table th {
            background: #f8f9fa;
            color: #374151;
            padding: 16px;
            text-align: left;
            font-weight: 600;
            font-size: 14px;
            border-bottom: 2px solid #e5e7eb;
        }
        
        .transaction-table td {
            padding: 16px;
            border-bottom: 1px solid #f0f0f0;
            font-size: 14px;
        }
        
        .transaction-table tbody tr:hover {
            background: #f8f9fa;
        }
        
        .transaction-type {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .type-bid {
            background: #fef3c7;
            color: #92400e;
        }
        
        .type-refund {
            background: #dbeafe;
            color: #1e40af;
        }
        
        .type-sale {
            background: #d1fae5;
            color: #065f46;
        }
        
        .type-charge {
            background: #e0e7ff;
            color: #3730a3;
        }
        
        .type-win {
            background: #fce7f3;
            color: #9d174d;
        }
        
        .amount-positive {
            color: #059669;
            font-weight: 600;
        }
        
        .amount-negative {
            color: #dc2626;
            font-weight: 600;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #9ca3af;
        }
        
        .empty-state i {
            font-size: 48px;
            margin-bottom: 16px;
            display: block;
            opacity: 0.5;
        }
        
        .back-button {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #f3f4f6;
            color: #374151;
            padding: 12px 20px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s;
            margin-bottom: 24px;
        }
        
        .back-button:hover {
            background: #e5e7eb;
            color: #1f2937;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <jsp:include page="/layout/header/luxury-header.jsp" />
    
    <div class="mileage-container">
        <a href="<%=ctx%>/mypage/myPage.jsp" class="back-button">
            <i class="fas fa-arrow-left"></i>
            마이페이지로 돌아가기
        </a>
        
        <div class="mileage-header">
            <h1 class="mileage-title">마일리지 거래 내역</h1>
            <p class="mileage-subtitle">마일리지 사용 및 적립 내역을 확인하세요</p>
            
            <div class="current-balance">
                <div class="balance-label">현재 보유 마일리지</div>
                <div class="balance-amount"><%=df.format(currentMileage)%>P</div>
            </div>
        </div>
        
        <div class="history-section">
            <h2 class="section-title">
                <i class="fas fa-history"></i>
                거래 내역
            </h2>
            
            <% if (transactionList.isEmpty()) { %>
                <div class="empty-state">
                    <i class="fas fa-receipt"></i>
                    <h3>거래 내역이 없습니다</h3>
                    <p>아직 마일리지 거래 내역이 없습니다.</p>
                    <p style="margin-top: 16px; font-size: 14px; color: #9ca3af;">
                        입찰, 충전, 판매 등의 활동을 하시면 여기에 내역이 표시됩니다.
                    </p>
                    <div style="margin-top: 24px; display: flex; gap: 12px; justify-content: center;">
                        <a href="<%=ctx%>/mypage/chargeForm.jsp" style="padding: 8px 16px; background: #c9961a; color: white; text-decoration: none; border-radius: 4px; font-size: 14px;">마일리지 충전</a>
                        <a href="<%=ctx%>/auction/auction.jsp" style="padding: 8px 16px; background: #f3f4f6; color: #374151; text-decoration: none; border-radius: 4px; font-size: 14px;">경매 참여</a>
                    </div>
                </div>
            <% } else { %>
                <table class="transaction-table">
                    <thead>
                        <tr>
                            <th>거래일시</th>
                            <th>거래유형</th>
                            <th>금액</th>
                            <th>관련상품</th>
                            <th>설명</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (TransactionRecord tr : transactionList) { 
                            String typeClass = "";
                            String typeText = "";
                            String typeIcon = "";
                            
                            switch (tr.transactionType) {
                                case "B":
                                    typeClass = "type-bid";
                                    typeText = "입찰";
                                    typeIcon = "fas fa-gavel";
                                    break;
                                case "R":
                                    typeClass = "type-refund";
                                    typeText = "환불";
                                    typeIcon = "fas fa-undo";
                                    break;
                                case "S":
                                    typeClass = "type-sale";
                                    typeText = "판매";
                                    typeIcon = "fas fa-store";
                                    break;
                                case "C":
                                    typeClass = "type-charge";
                                    typeText = "충전";
                                    typeIcon = "fas fa-credit-card";
                                    break;
                                case "W":
                                    typeClass = "type-win";
                                    typeText = "낙찰";
                                    typeIcon = "fas fa-trophy";
                                    break;
                                default:
                                    typeClass = "type-bid";
                                    typeText = "기타";
                                    typeIcon = "fas fa-circle";
                            }
                        %>
                        <tr>
                            <td><%=tr.transactionTime != null ? sdf.format(tr.transactionTime) : "-"%></td>
                            <td>
                                <span class="transaction-type <%=typeClass%>">
                                    <i class="<%=typeIcon%>"></i>
                                    <%=typeText%>
                                </span>
                            </td>
                            <td>
                                <span class="<%=tr.amount >= 0 ? "amount-positive" : "amount-negative"%>">
                                    <%=tr.amount >= 0 ? "+" : ""%><%=df.format(Math.abs(tr.amount))%>P
                                </span>
                            </td>
                            <td>
                                <% if (tr.relatedItemId != null) { %>
                                    <a href="<%=ctx%>/product/productDetail.jsp?productId=<%=tr.relatedItemId%>" 
                                       style="color: #c9961a; text-decoration: none;">
                                        상품 #<%=tr.relatedItemId%>
                                    </a>
                                <% } else { %>
                                    -
                                <% } %>
                            </td>
                            <td>
                                <%=tr.description != null ? tr.description : "-"%>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
        </div>
    </div>
    
    <!-- Footer -->
    <jsp:include page="/layout/footer/luxury-footer.jsp" />
</body>
</html>