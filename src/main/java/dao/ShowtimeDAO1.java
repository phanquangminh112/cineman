package dao;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

import model.Movie1;
import model.ScreeningRoom1;
import model.Showtime1;

public class ShowtimeDAO1 extends DAO1 {

    private static final String JOIN_SQL =
            "SELECT s.id AS showtime_id, s.show_date, s.start_time, s.time_end, "
          + "       m.id AS movie_id, m.title, m.genre, m.director, m.main_actors, "
          + "       m.duration, m.description, m.image_url, m.released_date, m.status, "
          + "       r.id AS room_id, r.room_name, r.description AS room_desc, r.capacity "
          + "FROM showtime1 s "
          + "JOIN movie1 m ON s.movie_id = m.id "
          + "JOIN screening_room1 r ON s.room_id = r.id ";

    public List<Showtime1> getShowtimeList() throws SQLException {
        List<Showtime1> result = new ArrayList<>();
        String sql = JOIN_SQL + "ORDER BY s.show_date, s.start_time, s.id";
        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                result.add(fromRow(rs));
            }
        }
        return result;
    }

    public List<Showtime1> getShowtimeOfMovie(Movie1 movie) throws SQLException {
        List<Showtime1> result = new ArrayList<>();
        String sql = JOIN_SQL
                + "WHERE s.movie_id = ? AND s.show_date >= CURRENT_DATE "
                + "ORDER BY s.show_date, s.start_time, s.id";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, movie.getId());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(fromRow(rs));
                }
            }
        }
        return result;
    }

    public boolean checkOverlap(int roomId, LocalDate day, LocalTime start, LocalTime end) throws SQLException {
        String sql = "SELECT COUNT(*) FROM showtime1 "
                   + "WHERE room_id = ? AND show_date = ? AND NOT (time_end <= ? OR start_time >= ?)";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ps.setDate(2, Date.valueOf(day));
            ps.setTime(3, Time.valueOf(start));
            ps.setTime(4, Time.valueOf(end));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public boolean saveShowtime(Showtime1 showtime) throws SQLException {
        boolean oldAutoCommit = con.getAutoCommit();
        try {
            con.setAutoCommit(false);
            if (checkOverlap(showtime.getScreeningRoom().getId(), showtime.getShowDate(),
                    showtime.getTimeStart(), showtime.getTimeEnd())) {
                con.rollback();
                return false;
            }
            int showtimeId = 0;
            String insert = "INSERT INTO showtime1 (movie_id, room_id, show_date, start_time, time_end) "
                          + "VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement ps = con.prepareStatement(insert, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, showtime.getMovie().getId());
                ps.setInt(2, showtime.getScreeningRoom().getId());
                ps.setDate(3, Date.valueOf(showtime.getShowDate()));
                ps.setTime(4, Time.valueOf(showtime.getTimeStart()));
                ps.setTime(5, Time.valueOf(showtime.getTimeEnd()));
                ps.executeUpdate();
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        showtimeId = keys.getInt(1);
                    }
                }
            }
            String genSeats = "INSERT INTO screening_room_seat1 (showtime_id, seat_id, status) "
                            + "SELECT ?, id, 'Còn trống' FROM seat1 WHERE room_id = ?";
            try (PreparedStatement ps = con.prepareStatement(genSeats)) {
                ps.setInt(1, showtimeId);
                ps.setInt(2, showtime.getScreeningRoom().getId());
                ps.executeUpdate();
            }
            con.commit();
            showtime.setId(showtimeId);
            return true;
        } catch (SQLException e) {
            try {
                con.rollback();
            } catch (SQLException ignored) {

            }
            throw e;
        } finally {
            con.setAutoCommit(oldAutoCommit);
        }
    }

    private Showtime1 fromRow(ResultSet rs) throws SQLException {
        Movie1 movie = new Movie1();
        movie.setId(rs.getInt("movie_id"));
        movie.setTitle(rs.getString("title"));
        movie.setGenre(rs.getString("genre"));
        movie.setDirector(rs.getString("director"));
        movie.setMainActors(rs.getString("main_actors"));
        movie.setDuration(rs.getInt("duration"));
        movie.setDescription(rs.getString("description"));
        movie.setImageUrl(rs.getString("image_url"));
        Date d = rs.getDate("released_date");
        movie.setReleaseDate(d == null ? null : d.toLocalDate());
        movie.setStatus(rs.getString("status"));

        ScreeningRoom1 room = new ScreeningRoom1();
        room.setId(rs.getInt("room_id"));
        room.setRoomName(rs.getString("room_name"));
        room.setDescription(rs.getString("room_desc"));
        room.setCapacity(rs.getInt("capacity"));

        Showtime1 s = new Showtime1();
        s.setId(rs.getInt("showtime_id"));
        Date showDate = rs.getDate("show_date");
        s.setShowDate(showDate == null ? null : showDate.toLocalDate());
        Time t1 = rs.getTime("start_time");
        s.setTimeStart(t1 == null ? null : t1.toLocalTime());
        Time t2 = rs.getTime("time_end");
        s.setTimeEnd(t2 == null ? null : t2.toLocalTime());
        s.setMovie(movie);
        s.setScreeningRoom(room);
        return s;
    }
}
