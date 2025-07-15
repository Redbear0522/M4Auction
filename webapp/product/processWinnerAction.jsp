<%--
  File: WebContent/product/processWinnerAction.jsp
  역할: 경매가 마감된 상품의 최종 낙찰자를 결정하고, 상품 상태를 변경합니다.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.auction.dto.MemberDTO" %>
<%@ page import="com.auction.dto.ProductDTO" %>
<%@ page import="com.auction.dto.BidDTO" %>
<%@ page import="com.auction.dao.ProductDAO" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %>

<%
    // 1. 판매자 본인이 맞는지 확인 (로그인 정보 & 상품의 판매자 정보 비교)
    MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");
    int productId = Integer.parseInt(request.getParameter("productId"));

    if(loginUser == null){
        session.setAttribute("alertMsg", "로그인 후 이용해주세요.");
        response.sendRedirect(request.getContextPath() + "/member/loginForm.jsp");
        return;
    }

    Connection conn = getConnection();
    ProductDAO pDao = new ProductDAO();

    ProductDTO p = pDao.selectProductById(conn, productId);

    if(!p.getSellerId().equals(loginUser.getMemberId())){
        session.setAttribute("alertMsg", "본인이 등록한 상품만 처리할 수 있습니다.");
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        close(conn);
        return;
    }

    // 2. 최고 입찰자 정보 조회
    BidDTO winner = pDao.findWinner(conn, productId);

    if(winner != null) { // 3. 입찰자가 있는 경우 (정상적인 낙찰 처리)
        
        // 3-1. PRODUCT 테이블에 최종 낙찰자, 최종 낙찰가 정보 업데이트
        int result1 = pDao.updateProductWinner(conn, productId, winner.getMemberId(), winner.getBidPrice());
        
        // 3-2. PRODUCT 테이블의 상태를 'E'(End)로 변경
        int result2 = pDao.updateProductStatus(conn, productId, "E");

        if(result1 > 0 && result2 > 0) {
            commit(conn);
            session.setAttribute("alertMsg", "낙찰 처리가 완료되었습니다.");
        } else {
            rollback(conn);
            session.setAttribute("alertMsg", "낙찰 처리 중 오류가 발생했습니다.");
        }

    } else { // 4. 입찰자가 아무도 없는 경우 (유찰 처리)

        // 4-1. PRODUCT 테이블의 상태만 'E'(End)로 변경
        int result = pDao.updateProductStatus(conn, productId, "E");

        if(result > 0){
            commit(conn);
            session.setAttribute("alertMsg", "입찰자가 없어 경매가 종료되었습니다.");
        } else {
            rollback(conn);
            session.setAttribute("alertMsg", "경매 종료 처리 중 오류가 발생했습니다.");
        }
    }

    // 5. 모든 처리가 끝나면 다시 상품 상세 페이지로 돌아갑니다.
    close(conn);
    response.sendRedirect(request.getContextPath() + "/product/productDetail.jsp?productId=" + productId);
%>
