<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Xác nhận email - TechCommerce</title>
</head>
<body>
<div class="mb-3">
    <h1 class="h4 fw-bold mb-1">Nhập mã xác nhận</h1>
    <p class="text-secondary small mb-0">
        Mã 6 chữ số đã gửi tới <strong class="tc-mono text-dark"><c:out value="${maskedEmail}"/></strong>.
    </p>
</div>

<c:if test="${not empty error}">
    <div class="alert alert-danger py-2 px-3 small d-flex align-items-center gap-2" role="alert" aria-live="polite">
        <i class="bi bi-exclamation-octagon-fill flex-shrink-0" aria-hidden="true"></i>
        <span><c:out value="${error}"/></span>
    </div>
</c:if>

<form action="${pageContext.request.contextPath}/auth/register/verify-otp" method="post" class="mb-3"
      autocomplete="off">
    <c:if test="${not empty _csrf}">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    </c:if>
    <input type="hidden" name="email" value="<c:out value='${email}'/>"/>

    <div class="mb-3">
        <label for="otp" class="form-label">Mã OTP</label>
        <input type="text" id="otp" name="otp" class="form-control tc-otp-input tc-tabular text-center"
               inputmode="numeric" pattern="[0-9]{6}" maxlength="6" required autofocus
               placeholder="000000" autocomplete="one-time-code">
    </div>

    <button type="submit" class="btn btn-primary w-100 py-2">
        <span>Xác nhận</span>
    </button>
</form>

<p class="text-center small text-secondary mb-0">
    Chưa nhận được mã?
    <a href="${pageContext.request.contextPath}/auth/register" class="fw-semibold text-decoration-none">Gửi lại mã</a>
</p>
</body>
</html>
