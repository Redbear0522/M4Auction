<%--
  File: WebContent/product/bidAction.jsp
  역할: 상품 상세 페이지에서 넘어온 입찰 요청을 실제로 처리합니다.
       이 페이지는 사용자에게 직접 보이지 않습니다.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.auction.vo.MemberDTO" %>
<%@ page import="com.auction.vo.ProductDTO" %>
<%@ page import="com.auction.vo.Bid" %>
<%@ page import="com.auction.dao.ProductDAO" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %>

<%
    // ----------------------------------------------------
    // 1. 사전 준비 및 유효성 검사
    // ----------------------------------------------------
    
    // 사용자가 로그인했는지 먼저 확인합니다.
    MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");

    if (loginUser == null) {
        // 로그인이 안되어있으면, 알림을 띄우고 로그인 페이지로 보냅니다.
        // 나중에 세션을 활용한 메시지 전달 방식으로 고도화할 수 있습니다.
        response.sendRedirect(request.getContextPath() + "/member/loginForm.jsp");
        return; // 아래 코드가 실행되지 않도록 여기서 멈춥니다.
    }

    // 상세 페이지에서 전달된 값들을 받습니다.
    int productId = Integer.parseInt(request.getParameter("productId"));
    int bidPrice = Integer.parseInt(request.getParameter("bidPrice"));
    int currentPrice = Integer.parseInt(request.getParameter("currentPrice"));

    // 내가 입찰하려는 금액이 현재가보다 낮은지 확인합니다.
    if (bidPrice <= currentPrice) {
%>
        <script>
            alert("입찰가는 현재가보다 높아야 합니다.");
            history.back(); // 이전 페이지(상세페이지)로 돌아갑니다.
        </script>
<%
        return; // 유효하지 않으므로 여기서 멈춥니다.
    }

    // ----------------------------------------------------
    // 2. 입찰 처리 로직 (트랜잭션 관리)
    // ----------------------------------------------------
    
    // 입찰 기록지(Bid 객체)에 필요한 정보를 담습니다.
    Bid b = new Bid();
    b.setProductId(productId);
    b.setBidderId(loginUser.getMemberId()); // 입찰자는 현재 로그인한 회원
    b.setBidPrice(bidPrice);

    Connection conn = getConnection();
    ProductDAO dao = new ProductDAO();

    // 1. BID 테이블에 새로운 입찰 기록 추가
    int result1 = dao.insertBid(conn, b);

    // 2. PRODUCT 테이블의 현재가를 새로운 입찰가로 업데이트
    int result2 = dao.updateCurrentPrice(conn, productId, bidPrice);

    // 두 작업이 모두 성공했을 때만 최종 저장(commit)합니다.
    if (result1 > 0 && result2 > 0) {
        commit(conn);
    } else {
        rollback(conn); // 둘 중 하나라도 실패하면 모든 작업을 취소합니다.
    }

    close(conn); // DB 연결을 반납합니다.
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>입찰 처리</title>
</head>
<body>

    <script>
        <% if (result1 > 0 && result2 > 0) { %>
            // 성공했을 때
            alert("입찰에 성공했습니다.");
            // 현재 상품의 상세 페이지를 새로고침하여 업데이트된 가격을 보여줍니다.
            location.replace("productDetail.jsp?productId=<%= productId %>");
        <% } else { %>
            // 실패했을 때
            alert("입찰 처리 중 오류가 발생했습니다. 다시 시도해주세요.");
            history.back();
        <% } %>
    </script>

</body>
</html>
