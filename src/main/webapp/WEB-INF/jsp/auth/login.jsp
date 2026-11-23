<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Đăng nhập - TechCommerce</title>
</head>
<body>
<h1 class="h4 fw-bold text-center mb-3">Đăng nhập tài khoản</h1>

<c:if test="${not empty error}">
    <div class="alert alert-danger py-2 small"><c:out value="${error}"/></div>
</c:if>
<c:if test="${not empty message}">
    <div class="alert alert-success py-2 small"><c:out value="${message}"/></div>
</c:if>

<form action="${pageContext.request.contextPath}/auth/login" method="post" class="mb-3">
    <c:if test="${not empty _csrf}">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    </c:if>
    <div class="mb-3">
        <label for="email" class="form-label small fw-semibold">Email</label>
        <input type="email" id="email" name="email" class="form-control" required
               value="<c:out value='${email}'/>" placeholder="ban@example.com">
    </div>
    <div class="mb-3">
        <div class="d-flex justify-content-between">
            <label for="password" class="form-label small fw-semibold">Mật khẩu</label>
            <a href="${pageContext.request.contextPath}/auth/forgot-password" class="small text-decoration-none">Quên mật khẩu?</a>
        </div>
        <input type="password" id="password" name="password" class="form-control" required placeholder="••••••••">
    </div>
    <button type="submit" class="btn btn-primary w-100 fw-semibold">Đăng nhập</button>
</form>

<div class="text-center my-3 position-relative">
    <hr class="my-2">
    <span class="small text-secondary bg-white px-2">hoặc</span>
</div>

<a href="${pageContext.request.contextPath}/oauth2/authorization/google"
   class="btn btn-outline-dark w-100 d-flex align-items-center justify-content-center gap-2 mb-3">
    <i class="bi bi-google text-danger"></i>
    <span>Đăng nhập nhanh bằng Google</span>
</a>

<p class="text-center small text-secondary mb-0">
    Chưa có tài khoản?
    <a href="${pageContext.request.contextPath}/auth/register" class="fw-semibold text-decoration-none">Đăng ký ngay</a>
</p>
</body>
</html>
