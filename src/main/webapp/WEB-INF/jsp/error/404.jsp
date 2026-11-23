<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>404 - Không tìm thấy trang</title>
</head>
<body>
<div class="row justify-content-center py-5 tc-hero-enter">
    <div class="col-12 col-md-7 col-lg-5">
        <div class="tc-card p-4 text-center">
            <span class="tc-badge tc-badge-warning tc-mono mb-2">404</span>
            <h1 class="h5 fw-bold mb-2">Không tìm thấy trang</h1>
            <p class="text-secondary small mb-3">
                <c:out value="${not empty errorMessage ? errorMessage : 'Trang bạn tìm không tồn tại.'}"/>
            </p>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary btn-sm">Về trang chủ</a>
        </div>
    </div>
</div>
</body>
</html>
