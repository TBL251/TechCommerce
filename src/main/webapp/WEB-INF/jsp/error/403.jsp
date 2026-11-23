<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>403 - Khu vực giới hạn quyền truy cập</title>
</head>
<body>
<div class="row justify-content-center py-5 tc-hero-enter">
    <div class="col-12 col-md-8 col-lg-6">
        <div class="tc-card p-4 p-md-5 text-center">
            <span class="tc-badge tc-badge-danger tc-mono mb-3">MÃ TRẠNG THÁI 403</span>
            <h1 class="h3 fw-bold mb-2">Khu vực giới hạn quyền truy cập</h1>
            <p class="text-secondary mb-4">
                <c:out value="${not empty errorMessage ? errorMessage : 'Tài khoản hiện tại của bạn không có quyền thực hiện thao tác hoặc truy cập dữ liệu của chi nhánh này.'}"/>
            </p>
            <div class="d-flex flex-wrap justify-content-center gap-2">
                <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
                    <i class="bi bi-house" aria-hidden="true"></i>
                    <span>Về trang chủ</span>
                </a>
                <a href="${pageContext.request.contextPath}/auth/login" class="btn btn-light border">
                    <i class="bi bi-person-check" aria-hidden="true"></i>
                    <span>Đăng nhập tài khoản khác</span>
                </a>
            </div>
        </div>
    </div>
</div>
</body>
</html>
