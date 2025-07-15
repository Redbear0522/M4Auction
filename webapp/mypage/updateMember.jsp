<%--
  File: WebContent/mypage/updateMember.jsp
  역할: myPage.jsp에서 넘어온 회원 정보 수정 요청을 실제로 처리합니다.
       이 페이지는 사용자에게 직접 보이지 않습니다.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.auction.dto.MemberDTO" %>
<%@ page import="com.auction.dao.MemberDAO" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %>

<%
    // 1. 한글 인코딩 설정
    request.setCharacterEncoding("UTF-8");

    // 2. 수정할 새로운 정보들을 form으로부터 받아옵니다.
    String updateName = request.getParameter("updateName");
    String updateEmail = request.getParameter("updateEmail");
    String updateTel = request.getParameter("updateTel");

    // 3. 현재 로그인한 회원의 아이디를 session에서 가져옵니다. (누구를 수정할지 알아야 하므로)
    MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");
    String userId = loginUser.getMemberId();
    
    // 4. 받아온 정보들을 '이름표 양식(Member 객체)'에 담습니다.
    MemberDTO m = new MemberDTO();
    m.setMemberName(updateName);
    m.setEmail(updateEmail);
    m.setTel(updateTel);
    m.setMemberId(userId); // 아이디 정보도 잊지 않고 담아줍니다. (WHERE 조건절에 필요)

    // 5. '마법 열쇠'와 '회원 관리 직원'을 준비합니다.
    Connection conn = getConnection();
    int result = new MemberDAO().updateMember(conn, m);

    // 6. 결과에 따라 최종 저장을 할지, 취소를 할지 결정합니다.
    if(result > 0) {
        commit(conn);

        // ======== 가장 중요한 부분! ========
        // DB 정보가 바뀌었으니, session에 저장된 'loginUser'의 정보도
        // 최신 정보로 직접 업데이트 해주어야 합니다.
        // 이렇게 하지 않으면, 다시 마이페이지로 돌아가도 예전 정보가 그대로 보입니다.
        loginUser.setMemberName(updateName);
        loginUser.setEmail(updateEmail);
        loginUser.setTel(updateTel);

        session.setAttribute("alertMsg", "회원 정보가 성공적으로 수정되었습니다.");
    } else {
        rollback(conn);
        session.setAttribute("alertMsg", "회원 정보 수정에 실패했습니다.");
    }

    // 7. 다 쓴 '마법 열쇠'는 반납하고, 마이페이지로 돌려보냅니다.
    close(conn);
    response.sendRedirect("myPage.jsp");
%>
