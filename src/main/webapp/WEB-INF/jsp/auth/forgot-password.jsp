<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quên mật khẩu - TechCommerce</title>
</head>
<body>
<div class="mb-3">
    <h1 class="h4 fw-bold mb-1">Quên mật khẩu</h1>
    <p class="small text-secondary mb-0">Nhập email để nhận liên kết đặt lại mật khẩu.</p>
</div>

<c:if test="${not empty error}">
    <div class="alert alert-danger py-2 px-3 small d-flex align-items-center gap-2" role="alert" aria-live="polite">
        <i class="bi bi-exclamation-octagon-fill flex-shrink-0" aria-hidden="true"></i>
        <span><c:out value="${error}"/></span>
    </div>
</c:if>
<c:if test="${not empty message}">
    <div class="alert alert-success py-2 px-3 small d-flex align-items-center gap-2" role="status" aria-live="polite">
        <i class="bi bi-envelope-check-fill flex-shrink-0" aria-hidden="true"></i>
        <span><c:out value="${message}"/></span>
    </div>
</c:if>

<form action="${pageContext.request.contextPath}/auth/forgot-password" method="post" class="mb-3">
    <c:if test="${not empty _csrf}">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    </c:if>
    <div class="mb-3">
        <label for="email" class="form-label">Email</label>
        <input type="email" id="email" name="email" class="form-control" required
               autocomplete="email" inputmode="email" spellcheck="false" placeholder="tenban@example.com">
    </div>
    <button type="submit" class="btn btn-primary w-100 py-2">
        <span>Gửi liên kết</span>
    </button>
</form>

<p class="text-center small mb-0">
    <a href="${pageContext.request.contextPath}/auth/login" class="text-decoration-none">Quay lại đăng nhập</a>
</p>
</body>
</html>
