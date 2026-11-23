<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quên mật khẩu - TechCommerce</title>
</head>
<body>
<h1 class="h4 fw-bold text-center mb-2">Khôi phục mật khẩu</h1>
<p class="small text-secondary text-center mb-3">Nhập email đăng ký của bạn để nhận liên kết đặt lại mật khẩu có hiệu lực trong 15 phút.</p>

<c:if test="${not empty error}">
    <div class="alert alert-danger py-2 small"><c:out value="${error}"/></div>
</c:if>
<c:if test="${not empty message}">
    <div class="alert alert-success py-2 small"><c:out value="${message}"/></div>
</c:if>

<form action="${pageContext.request.contextPath}/auth/forgot-password" method="post" class="mb-3">
    <c:if test="${not empty _csrf}">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    </c:if>
    <div class="mb-3">
        <label for="email" class="form-label small fw-semibold">Email</label>
        <input type="email" id="email" name="email" class="form-control" required placeholder="ban@example.com">
    </div>
    <button type="submit" class="btn btn-primary w-100 fw-semibold">Gửi liên kết đặt lại</button>
</form>

<p class="text-center small mb-0">
    <a href="${pageContext.request.contextPath}/auth/login" class="text-decoration-none">Quay lại đăng nhập</a>
</p>
</body>
</html>
