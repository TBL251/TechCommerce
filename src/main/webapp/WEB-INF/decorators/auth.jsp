<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="theme-color" content="#f6f8fa">
    <title><sitemesh:write property="title" default="Xác thực tài khoản - TechCommerce"/></title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
    <sitemesh:write property="head"/>
</head>
<body class="tc-auth-shell d-flex flex-column min-vh-100">
<a href="#auth-main-content" class="skip-link">Chuyển tới biểu mẫu xác thực</a>

<header class="py-3 border-bottom bg-white">
    <div class="container d-flex justify-content-between align-items-center">
        <a href="${pageContext.request.contextPath}/" class="text-decoration-none text-dark fw-bold fs-5 d-flex align-items-center gap-2" translate="no">
            <span class="tc-brand-mark" aria-hidden="true"><i class="bi bi-cpu"></i></span>
            <span>TechCommerce</span>
        </a>
        <a href="${pageContext.request.contextPath}/" class="btn btn-sm btn-light border">
            <i class="bi bi-arrow-left" aria-hidden="true"></i>
            <span>Về trang chủ</span>
        </a>
    </div>
</header>

<main id="auth-main-content" class="container my-auto py-4 py-md-5">
    <div class="row justify-content-center">
        <div class="col-12 col-sm-10 col-md-8 col-lg-5">
            <div class="tc-auth-card p-4 p-md-5 tc-hero-enter">
                <sitemesh:write property="body"/>
            </div>
            <div class="text-center mt-3 small text-secondary">
                <i class="bi bi-shield-check text-success me-1" aria-hidden="true"></i>
                Bảo vệ bằng JWT HttpOnly Cookie, xoay vòng Refresh Token &amp; khóa chống dò mật khẩu
            </div>
        </div>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
