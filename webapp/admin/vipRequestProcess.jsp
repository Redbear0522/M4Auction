<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %>
<%@ page import="com.auction.dto.MemberDTO" %>

<%
		MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
		if (loginUser == null || !"admin".equals(loginUser.getMemberId())) {
		    session.setAttribute("alertMsg", "관리자 로그인 후 이용 가능한 서비스입니다.");
		    response.sendRedirect(request.getContextPath() + "/member/loginForm.jsp");
		    return;
		}

    String requestIdStr = request.getParameter("requestId");
    String action = request.getParameter("action");

    if (requestIdStr == null || action == null || (!action.equals("승인") && !action.equals("거절"))) {
        session.setAttribute("alertMsg", "잘못된 접근입니다.");
        response.sendRedirect("vipRequestList.jsp");
        return;
    }

    int requestId = Integer.parseInt(requestIdStr);

    Connection conn = getConnection();
    PreparedStatement pstmt = null;
    PreparedStatement pstmtUpdateVip = null;
    ResultSet rs = null;

    try {
        // 신청 상태가 대기중인지 확인
        String checkSql = "SELECT MEMBER_ID, OPTION_NAME, STATUS FROM VIP_OPTION_REQUEST WHERE REQUEST_ID = ?";
        pstmt = conn.prepareStatement(checkSql);
        pstmt.setInt(1, requestId);
        rs = pstmt.executeQuery();

        if (!rs.next()) {
            session.setAttribute("alertMsg", "존재하지 않는 신청입니다.");
            response.sendRedirect("vipRequestList.jsp");
            return;
        }

        String memberId = rs.getString("MEMBER_ID");
        String optionName = rs.getString("OPTION_NAME");
        String status = rs.getString("STATUS");

        rs.close();
        pstmt.close();

        if (!"대기중".equals(status)) {
            session.setAttribute("alertMsg", "이미 처리된 신청입니다.");
            response.sendRedirect("vipRequestList.jsp");
            return;
        }

        // 신청 상태 업데이트
        String updateSql = "UPDATE VIP_OPTION_REQUEST SET STATUS = ?, REQUEST_DATE = SYSDATE WHERE REQUEST_ID = ?";
        pstmt = conn.prepareStatement(updateSql);
        pstmt.setString(1, action);
        pstmt.setInt(2, requestId);
        int updateCount = pstmt.executeUpdate();
        pstmt.close();

        if (updateCount > 0) {
            // 승인 시 VIP 혜택 관리 테이블에 반영
            if ("승인".equals(action)) {
                // 이미 VIP 혜택 관리 테이블에 등록된 회원인지 체크
                String checkVipSql = "SELECT COUNT(*) FROM VIP_BENEFIT WHERE MEMBER_ID = ?";
                pstmt = conn.prepareStatement(checkVipSql);
                pstmt.setString(1, memberId);
                rs = pstmt.executeQuery();
                rs.next();
                int count = rs.getInt(1);
                rs.close();
                pstmt.close();

                if (count == 0) {
                    // 신규 등록
                    String insertVipSql = "INSERT INTO VIP_BENEFIT (MEMBER_ID, BENEFIT_OPTION, APPROVED_DATE) VALUES (?, ?, SYSDATE)";
                    pstmt = conn.prepareStatement(insertVipSql);
                    pstmt.setString(1, memberId);
                    pstmt.setString(2, optionName);
                    pstmt.executeUpdate();
                    pstmt.close();
                } else {
                    // 기존 등록되어 있다면 옵션 업데이트
                    String updateVipSql = "UPDATE VIP_BENEFIT SET BENEFIT_OPTION = ?, APPROVED_DATE = SYSDATE WHERE MEMBER_ID = ?";
                    pstmt = conn.prepareStatement(updateVipSql);
                    pstmt.setString(1, optionName);
                    pstmt.setString(2, memberId);
                    pstmt.executeUpdate();
                    pstmt.close();
                }
            }

            commit(conn);
            session.setAttribute("alertMsg", "신청이 정상 처리되었습니다.");
        } else {
            rollback(conn);
            session.setAttribute("alertMsg", "처리 중 오류가 발생했습니다.");
        }

    } catch(Exception e) {
        e.printStackTrace();
        rollback(conn);
        session.setAttribute("alertMsg", "오류가 발생했습니다.");
    } finally {
        close(rs);
        close(pstmt);
        close(pstmtUpdateVip);
        close(conn);
    }

    response.sendRedirect("vipRequestList.jsp");
%>
