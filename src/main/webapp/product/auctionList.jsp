<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.* , com.auction.dao.AuctionDAO, com.auction.vo.AuctionDTO" %>    
<html>
<head>
	<title>경매 상품 목록</title>
	<style>
		table { width: 80%; border-collapse: collapse; margin: 20px auto; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: center; }
        th { background-color: #f2f2f2; }
        a { text-decoration: none; color: blue; }
	</style>
</head>
<body>
<jsp:include page="/layout/header/header.jsp" />
	<h2 style="text-align:center;">경매 상품 목록</h2>
	<table>
		<tr>
			<th>번호</th>
			<th>제목</th>
			<th>시작가</th>
			<th>현재가</th>
			<th>상태</th>
			<th>등록일</th>
		</tr>
		
		<%
			try{
				AuctionDAO dao = new AuctionDAO();
				List<AuctionDTO> items = dao.getAllAuctionItems();
				
				for(AuctionDTO item : items){
		%>
		<tr>
			<td><%= item.getId() %></td>
			<td><a href="auctionDetail.jsp?id=<%= item.getId() %>"><%= item.getTitle() %></a></td>
			<td><%= item.getStartPrice() %></td>
			<td><%= item.getCurrentPrice() %></td>
			<td><%= item.getStatus() %></td>
			<td><%= item.getRegDate() %></td>
		</tr>
		<%
				}
			}catch(Exception e){
		%>	
		<tr><td colspan = "6">데이터 조회 중 오류발생</td></tr>
		
			<%
				}
			%>	
	</table>
</body>
</html>