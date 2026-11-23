<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>403 - Từ chối truy cập</title>
</head>
<body>
<div class="text-center py-5">
    <h1 class="display-4 fw-bold text-danger">403</h1>
    <h2 class="h4 mb-3">Từ chối truy cập</h2>
    <p class="text-secondary mb-4"><c:out value="${not empty errorMessage ? errorMessage : 'Bạn không có quyền truy cập trang hoặc chi nhánh này.'}"/></p>
    <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Về trang chủ</a>
</div>
</body>
</html>
