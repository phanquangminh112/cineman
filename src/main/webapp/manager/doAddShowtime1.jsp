<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Movie1, model.ScreeningRoom1, model.Showtime1, dao.ShowtimeDAO1, dao.MovieDAO1,
                 java.time.LocalDate, java.time.LocalTime" %>
<%!
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
  String timeStartS = request.getParameter("timeStart");
  String timeEndS   = request.getParameter("timeEnd");
  String movieStr  = request.getParameter("movie");
  String roomStr   = request.getParameter("room");

  String backParams = "?showDate=" + url(showDate) + "&timeStart=" + url(timeStartS) + "&timeEnd=" + url(timeEndS);
  String back = ctx + "/manager/addShowtimeScreen1.jsp" + backParams;

  try {
      if (showDate == null || timeStartS == null || movieStr == null || roomStr == null
              || showDate.trim().isEmpty() || timeStartS.trim().isEmpty()
              || movieStr.trim().isEmpty() || roomStr.trim().isEmpty()) {
          response.sendRedirect(back + "&error=invalid");
          return;
      }
      LocalDate day = LocalDate.parse(showDate.trim());
      LocalTime timeStart = LocalTime.parse(timeStartS.trim());
      Movie1 movie = new MovieDAO1().getMovieById(Integer.parseInt(movieStr.trim()));
      LocalTime timeEnd = timeStart.plusMinutes(movie.getDuration());
      ScreeningRoom1 room = new ScreeningRoom1();
      room.setId(Integer.parseInt(roomStr.trim()));
      Showtime1 showtime = new Showtime1();
      showtime.setMovie(movie);
      showtime.setScreeningRoom(room);
      showtime.setShowDate(day);
      showtime.setTimeStart(timeStart);
      showtime.setTimeEnd(timeEnd);
      boolean ok;
      try (dao.ShowtimeDAO1 showtimeDAO = new dao.ShowtimeDAO1()) {
          ok = showtimeDAO.saveShowtime(showtime);
      }
      if (ok) {
          response.sendRedirect(ctx + "/manager/showtimeManageScreen1.jsp?msg=success");
      } else {
          response.sendRedirect(back + "&error=overlap");
      }
  } catch (NumberFormatException nfe) {
      response.sendRedirect(back + "&error=invalid");
  } catch (Exception ex) {
      response.sendRedirect(back + "&error=db");
  }
%>
