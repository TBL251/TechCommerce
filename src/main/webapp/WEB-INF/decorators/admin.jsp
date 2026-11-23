<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="theme-color" content="#0b1120">
    <title><sitemesh:write property="title" default="Quản trị hệ thống - TechCommerce"/></title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/main.css?v=3.0" rel="stylesheet">
    <c:if test="${not empty _csrf}">
        <meta name="_csrf" content="${_csrf.token}"/>
        <meta name="_csrf_header" content="${_csrf.headerName}"/>
    </c:if>
    <sitemesh:write property="head"/>
</head>
<body>
<a href="#admin-main-content" class="skip-link visually-hidden-focusable">Chuyển tới vùng làm việc chính</a>

<div class="d-flex min-vh-100">
    <!-- Sidebar quản trị trên màn hình lớn (Desktop Obsidian Shell) -->
    <aside class="tc-admin-sidebar text-white p-3 d-none d-lg-flex flex-column">
        <a href="${pageContext.request.contextPath}/admin/users" class="text-white text-decoration-none fw-bold fs-5 mb-3 d-flex align-items-center gap-2" translate="no">
            <span class="tc-brand-mark" aria-hidden="true"><i class="bi bi-cpu"></i></span>
            <div>
                <div class="lh-1">TechCommerce</div>
                <small class="text-info fw-normal" style="font-size: 0.72rem;">Trung tâm vận hành đa chi nhánh</small>
            </div>
        </a>

        <c:if test="${not empty currentUser}">
            <div class="p-3 rounded-3 mb-3" style="background-color: var(--tc-dark-surface); border: 1px solid var(--tc-dark-border);">
                <div class="d-flex align-items-center gap-2 mb-1">
                    <span class="tc-status-dot" aria-hidden="true"></span>
                    <div class="fw-semibold small text-white text-truncate"><c:out value="${currentUser.fullName}"/></div>
                </div>
                <div class="text-secondary tc-mono text-truncate" style="font-size: 0.73rem;"><c:out value="${currentUser.email}"/></div>
                <div class="d-flex align-items-center gap-2 mt-2">
                    <span class="badge bg-primary" style="font-size: 0.7rem;"><c:out value="${currentUser.role}"/></span>
                    <c:choose>
                        <c:when test="${not empty currentUser.storeId}">
                            <span class="badge bg-dark border border-secondary tc-mono" style="font-size: 0.7rem;">Chi nhánh #<c:out value="${currentUser.storeId}"/></span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-dark border border-secondary tc-mono" style="font-size: 0.7rem;">Toàn chuỗi HQ</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </c:if>

        <div class="tc-admin-section-label">Vận hành chi nhánh</div>
        <ul class="nav flex-column tc-admin-nav gap-1">
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link">
                    <i class="bi bi-graph-up-arrow" aria-hidden="true"></i><span>Báo cáo &amp; Doanh thu</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/orders" class="nav-link">
                    <i class="bi bi-receipt-cutoff" aria-hidden="true"></i><span>Đơn hàng chi nhánh</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/returns" class="nav-link">
                    <i class="bi bi-arrow-return-left" aria-hidden="true"></i><span>Yêu cầu đổi trả (7 ngày)</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/inventory" class="nav-link">
                    <i class="bi bi-boxes" aria-hidden="true"></i><span>Tồn kho biến thể SKU</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/chat" class="nav-link">
                    <i class="bi bi-chat-left-text" aria-hidden="true"></i><span>Chat hỗ trợ khách hàng</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/questions" class="nav-link">
                    <i class="bi bi-patch-question" aria-hidden="true"></i><span>Hỏi đáp sản phẩm (Q&amp;A)</span>
                </a>
            </li>
        </ul>

        <c:if test="${empty currentUser || currentUser.role == 'ADMIN'}">
            <div class="tc-admin-section-label mt-2">Quản trị toàn chuỗi (Admin)</div>
            <ul class="nav flex-column tc-admin-nav gap-1 mb-auto">
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/users" class="nav-link active">
                        <i class="bi bi-people-fill" aria-hidden="true"></i><span>Nhân sự &amp; Người dùng</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/stores" class="nav-link">
                        <i class="bi bi-shop-window" aria-hidden="true"></i><span>Hệ thống chi nhánh</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/catalog" class="nav-link">
                        <i class="bi bi-laptop" aria-hidden="true"></i><span>Danh mục &amp; Sản phẩm</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/vouchers" class="nav-link">
                        <i class="bi bi-ticket-perforated" aria-hidden="true"></i><span>Mã giảm giá (Voucher)</span>
                    </a>
                </li>
            </ul>
        </c:if>

        <div class="mt-auto pt-3 border-top border-secondary d-grid gap-2">
            <a href="${pageContext.request.contextPath}/" class="btn btn-sm btn-outline-info">
                <i class="bi bi-shop" aria-hidden="true"></i><span>Mở trang bán hàng</span>
            </a>
            <form action="${pageContext.request.contextPath}/auth/logout" method="post">
                <c:if test="${not empty _csrf}">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                </c:if>
                <button type="submit" class="btn btn-sm btn-outline-light w-100">
                    <i class="bi bi-box-arrow-right" aria-hidden="true"></i><span>Đăng xuất</span>
                </button>
            </form>
        </div>
    </aside>

    <!-- Nội dung chính -->
    <div class="flex-grow-1 d-flex flex-column min-w-0">
        <header class="bg-white border-bottom px-3 px-lg-4 py-2 d-flex justify-content-between align-items-center sticky-top shadow-xs">
            <div class="d-flex align-items-center gap-2">
                <a href="${pageContext.request.contextPath}/" class="btn btn-sm btn-light border d-lg-none" aria-label="Về trang chủ">
                    <i class="bi bi-house" aria-hidden="true"></i>
                </a>
                <span class="tc-status-dot d-none d-sm-inline-block" aria-hidden="true"></span>
                <span class="fw-semibold text-secondary small">Trung tâm điều hành chuỗi · <span class="tc-mono text-dark">HN-01 / HCM-01 / DN-01</span></span>
            </div>
            <div class="d-flex align-items-center gap-2">
                <a href="${pageContext.request.contextPath}/stores" class="btn btn-sm btn-light border d-none d-md-inline-flex">
                    <i class="bi bi-geo-alt text-primary" aria-hidden="true"></i>
                    <span>3 Showroom</span>
                </a>
                <span id="admin-notification-bell" class="btn btn-sm btn-light border position-relative" role="status" aria-label="Thông báo đơn hàng và hoàn trả theo thời gian thực">
                    <i class="bi bi-bell" aria-hidden="true"></i>
                    <span class="tc-status-dot ms-1" aria-hidden="true"></span>
                </span>
                <a href="${pageContext.request.contextPath}/profile" class="btn btn-sm btn-light border">
                    <i class="bi bi-person-gear" aria-hidden="true"></i>
                    <span class="d-none d-sm-inline">Hồ sơ cá nhân</span>
                </a>
            </div>
        </header>

        <main id="admin-main-content" class="p-3 p-lg-4 flex-grow-1">
            <sitemesh:write property="body"/>
        </main>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
