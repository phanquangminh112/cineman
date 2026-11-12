<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.User1, model.Manager1, model.Customer1, model.TicketSeller1" %>
<%
  User1 loginUser = (User1) session.getAttribute("user");
  String homeUrl = (loginUser instanceof Manager1)
          ? ctx + "/manager/managerHomeScreen1.jsp"
          : ctx + "/customer/customerHomeScreen1.jsp";
  String roleName;
  if (loginUser instanceof Manager1) {
      roleName = "Nhân viên quản lí";
  } else if (loginUser instanceof TicketSeller1) {
      roleName = "Nhân viên bán hàng";
  } else if (loginUser instanceof Customer1) {
      roleName = "Khách hàng";
  } else {
      roleName = "";
  }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>CineMan</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>
<div class="topbar">
    <div class="topbar-inner">
        <a class="brand" href="<%= homeUrl %>">Cine<span>Man</span></a>
        <div class="whoami">
            <% if (loginUser != null) { %>
                Xin chào, <b><%= loginUser.getName() %></b> (<%= roleName %>)
                <a class="toplink" href="<%= ctx %>/user/doLogout1.jsp">Đăng xuất</a>
            <% } else { %>
                <a class="toplink" href="<%= ctx %>/user/login1.jsp">Đăng nhập</a>
            <% } %>
        </div>
    </div>
</div>
<div class="container">
