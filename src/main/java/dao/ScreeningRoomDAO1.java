package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

import model.ScreeningRoom1;

public class ScreeningRoomDAO1 extends DAO1 {

    public List<ScreeningRoom1> getAvailableRooms(LocalDate day, LocalTime timeStart, LocalTime timeEnd) throws SQLException {
        List<ScreeningRoom1> result = new ArrayList<>();
        String sql = "SELECT id, room_name, description, capacity FROM screening_room1 "
                   + "WHERE id NOT IN (SELECT room_id FROM showtime1 "
                   + "                 WHERE show_date = ? AND NOT (time_end <= ? OR start_time >= ?)) "
                   + "ORDER BY id";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDate(1, java.sql.Date.valueOf(day));
            ps.setTime(2, java.sql.Time.valueOf(timeStart));
            ps.setTime(3, java.sql.Time.valueOf(timeEnd));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(fromRow(rs));
                }
            }
        }
        return result;
    }

    private ScreeningRoom1 fromRow(ResultSet rs) throws SQLException {
        ScreeningRoom1 r = new ScreeningRoom1();
        r.setId(rs.getInt("id"));
        r.setRoomName(rs.getString("room_name"));
        r.setDescription(rs.getString("description"));
        r.setCapacity(rs.getInt("capacity"));
        return r;
    }
}
