<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Đặt lại mật khẩu - TechCommerce</title>
</head>
<body>
<h1 class="h4 fw-bold text-center mb-3">Đặt mật khẩu mới</h1>

<c:if test="${not empty error}">
    <div class="alert alert-danger py-2 small"><c:out value="${error}"/></div>
</c:if>

<form action="${pageContext.request.contextPath}/auth/reset-password" method="post" class="mb-3">
    <c:if test="${not empty _csrf}">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    </c:if>
    <input type="hidden" name="token" value="<c:out value='${token}'/>"/>
    <div class="mb-3">
        <label for="newPassword" class="form-label small fw-semibold">Mật khẩu mới (tối thiểu 8 ký tự)</label>
        <input type="password" id="newPassword" name="newPassword" class="form-control" minlength="8" required>
    </div>
    <div class="mb-3">
        <label for="confirmPassword" class="form-label small fw-semibold">Xác nhận mật khẩu mới</label>
        <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" minlength="8" required>
    </div>
    <button type="submit" class="btn btn-primary w-100 fw-semibold">Cập nhật mật khẩu</button>
</form>
</body>
</html>
