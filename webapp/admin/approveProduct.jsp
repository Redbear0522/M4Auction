<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="static com.auction.common.JDBCTemplate.*"%>
<%@ page import="com.auction.dao.AdminDAO"%>
<%@ page import="com.auction.dao.ProductDAO"%>
<%
    String strId = request.getParameter("productId");
    int productId = Integer.parseInt(strId);

    Connection conn = getConnection();
    AdminDAO dao = new AdminDAO();
    ProductDAO dao1 = new ProductDAO();
    int result = dao1.updateProductStatus(conn, productId, "A");  // 'P' → 'A'
    if(result > 0) {
        commit(conn);
        session.setAttribute("alertMsg", "상품 승인 완료");
    } else {
        rollback(conn);
        session.setAttribute("alertMsg", "상품 승인 실패");
    }
    close(conn);
    response.sendRedirect(request.getContextPath() + "/admin/adminPage.jsp");
%>
