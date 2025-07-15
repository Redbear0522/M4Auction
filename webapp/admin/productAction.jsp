<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.auction.dto.MemberDTO" %>
<%@ page import="com.auction.dao.ProductDAO" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %>
<%
    // 관리자 로그인 체크
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null || !"admin".equals(loginUser.getMemberId())) {
        session.setAttribute("alertMsg", "관리자 로그인 후 이용 가능한 서비스입니다.");
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    // 파라미터 받기
    String action = request.getParameter("action");
    String productIdStr = request.getParameter("productId");
    
    if (action == null || productIdStr == null) {
        session.setAttribute("alertMsg", "잘못된 요청입니다.");
        response.sendRedirect(request.getContextPath() + "/admin/waittingProduct.jsp");
        return;
    }
    
    int productId = Integer.parseInt(productIdStr);
    Connection conn = null;
    int result = 0;
    
    try {
        conn = getConnection();
        ProductDAO pDao = new ProductDAO();
        
        if ("approve".equals(action)) {
            // 상품 승인: STATUS를 'P' → 'A' (Active)로 변경
            result = pDao.updateProductStatus(conn, productId, "A");
            
            if (result > 0) {
                commit(conn);
                session.setAttribute("alertMsg", "상품이 성공적으로 승인되었습니다. 경매가 시작됩니다.");
            } else {
                rollback(conn);
                session.setAttribute("alertMsg", "상품 승인에 실패했습니다.");
            }
            
        } else if ("reject".equals(action)) {
            // 상품 거부: STATUS를  'P' → 'C' (Cancelled)로 변경
            result = pDao.updateProductStatus(conn, productId, "C");
            
            if (result > 0) {
                commit(conn);
                session.setAttribute("alertMsg", "상품이 거부되었습니다. 판매자에게 통보됩니다.");
            } else {
                rollback(conn);
                session.setAttribute("alertMsg", "상품 거부에 실패했습니다.");
            }
            
        } else {
            session.setAttribute("alertMsg", "잘못된 액션입니다.");
        }
        
    } catch (Exception e) {
        e.printStackTrace();
        if (conn != null) rollback(conn);
        session.setAttribute("alertMsg", "처리 중 오류가 발생했습니다: " + e.getMessage());
    } finally {
        if (conn != null) close(conn);
    }
    
    // 상품 승인 관리 페이지로 리다이렉트
    response.sendRedirect(request.getContextPath() + "/admin/waittingProduct.jsp");
%>