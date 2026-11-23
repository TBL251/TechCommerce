<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Xác nhận email - TechCommerce</title>
</head>
<body>
<div class="mb-4">
    <h1 class="h4 fw-bold mb-1">Nhập mã xác nhận</h1>
    <p class="text-secondary small mb-0">
        Chúng tôi vừa gửi mã 6 chữ số đến
        <span class="fw-semibold text-body"><c:out value="${maskedEmail}"/></span>.
        Mã có hiệu lực trong 10 phút.
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
    <%-- Email ẩn để gửi kèm theo form --%>
    <input type="hidden" name="email" value="<c:out value='${email}'/>"/>

    <div class="mb-4">
        <label for="otp" class="form-label fw-semibold">Mã OTP</label>
        <input type="text" id="otp" name="otp" class="form-control form-control-lg tc-tabular text-center"
               inputmode="numeric" pattern="[0-9]{6}" maxlength="6" required
               placeholder="000000" autocomplete="one-time-code" aria-describedby="otpHint">
        <div id="otpHint" class="form-text">Nhập đúng 6 chữ số từ email của bạn.</div>
    </div>

    <button type="submit" class="btn btn-primary w-100 py-2 mb-2">
        <i class="bi bi-person-check" aria-hidden="true"></i>
        <span>Xác nhận và tạo tài khoản</span>
    </button>
</form>

<p class="text-center small text-secondary mb-0">
    Chưa nhận được mã?
    <a href="${pageContext.request.contextPath}/auth/register" class="fw-semibold text-decoration-none">Đăng ký lại</a>
    để nhận mã mới.
</p>
</body>
</html>
