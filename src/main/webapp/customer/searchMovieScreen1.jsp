<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Movie1, dao.MovieDAO1, java.util.List, java.time.format.DateTimeFormatter" %>
<%!
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
  String keyword = request.getParameter("keyword");
  List<Movie1> movies = null;
  String dbError = null;
  boolean searched = keyword != null && !keyword.trim().isEmpty();
  if (searched) {
      try (dao.MovieDAO1 movieDAO = new dao.MovieDAO1()) {
          movies = movieDAO.getMovieByKeyword(keyword.trim());
      } catch (Exception e) {
          dbError = "Không kết nối được cơ sở dữ liệu: " + e.getMessage();
      }
  }
%>
<%@ include file="/common/header1.jsp" %>
<div class="panel">
    <h1>Tìm kiếm phim</h1>
    <% if (dbError != null) { %>
        <div class="alert err"><%= esc(dbError) %></div>
    <% } %>
    <form method="post" action="<%= ctx %>/customer/searchMovieScreen1.jsp" class="field-row">
        <label for="keyword">Từ khoá</label>
        <input type="text" id="keyword" name="keyword" value="<%= esc(keyword) %>"
               placeholder="Nhập tên phim cần tìm" required>
        <button class="btn" type="submit">Tìm</button>
    </form>

    <% if (searched && dbError == null) { %>
        <% if (movies.isEmpty()) { %>
            <%-- Ngoại lệ 4a: không có phim nào có tên chứa từ khóa -> danh sách rỗng --%>
            <div class="empty-note">Không tìm thấy phim phù hợp với từ khoá
                "<b><%= esc(keyword.trim()) %></b>". Vui lòng nhập từ khoá khác.</div>
        <% } else { %>
            <table class="data">
                <thead>
                <tr><th class="num">TT</th><th class="num">Mã phim</th><th>Tên phim</th>
                    <th>Thể loại</th><th>Thời lượng</th><th>Ngày khởi chiếu</th></tr>
                </thead>
                <tbody>
                <% int stt = 1;
                   DateTimeFormatter D = DateTimeFormatter.ofPattern("dd/MM/yyyy");
                   for (Movie1 m : movies) { %>
                    <tr>
                        <td class="num"><%= stt++ %></td>
                        <td class="num"><%= m.getId() %></td>
                        <td><a href="<%= ctx %>/customer/movieDetailScreen1.jsp?movieId=<%= m.getId() %>"><%= esc(m.getTitle()) %></a></td>
                        <td><%= esc(m.getGenre()) %></td>
                        <td><%= m.getDuration() %> phút</td>
                        <td><%= m.getReleaseDate() != null ? m.getReleaseDate().format(D) : "" %></td>
                    </tr>
                <% } %>
                </tbody>
            </table>
            <div class="empty-note" style="margin-top:10px;">Bấm vào <b>tên phim</b> để xem thông tin chi tiết.</div>
        <% } %>
    <% } %>

    <div class="actions">
        <div class="left"></div>
        <div class="right"><a class="btn" href="<%= ctx %>/customer/customerHomeScreen1.jsp">Quay lại</a></div>
    </div>
</div>
<%@ include file="/common/footer1.jsp" %>
