<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>500 - Lỗi hệ thống</title>
</head>
<body>
<div class="text-center py-5">
    <h1 class="display-4 fw-bold text-secondary">500</h1>
    <h2 class="h4 mb-3">Sự cố hệ thống tạm thời</h2>
    <p class="text-secondary mb-4"><c:out value="${not empty errorMessage ? errorMessage : 'Đã xảy ra lỗi khi xử lý yêu cầu. Vui lòng thử lại sau.'}"/></p>
    <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Về trang chủ</a>
</div>
</body>
</html>
