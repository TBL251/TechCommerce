<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Đăng ký tài khoản - TechCommerce</title>
</head>
<body>
<h1 class="h4 fw-bold text-center mb-3">Đăng ký tài khoản mới</h1>

<c:if test="${not empty error}">
    <div class="alert alert-danger py-2 small"><c:out value="${error}"/></div>
</c:if>

<form action="${pageContext.request.contextPath}/auth/register" method="post" class="mb-3">
    <c:if test="${not empty _csrf}">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    </c:if>
    <div class="mb-3">
        <label for="fullName" class="form-label small fw-semibold">Họ và tên</label>
        <input type="text" id="fullName" name="fullName" class="form-control" required
               value="<c:out value='${fullName}'/>" placeholder="Nguyễn Văn A">
    </div>
    <div class="mb-3">
        <label for="email" class="form-label small fw-semibold">Email</label>
        <input type="email" id="email" name="email" class="form-control" required
               value="<c:out value='${email}'/>" placeholder="ban@example.com">
    </div>
    <div class="mb-3">
        <label for="phone" class="form-label small fw-semibold">Số điện thoại</label>
        <input type="tel" id="phone" name="phone" class="form-control"
               value="<c:out value='${phone}'/>" placeholder="0901234567">
    </div>
    <div class="mb-3">
        <label for="password" class="form-label small fw-semibold">Mật khẩu (tối thiểu 8 ký tự)</label>
        <input type="password" id="password" name="password" class="form-control" minlength="8" required>
    </div>
    <div class="mb-3">
        <label for="confirmPassword" class="form-label small fw-semibold">Nhập lại mật khẩu</label>
        <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" minlength="8" required>
    </div>
    <button type="submit" class="btn btn-primary w-100 fw-semibold">Tạo tài khoản</button>
</form>

<p class="text-center small text-secondary mb-0">
    Đã có tài khoản?
    <a href="${pageContext.request.contextPath}/auth/login" class="fw-semibold text-decoration-none">Đăng nhập</a>
</p>
</body>
</html>
