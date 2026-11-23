<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Đăng ký tài khoản - TechCommerce</title>
</head>
<body>
<div class="mb-4">
    <h1 class="h4 fw-bold mb-1">Tạo tài khoản mới</h1>
    <p class="text-secondary small mb-0">Lưu sổ địa chỉ nhận hàng, theo dõi tiến trình đơn hàng và đổi trả trong 7&nbsp;ngày</p>
</div>

<c:if test="${not empty error}">
    <div class="alert alert-danger py-2 px-3 small d-flex align-items-center gap-2" role="alert" aria-live="polite">
        <i class="bi bi-exclamation-octagon-fill flex-shrink-0" aria-hidden="true"></i>
        <span><c:out value="${error}"/></span>
    </div>
</c:if>

<form action="${pageContext.request.contextPath}/auth/register/send-otp" method="post" class="mb-3">
    <c:if test="${not empty _csrf}">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    </c:if>
    <div class="mb-3">
        <label for="fullName" class="form-label">Họ và tên</label>
        <input type="text" id="fullName" name="fullName" class="form-control" required
               autocomplete="name" value="<c:out value='${fullName}'/>" placeholder="Nguyễn Văn A…">
    </div>
    <div class="mb-3">
        <label for="email" class="form-label">Địa chỉ email</label>
        <input type="email" id="email" name="email" class="form-control" required
               autocomplete="email" inputmode="email" spellcheck="false"
               value="<c:out value='${email}'/>" placeholder="tenban@example.com…">
    </div>
    <div class="mb-3">
        <label for="phone" class="form-label">Số điện thoại liên hệ</label>
        <input type="tel" id="phone" name="phone" class="form-control tc-tabular"
               autocomplete="tel" inputmode="tel"
               value="<c:out value='${phone}'/>" placeholder="0901234567…">
    </div>
    <div class="row g-2 mb-3">
        <div class="col-sm-6">
            <label for="password" class="form-label">Mật khẩu</label>
            <input type="password" id="password" name="password" class="form-control"
                   minlength="8" required autocomplete="new-password" placeholder="Tối thiểu 8 ký tự…">
        </div>
        <div class="col-sm-6">
            <label for="confirmPassword" class="form-label">Nhập lại mật khẩu</label>
            <input type="password" id="confirmPassword" name="confirmPassword" class="form-control"
                   minlength="8" required autocomplete="new-password" placeholder="Khớp mật khẩu trên…">
        </div>
    </div>
    <button type="submit" class="btn btn-primary w-100 py-2">
        <i class="bi bi-envelope-check" aria-hidden="true"></i>
        <span>Gửi mã xác nhận qua email</span>
    </button>
</form>

<p class="text-center small text-secondary mb-0">
    Đã có tài khoản?
    <a href="${pageContext.request.contextPath}/auth/login" class="fw-semibold text-decoration-none">Đăng nhập ngay</a>
</p>
</body>
</html>
