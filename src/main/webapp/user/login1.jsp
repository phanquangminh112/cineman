<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  String ctx = request.getContextPath();
  String error = request.getParameter("error");
%>
<%@ include file="/common/header1.jsp" %>
<div class="panel">
    <h1>Đăng nhập</h1>
    <% if ("1".equals(error)) { %>
        <div class="alert err">Sai tên đăng nhập hoặc mật khẩu! Vui lòng nhập lại.</div>
    <% } else if ("admin".equals(error)) { %>
        <div class="alert err">Bạn cần đăng nhập với quyền <b>nhân viên quản lí</b> để truy cập chức năng này.</div>
    <% } else if ("db".equals(error)) { %>
        <div class="alert err">Không kết nối được cơ sở dữ liệu. Vui lòng kiểm tra MySQL và cấu hình kết nối trong lớp dao.DAO1.</div>
    <% } %>
    <form method="post" action="<%= ctx %>/user/doLogin1.jsp">
        <div class="form-grid">
            <label>Tên đăng nhập</label>
            <input type="text" name="username" required autofocus>
            <label>Mật khẩu</label>
            <input type="password" name="password" required>
        </div>
        <div class="actions">
            <div class="left"><button class="btn" type="submit">Đăng nhập</button></div>
            <div class="right"><a class="btn" href="<%= ctx %>/customer/customerHomeScreen1.jsp">Quay lại</a></div>
        </div>
    </form>
</div>
<%@ include file="/common/footer1.jsp" %>
