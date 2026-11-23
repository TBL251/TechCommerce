<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quên mật khẩu - TechCommerce</title>
</head>
<body>
<div class="relative">
    <div class="mb-5">
        <h1 class="text-2xl font-headline font-bold tracking-tight text-on-surface mb-1">Khôi phục mật khẩu</h1>
        <p class="text-xs text-on-surface-variant mb-0">Nhập email để nhận liên kết đặt lại mật khẩu (hiệu lực 15&nbsp;phút)</p>
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

    <form action="${pageContext.request.contextPath}/auth/forgot-password" method="post" class="space-y-4">
        <c:if test="${not empty _csrf}">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        </c:if>
        <div>
            <label class="block text-xs font-semibold text-on-surface mb-1.5" for="email">Email tài khoản</label>
            <div class="relative flex items-center">
                <span class="material-symbols-outlined absolute left-3.5 text-outline text-[19px] pointer-events-none">mail</span>
                <input class="w-full h-11 pl-10 pr-4 rounded-lg bg-surface-container-low text-sm text-on-surface placeholder:text-outline focus:outline-none focus:bg-surface-container-lowest focus:shadow-[0_0_0_2px_#0f52ba] transition-all border-0"
                       id="email" name="email" type="email" required autocomplete="email" inputmode="email" spellcheck="false"
                       placeholder="tenban@example.com"/>
            </div>
        </div>
        <button type="submit"
                class="w-full h-11 rounded-lg bg-primary-container hover:bg-primary text-on-primary font-semibold text-sm shadow-sm transition-all flex items-center justify-center gap-2 border-0">
            <span>Gửi liên kết đặt lại mật khẩu</span>
            <span class="material-symbols-outlined text-[18px]">send</span>
        </button>
    </form>

    <p class="mt-5 text-center text-xs mb-0">
        <a href="${pageContext.request.contextPath}/auth/login"
           class="font-semibold text-primary-container hover:text-primary text-decoration-none inline-flex items-center gap-1">
            <span class="material-symbols-outlined text-[16px]">arrow_back</span>
            <span>Quay lại đăng nhập</span>
        </a>
    </p>
</div>
</body>
</html>
