<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>500 - Gián đoạn xử lý yêu cầu</title>
</head>
<body>
<div class="row justify-content-center py-5 tc-hero-enter">
    <div class="col-12 col-md-8 col-lg-6">
        <div class="tc-card p-4 p-md-5 text-center">
            <div class="d-inline-flex align-items-center justify-content-center rounded-circle mb-3"
                 style="width: 56px; height: 56px; background-color: var(--tc-surface-subtle); color: var(--tc-ink-secondary); font-size: 1.5rem;">
                <i class="bi bi-exclamation-triangle" aria-hidden="true"></i>
            </div>
            <div>
                <span class="tc-badge tc-badge-neutral tc-mono mb-3">HTTP 500 · SERVER ERROR</span>
            </div>
            <h1 class="h3 fw-bold mb-2">Không thể hoàn tất yêu cầu lúc này</h1>
            <p class="text-secondary mb-4">
                <c:out value="${not empty errorMessage ? errorMessage : 'Hệ thống gặp sự cố tạm thời khi xử lý dữ liệu. Bạn hãy tải lại trang hoặc quay về trang chủ để tiếp tục.'}"/>
            </p>
            <div class="d-flex flex-wrap justify-content-center gap-2">
                <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
                    <i class="bi bi-house" aria-hidden="true"></i>
                    <span>Về trang chủ</span>
                </a>
                <a href="${pageContext.request.contextPath}/auth/login" class="btn btn-light border">
                    <i class="bi bi-arrow-clockwise" aria-hidden="true"></i>
                    <span>Thử đăng nhập lại</span>
                </a>
            </div>
        </div>
    </div>
</div>
</body>
</html>
