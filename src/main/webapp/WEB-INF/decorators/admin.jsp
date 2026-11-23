<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property="title" default="Quản trị hệ thống - TechCommerce"/></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
    <c:if test="${not empty _csrf}">
        <meta name="_csrf" content="${_csrf.token}"/>
        <meta name="_csrf_header" content="${_csrf.headerName}"/>
    </c:if>
    <sitemesh:write property="head"/>
</head>
<body class="bg-light">
<div class="d-flex min-vh-100">
    <!-- Sidebar quản trị phân quyền ADMIN / STAFF -->
    <aside class="bg-dark text-white p-3 d-flex flex-column" style="width: 260px; min-width: 260px;">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="text-white text-decoration-none fw-bold fs-5 mb-3 d-flex align-items-center gap-2">
            <i class="bi bi-cpu-fill text-info"></i>
            <span>TechCommerce Admin</span>
        </a>
        <c:if test="${not empty currentUser}">
            <div class="small text-secondary mb-3 pb-2 border-bottom border-secondary">
                <div><c:out value="${currentUser.fullName}"/> (<span class="badge bg-info text-dark"><c:out value="${currentUser.role}"/></span>)</div>
            </div>
        </c:if>

        <ul class="nav nav-pills flex-column gap-1 mb-auto small">
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link text-white">
                    <i class="bi bi-bar-chart-line me-2"></i>Thống kê & Doanh thu
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/orders" class="nav-link text-white">
                    <i class="bi bi-receipt me-2"></i>Quản lý đơn hàng
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/returns" class="nav-link text-white">
                    <i class="bi bi-arrow-return-left me-2"></i>Yêu cầu hoàn trả
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/inventory" class="nav-link text-white">
                    <i class="bi bi-boxes me-2"></i>Tồn kho chi nhánh
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/chat" class="nav-link text-white">
                    <i class="bi bi-chat-dots me-2"></i>Chat hỗ trợ
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/questions" class="nav-link text-white">
                    <i class="bi bi-question-circle me-2"></i>Hỏi đáp sản phẩm (Q&A)
                </a>
            </li>

            <c:if test="${empty currentUser || currentUser.role == 'ADMIN'}">
                <li class="text-uppercase text-secondary fw-bold mt-3 mb-1 px-2" style="font-size: 0.72rem;">Quản trị chuỗi (Admin)</li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/stores" class="nav-link text-white">
                        <i class="bi bi-shop me-2"></i>Chi nhánh cửa hàng
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/catalog" class="nav-link text-white">
                        <i class="bi bi-laptop me-2"></i>Danh mục & Sản phẩm
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/vouchers" class="nav-link text-white">
                        <i class="bi bi-ticket-perforated me-2"></i>Mã giảm giá
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/users" class="nav-link text-white">
                        <i class="bi bi-people me-2"></i>Nhân viên & Người dùng
                    </a>
                </li>
            </c:if>
        </ul>

        <div class="mt-3 pt-3 border-top border-secondary">
            <a href="${pageContext.request.contextPath}/" class="btn btn-sm btn-outline-info w-100 mb-2">
                <i class="bi bi-box-arrow-up-right me-1"></i>Xem trang bán hàng
            </a>
            <form action="${pageContext.request.contextPath}/auth/logout" method="post">
                <c:if test="${not empty _csrf}">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                </c:if>
                <button type="submit" class="btn btn-sm btn-outline-light w-100">Đăng xuất</button>
            </form>
        </div>
    </aside>

    <!-- Nội dung chính -->
    <div class="flex-grow-1 d-flex flex-column">
        <header class="bg-white border-bottom px-4 py-2 d-flex justify-content-between align-items-center">
            <span class="fw-semibold text-secondary">Bảng điều khiển chuỗi cửa hàng</span>
            <div class="d-flex align-items-center gap-3">
                <span id="admin-notification-bell" class="position-relative" title="Thông báo đơn hàng & hoàn trả realtime">
                    <i class="bi bi-bell fs-5"></i>
                </span>
            </div>
        </header>
        <main class="p-4 flex-grow-1">
            <sitemesh:write property="body"/>
        </main>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
