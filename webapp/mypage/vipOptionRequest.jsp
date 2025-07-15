<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.auction.dto.MemberDTO" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %>

<%
    request.setCharacterEncoding("UTF-8");

    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null) {
        session.setAttribute("alertMsg", "로그인 후 이용 가능합니다.");
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    String memberId = loginUser.getMemberId();
    String option = request.getParameter("option");

    // 유효성 검사
    if (option == null || (!option.equals("골드") && !option.equals("다이아"))) {
        session.setAttribute("alertMsg", "잘못된 혜택 옵션입니다.");
        response.sendRedirect("myPage.jsp");
        return;
    }

    Connection conn = getConnection();
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // 이미 같은 상태로 신청한 내역이 있는지 확인
        String checkSql = "SELECT COUNT(*) FROM VIP_OPTION_REQUEST WHERE MEMBER_ID = ? AND STATUS = '대기중'";
        pstmt = conn.prepareStatement(checkSql);
        pstmt.setString(1, memberId);
        rs = pstmt.executeQuery();
        rs.next();
        int count = rs.getInt(1);
        rs.close(); pstmt.close();

        if (count > 0) {
            session.setAttribute("alertMsg", "이미 신청한 VIP 혜택이 대기중입니다.");
            response.sendRedirect("myPage.jsp");
            return;
        }

        // 신청 INSERT
        String insertVipSql = "INSERT INTO VIP_BENEFIT (MEMBER_ID, OPTION_NAME, START_DATE) VALUES (?, ?, SYSDATE)";
		pstmt = conn.prepareStatement(insertVipSql);
        pstmt.setString(1, memberId);
        pstmt.setString(2, option);
        int result = pstmt.executeUpdate();

        if (result > 0) {
            commit(conn);
            session.setAttribute("alertMsg", "VIP 혜택 신청이 완료되었습니다. 관리자의 승인을 기다려주세요.");
        } else {
            rollback(conn);
            session.setAttribute("alertMsg", "신청에 실패했습니다. 다시 시도해주세요.");
        }

    } catch (Exception e) {
        e.printStackTrace();
        rollback(conn);
        session.setAttribute("alertMsg", "오류가 발생했습니다.");
    } finally {
        close(pstmt);
        close(conn);
    }

    response.sendRedirect("myPage.jsp");
%>
