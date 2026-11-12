package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DAO1 implements AutoCloseable {

    protected Connection con;

    private static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String DB_URL = "jdbc:mysql://localhost:3306/cineman?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Ho_Chi_Minh&useSSL=false&allowPublicKeyRetrieval=true";
    private static final String DB_USER = "cineman";
    private static final String DB_PASS = "cineman";

    public DAO1() {
        try {
            Class.forName(DB_DRIVER);
            con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Không tìm thấy trình điều khiển JDBC (mysql-connector-j): " + e.getMessage(), e);
        } catch (SQLException e) {
            throw new RuntimeException("Không kết nối được MySQL cineman: " + e.getMessage(), e);
        }
    }

    @Override
    public void close() {
        try {
            if (con != null && !con.isClosed()) {
                con.close();
            }
        } catch (SQLException ignored) {

        }
    }
}
