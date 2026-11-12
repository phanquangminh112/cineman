<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Manager1" %>
<%
  if (!(session.getAttribute("manager") instanceof Manager1)) {
      response.sendRedirect(request.getContextPath() + "/user/login1.jsp?error=admin");
      return;
  }
%>
