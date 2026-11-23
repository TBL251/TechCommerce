<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Xác thực mã OTP Email - TechCommerce</title>
</head>
<body>
<div class="mb-4">
    <div class="d-flex align-items-center gap-2 mb-2">
        <span class="tc-step-pill tc-badge-success"><i class="bi bi-check2" aria-hidden="true"></i>1. Thông tin</span>
        <i class="bi bi-chevron-right text-secondary small" aria-hidden="true"></i>
        <span class="tc-step-pill tc-badge-primary">2. Xác thực OTP Email</span>
    </div>
    <h1 class="h4 fw-bold mb-1">Xác thực mã OTP Email</h1>
    <div class="tc-surface-subtle p-3 mt-2 small">
        <i class="bi bi-envelope-paper-fill text-primary me-1" aria-hidden="true"></i>
        Mã xác nhận gồm 6 chữ số đã được gửi tới
        <span class="fw-bold tc-mono text-dark"><c:out value="${maskedEmail}"/></span>
        (hiệu lực trong 10&nbsp;phút).
    </div>
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

    <div class="mb-4">
        <label for="otp" class="form-label fw-semibold d-flex justify-content-between">
            <span>Mã xác thực OTP (6 chữ số)</span>
            <span class="tc-mono text-secondary fw-normal">Tối đa 5 lần thử</span>
        </label>
        <input type="text" id="otp" name="otp" class="form-control tc-otp-input tc-tabular text-center"
               inputmode="numeric" pattern="[0-9]{6}" maxlength="6" required autofocus
               placeholder="000000" autocomplete="one-time-code" aria-describedby="otpHint">
        <div id="otpHint" class="form-text text-center mt-2">
            Nhập đúng 6 chữ số từ hộp thư đến (hoặc thư mục Quảng cáo / Spam).
        </div>
    </div>

    <button type="submit" class="btn btn-primary w-100 py-2 mb-2">
        <i class="bi bi-shield-check" aria-hidden="true"></i>
        <span>Xác nhận và tạo tài khoản</span>
    </button>
</form>

<p class="text-center small text-secondary mb-0">
    Chưa nhận được mã hoặc nhập sai email?
    <a href="${pageContext.request.contextPath}/auth/register" class="fw-semibold text-decoration-none">Đăng ký lại để nhận mã mới</a>
</p>
</body>
</html>
