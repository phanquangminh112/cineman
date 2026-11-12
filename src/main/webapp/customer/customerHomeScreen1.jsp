<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  String ctx = request.getContextPath();
%>
<%@ include file="/common/header1.jsp" %>
<div class="panel">
    <h1>Trang chủ khách hàng</h1>
    <p class="home-hero">Chào mừng bạn đến với CineMan!</p>
    <div class="menu-grid">
        <a class="menu-card" href="<%= ctx %>/customer/searchMovieScreen1.jsp">
            <div class="mc-title">Tìm thông tin phim</div>
            <div class="mc-desc">Nhập tên phim để tìm, xem danh sách các phim có tên chứa từ khóa và xem thông tin chi tiết phim.</div>
        </a>
    </div>
</div>
<%@ include file="/common/footer1.jsp" %>
