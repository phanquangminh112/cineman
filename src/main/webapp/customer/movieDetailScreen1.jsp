<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Movie1, model.Showtime1, dao.MovieDAO1, dao.ShowtimeDAO1, java.util.List, java.time.format.DateTimeFormatter" %>
<%!
  private static final DateTimeFormatter D = DateTimeFormatter.ofPattern("dd/MM/yyyy");
  private static final DateTimeFormatter T = DateTimeFormatter.ofPattern("HH:mm");

  private static String esc(String s) {
      if (s == null) {
          return "";
      }
      return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;");
  }
%>
<%
  request.setCharacterEncoding("UTF-8");
  String ctx = request.getContextPath();
  String movieIdStr = request.getParameter("movieId");
  Movie1 movie = null;
  List<Showtime1> showtimes = null;
  String dbError = null;
  if (movieIdStr != null) {
      try (dao.MovieDAO1 movieDAO = new dao.MovieDAO1();
           dao.ShowtimeDAO1 showtimeDAO = new dao.ShowtimeDAO1()) {
          int movieId = Integer.parseInt(movieIdStr);
          movie = movieDAO.getMovieById(movieId);
          if (movie != null) {
              showtimes = showtimeDAO.getShowtimeOfMovie(movie);
          }
      } catch (NumberFormatException nfe) {
      } catch (Exception e) {
          dbError = "Không kết nối được cơ sở dữ liệu: " + e.getMessage();
      }
  }
  if (movie == null && dbError == null) {
      response.sendRedirect(ctx + "/customer/searchMovieScreen1.jsp");
      return;
  }
%>
<%@ include file="/common/header1.jsp" %>
<div class="panel">
    <h1>Chi tiết phim</h1>
    <% if (dbError != null) { %>
        <div class="alert err"><%= esc(dbError) %></div>
    <% } else if (movie != null) { %>
        <div class="meta-line"><b>Mã phim:</b> <%= movie.getId() %></div>
        <div class="meta-line"><b>Tên phim:</b> <%= esc(movie.getTitle()) %></div>
        <div class="meta-grid">
            <div class="meta"><div class="k">Đạo diễn</div><div class="v"><%= esc(movie.getDirector()) %></div></div>
            <div class="meta"><div class="k">Diễn viên chính</div><div class="v"><%= esc(movie.getMainActors()) %></div></div>
            <div class="meta"><div class="k">Thể loại</div><div class="v"><%= esc(movie.getGenre()) %></div></div>
            <div class="meta"><div class="k">Thời lượng</div><div class="v"><%= movie.getDuration() %> phút</div></div>
            <div class="meta"><div class="k">Trạng thái</div><div class="v"><%= esc(movie.getStatus()) %></div></div>
            <div class="meta"><div class="k">Ngày khởi chiếu</div>
                <div class="v"><%= movie.getReleaseDate() != null ? movie.getReleaseDate().format(D) : "" %></div></div>
        </div>
        <b>Mô tả:</b>
        <div class="desc-box"><%= esc(movie.getDescription()) %></div>
        <% if (movie.getImageUrl() != null && !movie.getImageUrl().isEmpty()) {
               String src = movie.getImageUrl().startsWith("http")
                       ? movie.getImageUrl()
                       : ctx + "/images/" + movie.getImageUrl(); %>
            <img class="poster" src="<%= src %>" alt="Ảnh phim <%= esc(movie.getTitle()) %>">
        <% } %>

        <h2>Các suất chiếu sắp tới:</h2>
        <% if (showtimes == null || showtimes.isEmpty()) { %>
            <div class="empty-note">Phim hiện chưa có suất chiếu sắp tới.</div>
        <% } else { %>
            <table class="data">
                <thead>
                <tr><th class="num">TT</th><th>Ngày</th><th>Khung giờ</th><th>Phòng</th></tr>
                </thead>
                <tbody>
                <% int stt = 1;
                   for (Showtime1 st : showtimes) { %>
                    <tr>
                        <td class="num"><%= stt++ %></td>
                        <td><%= st.getShowDate() != null ? st.getShowDate().format(D) : "" %></td>
                        <td><%= st.getTimeStart() != null ? st.getTimeStart().format(T) : "" %> -
                            <%= st.getTimeEnd() != null ? st.getTimeEnd().format(T) : "" %></td>
                        <td><%= st.getScreeningRoom() != null ? esc(st.getScreeningRoom().getRoomName()) : "" %></td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        <% } %>
    <% } %>
    <div class="actions">
        <div class="left"></div>
        <div class="right"><a class="btn" href="<%= ctx %>/customer/searchMovieScreen1.jsp">Quay lại</a></div>
    </div>
</div>
<%@ include file="/common/footer1.jsp" %>
