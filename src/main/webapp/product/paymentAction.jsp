<%--
  File: WebContent/product/paymentAction.jsp
  역할: 최종 낙찰 또는 즉시 구매 시, 마일리지를 차감하고 결제를 완료 처리합니다.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.auction.vo.MemberDTO" %>
<%@ page import="com.auction.vo.ProductDTO" %>
<%@ page import="com.auction.dao.MemberDAO" %>
<%@ page import="com.auction.dao.ProductDAO" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %>

<%
    // 1. 로그인 여부 확인
    MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");
    if(loginUser == null){
        session.setAttribute("alertMsg", "로그인 후 이용해주세요.");
        response.sendRedirect(request.getContextPath() + "/member/loginForm.jsp");
        return;
    }

    // 2. 결제할 상품 번호와, 해당 상품 정보를 가져옵니다.
    int productId = Integer.parseInt(request.getParameter("productId"));
    
    Connection conn = getConnection();
    ProductDAO pDao = new ProductDAO();
    ProductDTO p = pDao.selectProductById(conn, productId);

    // 3. 결제할 금액 결정 (일반 낙찰 or 즉시 구매)
    int finalPrice = 0;
    String winnerId = "";
    
    if(p.getStatus().equals("E")) { // 일반 경매 종료 후 낙찰
        finalPrice = p.getFinalPrice();
        winnerId = p.getWinnerId();
    } else { // 즉시 구매 시도
        finalPrice = p.getBuyNowPrice();
        winnerId = loginUser.getMemberId();
    }

    // 4. 결제 자격 확인
    if(!loginUser.getMemberId().equals(winnerId)) {
        session.setAttribute("alertMsg", "구매 자격이 없습니다.");
        response.sendRedirect("productDetail.jsp?productId=" + productId);
        close(conn);
        return;
    }

    if(loginUser.getMileage() < finalPrice) {
        session.setAttribute("alertMsg", "마일리지가 부족합니다. 마이페이지에서 충전 후 이용해주세요.");
        response.sendRedirect(request.getContextPath() + "/mypage/myPage.jsp");
        close(conn);
        return;
    }

    // 5. 결제 처리 (트랜잭션 관리)
    MemberDAO mDao = new MemberDAO();
    int result1 = mDao.deductMileage(conn, loginUser.getMemberId(), finalPrice);
    int result2 = pDao.updateProductStatus(conn, productId, "P");
    int result3 = 1;
    if(!p.getStatus().equals("E")){
        result3 = pDao.updateProductWinner(conn, productId, winnerId, finalPrice);
    }

    if(result1 > 0 && result2 > 0 && result3 > 0) {
        commit(conn);
        loginUser.setMileage(loginUser.getMileage() - finalPrice);
        session.setAttribute("alertMsg", "결제가 완료되었습니다. 감사합니다.");
    } else {
        rollback(conn);
        session.setAttribute("alertMsg", "결제 처리 중 오류가 발생했습니다.");
    }
    
    // ======== 수정된 부분! ========
    // 6. 모든 처리가 끝나면 메인 페이지로 돌아갑니다.
    close(conn);
    response.sendRedirect(request.getContextPath() + "/index.jsp");
%>
