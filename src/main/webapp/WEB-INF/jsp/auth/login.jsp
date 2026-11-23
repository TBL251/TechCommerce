<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Đăng nhập - TechCommerce</title>
</head>
<body>
<h1 class="h4 fw-bold mb-3">Đăng nhập</h1>

<c:if test="${not empty error}">
    <div class="alert alert-danger py-2 px-3 small d-flex align-items-center gap-2" role="alert" aria-live="polite">
        <i class="bi bi-exclamation-octagon-fill flex-shrink-0" aria-hidden="true"></i>
        <span><c:out value="${error}"/></span>
    </div>
</c:if>
<c:if test="${not empty message}">
    <div class="alert alert-success py-2 px-3 small d-flex align-items-center gap-2" role="status" aria-live="polite">
        <i class="bi bi-check-circle-fill flex-shrink-0" aria-hidden="true"></i>
        <span><c:out value="${message}"/></span>
    </div>
</c:if>

<form id="loginForm" action="${pageContext.request.contextPath}/auth/login" method="post" class="mb-3">
    <c:if test="${not empty _csrf}">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    </c:if>
    <div class="mb-3">
        <label for="email" class="form-label">Email</label>
        <input type="email" id="email" name="email" class="form-control" required
               autocomplete="email" inputmode="email" spellcheck="false"
               value="<c:out value='${email}'/>" placeholder="tenban@example.com">
    </div>
    <div class="mb-3">
        <div class="d-flex justify-content-between align-items-center mb-1">
            <label for="password" class="form-label mb-0">Mật khẩu</label>
            <a href="${pageContext.request.contextPath}/auth/forgot-password" class="small text-decoration-none">Quên mật khẩu?</a>
        </div>
        <div class="input-group">
            <input type="password" id="password" name="password" class="form-control" required
                   autocomplete="current-password" placeholder="Nhập mật khẩu">
            <button class="btn btn-light border" type="button" id="togglePwdBtn"
                    aria-label="Hiện hoặc ẩn mật khẩu"
                    onclick="const p=document.getElementById('password'); const i=this.querySelector('i'); if(p.type==='password'){p.type='text';i.className='bi bi-eye-slash';}else{p.type='password';i.className='bi bi-eye';}">
                <i class="bi bi-eye" aria-hidden="true"></i>
            </button>
        </div>
    </div>
    <button type="submit" id="loginSubmitBtn" class="btn btn-primary w-100 py-2">
        <span>Đăng nhập</span>
    </button>
</form>

<a href="${pageContext.request.contextPath}/oauth2/authorization/google"
   class="btn btn-light border w-100 d-flex align-items-center justify-content-center gap-2 mb-3">
    <i class="bi bi-google text-danger" aria-hidden="true"></i>
    <span>Tiếp tục với Google</span>
</a>

<div class="tc-surface-subtle p-2 px-3 mb-3">
    <div class="small text-secondary mb-1">Tài khoản thử nghiệm:</div>
    <div class="d-flex flex-wrap gap-1">
        <button type="button" class="btn btn-sm btn-white border bg-white"
                onclick="document.getElementById('email').value='admin@techcommerce.store';document.getElementById('password').value='Password123!';">
            Admin
        </button>
        <button type="button" class="btn btn-sm btn-white border bg-white"
                onclick="document.getElementById('email').value='staff.hn@techcommerce.store';document.getElementById('password').value='Password123!';">
            Staff HN
        </button>
        <button type="button" class="btn btn-sm btn-white border bg-white"
                onclick="document.getElementById('email').value='staff.hcm@techcommerce.store';document.getElementById('password').value='Password123!';">
            Staff HCM
        </button>
        <button type="button" class="btn btn-sm btn-white border bg-white"
                onclick="document.getElementById('email').value='customer@techcommerce.store';document.getElementById('password').value='Password123!';">
            Khách hàng
        </button>
    </div>
</div>

<p class="text-center small text-secondary mb-0">
    Chưa có tài khoản?
    <a href="${pageContext.request.contextPath}/auth/register" class="fw-semibold text-decoration-none">Đăng ký</a>
</p>
</body>
</html>
