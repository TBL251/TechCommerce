<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Xác thực mã OTP Email - TechCommerce</title>
</head>
<body>
<div class="relative">
    <!-- Stitch Step 2 Progress Bar -->
    <div class="flex flex-col gap-2 mb-5">
        <div class="flex items-center justify-between text-xs font-label">
            <span class="font-bold uppercase tracking-wider text-primary-container flex items-center gap-1.5">
                <span class="w-5 h-5 rounded-full bg-primary-container text-on-primary flex items-center justify-center text-[11px] font-mono">2</span>
                Xác thực email OTP
            </span>
            <span class="inline-flex items-center gap-1 px-2 py-0.5 rounded-full bg-tertiary-fixed text-on-tertiary-fixed text-[11px] font-mono font-bold">
                10 PHÚT
            </span>
        </div>
        <div class="w-full h-1.5 bg-surface-container rounded-full overflow-hidden">
            <div class="w-full h-full bg-primary-container rounded-full"></div>
        </div>
    </div>

    <!-- Stitch Envelope Icon & Header -->
    <div class="flex flex-col items-center text-center gap-2 mb-5">
        <div class="w-14 h-14 rounded-2xl bg-primary-fixed flex items-center justify-center text-primary shadow-sm relative">
            <span class="material-symbols-outlined text-[28px]">mark_email_unread</span>
        </div>
        <h1 class="text-xl font-headline font-bold text-on-surface mb-0">Xác thực mã OTP Email</h1>
        <p class="text-xs text-on-surface-variant mb-0">
            Mã 6 chữ số đã gửi tới <strong class="font-mono text-on-surface"><c:out value="${maskedEmail}"/></strong>
        </p>
    </div>

    <c:if test="${not empty error}">
        <div class="mb-4 p-3 rounded-xl bg-error-container text-on-error-container text-xs font-medium flex items-center gap-2" role="alert">
            <span class="material-symbols-outlined text-[18px] shrink-0">error</span>
            <span><c:out value="${error}"/></span>
        </div>
    </c:if>

    <form id="otpForm" action="${pageContext.request.contextPath}/auth/register/verify-otp" method="post" autocomplete="off" class="space-y-5">
        <c:if test="${not empty _csrf}">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        </c:if>
        <input type="hidden" name="email" value="<c:out value='${email}'/>"/>
        <input type="hidden" id="otp" name="otp" value=""/>

        <!-- Stitch 6-Digit Monospace OTP Input Matrix -->
        <div>
            <label class="block text-xs font-semibold text-on-surface-variant mb-2 text-center" for="otp-box-0">
                Nhập 6 chữ số xác thực
            </label>
            <div class="grid grid-cols-6 gap-2 sm:gap-2.5" id="otp-boxes">
                <input id="otp-box-0" type="text" inputmode="numeric" maxlength="1" autofocus
                       class="otp-digit w-full h-13 py-2.5 text-center font-mono text-xl font-bold rounded-lg bg-surface-container-low text-on-surface focus:outline-none focus:bg-surface-container-lowest focus:shadow-[0_0_0_2px_#0f52ba] transition-all border-0"/>
                <input id="otp-box-1" type="text" inputmode="numeric" maxlength="1"
                       class="otp-digit w-full h-13 py-2.5 text-center font-mono text-xl font-bold rounded-lg bg-surface-container-low text-on-surface focus:outline-none focus:bg-surface-container-lowest focus:shadow-[0_0_0_2px_#0f52ba] transition-all border-0"/>
                <input id="otp-box-2" type="text" inputmode="numeric" maxlength="1"
                       class="otp-digit w-full h-13 py-2.5 text-center font-mono text-xl font-bold rounded-lg bg-surface-container-low text-on-surface focus:outline-none focus:bg-surface-container-lowest focus:shadow-[0_0_0_2px_#0f52ba] transition-all border-0"/>
                <input id="otp-box-3" type="text" inputmode="numeric" maxlength="1"
                       class="otp-digit w-full h-13 py-2.5 text-center font-mono text-xl font-bold rounded-lg bg-surface-container-low text-on-surface focus:outline-none focus:bg-surface-container-lowest focus:shadow-[0_0_0_2px_#0f52ba] transition-all border-0"/>
                <input id="otp-box-4" type="text" inputmode="numeric" maxlength="1"
                       class="otp-digit w-full h-13 py-2.5 text-center font-mono text-xl font-bold rounded-lg bg-surface-container-low text-on-surface focus:outline-none focus:bg-surface-container-lowest focus:shadow-[0_0_0_2px_#0f52ba] transition-all border-0"/>
                <input id="otp-box-5" type="text" inputmode="numeric" maxlength="1"
                       class="otp-digit w-full h-13 py-2.5 text-center font-mono text-xl font-bold rounded-lg bg-surface-container-low text-on-surface focus:outline-none focus:bg-surface-container-lowest focus:shadow-[0_0_0_2px_#0f52ba] transition-all border-0"/>
            </div>
        </div>

        <button type="submit"
                class="w-full h-11 bg-primary-container hover:bg-primary text-on-primary rounded-lg font-headline font-semibold text-sm flex items-center justify-center gap-2 shadow-sm transition-all border-0">
            <span class="material-symbols-outlined text-[19px]">verified_user</span>
            <span>Xác nhận và tạo tài khoản</span>
        </button>
    </form>

    <p class="mt-5 text-center text-xs text-on-surface-variant mb-0">
        Chưa nhận được mã?
        <a class="font-semibold text-primary-container hover:text-primary text-decoration-none ml-1"
           href="${pageContext.request.contextPath}/auth/register">
            Đăng ký lại để nhận mã mới
        </a>
    </p>
</div>

<script>
    (function () {
        const digits = Array.from(document.querySelectorAll('.otp-digit'));
        const hiddenOtp = document.getElementById('otp');
        const form = document.getElementById('otpForm');

        function syncOtp() {
            hiddenOtp.value = digits.map(d => d.value.replace(/\D/g, '')).join('');
        }

        digits.forEach((input, idx) => {
            input.addEventListener('input', (e) => {
                e.target.value = e.target.value.replace(/\D/g, '').slice(0, 1);
                syncOtp();
                if (e.target.value && idx < digits.length - 1) {
                    digits[idx + 1].focus();
                }
            });
            input.addEventListener('keydown', (e) => {
                if (e.key === 'Backspace' && !e.target.value && idx > 0) {
                    digits[idx - 1].focus();
                }
            });
            input.addEventListener('paste', (e) => {
                e.preventDefault();
                const pasted = (e.clipboardData || window.clipboardData).getData('text').replace(/\D/g, '').slice(0, 6);
                pasted.split('').forEach((ch, i) => {
                    if (digits[i]) digits[i].value = ch;
                });
                syncOtp();
                if (pasted.length > 0) {
                    digits[Math.min(pasted.length, digits.length - 1)].focus();
                }
            });
        });

        let submitting = false;
        form.addEventListener('submit', (e) => {
            syncOtp();
            if (hiddenOtp.value.length !== 6 || submitting) {
                e.preventDefault();
                if (!submitting) digits[0].focus();
                return;
            }
            submitting = true;
            const btn = form.querySelector('button[type="submit"]');
            if (btn) btn.disabled = true;
        });
    })();
</script>
</body>
</html>
