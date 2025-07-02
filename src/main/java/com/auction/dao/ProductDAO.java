// File: src/main/java/com/auction/dao/ProductDAO.java
// 역할: PRODUCT 및 BID 테이블과 관련된 SQL문을 실행하고 결과를 반환하는 클래스입니다.
package com.auction.dao;

import static com.auction.common.JDBCTemplate.*;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import com.auction.common.PageInfo;
import com.auction.vo.Bid;
import com.auction.vo.ProductDTO;

public class ProductDAO {

	public ProductDAO() {}
        
    // --- (다른 메소드들은 기존과 동일) ---

    /**
     * 내가 입찰한 상품 목록을 조회하는 기능 (최종 수정)
     * 이제 이미지 파일 이름도 정확하게 가져옵니다.
     */
    public List<ProductDTO> selectProductsByBidder(Connection conn, String bidderId) {
        List<ProductDTO> list = new ArrayList<>();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "	SELECT DISTINCT\r\n"
        		+ "		       P.PRODUCT_ID,\r\n"
        		+ "		       P.PRODUCT_NAME,\r\n"
        		+ "		       P.CURRENT_PRICE,\r\n"
        		+ "		       P.IMAGE_RENAMED_NAME\r\n"
        		+ "		  FROM PRODUCT P\r\n"
        		+ "		  JOIN BID B ON (P.PRODUCT_ID = B.PRODUCT_ID)\r\n"
        		+ "		 WHERE B.BIDDER_ID = ?\r\n"
        		+ "		   AND P.STATUS != 'C'\r\n"
        		+ "		 ORDER BY P.PRODUCT_ID DESC";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, bidderId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                ProductDTO p = new ProductDTO();
                p.setProductId(rs.getInt("PRODUCT_ID"));
                p.setProductName(rs.getString("PRODUCT_NAME"));
                p.setCurrentPrice(rs.getInt("CURRENT_PRICE"));
                
                // ======== 수정된 부분! 빠뜨렸던 이미지 파일 이름을 추가합니다. ========
                p.setImageRenamedName(rs.getString("IMAGE_RENAMED_NAME"));
                
                list.add(p);
            }
        } catch (SQLException e) { e.printStackTrace(); } 
        finally { close(rs); close(pstmt); }
        return list;
    }

    // --- (이하 다른 모든 메소드들은 기존과 동일합니다) ---
    public int selectProductCountByCategory(Connection conn, String category) {
        int listCount = 0;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT COUNT(*) AS COUNT\r\n"
        		+ "		  FROM PRODUCT\r\n"
        		+ "		 WHERE STATUS = 'A'\r\n"
        		+ "		   AND CATEGORY = ?";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, category);
            rs = pstmt.executeQuery();
            if(rs.next()) {
                listCount = rs.getInt("COUNT");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(rs);
            close(pstmt);
        }
        return listCount;
    }

    public List<ProductDTO> selectProductListByCategory(Connection conn, String category, PageInfo pi) {
        List<ProductDTO> list = new ArrayList<>();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT *\r\n"
        		+ "FROM (\r\n"
        		+ "SELECT ROWNUM AS RNUM, A.*\r\n"
        		+ "FROM (\r\n"
        		+ "SELECT\r\n"
        		+ "P.PRODUCT_ID, P.PRODUCT_NAME, P.ARTIST_NAME, P.START_PRICE,\r\n"
        		+ "P.CURRENT_PRICE, P.END_TIME, P.IMAGE_RENAMED_NAME\r\n"
        		+ "FROM PRODUCT P\r\n"
        		+ "WHERE P.STATUS = 'A'\r\n"
        		+ "AND P.CATEGORY = ?\r\n"
        		+ "ORDER BY P.END_TIME ASC\r\n"
        		+ ") A\r\n"
        		+ ")\r\n"
        		+ "WHERE RNUM BETWEEN ? AND ?";
        try {
            pstmt = conn.prepareStatement(sql);
            int startRow = (pi.getCurrentPage() - 1) * pi.getBoardLimit() + 1;
            int endRow = startRow + pi.getBoardLimit() - 1;
            pstmt.setString(1, category);
            pstmt.setInt(2, startRow);
            pstmt.setInt(3, endRow);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                ProductDTO p = new ProductDTO();
                p.setProductId(rs.getInt("PRODUCT_ID"));
                p.setProductName(rs.getString("PRODUCT_NAME"));
                p.setArtistName(rs.getString("ARTIST_NAME"));
                p.setCurrentPrice(rs.getInt("CURRENT_PRICE"));
                p.setImageRenamedName(rs.getString("IMAGE_RENAMED_NAME"));
                p.setEndTime(rs.getTimestamp("END_TIME"));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(rs);
            close(pstmt);
        }
        return list;
    }
    
    public int searchProductCount(Connection conn, String keyword) {
        int listCount = 0;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT COUNT(*) AS COUNT\r\n"
        		+ "FROM PRODUCT\r\n"
        		+ "WHERE STATUS = 'A'\r\n"
        		+ "AND (PRODUCT_NAME LIKE ? OR ARTIST_NAME LIKE ?)";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, "%" + keyword + "%");
            pstmt.setString(2, "%" + keyword + "%");
            rs = pstmt.executeQuery();
            if(rs.next()) { listCount = rs.getInt("COUNT"); }
        } catch (SQLException e) { e.printStackTrace(); } 
        finally { close(rs); close(pstmt); }
        return listCount;
    }

    public List<ProductDTO> searchProductList(Connection conn, String keyword, PageInfo pi) {
        List<ProductDTO> list = new ArrayList<>();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT *\r\n"
        		+ "FROM (\r\n"
        		+ "SELECT ROWNUM AS RNUM, A.*\r\n"
        		+ "FROM (\r\n"
        		+ "SELECT\r\n"
        		+ "P.PRODUCT_ID, P.PRODUCT_NAME, P.ARTIST_NAME, P.START_PRICE,\r\n"
        		+ "P.CURRENT_PRICE, P.END_TIME, P.IMAGE_RENAMED_NAME\r\n"
        		+ "FROM PRODUCT P\r\n"
        		+ "WHERE P.STATUS = 'A'\r\n"
        		+ "AND (P.PRODUCT_NAME LIKE ? OR P.ARTIST_NAME LIKE ?)\r\n"
        		+ "ORDER BY P.END_TIME ASC\r\n"
        		+ ") A\r\n"
        		+ ")\r\n"
        		+ "WHERE RNUM BETWEEN ? AND ?";
        try {
            pstmt = conn.prepareStatement(sql);
            int startRow = (pi.getCurrentPage() - 1) * pi.getBoardLimit() + 1;
            int endRow = startRow + pi.getBoardLimit() - 1;
            pstmt.setString(1, "%" + keyword + "%");
            pstmt.setString(2, "%" + keyword + "%");
            pstmt.setInt(3, startRow);
            pstmt.setInt(4, endRow);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                ProductDTO p = new ProductDTO();
                p.setProductId(rs.getInt("PRODUCT_ID"));
                p.setProductName(rs.getString("PRODUCT_NAME"));
                p.setArtistName(rs.getString("ARTIST_NAME"));
                p.setCurrentPrice(rs.getInt("CURRENT_PRICE"));
                p.setImageRenamedName(rs.getString("IMAGE_RENAMED_NAME"));
                p.setEndTime(rs.getTimestamp("END_TIME"));
                list.add(p);
            }
        } catch (SQLException e) { e.printStackTrace(); } 
        finally { close(rs); close(pstmt); }
        return list;
    }

    public int selectProductCount(Connection conn) {
        int listCount = 0;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT COUNT(*) AS COUNT\r\n"
        		+ "FROM PRODUCT \r\n"
        		+ "WHERE STATUS = 'A'";
        try {
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if(rs.next()) { listCount = rs.getInt("COUNT"); }
        } catch (SQLException e) { e.printStackTrace(); } 
        finally { close(rs); close(pstmt); }
        return listCount;
    }

    public List<ProductDTO> selectProductList(Connection conn, PageInfo pi) {
        List<ProductDTO> list = new ArrayList<>();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT *\r\n"
        		+ "FROM (\r\n"
        		+ "SELECT ROWNUM AS RNUM, A.*\r\n"
        		+ "FROM (\r\n"
        		+ "SELECT\r\n"
        		+ "P.PRODUCT_ID, P.PRODUCT_NAME, P.ARTIST_NAME, P.START_PRICE,\r\n"
        		+ "P.CURRENT_PRICE, P.END_TIME, P.IMAGE_RENAMED_NAME\r\n"
        		+ "FROM PRODUCT P\r\n"
        		+ "WHERE P.STATUS = 'A'\r\n"
        		+ "ORDER BY P.END_TIME ASC\r\n"
        		+ ") A\r\n"
        		+ ")\r\n"
        		+ "WHERE RNUM BETWEEN ? AND ?";
        try {
            pstmt = conn.prepareStatement(sql);
            int startRow = (pi.getCurrentPage() - 1) * pi.getBoardLimit() + 1;
            int endRow = startRow + pi.getBoardLimit() - 1;
            pstmt.setInt(1, startRow);
            pstmt.setInt(2, endRow);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                ProductDTO p = new ProductDTO();
                p.setProductId(rs.getInt("PRODUCT_ID"));
                p.setProductName(rs.getString("PRODUCT_NAME"));
                p.setArtistName(rs.getString("ARTIST_NAME"));
                p.setStartPrice(rs.getInt("START_PRICE"));
                p.setCurrentPrice(rs.getInt("CURRENT_PRICE"));
                p.setEndTime(rs.getTimestamp("END_TIME"));
                p.setImageRenamedName(rs.getString("IMAGE_RENAMED_NAME"));
                list.add(p);
            }
        } catch (SQLException e) { e.printStackTrace(); } 
        finally { close(rs); close(pstmt); }
        return list;
    }

    public ProductDTO selectProductById(Connection conn, int productId) {
        ProductDTO p = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM PRODUCT\r\n WHERE PRODUCT_ID = ?";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, productId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                p = new ProductDTO();
                p.setProductId(rs.getInt("PRODUCT_ID"));
                p.setProductName(rs.getString("PRODUCT_NAME"));
                p.setArtistName(rs.getString("ARTIST_NAME"));
                p.setProductDesc(rs.getString("PRODUCT_DESC"));
                p.setStartPrice(rs.getInt("START_PRICE"));
                p.setBuyNowPrice(rs.getInt("BUY_NOW_PRICE"));
                p.setCurrentPrice(rs.getInt("CURRENT_PRICE"));
                p.setEndTime(rs.getTimestamp("END_TIME"));
                p.setImageRenamedName(rs.getString("IMAGE_RENAMED_NAME"));
                p.setSellerId(rs.getString("SELLER_ID"));
                p.setRegDate(rs.getDate("REG_DATE"));
                p.setStatus(rs.getString("STATUS"));
                p.setCategory(rs.getString("CATEGORY"));
                p.setWinnerId(rs.getString("WINNER_ID"));
                p.setFinalPrice(rs.getInt("FINAL_PRICE"));
            }
        } catch (SQLException e) { e.printStackTrace(); } 
        finally { close(rs); close(pstmt); }
        return p;
    }
    
    public int insertBid(Connection conn, Bid b) {
        int result = 0;
        PreparedStatement pstmt = null;
        String sql = "INSERT INTO BID (BID_ID, PRODUCT_ID, BIDDER_ID, BID_PRICE, BID_TIME)\r\n"
        		+ "		VALUES (SEQ_BID_ID.NEXTVAL, ?, ?, ?, SYSDATE)";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, b.getProductId());
            pstmt.setString(2, b.getBidderId());
            pstmt.setInt(3, b.getBidPrice());
            result = pstmt.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); } 
        finally { close(pstmt); }
        return result;
    }
    
    public int updateCurrentPrice(Connection conn, int productId, int bidPrice) {
        int result = 0;
        PreparedStatement pstmt = null;
        String sql = "	UPDATE PRODUCT\r\n SET CURRENT_PRICE = ?\r\n WHERE PRODUCT_ID = ?";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, bidPrice);
            pstmt.setInt(2, productId);
            result = pstmt.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); } 
        finally { close(pstmt); }
        return result;
    }

    public int insertProduct(Connection conn, ProductDTO p) {
        int result = 0;
        PreparedStatement pstmt = null;
        String sql = "INSERT INTO PRODUCT (\r\n"
        		+ "			PRODUCT_ID, PRODUCT_NAME, ARTIST_NAME, PRODUCT_DESC, \r\n"
        		+ "			START_PRICE, BUY_NOW_PRICE, CURRENT_PRICE, END_TIME, \r\n"
        		+ "			IMAGE_ORIGINAL_NAME, IMAGE_RENAMED_NAME, CATEGORY, SELLER_ID, \r\n"
        		+ "			REG_DATE, STATUS\r\n"
        		+ "		) VALUES (\r\n"
        		+ "			SEQ_PRODUCT_ID.NEXTVAL, ?, ?, ?,\r\n"
        		+ "			?, ?, 0, ?,\r\n"
        		+ "			?, ?, ?, ?, \r\n"
        		+ "			SYSDATE, 'A'\r\n"
        		+ "		)";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, p.getProductName());
            pstmt.setString(2, p.getArtistName());
            pstmt.setString(3, p.getProductDesc());
            pstmt.setInt(4, p.getStartPrice());
            if (p.getBuyNowPrice() > 0) {
                pstmt.setInt(5, p.getBuyNowPrice());
            } else {
                pstmt.setNull(5, java.sql.Types.INTEGER);
            }
            pstmt.setTimestamp(6, p.getEndTime());
            pstmt.setString(7, p.getImageOriginalName());
            pstmt.setString(8, p.getImageRenamedName());
            pstmt.setString(9, p.getCategory());
            pstmt.setString(10, p.getSellerId());
            result = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(pstmt);
        }
        return result;
    }

    public List<ProductDTO> selectProductsBySeller(Connection conn, String sellerId) {
        List<ProductDTO> list = new ArrayList<>();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT PRODUCT_ID, PRODUCT_NAME, CURRENT_PRICE, IMAGE_RENAMED_NAME\r\n"
        		+ "		  FROM PRODUCT\r\n"
        		+ "		 WHERE SELLER_ID = ?\r\n"
        		+ "		   AND STATUS = 'A' \r\n"
        		+ "		 ORDER BY PRODUCT_ID DESC";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, sellerId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                ProductDTO p = new ProductDTO();
                p.setProductId(rs.getInt("PRODUCT_ID"));
                p.setProductName(rs.getString("PRODUCT_NAME"));
                p.setCurrentPrice(rs.getInt("CURRENT_PRICE"));
                p.setImageRenamedName(rs.getString("IMAGE_RENAMED_NAME"));
                list.add(p);
            }
        } catch (SQLException e) { e.printStackTrace(); } 
        finally { close(rs); close(pstmt); }
        return list;
    }
    
    public int deleteProduct(Connection conn, int productId, String memberId) {
        int result = 0;
        PreparedStatement pstmt = null;
        String sql = "	UPDATE PRODUCT\r\n"
        		+ "		   SET STATUS = 'C'\r\n"
        		+ "		 WHERE PRODUCT_ID = ?\r\n"
        		+ "		   AND SELLER_ID = ?";
        
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, productId);
            pstmt.setString(2, memberId);
            
            result = pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(pstmt);
        }
        
        return result;
    }

    public Bid findWinner(Connection conn, int productId) {
        Bid winner = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT *\r\n"
        		+ "		  FROM (\r\n"
        		+ "		        SELECT BIDDER_ID, BID_PRICE\r\n"
        		+ "		          FROM BID\r\n"
        		+ "		         WHERE PRODUCT_ID = ?\r\n"
        		+ "		         ORDER BY BID_PRICE DESC\r\n"
        		+ "		       )\r\n"
        		+ "		 WHERE ROWNUM = 1";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, productId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                winner = new Bid();
                winner.setBidderId(rs.getString("BIDDER_ID"));
                winner.setBidPrice(rs.getInt("BID_PRICE"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(rs);
            close(pstmt);
        }
        return winner;
    }

    public int updateProductWinner(Connection conn, int productId, String winnerId, int finalPrice) {
        int result = 0;
        PreparedStatement pstmt = null;
        String sql = "UPDATE PRODUCT\r\n SET WINNER_ID = ?,\r\n FINAL_PRICE = ?\r\n WHERE PRODUCT_ID = ?";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, winnerId);
            pstmt.setInt(2, finalPrice);
            pstmt.setInt(3, productId);
            result = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(pstmt);
        }
        return result;
    }
    
    public int updateProductStatus(Connection conn, int productId, String status) {
        int result = 0;
        PreparedStatement pstmt = null;
        String sql = "	UPDATE PRODUCT\r\n SET STATUS = ?\r\n WHERE PRODUCT_ID = ?";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            pstmt.setInt(2, productId);
            result = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(pstmt);
        }
        return result;
    }
    public List<ProductDTO> selectWonProducts(Connection conn, String winnerId) {
        List<ProductDTO> list = new ArrayList<>();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "		SELECT \r\n"
        		+ "		       PRODUCT_ID,\r\n"
        		+ "		       PRODUCT_NAME,\r\n"
        		+ "		       FINAL_PRICE,\r\n"
        		+ "		       IMAGE_RENAMED_NAME,\r\n"
        		+ "		       STATUS\r\n"
        		+ "		  FROM PRODUCT\r\n"
        		+ "		 WHERE WINNER_ID = ?\r\n"
        		+ "		 ORDER BY PRODUCT_ID DESC";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, winnerId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                ProductDTO p = new ProductDTO();
                p.setProductId(rs.getInt("PRODUCT_ID"));
                p.setProductName(rs.getString("PRODUCT_NAME"));
                p.setFinalPrice(rs.getInt("FINAL_PRICE"));
                p.setImageRenamedName(rs.getString("IMAGE_RENAMED_NAME"));
                p.setStatus(rs.getString("STATUS")); // 결제 여부 확인을 위해 상태 추가
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(rs);
            close(pstmt);
        }
        return list;
    }
    
    // 가장 최근에 시퀀스로 생성된 PRODUCT_ID를 반환 (insert 직후에 호출해야 함)
    public int selectLastInsertedProductId(Connection conn) throws SQLException {
        String sql = "SELECT SEQ_PRODUCT_ID.CURRVAL FROM DUAL";
        try (PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return -1; // 실패 시 -1 반환
    }
    
}
