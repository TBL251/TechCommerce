<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Đăng ký tài khoản - TechCommerce</title>
</head>
<body>
<div class="relative">
    <!-- Stitch Step 1 Progress Bar -->
    <div class="flex flex-col gap-2 mb-5">
        <div class="flex items-center justify-between text-xs font-label">
            <span class="font-bold uppercase tracking-wider text-primary-container flex items-center gap-1.5">
                <span class="w-5 h-5 rounded-full bg-primary-container text-on-primary flex items-center justify-center text-[11px] font-mono">1</span>
                Thông tin tài khoản
            </span>
            <span class="text-on-surface-variant flex items-center gap-1">
                <span>Bước 2: OTP Email</span>
                <span class="material-symbols-outlined text-[14px]">arrow_forward</span>
            </span>
        </div>
        <div class="w-full h-1.5 bg-surface-container rounded-full overflow-hidden">
            <div class="w-1/2 h-full bg-primary-container rounded-full"></div>
        </div>
    </div>

    <div class="mb-5">
        <h1 class="text-2xl font-headline font-bold tracking-tight text-on-surface mb-1">Tạo tài khoản mới</h1>
        <p class="text-xs text-on-surface-variant mb-0">Điền thông tin để nhận mã OTP 6 chữ số xác thực qua email</p>
    </div>

    <c:if test="${not empty error}">
        <div class="mb-4 p-3 rounded-xl bg-error-container text-on-error-container text-xs font-medium flex items-center gap-2" role="alert">
            <span class="material-symbols-outlined text-[18px] shrink-0">error</span>
            <span><c:out value="${error}"/></span>
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/auth/register/send-otp" method="post" class="space-y-4">
        <c:if test="${not empty _csrf}">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        </c:if>

        <div>
            <label class="block text-xs font-semibold text-on-surface mb-1.5" for="fullName">Họ và tên</label>
            <div class="relative flex items-center">
                <span class="material-symbols-outlined absolute left-3.5 text-outline text-[19px] pointer-events-none">person</span>
                <input class="w-full h-11 pl-10 pr-4 bg-surface-container-low rounded-lg text-sm text-on-surface placeholder:text-outline focus:bg-surface-container-lowest focus:outline-none focus:shadow-[0_0_0_2px_#0f52ba] transition-all border-0"
                       id="fullName" name="fullName" type="text" required autocomplete="name"
                       value="<c:out value='${fullName}'/>" placeholder="Nguyễn Văn A"/>
            </div>
        </div>

        <div>
            <label class="block text-xs font-semibold text-on-surface mb-1.5" for="email">Địa chỉ email nhận OTP</label>
            <div class="relative flex items-center">
                <span class="material-symbols-outlined absolute left-3.5 text-outline text-[19px] pointer-events-none">mail</span>
                <input class="w-full h-11 pl-10 pr-4 bg-surface-container-low rounded-lg text-sm font-mono text-on-surface placeholder:text-outline focus:bg-surface-container-lowest focus:outline-none focus:shadow-[0_0_0_2px_#0f52ba] transition-all border-0"
                       id="email" name="email" type="email" required autocomplete="email" inputmode="email" spellcheck="false"
                       value="<c:out value='${email}'/>" placeholder="tenban@gmail.com"/>
            </div>
        </div>

        <div>
            <label class="block text-xs font-semibold text-on-surface mb-1.5" for="phone">Số điện thoại</label>
            <div class="relative flex items-center">
                <span class="material-symbols-outlined absolute left-3.5 text-outline text-[19px] pointer-events-none">smartphone</span>
                <input class="w-full h-11 pl-10 pr-4 bg-surface-container-low rounded-lg text-sm font-mono text-on-surface placeholder:text-outline focus:bg-surface-container-lowest focus:outline-none focus:shadow-[0_0_0_2px_#0f52ba] transition-all border-0"
                       id="phone" name="phone" type="tel" autocomplete="tel" inputmode="tel"
                       value="<c:out value='${phone}'/>" placeholder="0901234567"/>
            </div>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
            <div>
                <label class="block text-xs font-semibold text-on-surface mb-1.5" for="password">Mật khẩu</label>
                <div class="relative flex items-center">
                    <span class="material-symbols-outlined absolute left-3.5 text-outline text-[18px] pointer-events-none">lock</span>
                    <input class="w-full h-11 pl-10 pr-3 bg-surface-container-low rounded-lg text-sm text-on-surface placeholder:text-outline focus:bg-surface-container-lowest focus:outline-none focus:shadow-[0_0_0_2px_#0f52ba] transition-all border-0"
                           id="password" name="password" type="password" minlength="8" required autocomplete="new-password"
                           placeholder="Tối thiểu 8 ký tự"/>
                </div>
            </div>
            <div>
                <label class="block text-xs font-semibold text-on-surface mb-1.5" for="confirmPassword">Nhập lại mật khẩu</label>
                <div class="relative flex items-center">
                    <span class="material-symbols-outlined absolute left-3.5 text-outline text-[18px] pointer-events-none">lock_reset</span>
                    <input class="w-full h-11 pl-10 pr-3 bg-surface-container-low rounded-lg text-sm text-on-surface placeholder:text-outline focus:bg-surface-container-lowest focus:outline-none focus:shadow-[0_0_0_2px_#0f52ba] transition-all border-0"
                           id="confirmPassword" name="confirmPassword" type="password" minlength="8" required autocomplete="new-password"
                           placeholder="Khớp mật khẩu"/>
                </div>
            </div>
        </div>

        <button type="submit"
                class="w-full h-11 mt-2 bg-primary-container hover:bg-primary text-on-primary rounded-lg font-headline font-semibold text-sm flex items-center justify-center gap-2 shadow-sm transition-all border-0">
            <span>Gửi mã xác nhận qua email</span>
            <span class="material-symbols-outlined text-[18px]">arrow_forward</span>
        </button>
    </form>

    <p class="mt-5 text-center text-xs text-on-surface-variant mb-0">
        Đã có tài khoản?
        <a class="font-semibold text-primary-container hover:text-primary text-decoration-none ml-1"
           href="${pageContext.request.contextPath}/auth/login">
            Đăng nhập ngay
        </a>
    </p>
</div>
</body>
</html>
