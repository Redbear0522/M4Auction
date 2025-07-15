<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.auction.dto.MemberDTO" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %>
<%@ page import="java.sql.PreparedStatement" %>
<%
    request.setCharacterEncoding("UTF-8");

    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null) {
        response.sendRedirect(request.getContextPath() + "/member/loginForm.jsp");
        return;
    }

    long amount = Long.parseLong(request.getParameter("amount"));
    Connection conn = getConnection();

    int result = 0;
    PreparedStatement pstmt = null;

    try {
    	String sql = "INSERT INTO CHARGE_REQUEST (REQ_ID, MEMBER_ID, AMOUNT, STATUS) VALUES (CHARGE_REQUEST_SEQ.NEXTVAL, ?, ?, 'W')";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, loginUser.getMemberId());
        pstmt.setLong(2, amount);
        result = pstmt.executeUpdate();

        if (result > 0) {
            commit(conn);
            session.setAttribute("alertMsg", "충전 요청이 성공적으로 접수되었습니다.");
        } else {
            rollback(conn);
            session.setAttribute("alertMsg", "충전 요청에 실패했습니다.");
        }
    } catch (Exception e) {
        rollback(conn);
        e.printStackTrace();
        session.setAttribute("alertMsg", "오류가 발생했습니다.");
    } finally {
        close(pstmt);
        close(conn);
    }

    response.sendRedirect("myPage.jsp");
    return;
%>