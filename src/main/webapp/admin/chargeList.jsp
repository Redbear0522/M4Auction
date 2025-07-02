<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.auction.dao.AdminDAO" %>
<%@ page import="com.auction.vo.ChargeRequestDTO" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="static com.auction.common.JDBCTemplate.*" %>
<%
    Connection conn = getConnection();
    List<ChargeRequestDTO> list = new AdminDAO().getAllChargeRequests(conn);
    close(conn);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>마일리지 충전 요청 목록</title>
</head>
<body>
    <h2>충전 요청 목록</h2>
    <table border="1" cellpadding="10">
        <tr>
            <th>요청번호</th>
            <th>회원 ID</th>
            <th>금액</th>
            <th>상태</th>
            <th>요청일</th>
            <th>승인일</th>
            <th>처리</th>
        </tr>
        <% for(ChargeRequestDTO dto : list) { %>
        <tr>
            <td><%= dto.getReqId() %></td>
            <td><%= dto.getMemberId() %></td>
            <td><%= dto.getAmount() %></td>
            <td><%= dto.getStatus() %></td>
            <td><%= dto.getRequestDate() %></td>
            <td><%= dto.getApproveDate() == null ? "-" : dto.getApproveDate() %></td>
            <td>
                <% if("W".equals(dto.getStatus())) { %>
                    <form action="<%=request.getContextPath()%>/admin/chargeAction" method="post" style="display:inline;">
                        <input type="hidden" name="reqId" value="<%= dto.getReqId() %>">
                        <input type="hidden" name="action" value="approve">
                        <button type="submit">승인</button>
                    </form>
                    <form action="<%=request.getContextPath()%>/admin/chargeAction" method="post" style="display:inline;">
                        <input type="hidden" name="reqId" value="<%= dto.getReqId() %>">
                        <input type="hidden" name="action" value="reject">
                        <button type="submit">거절</button>
                    </form>
                <% } else { %>
                    처리 완료
                <% } %>
            </td>
        </tr>
        <% } %>
    </table>
</body>
</html>
