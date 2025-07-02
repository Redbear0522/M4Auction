package com.auction.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.auction.vo.AuctionDTO;

public class AuctionDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	// 상품 등록
	public void insertAuctionItem(String title, String description, int startPrice)
		throws ClassNotFoundException, SQLException {
		String sql = "insert into AUCTION_ITEM (ID, TITLE, DESCRIPTION, START_PRICE, CURRENT_PRICE) "
				+ "vlaues (AUCTION_ITEM_SEQ.NEXTVAL, ?, ?, ?, ?)";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1,title);
		pstmt.setString(2,description);
		pstmt.setInt(3, startPrice);
		pstmt.setInt(4, startPrice); // 현재가 = 시작가로 초기화
		
		pstmt.executeUpdate();
	}
	
	//상품 전체 조회 메서드 추가
	public List<AuctionDTO> getAllAuctionItems() throws ClassNotFoundException, SQLException {
		List<AuctionDTO> itemList = new ArrayList<>();
		String sql = "select * from AUCTION_ITEM order by ID desc";
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();
		
		while (rs.next()) {
			AuctionDTO dto = new AuctionDTO();
			dto.setId(rs.getInt("ID"));
			dto.setTitle(rs.getString("TITLE"));
			dto.setStartPrice(rs.getInt("START_PRICE"));
			dto.setCurrentPrice(rs.getInt("CURRENT_PRICE"));
			dto.setStatus(rs.getString("STATUS"));
			dto.setRegDate(rs.getDate("REG_DATE"));
			itemList.add(dto);
		}
		return itemList;
	}
	
	//상품상세 정보 보기
	public AuctionDTO getAuctionItemById(int id) throws ClassNotFoundException, SQLException{
		AuctionDTO dto = null;
		String sql = "select * from AUCTION_ITEM where ID = ?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, id);
		rs = pstmt.executeQuery();
		
		if(rs.next()) {
			dto = new AuctionDTO();
	        dto.setId(rs.getInt("ID"));
	        dto.setTitle(rs.getString("TITLE"));
	        dto.setStartPrice(rs.getInt("START_PRICE"));
	        dto.setCurrentPrice(rs.getInt("CURRENT_PRICE"));
	        dto.setStatus(rs.getString("STATUS"));
	        dto.setRegDate(rs.getDate("REG_DATE"));
	        dto.setDescription(rs.getString("DESCRIPTION"));
		}
		return dto;
	}
	
	
}
