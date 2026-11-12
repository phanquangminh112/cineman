<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Movie1, model.ScreeningRoom1, dao.MovieDAO1, dao.ScreeningRoomDAO1,
                 java.util.List, java.time.LocalDate, java.time.LocalTime,
                 java.time.format.DateTimeFormatter, java.time.format.DateTimeParseException" %>
<%!
  private static final DateTimeFormatter T = DateTimeFormatter.ofPattern("HH:mm");

  private static String esc(String s) {
      if (s == null) {
          return "";
      }
      return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;");
  }

  private static String url(String s) {
      try {
          return java.net.URLEncoder.encode(s == null ? "" : s, "UTF-8");
      } catch (java.io.UnsupportedEncodingException e) {
          return "";
      }
  }
%>
<%
  request.setCharacterEncoding("UTF-8");
  String ctx = request.getContextPath();

  String showDate  = request.getParameter("showDate");
  String timeStart = request.getParameter("timeStart");
  String timeEnd   = request.getParameter("timeEnd");
  String roomSel   = request.getParameter("room");
  String movieSel  = request.getParameter("movie");
  String msg       = request.getParameter("msg");
  String error     = request.getParameter("error");

  List<ScreeningRoom1> availableRooms = null;
  List<Movie1> showingMovies = null;
  String dbError = null;
  String findError = null;

  boolean hasDateTime = showDate != null && !showDate.trim().isEmpty()
                     && timeStart != null && !timeStart.trim().isEmpty()
                     && timeEnd != null && !timeEnd.trim().isEmpty();

  String addMovieUrl = "addMovie1.jsp";
  if (hasDateTime) {
      addMovieUrl += "?showDate=" + url(showDate.trim())
                  + "&timeStart=" + url(timeStart.trim())
                  + "&timeEnd=" + url(timeEnd.trim());
  }

  try (dao.MovieDAO1 movieDAO = new dao.MovieDAO1();
       dao.ScreeningRoomDAO1 roomDAO = new dao.ScreeningRoomDAO1()) {
      showingMovies = movieDAO.getShowingMovies();
      if (hasDateTime) {
          LocalDate day = LocalDate.parse(showDate.trim());
          LocalTime s = LocalTime.parse(timeStart.trim());
          LocalTime e = LocalTime.parse(timeEnd.trim());
          if (!e.isAfter(s)) {
              findError = "Giờ kết thúc phải sau giờ bắt đầu, vui lòng nhập lại.";
          } else {
              availableRooms = roomDAO.getAvailableRooms(day, s, e);
          }
      }
  } catch (DateTimeParseException pe) {
      findError = "Ngày chiếu hoặc khung giờ không hợp lệ, vui lòng nhập lại.";
  } catch (Exception ex) {
      dbError = "Không kết nối được cơ sở dữ liệu: " + ex.getMessage();
  }
