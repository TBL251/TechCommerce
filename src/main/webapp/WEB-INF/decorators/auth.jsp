<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property="title" default="Tài khoản - TechCommerce"/></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
    <sitemesh:write property="head"/>
</head>
<body class="bg-light d-flex flex-column min-vh-100">
<main class="container my-auto py-5">
    <div class="row justify-content-center">
        <div class="col-12 col-md-7 col-lg-5">
            <div class="text-center mb-4">
                <a href="${pageContext.request.contextPath}/" class="text-decoration-none text-dark fw-bold fs-3">
                    <i class="bi bi-cpu-fill text-info me-1"></i>TechCommerce
                </a>
                <p class="text-secondary small mb-0">Hệ thống chuỗi cửa hàng công nghệ</p>
            </div>
            <div class="card shadow-sm border-0">
                <div class="card-body p-4">
                    <sitemesh:write property="body"/>
                </div>
            </div>
        </div>
    </div>
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
