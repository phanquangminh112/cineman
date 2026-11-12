<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%!
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
  String error     = request.getParameter("error");

  String backParams = "?showDate=" + url(showDate) + "&timeStart=" + url(timeStart) + "&timeEnd=" + url(timeEnd);
%>
<%@ include file="/common/checkManager1.jsp" %>
<%@ include file="/common/header1.jsp" %>
<div class="panel">
    <h1>Thêm phim</h1>
    <% if ("invalid".equals(error)) { %>
        <div class="alert err">Vui lòng nhập <b>tên phim</b> và <b>thời lượng</b> hợp lệ.</div>
    <% } else if ("db".equals(error)) { %>
        <div class="alert err">Không kết nối được cơ sở dữ liệu, vui lòng thử lại.</div>
    <% } %>
    <form method="post" action="<%= ctx %>/manager/doAddMovie1.jsp">
        <input type="hidden" name="showDate" value="<%= esc(showDate) %>">
        <input type="hidden" name="timeStart" value="<%= esc(timeStart) %>">
        <input type="hidden" name="timeEnd" value="<%= esc(timeEnd) %>">
        <div class="form-grid">
            <label>Tên phim</label>
            <input type="text" name="title" required>
            <label>Thể loại</label>
            <input type="text" name="genre">
            <label>Đạo diễn</label>
            <input type="text" name="director">
            <label>Diễn viên chính</label>
            <input type="text" name="mainActors">
            <label>Thời lượng (phút)</label>
            <input type="number" name="duration" min="1" max="600" required>
            <label>Mô tả</label>
            <textarea name="description"></textarea>
            <label>Ảnh</label>
            <input type="text" name="image" placeholder="tên tệp trong thư mục images/ hoặc đường dẫn http://...">
            <label>Ngày khởi chiếu</label>
            <input type="date" name="releaseDate">
            <span class="form-hint">Phim thêm mới sẽ có trạng thái "Đang chiếu" và xuất hiện ngay trong danh sách phim đang chiếu.</span>
        </div>
        <div class="actions">
            <div class="left"><button class="btn" type="submit">Xác nhận</button></div>
            <div class="right"><a class="btn" href="addShowtimeScreen1.jsp<%= backParams %>">Hủy</a></div>
        </div>
    </form>
</div>
<%@ include file="/common/footer1.jsp" %>
