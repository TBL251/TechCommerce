<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>404 - Không tìm thấy trang</title>
</head>
<body>
<div class="row justify-content-center py-5 tc-hero-enter">
    <div class="col-12 col-md-8 col-lg-6">
        <div class="tc-card p-4 p-md-5 text-center">
            <span class="tc-badge tc-badge-warning tc-mono mb-3">MÃ TRẠNG THÁI 404</span>
            <h1 class="h3 fw-bold mb-2">Không tìm thấy đường dẫn yêu cầu</h1>
            <p class="text-secondary mb-4">
                <c:out value="${not empty errorMessage ? errorMessage : 'Trang, sản phẩm hoặc chi nhánh bạn đang tìm không tồn tại hoặc đã được chuyển sang địa chỉ mới.'}"/>
            </p>
            <div class="d-flex flex-wrap justify-content-center gap-2">
                <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
                    <i class="bi bi-house" aria-hidden="true"></i>
                    <span>Về trang chủ</span>
                </a>
                <a href="${pageContext.request.contextPath}/profile" class="btn btn-light border">
                    <i class="bi bi-person-vcard" aria-hidden="true"></i>
                    <span>Mở hồ sơ tài khoản</span>
                </a>
            </div>
        </div>
    </div>
</div>
</body>
</html>
