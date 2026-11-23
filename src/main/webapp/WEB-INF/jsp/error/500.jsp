<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>500 - Lỗi hệ thống</title>
</head>
<body>
<div class="max-w-md mx-auto py-16 px-4 text-center">
    <div class="rounded-2xl bg-surface-container-lowest p-8 shadow-md border border-surface-container-high">
        <span class="inline-flex px-2.5 py-1 rounded-full text-xs font-mono font-bold bg-surface-container text-on-surface-variant mb-3">500</span>
        <h1 class="text-xl font-headline font-bold text-on-surface mb-2">Đã xảy ra lỗi</h1>
        <p class="text-xs text-on-surface-variant mb-5">
            <c:out value="${not empty errorMessage ? errorMessage : 'Hệ thống đang bận, vui lòng thử lại sau.'}"/>
        </p>
        <a href="${pageContext.request.contextPath}/"
           class="inline-flex items-center justify-center gap-2 px-5 py-2.5 rounded-xl bg-primary-container hover:bg-primary text-on-primary text-xs font-semibold text-decoration-none transition-colors">
            <span>Về trang chủ</span>
        </a>
    </div>
</div>
</body>
</html>
