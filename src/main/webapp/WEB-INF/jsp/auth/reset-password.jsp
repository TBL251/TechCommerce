<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Đặt mật khẩu mới - TechCommerce</title>
</head>
<body>
<div class="mb-4">
    <div class="d-inline-flex align-items-center gap-2 tc-badge tc-badge-success mb-2">
        <i class="bi bi-shield-check" aria-hidden="true"></i>
        <span>Đặt lại mật khẩu bảo mật</span>
    </div>
    <h1 class="h4 fw-bold mb-1">Thiết lập mật khẩu mới</h1>
    <p class="small text-secondary mb-0">Sau khi cập nhật, toàn bộ các phiên Refresh Token cũ trên thiết bị khác sẽ tự động bị thu hồi.</p>
</div>

<c:if test="${not empty error}">
    <div class="alert alert-danger py-2 px-3 small d-flex align-items-center gap-2" role="alert" aria-live="polite">
        <i class="bi bi-exclamation-octagon-fill flex-shrink-0" aria-hidden="true"></i>
        <span><c:out value="${error}"/></span>
    </div>
</c:if>

<form action="${pageContext.request.contextPath}/auth/reset-password" method="post" class="mb-3">
    <c:if test="${not empty _csrf}">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    </c:if>
    <input type="hidden" name="token" value="<c:out value='${token}'/>"/>
    <div class="mb-3">
        <label for="newPassword" class="form-label">Mật khẩu mới (tối thiểu 8 ký tự)</label>
        <div class="input-group">
            <span class="input-group-text bg-light text-secondary"><i class="bi bi-lock" aria-hidden="true"></i></span>
            <input type="password" id="newPassword" name="newPassword" class="form-control"
                   minlength="8" required autocomplete="new-password" placeholder="Nhập mật khẩu mới…">
        </div>
    </div>
    <div class="mb-3">
        <label for="confirmPassword" class="form-label">Xác nhận mật khẩu mới</label>
        <div class="input-group">
            <span class="input-group-text bg-light text-secondary"><i class="bi bi-lock-fill" aria-hidden="true"></i></span>
            <input type="password" id="confirmPassword" name="confirmPassword" class="form-control"
                   minlength="8" required autocomplete="new-password" placeholder="Nhập lại mật khẩu mới…">
        </div>
    </div>
    <button type="submit" class="btn btn-primary w-100 py-2">
        <i class="bi bi-check2-circle" aria-hidden="true"></i>
        <span>Lưu mật khẩu mới</span>
    </button>
</form>
</body>
</html>
