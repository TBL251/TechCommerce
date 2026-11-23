<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Đặt mật khẩu mới - TechCommerce</title>
</head>
<body>
<h1 class="h4 fw-bold mb-3">Đặt mật khẩu mới</h1>

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
        <label for="newPassword" class="form-label">Mật khẩu mới</label>
        <input type="password" id="newPassword" name="newPassword" class="form-control"
               minlength="8" required autocomplete="new-password" placeholder="Tối thiểu 8 ký tự">
    </div>
    <div class="mb-3">
        <label for="confirmPassword" class="form-label">Nhập lại mật khẩu</label>
        <input type="password" id="confirmPassword" name="confirmPassword" class="form-control"
               minlength="8" required autocomplete="new-password" placeholder="Nhập lại mật khẩu">
    </div>
    <button type="submit" class="btn btn-primary w-100 py-2">
        <span>Lưu mật khẩu</span>
    </button>
</form>
</body>
</html>
