<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Showtime1, dao.ShowtimeDAO1, java.util.List, java.time.format.DateTimeFormatter" %>
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
  String ctx = request.getContextPath();
  String msg = request.getParameter("msg");
  List<Showtime1> showtimes = null;
  String dbError = null;
  try (dao.ShowtimeDAO1 showtimeDAO = new dao.ShowtimeDAO1()) {
      showtimes = showtimeDAO.getShowtimeList();
  } catch (Exception e) {
      dbError = "Không kết nối được cơ sở dữ liệu: " + e.getMessage();
  }
%>
<%@ include file="/common/checkManager1.jsp" %>
<%@ include file="/common/header1.jsp" %>
<div class="panel">
    <h1>Quản lí lịch chiếu</h1>
    <% if ("success".equals(msg)) { %>
        <div class="alert ok">Lên lịch chiếu thành công!</div>
    <% } %>
    <% if (dbError != null) { %>
        <div class="alert err"><%= esc(dbError) %></div>
    <% } else if (showtimes == null || showtimes.isEmpty()) { %>
        <div class="empty-note">Chưa có suất chiếu nào trong hệ thống.</div>
    <% } else { %>
        <table class="data">
            <thead>
            <tr><th class="num">TT</th><th>Ngày chiếu</th><th>Khung giờ</th><th>Phòng chiếu</th><th>Phim</th></tr>
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
                    <td><%= st.getMovie() != null ? esc(st.getMovie().getTitle()) : "" %></td>
                </tr>
            <% } %>
            </tbody>
        </table>
    <% } %>
    <div class="actions">
        <div class="left"><a class="btn" href="<%= ctx %>/manager/addShowtimeScreen1.jsp">Thêm lịch chiếu</a></div>
        <div class="right"><a class="btn" href="<%= ctx %>/manager/managerHomeScreen1.jsp">Quay lại</a></div>
    </div>
</div>
<%@ include file="/common/footer1.jsp" %>
