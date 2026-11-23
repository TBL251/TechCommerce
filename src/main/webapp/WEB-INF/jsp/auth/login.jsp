<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Đăng nhập tài khoản - TechCommerce</title>
</head>
<body>
<div class="relative">
    <div class="mb-5">
        <h1 class="text-2xl font-headline font-bold tracking-tight text-on-surface mb-1">Đăng nhập tài khoản</h1>
        <p class="text-xs text-on-surface-variant mb-0">Truy cập giỏ hàng, sổ địa chỉ và hệ thống chi nhánh</p>
    </div>

    <c:if test="${not empty error}">
        <div class="mb-4 p-3 rounded-xl bg-error-container text-on-error-container text-xs font-medium flex items-center gap-2" role="alert">
            <span class="material-symbols-outlined text-[18px] shrink-0">error</span>
            <span><c:out value="${error}"/></span>
        </div>
    </c:if>
    <c:if test="${not empty message}">
        <div class="mb-4 p-3 rounded-xl bg-tertiary-fixed/40 text-tertiary text-xs font-medium flex items-center gap-2" role="status">
            <span class="material-symbols-outlined text-[18px] shrink-0">check_circle</span>
            <span><c:out value="${message}"/></span>
        </div>
    </c:if>

    <form id="loginForm" action="${pageContext.request.contextPath}/auth/login" method="post" class="space-y-4">
        <c:if test="${not empty _csrf}">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        </c:if>

        <div>
            <label class="block text-xs font-semibold text-on-surface mb-1.5" for="email">Email đăng nhập</label>
            <div class="relative">
                <span class="material-symbols-outlined absolute left-3.5 top-1/2 -translate-y-1/2 text-outline text-[19px]">mail</span>
                <input class="w-full h-11 pl-10 pr-4 rounded-lg bg-surface-container-low text-sm text-on-surface placeholder:text-outline focus:outline-none focus:bg-surface-container-lowest focus:shadow-[0_0_0_2px_#0f52ba] transition-all border-0"
                       id="email" name="email" type="email" required autocomplete="email" inputmode="email" spellcheck="false"
                       value="<c:out value='${email}'/>" placeholder="name@techcommerce.store"/>
            </div>
        </div>

        <div>
            <div class="flex items-center justify-between mb-1.5">
                <label class="block text-xs font-semibold text-on-surface" for="password">Mật khẩu</label>
                <a class="text-xs font-medium text-primary-container hover:text-primary text-decoration-none transition-colors"
                   href="${pageContext.request.contextPath}/auth/forgot-password">
                    Quên mật khẩu?
                </a>
            </div>
            <div class="relative">
                <span class="material-symbols-outlined absolute left-3.5 top-1/2 -translate-y-1/2 text-outline text-[19px]">lock</span>
                <input class="w-full h-11 pl-10 pr-11 rounded-lg bg-surface-container-low text-sm text-on-surface placeholder:text-outline focus:outline-none focus:bg-surface-container-lowest focus:shadow-[0_0_0_2px_#0f52ba] transition-all border-0"
                       id="password" name="password" type="password" required autocomplete="current-password"
                       placeholder="••••••••••••"/>
                <button type="button" id="togglePwdBtn" aria-label="Hiện hoặc ẩn mật khẩu"
                        class="absolute right-2.5 top-1/2 -translate-y-1/2 p-1.5 rounded-md text-on-surface-variant hover:text-on-surface hover:bg-surface-container transition-colors border-0 bg-transparent"
                        onclick="const p=document.getElementById('password'); const i=document.getElementById('password-eye-icon'); if(p.type==='password'){p.type='text';i.textContent='visibility_off';}else{p.type='password';i.textContent='visibility';}">
                    <span class="material-symbols-outlined text-[19px]" id="password-eye-icon">visibility</span>
                </button>
            </div>
        </div>

        <button type="submit" id="loginSubmitBtn"
                class="w-full h-11 rounded-lg bg-primary-container hover:bg-primary text-on-primary font-semibold text-sm shadow-sm hover:shadow-md transition-all flex items-center justify-center gap-2 border-0">
            <span>Đăng nhập</span>
            <span class="material-symbols-outlined text-[18px]">arrow_forward</span>
        </button>
    </form>

    <div class="relative flex items-center my-5">
        <div class="flex-grow h-px bg-surface-container-high"></div>
        <span class="px-3 text-xs font-medium text-on-surface-variant">hoặc tiếp tục với</span>
        <div class="flex-grow h-px bg-surface-container-high"></div>
    </div>

    <a href="${pageContext.request.contextPath}/oauth2/authorization/google"
       class="w-full h-11 rounded-lg bg-surface-container-low hover:bg-surface-container text-on-surface font-medium text-sm transition-colors flex items-center justify-center gap-2.5 text-decoration-none">
        <svg aria-hidden="true" class="w-4 h-4" viewBox="0 0 24 24">
            <path d="M23.745 12.27c0-.7-.06-1.4-.19-2.07H12v4.51h6.6c-.29 1.52-1.14 2.82-2.4 3.68v3.05h3.88c2.27-2.09 3.665-5.17 3.665-9.17z" fill="#4285F4"></path>
            <path d="M12 24c3.24 0 5.95-1.08 7.93-2.91l-3.88-3.05c-1.08.72-2.45 1.16-4.05 1.16-3.12 0-5.77-2.11-6.72-4.96H1.29v3.14C3.26 21.3 7.31 24 12 24z" fill="#34A853"></path>
            <path d="M5.28 14.24c-.24-.72-.38-1.49-.38-2.24s.14-1.52.38-2.24V6.62H1.29C.47 8.24 0 10.06 0 12s.47 3.76 1.29 5.38l3.99-3.14z" fill="#FBBC05"></path>
            <path d="M12 4.75c1.77 0 3.35.61 4.6 1.8l3.42-3.42C17.95 1.19 15.24 0 12 0 7.31 0 3.26 2.7 1.29 6.62l3.99 3.14c.95-2.85 3.6-4.96 6.72-4.96z" fill="#EA4335"></path>
        </svg>
        <span>Đăng nhập bằng tài khoản Google</span>
    </a>

    <!-- Stitch 2x2 Demo Quick-Fill Box -->
    <div class="mt-5 p-3.5 rounded-xl bg-surface-container-low">
        <div class="flex items-center justify-between gap-2 mb-2.5">
            <div class="flex items-center gap-1.5">
                <span class="material-symbols-outlined text-primary text-[16px]">bolt</span>
                <span class="text-xs font-semibold text-on-surface">Điền nhanh tài khoản mẫu</span>
            </div>
            <span class="px-2 py-0.5 rounded bg-surface-container-lowest text-on-surface-variant font-mono text-[11px] font-medium shadow-sm">
                Password123!
            </span>
        </div>
        <div class="grid grid-cols-2 gap-2">
            <button type="button"
                    class="px-3 py-2 rounded-lg bg-surface-container-lowest hover:bg-primary-fixed text-on-surface hover:text-on-primary-fixed text-xs font-medium shadow-sm transition-all flex items-center justify-between border-0"
                    onclick="document.getElementById('email').value='admin@techcommerce.store';document.getElementById('password').value='Password123!';">
                <span>Admin chuỗi</span>
                <span class="font-mono text-[10px] text-primary font-semibold">ALL</span>
            </button>
            <button type="button"
                    class="px-3 py-2 rounded-lg bg-surface-container-lowest hover:bg-primary-fixed text-on-surface hover:text-on-primary-fixed text-xs font-medium shadow-sm transition-all flex items-center justify-between border-0"
                    onclick="document.getElementById('email').value='staff.hn@techcommerce.store';document.getElementById('password').value='Password123!';">
                <span>Staff HN-01</span>
                <span class="font-mono text-[10px] text-tertiary font-semibold">HN</span>
            </button>
            <button type="button"
                    class="px-3 py-2 rounded-lg bg-surface-container-lowest hover:bg-primary-fixed text-on-surface hover:text-on-primary-fixed text-xs font-medium shadow-sm transition-all flex items-center justify-between border-0"
                    onclick="document.getElementById('email').value='staff.hcm@techcommerce.store';document.getElementById('password').value='Password123!';">
                <span>Staff HCM-01</span>
                <span class="font-mono text-[10px] text-tertiary font-semibold">HCM</span>
            </button>
            <button type="button"
                    class="px-3 py-2 rounded-lg bg-surface-container-lowest hover:bg-primary-fixed text-on-surface hover:text-on-primary-fixed text-xs font-medium shadow-sm transition-all flex items-center justify-between border-0"
                    onclick="document.getElementById('email').value='customer@techcommerce.store';document.getElementById('password').value='Password123!';">
                <span>Khách hàng</span>
                <span class="font-mono text-[10px] text-on-surface-variant font-semibold">USER</span>
            </button>
        </div>
    </div>

    <p class="mt-5 text-center text-xs text-on-surface-variant mb-0">
        Chưa có tài khoản?
        <a class="font-semibold text-primary-container hover:text-primary text-decoration-none ml-1"
           href="${pageContext.request.contextPath}/auth/register">
            Tạo tài khoản khách hàng
        </a>
    </p>
</div>
</body>
</html>
