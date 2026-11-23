<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>404 - Không tìm thấy trang</title>
</head>
<body>
<div class="text-center py-5">
    <h1 class="display-4 fw-bold text-warning">404</h1>
    <h2 class="h4 mb-3">Không tìm thấy nội dung</h2>
    <p class="text-secondary mb-4"><c:out value="${not empty errorMessage ? errorMessage : 'Trang hoặc sản phẩm bạn tìm không tồn tại.'}"/></p>
    <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Về trang chủ</a>
</div>
</body>
</html>