%>
<%@ include file="/common/checkManager1.jsp" %>
<%@ include file="/common/header1.jsp" %>
<div class="panel">
    <h1>Thêm lịch chiếu</h1>

    <% if ("movieAdded".equals(msg)) { %>
        <div class="alert ok">Đã thêm phim mới thành công, hãy chọn phim trong danh sách đang chiếu.</div>
    <% } %>
    <% if ("overlap".equals(error)) { %>
        <div class="alert err"><b>Trùng lịch chiếu!</b> Phòng đã có suất chiếu khác trong khung giờ vừa chọn.
            Vui lòng chọn lại phòng hoặc khung giờ.</div>
    <% } else if ("invalid".equals(error)) { %>
        <div class="alert err">Dữ liệu gửi lên chưa hợp lệ (thiếu ngày chiếu, khung giờ, phòng chiếu hoặc phim).</div>
    <% } else if ("db".equals(error)) { %>
        <div class="alert err">Không kết nối được cơ sở dữ liệu, vui lòng thử lại.</div>
    <% } %>
    <% if (dbError != null) { %>
        <div class="alert err"><%= esc(dbError) %></div>
    <% } %>

    <form method="post" action="<%= ctx %>/manager/doAddShowtime1.jsp" id="inputForm">
        <div class="field-row">
            <label for="showDate">Ngày chiếu</label>
            <input type="date" id="showDate" name="showDate" value="<%= esc(showDate) %>" required>
            <label for="timeStart">Giờ bắt đầu</label>
            <input type="time" id="timeStart" name="timeStart" value="<%= esc(timeStart) %>" required>
            <label for="timeEnd">Giờ kết thúc</label>
            <input type="time" id="timeEnd" name="timeEnd" value="<%= esc(timeEnd) %>" required>
            <button class="btn" type="submit" name="action" value="findRooms"
                    formaction="<%= ctx %>/manager/addShowtimeScreen1.jsp">Tìm phòng</button>
        </div>

        <div class="split">
            <div>
                <h3>Phòng chiếu còn rảnh:</h3>
                <% if (!hasDateTime) { %>
                    <div class="empty-note">(rỗng, hiện sau khi chọn ngày, giờ)</div>
                <% } else if (findError != null) { %>
                    <div class="alert err"><%= findError %></div>
                <% } else if (availableRooms == null || availableRooms.isEmpty()) { %>
                    <div class="empty-note">Không có phòng chiếu nào còn rảnh vào ngày/khung giờ đã chọn.
                        Vui lòng chọn lại ngày hoặc khung giờ khác.</div>
                <% } else { %>
                    <table class="data">
                        <thead>
                        <tr><th>Mã phòng</th><th>Tên phòng</th><th>Sức chứa</th></tr>
                        </thead>
                        <tbody>
                        <% for (ScreeningRoom1 r : availableRooms) {
                               boolean checked = roomSel != null && String.valueOf(r.getId()).equals(roomSel); %>
                            <tr>
                                <td><label class="pick">
                                    <input type="radio" name="room" value="<%= r.getId() %>" <%= checked ? "checked" : "" %>>
                                    <%= r.getId() %></label></td>
                                <td><%= esc(r.getRoomName()) %></td>
                                <td><%= r.getCapacity() %> ghế</td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
                <% } %>
            </div>
            <div>
                <h3>Phim đang chiếu:
                    <a class="btn small" style="margin-left:8px;" href="<%= addMovieUrl %>">Thêm phim</a>
                </h3>
                <% if (showingMovies == null || showingMovies.isEmpty()) { %>
                    <div class="empty-note">Chưa có phim nào đang chiếu. Hãy bấm "Thêm phim".</div>
                <% } else { %>
                    <table class="data">
                        <thead>
                        <tr><th class="num">TT</th><th>Mã phim</th><th>Tên phim</th><th>Thể loại</th><th>Thời lượng</th></tr>
                        </thead>
                        <tbody>
                        <% int stt = 1;
                           for (Movie1 m : showingMovies) {
                               boolean checked = movieSel != null && String.valueOf(m.getId()).equals(movieSel); %>
                            <tr>
                                <td class="num"><%= stt++ %></td>
                                <td><label class="pick">
                                    <input class="movie-radio" type="radio" name="movie" value="<%= m.getId() %>" <%= checked ? "checked" : "" %>
                                           data-duration="<%= m.getDuration() %>">
                                    <%= m.getId() %></label></td>
                                <td><%= esc(m.getTitle()) %></td>
                                <td><%= esc(m.getGenre()) %></td>
                                <td><%= m.getDuration() %> phút</td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
                <% } %>
            </div>
        </div>

        <div class="actions">
            <div class="left"><button class="btn" type="submit">Xác nhận</button></div>
            <div class="right"><a class="btn" href="<%= ctx %>/manager/showtimeManageScreen1.jsp">Hủy</a></div>
        </div>
    </form>
</div>
<%@ include file="/common/footer1.jsp" %>
<script>
    let currentDuration = 0;
    const timeStartElement = document.getElementById("timeStart");
    const timeEndElement = document.getElementById("timeEnd");
    
    function refreshTimeEnd() {
        if (currentDuration === 0) {
            timeEndElement.disabled = false;
        } else {
            timeEndElement.disabled = true;
            if (timeStartElement.value === '') {
                return;
            }
            const [sH, sM] = timeStartElement.value.split(':').map(x => parseInt(x));
            let newTime = (sH * 60 + sM + currentDuration) % (24 * 60);
            let eH = Math.floor(newTime / 60).toString();
            let eM = (newTime % 60).toString();
            if (eH.length < 2) {
                eH = '0' + eH;
            }
            if (eM.length < 2) {
                eM = '0' + eM;
            }
            timeEndElement.value = eH + ':' + eM;
        }
    }

    document.querySelectorAll(".movie-radio").forEach(radio => {
        radio.addEventListener('change', () => {
            currentDuration = parseInt(radio.getAttribute("data-duration"));
            refreshTimeEnd();
        });
        if (radio.checked) {
            currentDuration = parseInt(radio.getAttribute("data-duration"));
            refreshTimeEnd();
        }
    });
    
    timeStartElement.addEventListener('change', () => {
        refreshTimeEnd();
    });
    
    document.getElementById("inputForm").addEventListener('submit', () => {
        timeEndElement.disabled = false;
    });
</script>