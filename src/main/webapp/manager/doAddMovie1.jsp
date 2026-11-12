<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Movie1, dao.MovieDAO1, java.time.LocalDate" %>
<%!
  private static String url(String s) {
      try {
          return java.net.URLEncoder.encode(s == null ? "" : s, "UTF-8");
      } catch (java.io.UnsupportedEncodingException e) {
          return "";
      }
  }

  private static String trimOrNull(String s) {
      if (s == null || s.trim().isEmpty()) {
          return null;
      }
      return s.trim();
  }
%>
<%
  request.setCharacterEncoding("UTF-8");
  String ctx = request.getContextPath();

  String showDate  = request.getParameter("showDate");
  String timeStart = request.getParameter("timeStart");
  String timeEnd   = request.getParameter("timeEnd");
  String backParams = "?showDate=" + url(showDate) + "&timeStart=" + url(timeStart) + "&timeEnd=" + url(timeEnd);

  try {
      String title = request.getParameter("title");
      String durationStr = request.getParameter("duration");
      if (title == null || title.trim().isEmpty() || durationStr == null || durationStr.trim().isEmpty()) {
          response.sendRedirect(ctx + "/manager/addMovie1.jsp" + backParams + "&error=invalid");
          return;
      }
      int duration = Integer.parseInt(durationStr.trim());
      if (duration <= 0) {
          response.sendRedirect(ctx + "/manager/addMovie1.jsp" + backParams + "&error=invalid");
          return;
      }
      Movie1 movie = new Movie1();
      movie.setTitle(title.trim());
      movie.setGenre(trimOrNull(request.getParameter("genre")));
      movie.setDirector(trimOrNull(request.getParameter("director")));
      movie.setMainActors(trimOrNull(request.getParameter("mainActors")));
      movie.setDuration(duration);
      movie.setDescription(trimOrNull(request.getParameter("description")));
      movie.setImageUrl(trimOrNull(request.getParameter("image")));
      String released = request.getParameter("releaseDate");
      if (released != null && !released.trim().isEmpty()) {
          movie.setReleaseDate(LocalDate.parse(released.trim()));
      }
      movie.setStatus("Đang chiếu");
      boolean ok;
      try (dao.MovieDAO1 movieDAO = new dao.MovieDAO1()) {
          ok = movieDAO.addMovie(movie);
      }
      if (ok) {
          response.sendRedirect(ctx + "/manager/addShowtimeScreen1.jsp" + backParams + "&msg=movieAdded");
      } else {
          response.sendRedirect(ctx + "/manager/addMovie1.jsp" + backParams + "&error=invalid");
      }
  } catch (NumberFormatException nfe) {
      response.sendRedirect(ctx + "/manager/addMovie1.jsp" + backParams + "&error=invalid");
  } catch (Exception ex) {
      response.sendRedirect(ctx + "/manager/addMovie1.jsp" + backParams + "&error=db");
  }
%>
