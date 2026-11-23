<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>403 - Không có quyền truy cập</title>
</head>
<body>
<div class="row justify-content-center py-5 tc-hero-enter">
    <div class="col-12 col-md-7 col-lg-5">
        <div class="tc-card p-4 text-center">
            <span class="tc-badge tc-badge-danger tc-mono mb-2">403</span>
            <h1 class="h5 fw-bold mb-2">Không có quyền truy cập</h1>
            <p class="text-secondary small mb-3">
                <c:out value="${not empty errorMessage ? errorMessage : 'Bạn không có quyền truy cập trang này.'}"/>
            </p>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary btn-sm">Về trang chủ</a>
        </div>
    </div>
</div>
</body>
</html>
