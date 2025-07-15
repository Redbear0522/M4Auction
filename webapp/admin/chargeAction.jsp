<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.auction.dao.AdminDAO" %>
<%@ page import="com.auction.dto.MemberDTO" %>
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
    String reqIdStr = request.getParameter("reqId");
    String action = request.getParameter("action");
    
    if (reqIdStr == null || action == null) {
        session.setAttribute("alertMsg", "잘못된 요청입니다.");
        response.sendRedirect(request.getContextPath() + "/admin/adminPage.jsp");
        return;
    }

    int reqId = Integer.parseInt(reqIdStr);
    
    Connection conn = null;
    try {
        conn = getConnection();
        AdminDAO dao = new AdminDAO();
        int result = 0;
        
        if ("approve".equals(action)) {
            result = dao.approveCharge(conn, reqId);
            if (result > 0) {
                commit(conn);
                session.setAttribute("alertMsg", "충전 요청이 승인되었습니다.");
            } else {
                rollback(conn);
                session.setAttribute("alertMsg", "충전 승인에 실패했습니다.");
            }
        } else if ("reject".equals(action)) {
            result = dao.rejectCharge(conn, reqId);
            if (result > 0) {
                commit(conn);
                session.setAttribute("alertMsg", "충전 요청이 거부되었습니다.");
            } else {
                rollback(conn);
                session.setAttribute("alertMsg", "충전 거부에 실패했습니다.");
            }
        } else {
            session.setAttribute("alertMsg", "잘못된 요청입니다.");
        }
        
    } catch (Exception e) {
        e.printStackTrace();
        if (conn != null) rollback(conn);
        session.setAttribute("alertMsg", "시스템 오류가 발생했습니다.");
    } finally {
        if (conn != null) close(conn);
    }
    
    // 처리 완료 후 리다이렉트
    response.sendRedirect(request.getContextPath() + "/admin/adminPage.jsp");
%>