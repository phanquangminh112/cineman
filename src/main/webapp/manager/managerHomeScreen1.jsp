<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  String ctx = request.getContextPath();
  model.User1 managerUser = (model.User1) session.getAttribute("manager");
%>
<%@ include file="/common/checkManager1.jsp" %>
<%@ include file="/common/header1.jsp" %>
<div class="panel">
    <h1>Trang chủ quản lí</h1>
    <p class="home-hero">Xin chào, <%= managerUser != null ? managerUser.getName() : "" %>!</p>
    <div class="menu-grid">
        <a class="menu-card" href="<%= ctx %>/manager/showtimeManageScreen1.jsp">
            <div class="mc-title">Quản lí lịch chiếu</div>
            <div class="mc-desc">Xem danh sách các suất chiếu hiện có và thêm lịch chiếu mới.</div>
        </a>
    </div>
</div>
<%@ include file="/common/footer1.jsp" %>
