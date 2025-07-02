<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.auction.dao.AuctionDAO, com.auction.vo.AuctionDTO, com.auction.dao.BidDAO, com.auction.vo.BidDTO, java.util.List, java.text.SimpleDateFormat" %>

<%
    // 요청 파라미터로부터 상품 ID를 정수로 받아옴 (예: detail.jsp?id=5 에서 5)
    int id = Integer.parseInt(request.getParameter("id"));

    // 경매 DAO 객체 생성 후, 해당 ID 상품의 상세 정보 조회
    AuctionDAO dao = new AuctionDAO();
    AuctionDTO item = dao.getAuctionItemById(id);

    // 현재 세션에 로그인된 회원 아이디를 가져옴 (로그인 상태 확인용)
    String memberId = (String) session.getAttribute("memberId");

    // 입찰 DAO 객체 생성 후, 해당 상품의 입찰 내역 리스트 조회
    BidDAO bidDao = new BidDAO();
    List<BidDTO> bidList = bidDao.getBidsItemId(id);

    // 입찰 시간 출력 포맷 지정 (예: 2025-07-01 15:30:25)
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
%>
<html>
<head>
    <title>상품 상세 보기</title>
    <style>
        /* 상품 상세정보 박스 스타일 */
        .detail-box { width: 60%; margin: 30px auto; padding: 20px; border: 1px solid #ccc; border-radius: 10px; }
        .detail-box h2 { margin-bottom: 20px; }
        .detail-box p { margin: 10px 0; }

        /* 상품 설명 영역: 줄바꿈(\n) 유지 */
        .description { white-space: pre-line; }

        /* 입찰 폼 박스 스타일 */
        .bid-box { margin-top: 30px; }
        .bid-box input[type="number"] { width: 150px; padding: 5px; }
        .bid-box input[type="submit"] { padding: 5px 10px; }

        /* 입찰 내역 테이블 스타일 */
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: center; }
        th { background-color: #f0f0f0; }
    </style>
</head>
<body>
    <div class="detail-box">
        <!-- 상품 제목 출력 -->
        <h2><%= item.getTitle() %></h2>

        <!-- 상품 기본 정보 출력 -->
        <p><strong>상품 번호:</strong> <%= item.getId() %></p>
        <p><strong>시작 가격:</strong> <%= item.getStartPrice() %>원</p>
        <p><strong>현재 최고가:</strong> <%= item.getCurrentPrice() %>원</p>
        <p><strong>등록일:</strong> <%= item.getRegDate() %></p>
        <p><strong>상태:</strong> <%= item.getStatus() %></p>
    
        <hr>

        <!-- 상품 상세 설명 영역: 줄바꿈을 그대로 유지해서 보여줌 -->
        <p><strong>상품 설명:</strong></p>
        <div class="description"><%= item.getDescription() %></div>
                
        <hr>

        <!-- 입찰 폼 영역 시작 -->
        <div class="bid-box">
            <h3> 입찰하기</h3>

            <%
                // 만약 로그인하지 않은 상태라면 입찰 불가 메시지를 출력
                if(memberId == null){
            %>
                <p style="color:red;">로그인 후 입찰이 가능합니다.</p>
            <%
                } else {
                    // 로그인 상태일 때 입찰 폼을 보여줌
            %>    
                <form action="bidProcess.jsp" method="post">
                    <!-- 입찰 대상 상품 ID를 숨겨서 서버로 전송 -->
                    <input type="hidden" name="itemId" value="<%= item.getId() %>">
                    <!-- 입찰 가격 입력란: 현재 최고가보다 1원 이상 높은 가격만 입력 가능 -->
                    <input type="number" name="bidPrice" min="<%= item.getCurrentPrice() + 1 %>" required> 원
                    <input type="submit" value="입찰">
                </form>
            <%
                }
            %>        

            <!-- 입찰 내역 테이블 출력 -->
            <h3>입찰 내역</h3>
            <table>
                <thead>
                    <tr>
                        <th>입찰 번호</th>
                        <th>입찰자 아이디</th>
                        <th>입찰 가격</th>
                        <th>입찰 시간</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        // 입찰 내역이 하나도 없을 경우 안내 문구 출력
                        if (bidList.isEmpty()) {
                    %>
                        <tr><td colspan="4">입찰 내역이 없습니다.</td></tr>
                    <%
                        } else {
                            // 입찰 내역을 한 줄씩 테이블에 출력, 입찰 시간은 지정한 포맷으로 변환해서 출력
                            for (BidDTO bid : bidList) {
                    %>
                        <tr>
                            <td><%= bid.getBidId() %></td>
                            <td><%= bid.getBidderId() %></td>
                            <td><%= bid.getBidPrice() %> 원</td>
                            <%
    							// bid.getBidTime()이 null인지 체크해서,
    							// null이 아니면 sdf.format()으로 날짜 형식 변환 후 출력,
    							// null이면 빈 문자열("") 출력 (날짜 정보가 없을 때 대비)
							%>
                            <td><%= bid.getBidTime() != null ? sdf.format(bid.getBidTime()) : "" %></td>
                        </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>
        
        <!-- 목록으로 돌아가기 링크 -->
        <p><a href="auctionList.jsp">←목록으로 돌아가기</a></p>
    </div>    
</body>
</html>
