// File: src/main/java/com/auction/common/JDBCTemplate.java
// 역할: 데이터베이스(DB)라는 커다란 데이터 보관함에 연결하고, 사용 후에는 잘 정리정돈 해주는 도구상자입니다.
package com.auction.common;

import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

public class JDBCTemplate { //기존의 DTO  변경예정 

    // '데이터 보관함'에 들어갈 수 있는 '마법 열쇠(Connection)'를 만들어주는 기능
    public static Connection getConnection() {
        Connection conn = null; // 열쇠를 담을 빈 상자
        Properties prop = new Properties(); // DB 주소와 비밀번호를 적어둘 쪽지

        // DB 정보가 적힌 쪽지(driver.properties)가 어디 있는지 알려줍니다.
        String filePath = JDBCTemplate.class.getResource("/db/driver/driver.properties").getPath();
        
        try {
            // 1. 쪽지(properties 파일) 내용을 읽습니다.
            prop.load(new FileInputStream(filePath));
            
            // 2. 오라클 데이터 보관함을 열 수 있는 전문가(Driver)를 부릅니다.
            Class.forName(prop.getProperty("driver"));
            
            // 3. 전문가에게 쪽지를 보여주고, 진짜 '마법 열쇠(Connection)'를 받습니다.
            conn = DriverManager.getConnection(prop.getProperty("url"),
                                             prop.getProperty("username"),
                                             prop.getProperty("password"));
            
            // 4. 우리가 직접 "저장해!"라고 말하기 전까지는, 마음대로 저장하지 않도록 설정합니다. (중요!)
            conn.setAutoCommit(false);

        } catch (Exception e) {
            // 문제가 생기면 어디서 문제가 생겼는지 알려줍니다.
            e.printStackTrace();
        }

        return conn; // 완성된 '마법 열쇠'를 돌려줍니다.
    }

    // --- 아래는 다 쓴 도구들을 제자리에 정리하는 기능들입니다 ---
    
    // "저장해!" 라고 외치는 기능
    public static void commit(Connection conn) {
        try {
            if (conn != null && !conn.isClosed()) conn.commit();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    // "어, 방금 한 거 취소!" 라고 외치는 기능
    public static void rollback(Connection conn) {
        try {
            if (conn != null && !conn.isClosed()) conn.rollback();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    // DB와 대화할 때 쓴 편지지(Statement)를 닫는 기능
    public static void close(Statement stmt) {
        try {
            if (stmt != null && !stmt.isClosed()) stmt.close();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    // DB에서 보낸 결과지(ResultSet)를 닫는 기능
    public static void close(ResultSet rs) {
        try {
            if (rs != null && !rs.isClosed()) rs.close();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    // 가장 중요한 '마법 열쇠(Connection)'를 닫는 기능
    public static void close(Connection conn) {
        try {
            if (conn != null && !conn.isClosed()) conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
    }
}
