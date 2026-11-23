<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Đặt mật khẩu mới - TechCommerce</title>
</head>
<body>
<div class="relative">
    <div class="mb-5">
        <h1 class="text-2xl font-headline font-bold tracking-tight text-on-surface mb-1">Thiết lập mật khẩu mới</h1>
        <p class="text-xs text-on-surface-variant mb-0">Nhập mật khẩu mới tối thiểu 8 ký tự cho tài khoản của bạn</p>
    </div>

    <c:if test="${not empty error}">
        <div class="mb-4 p-3 rounded-xl bg-error-container text-on-error-container text-xs font-medium flex items-center gap-2" role="alert">
            <span class="material-symbols-outlined text-[18px] shrink-0">error</span>
            <span><c:out value="${error}"/></span>
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/auth/reset-password" method="post" class="space-y-4">
        <c:if test="${not empty _csrf}">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        </c:if>
        <input type="hidden" name="token" value="<c:out value='${token}'/>"/>

        <div>
            <label class="block text-xs font-semibold text-on-surface mb-1.5" for="newPassword">Mật khẩu mới</label>
            <div class="relative flex items-center">
                <span class="material-symbols-outlined absolute left-3.5 text-outline text-[19px] pointer-events-none">lock</span>
                <input class="w-full h-11 pl-10 pr-4 rounded-lg bg-surface-container-low text-sm text-on-surface placeholder:text-outline focus:outline-none focus:bg-surface-container-lowest focus:shadow-[0_0_0_2px_#0f52ba] transition-all border-0"
                       id="newPassword" name="newPassword" type="password" minlength="8" required autocomplete="new-password"
                       placeholder="Tối thiểu 8 ký tự"/>
            </div>
        </div>

        <div>
            <label class="block text-xs font-semibold text-on-surface mb-1.5" for="confirmPassword">Xác nhận mật khẩu mới</label>
            <div class="relative flex items-center">
                <span class="material-symbols-outlined absolute left-3.5 text-outline text-[19px] pointer-events-none">lock_reset</span>
                <input class="w-full h-11 pl-10 pr-4 rounded-lg bg-surface-container-low text-sm text-on-surface placeholder:text-outline focus:outline-none focus:bg-surface-container-lowest focus:shadow-[0_0_0_2px_#0f52ba] transition-all border-0"
                       id="confirmPassword" name="confirmPassword" type="password" minlength="8" required autocomplete="new-password"
                       placeholder="Nhập lại mật khẩu mới"/>
            </div>
        </div>

        <button type="submit"
                class="w-full h-11 rounded-lg bg-primary-container hover:bg-primary text-on-primary font-semibold text-sm shadow-sm transition-all flex items-center justify-center gap-2 border-0">
            <span class="material-symbols-outlined text-[18px]">check_circle</span>
            <span>Lưu mật khẩu mới</span>
        </button>
    </form>
</div>
</body>
</html>
