<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.auction.dto.MemberDTO" %>
<%@ page import="com.auction.dao.MemberDAO" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    
    MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");
    
    if(loginUser == null){
        session.setAttribute("alertMsg", "로그인 후 이용 가능한 서비스입니다.");
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    
    // 입력받은 비밀번호
    String currentPwd = request.getParameter("currentPwd");
    String newPwd = request.getParameter("newPwd");
    String newPwdCheck = request.getParameter("newPwdCheck");
    
    // 새 비밀번호 확인
    if(!newPwd.equals(newPwdCheck)) {
        session.setAttribute("alertMsg", "새 비밀번호가 일치하지 않습니다.");
        response.sendRedirect("changePwdForm.jsp");
        return;
    }
    
    // DB에서 비밀번호 변경
    Connection conn = getConnection();
    MemberDAO dao = new MemberDAO();
    
    int result = dao.updatePassword(conn, loginUser.getMemberId(), currentPwd, newPwd);
    
    if(result > 0) {
        commit(conn);
        session.setAttribute("alertMsg", "비밀번호가 성공적으로 변경되었습니다.");
        
        // 보안을 위해 로그아웃 처리
        session.invalidate();
        %>
        <script>
            alert("비밀번호가 변경되었습니다. 새 비밀번호로 다시 로그인해주세요.");
            location.href = "<%=request.getContextPath()%>/member/loginForm.jsp";
        </script>
        <%
    } else {
        rollback(conn);
        session.setAttribute("alertMsg", "현재 비밀번호가 일치하지 않습니다.");
        response.sendRedirect("changePwdForm.jsp");
    }
    
    close(conn);
%>