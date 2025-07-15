<%--
  File: WebContent/mypage/deleteProduct.jsp
  역할: 상품 삭제 요청을 실제로 처리합니다.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="com.auction.dto.MemberDTO" %>
<%@ page import="com.auction.dao.ProductDAO" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %>

<%
    // 1. 로그인 여부 및 본인 확인
    MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");
    if(loginUser == null){
        // 로그인이 안되어있으면 처리하지 않고 돌려보냄
        response.sendRedirect(request.getContextPath() + "/member/loginForm.jsp");
        return;
    }

    // 2. 삭제할 상품의 번호를 받아옵니다.
    int productId = Integer.parseInt(request.getParameter("productId"));
    
    // 3. '마법 열쇠'와 '상품 관리 직원'을 준비합니다.
    Connection conn = getConnection();
    int result = new ProductDAO().deleteProduct(conn, productId, loginUser.getMemberId());
    
    // 4. 결과에 따라 최종 저장을 할지, 취소를 할지 결정합니다.
    if(result > 0){
        commit(conn);
        session.setAttribute("alertMsg", "상품이 성공적으로 삭제되었습니다.");
    } else {
        rollback(conn);
        session.setAttribute("alertMsg", "상품 삭제에 실패했습니다. (본인 상품이 아닐 수 있습니다.)");
    }
    
    // 5. 처리가 끝나면 마이페이지로 돌려보냅니다.
    close(conn);
    response.sendRedirect("myPage.jsp");
%>
