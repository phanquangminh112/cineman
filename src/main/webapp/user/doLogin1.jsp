<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.User1, model.Manager1, dao.UserDAO1" %>
<%
  request.setCharacterEncoding("UTF-8");
  String ctx = request.getContextPath();
  String username = request.getParameter("username");
  String password = request.getParameter("password");
  User1 user = null;
  try (dao.UserDAO1 userDAO = new dao.UserDAO1()) {
      if (username != null && password != null && !username.trim().isEmpty()) {
          user = userDAO.login(username.trim(), password);
      }
  } catch (Exception e) {
      response.sendRedirect(ctx + "/user/login1.jsp?error=db");
      return;
  }
  if (user == null) {
      response.sendRedirect(ctx + "/user/login1.jsp?error=1");
      return;
  }
  session.setAttribute("user", user);
  if (user instanceof Manager1) {
      // Hình 16: các trang của module Lên lịch chiếu đều mang thuộc tính manager: Manager1
      session.setAttribute("manager", user);
      response.sendRedirect(ctx + "/manager/managerHomeScreen1.jsp");
  } else {
      response.sendRedirect(ctx + "/customer/customerHomeScreen1.jsp");
  }
%>
