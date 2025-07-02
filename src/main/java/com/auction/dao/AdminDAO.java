package com.auction.dao;

import com.auction.vo.ChargeRequestDTO;
import com.auction.vo.ProductDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import static com.auction.common.JDBCTemplate.*;

public class AdminDAO {

    /** 전체 상품 수 조회 */
    public int selectTotalProducts(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM tbl_product";
        try (
            PreparedStatement pstmt = conn.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery()
        ) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /** 승인 대기 상품 수 조회 (status = 'W') */
    public int selectPendingProducts(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM tbl_product WHERE status = 'W'";
        try (
            PreparedStatement pstmt = conn.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery()
        ) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /** 전체 입찰 건수 조회 */
    public int selectTotalBids(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM bid";
        try (
            PreparedStatement pstmt = conn.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery()
        ) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /** 총 낙찰 금액 합계 조회 (status = 'F') */
    public long selectTotalRevenue(Connection conn) throws SQLException {
        String sql = "SELECT NVL(SUM(final_price), 0) FROM tbl_product WHERE status = 'F'";
        try (
            PreparedStatement pstmt = conn.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery()
        ) {
            if (rs.next()) {
                return rs.getLong(1);
            }
        }
        return 0L;
    }

    /** 승인 대기 중인 상품 목록 조회 (status = 'W') */
    public List<ProductDTO> selectPendingProductsList(Connection conn) throws SQLException {
        String sql = "SELECT product_id, product_name, start_price, image_renamed_name, seller_id "
                   + "FROM tbl_product WHERE status = 'W' ORDER BY product_id DESC";
        List<ProductDTO> list = new ArrayList<>();
        try (
            PreparedStatement pstmt = conn.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery()
        ) {
            while (rs.next()) {
                ProductDTO dto = new ProductDTO();
                dto.setProductId(rs.getInt("product_id"));
                dto.setProductName(rs.getString("product_name"));
                dto.setStartPrice(rs.getInt("start_price"));
                dto.setImageRenamedName(rs.getString("image_renamed_name"));
                dto.setSellerId(rs.getString("seller_id"));
                list.add(dto);
            }
        }
        return list;
    }
    public int approveMileage(Connection conn, int reqId) {
        int result = 0;
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        ResultSet rs = null;

        try {
            // 1. 충전 요청 정보 조회
            String sql1 = "SELECT MEMBER_ID, AMOUNT FROM CHARGE_REQUEST WHERE REQ_ID = ?";
            pstmt1 = conn.prepareStatement(sql1);
            pstmt1.setInt(1, reqId);
            rs = pstmt1.executeQuery();

            if(rs.next()) {
                String memberId = rs.getString("MEMBER_ID");
                long amount = rs.getLong("AMOUNT");

                // 2. 마일리지 업데이트
                String sql2 = "UPDATE MEMBER SET MILEAGE = MILEAGE + ? WHERE MEMBER_ID = ?";
                pstmt2 = conn.prepareStatement(sql2);
                pstmt2.setLong(1, amount);
                pstmt2.setString(2, memberId);
                int updateResult = pstmt2.executeUpdate();

                // 3. 승인 처리
                if(updateResult > 0) {
                    String sql3 = "UPDATE CHARGE_REQUEST SET STATUS = '승인', APPROVE_DATE = SYSDATE WHERE REQ_ID = ?";
                    PreparedStatement pstmt3 = conn.prepareStatement(sql3);
                    pstmt3.setInt(1, reqId);
                    result = pstmt3.executeUpdate();
                    pstmt3.close();
                }
            }
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            close(rs);
            close(pstmt1);
            close(pstmt2);
        }

        return result;
    }
    public List<ChargeRequestDTO> getAllChargeRequests(Connection conn) {
        List<ChargeRequestDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM CHARGE_REQUEST ORDER BY REQUEST_DATE DESC";

        try (PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                ChargeRequestDTO dto = new ChargeRequestDTO();
                dto.setReqId(rs.getInt("REQ_ID"));
                dto.setMemberId(rs.getString("MEMBER_ID"));
                dto.setAmount(rs.getLong("AMOUNT"));
                dto.setStatus(rs.getString("STATUS"));
                dto.setRequestDate(rs.getDate("REQUEST_DATE"));
                dto.setApproveDate(rs.getDate("APPROVE_DATE"));
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }


    public int approveCharge(Connection conn, int reqId) {
        int result = 0;
        try (PreparedStatement ps1 = conn.prepareStatement(
                 "SELECT MEMBER_ID, AMOUNT FROM CHARGE_REQUEST WHERE REQ_ID = ? AND STATUS = 'W'");
             PreparedStatement ps2 = conn.prepareStatement(
                 "UPDATE USERS SET MILEAGE = MILEAGE + ? WHERE \"MEMBER_ID\" = ?");
             PreparedStatement ps3 = conn.prepareStatement(
                 "UPDATE CHARGE_REQUEST SET STATUS = 'A', APPROVE_DATE = SYSDATE WHERE REQ_ID = ?")) {
            
            ps1.setInt(1, reqId);
            ResultSet rs = ps1.executeQuery();
            if(rs.next()) {
                String memberId = rs.getString("MEMBER_ID");
                long amount = rs.getLong("AMOUNT");

                ps2.setLong(1, amount);
                ps2.setString(2, memberId);
                int r1 = ps2.executeUpdate();

                ps3.setInt(1, reqId);
                int r2 = ps3.executeUpdate();

                result = r1 * r2; // 둘 다 성공해야 1
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public int rejectCharge(Connection conn, int reqId) {
        int result = 0;
        String sql = "UPDATE CHARGE_REQUEST SET STATUS = 'R', APPROVE_DATE = SYSDATE WHERE REQ_ID = ? AND STATUS = 'W'";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, reqId);
            result = pstmt.executeUpdate();
        } catch(Exception e) {
            e.printStackTrace();
        }
        return result;
    }
}
