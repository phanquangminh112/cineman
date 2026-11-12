package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.Movie1;

public class MovieDAO1 extends DAO1 {

    private static final String COLS =
            "id, title, genre, director, main_actors, duration, description, image_url, released_date, status";

    public List<Movie1> getMovieByKeyword(String keyword) throws SQLException {
        List<Movie1> result = new ArrayList<>();
        String sql = "SELECT " + COLS + " FROM movie1 WHERE title LIKE ? ORDER BY id";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(fromRow(rs));
                }
            }
        }
        return result;
    }

    public List<Movie1> getShowingMovies() throws SQLException {
        List<Movie1> result = new ArrayList<>();
        String sql = "SELECT " + COLS + " FROM movie1 WHERE status = 'Đang chiếu' ORDER BY id";
        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                result.add(fromRow(rs));
            }
        }
        return result;
    }

    public Movie1 getMovieById(int id) throws SQLException {
        String sql = "SELECT " + COLS + " FROM movie1 WHERE id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return fromRow(rs);
                }
            }
        }
        return null;
    }

    public boolean addMovie(Movie1 movie) throws SQLException {
        String sql = "INSERT INTO movie1 "
                + "(title, genre, director, main_actors, duration, description, image_url, released_date, status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, movie.getTitle());
            ps.setString(2, movie.getGenre());
            ps.setString(3, movie.getDirector());
            ps.setString(4, movie.getMainActors());
            ps.setInt(5, movie.getDuration());
            ps.setString(6, movie.getDescription());
            ps.setString(7, movie.getImageUrl());
            if (movie.getReleaseDate() != null) {
                ps.setDate(8, java.sql.Date.valueOf(movie.getReleaseDate()));
            } else {
                ps.setNull(8, java.sql.Types.DATE);
            }
            ps.setString(9, movie.getStatus() == null || movie.getStatus().isEmpty()
                    ? "Đang chiếu" : movie.getStatus());
            return ps.executeUpdate() > 0;
        }
    }

    private Movie1 fromRow(ResultSet rs) throws SQLException {
        Movie1 m = new Movie1();
        m.setId(rs.getInt("id"));
        m.setTitle(rs.getString("title"));
        m.setGenre(rs.getString("genre"));
        m.setDirector(rs.getString("director"));
        m.setMainActors(rs.getString("main_actors"));
        m.setDuration(rs.getInt("duration"));
        m.setDescription(rs.getString("description"));
        m.setImageUrl(rs.getString("image_url"));
        java.sql.Date d = rs.getDate("released_date");
        m.setReleaseDate(d == null ? null : d.toLocalDate());
        m.setStatus(rs.getString("status"));
        return m;
    }
}
