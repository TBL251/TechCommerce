<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title><c:out value="${appName}"/> - Trang chủ</title>
</head>
<body>
<main class="container py-5">
    <div class="p-4 p-md-5 mb-4 rounded-3 bg-white shadow-sm border">
        <span class="badge bg-primary mb-2">Hệ thống Thương mại Điện tử Đa chi nhánh</span>
        <h1 id="health-title" class="display-6 fw-bold"><c:out value="${appName}"/> - OK</h1>
        <p class="lead text-secondary mb-4">
            Nền tảng mua sắm thiết bị công nghệ với xác thực JWT HttpOnly Cookie, Google OAuth2 và phân quyền đa chi nhánh (Hà Nội, TP.HCM, Đà Nẵng).
        </p>
        <div class="d-flex flex-wrap gap-2">
            <c:choose>
                <c:when test="${not empty currentUser}">
                    <a href="${pageContext.request.contextPath}/profile" class="btn btn-primary">
                        Hồ sơ &amp; Sổ địa chỉ (<c:out value="${currentUser.email}"/>)
                    </a>
                    <c:if test="${currentUser.role == 'ADMIN'}">
                        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-dark">
                            Quản trị Người dùng &amp; Chi nhánh
                        </a>
                    </c:if>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/auth/login" class="btn btn-primary">Đăng nhập</a>
                    <a href="${pageContext.request.contextPath}/auth/register" class="btn btn-outline-primary">Đăng ký tài khoản</a>
                    <a href="${pageContext.request.contextPath}/auth/forgot-password" class="btn btn-outline-secondary">Quên mật khẩu</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div class="row g-4">
        <div class="col-md-4">
            <div class="card h-100 shadow-sm border-0">
                <div class="card-body">
                    <h5 class="card-title fw-semibold">Chi nhánh Hà Nội (HN-01)</h5>
                    <p class="card-text text-secondary small mb-0">120 Cầu Giấy, Quận Cầu Giấy, Hà Nội</p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card h-100 shadow-sm border-0">
                <div class="card-body">
                    <h5 class="card-title fw-semibold">Chi nhánh TP.HCM (HCM-01)</h5>
                    <p class="card-text text-secondary small mb-0">268 Lý Thường Kiệt, Quận 10, TP.HCM</p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card h-100 shadow-sm border-0">
                <div class="card-body">
                    <h5 class="card-title fw-semibold">Chi nhánh Đà Nẵng (DN-01)</h5>
                    <p class="card-text text-secondary small mb-0">54 Nguyễn Lương Bằng, Quận Liên Chiểu, Đà Nẵng</p>
                </div>
            </div>
        </div>
    </div>
</main>
</body>
</html>
