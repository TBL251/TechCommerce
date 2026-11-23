<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>500 - Lỗi hệ thống</title>
</head>
<body>
<div class="row justify-content-center py-5 tc-hero-enter">
    <div class="col-12 col-md-7 col-lg-5">
        <div class="tc-card p-4 text-center">
            <span class="tc-badge tc-badge-neutral tc-mono mb-2">500</span>
            <h1 class="h5 fw-bold mb-2">Đã xảy ra lỗi</h1>
            <p class="text-secondary small mb-3">
                <c:out value="${not empty errorMessage ? errorMessage : 'Hệ thống đang bận, vui lòng thử lại sau.'}"/>
            </p>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary btn-sm">Về trang chủ</a>
        </div>
    </div>
</div>
</body>
</html>
