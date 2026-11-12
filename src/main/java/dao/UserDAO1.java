package dao;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import model.Customer1;
import model.Employee1;
import model.Manager1;
import model.TicketSeller1;
import model.User1;

public class UserDAO1 extends DAO1 {

    public User1 login(String username, String password) throws SQLException {
        String sql = "SELECT u.username, u.password, u.name, u.date_of_birth, u.email, u.phone, u.address, "
                   + "       c.loyalty_points, e.position "
                   + "FROM user1 u "
                   + "LEFT JOIN customer1 c ON c.username = u.username "
                   + "LEFT JOIN employee1 e ON e.username = u.username "
                   + "WHERE u.username = ? AND u.password = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                String position = rs.getString("position");
                User1 user;
                if ("Quản lí".equals(position)) {
                    user = new Manager1();
                    ((Employee1) user).setPosition(position);
                } else if ("Nhân viên bán hàng".equals(position)) {
                    user = new TicketSeller1();
                    ((Employee1) user).setPosition(position);
                } else if (rs.getObject("loyalty_points") == null) {
                    return null;
                } else {
                    Customer1 customer = new Customer1();
                    customer.setLoyaltyPoints(rs.getInt("loyalty_points"));
                    user = customer;
                }
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setName(rs.getString("name"));
                Date d = rs.getDate("date_of_birth");
                user.setDateOfBirth(d == null ? null : d.toLocalDate());
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setAddress(rs.getString("address"));
                return user;
            }
        }
    }
}
