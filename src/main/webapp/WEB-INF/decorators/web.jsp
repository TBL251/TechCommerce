<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="theme-color" content="#0b1120">
    <title><sitemesh:write property="title" default="TechCommerce - Hệ thống bán lẻ thiết bị công nghệ đa chi nhánh"/></title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
    <c:if test="${not empty _csrf}">
        <meta name="_csrf" content="${_csrf.token}"/>
        <meta name="_csrf_header" content="${_csrf.headerName}"/>
    </c:if>
    <sitemesh:write property="head"/>
</head>
<body class="d-flex flex-column min-vh-100">
<a href="#main-content" class="skip-link">Chuyển tới nội dung chính</a>

<!-- Thanh thông tin chi nhánh & cam kết dịch vụ -->
<div class="tc-topbar py-1 d-none d-md-block">
    <div class="container d-flex justify-content-between align-items-center">
        <div class="d-flex align-items-center gap-3">
            <span><i class="bi bi-geo-alt-fill text-info me-1" aria-hidden="true"></i>Hệ thống 3 chi nhánh: <strong class="text-white">Hà Nội · TP.HCM · Đà Nẵng</strong></span>
            <span class="text-secondary">|</span>
            <span><i class="bi bi-arrow-repeat text-success me-1" aria-hidden="true"></i>Đổi trả miễn phí trong 7 ngày</span>
        </div>
        <div class="d-flex align-items-center gap-3">
            <a href="${pageContext.request.contextPath}/stores" class="text-decoration-none text-light">Tra cứu tồn kho chi nhánh</a>
            <span class="text-secondary">|</span>
            <span class="tc-mono text-info" translate="no">techcommerce.store</span>
        </div>
    </div>
</div>

<!-- Thanh điều hướng chính -->
<header class="navbar navbar-expand-lg navbar-dark tc-header sticky-top shadow-sm py-2">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center gap-2 me-3" href="${pageContext.request.contextPath}/" translate="no">
            <span class="tc-brand-mark" aria-hidden="true"><i class="bi bi-cpu"></i></span>
            <span>TechCommerce</span>
        </a>

        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#mainNavbar"
                aria-controls="mainNavbar" aria-expanded="false" aria-label="Mở menu điều hướng">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="mainNavbar">
            <!-- Bộ chọn chi nhánh mua sắm -->
            <div class="dropdown me-lg-3 my-2 my-lg-0">
                <button class="tc-branch-pill dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false" aria-label="Chọn chi nhánh mua sắm">
                    <span class="tc-status-dot" aria-hidden="true"></span>
                    <i class="bi bi-shop text-info" aria-hidden="true"></i>
                    <span><c:out value="${not empty currentStore ? currentStore.name : 'Chi nhánh: Toàn hệ thống'}"/></span>
                </button>
                <ul class="dropdown-menu dropdown-menu-dark shadow border-secondary mt-1">
                    <li class="dropdown-header small text-secondary">Chọn điểm xem tồn kho &amp; nhận hàng</li>
                    <c:forEach var="storeItem" items="${activeStores}">
                        <li>
                            <a class="dropdown-item d-flex justify-content-between align-items-center gap-3"
                               href="${pageContext.request.contextPath}/stores/select?storeId=${storeItem.id}">
                                <span><c:out value="${storeItem.name}"/></span>
                                <span class="badge bg-secondary tc-mono"><c:out value="${storeItem.code}"/></span>
                            </a>
                        </li>
                    </c:forEach>
                    <c:if test="${empty activeStores}">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/?branch=HN-01">TechCommerce Hà Nội <span class="tc-mono text-info ms-1">HN-01</span></a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/?branch=HCM-01">TechCommerce TP.HCM <span class="tc-mono text-info ms-1">HCM-01</span></a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/?branch=DN-01">TechCommerce Đà Nẵng <span class="tc-mono text-info ms-1">DN-01</span></a></li>
                    </c:if>
                    <li><hr class="dropdown-divider border-secondary"></li>
                    <li>
                        <a class="dropdown-item small text-info" href="${pageContext.request.contextPath}/stores">
                            <i class="bi bi-compass me-1" aria-hidden="true"></i>Xem địa chỉ &amp; giờ mở cửa
                        </a>
                    </li>
                </ul>
            </div>

            <!-- Ô tìm kiếm tiếng Việt không dấu -->
            <form class="d-flex flex-grow-1 position-relative me-lg-3 my-2 my-lg-0"
                  action="${pageContext.request.contextPath}/products" method="get" role="search">
                <div class="input-group tc-search-group">
                    <label for="search-input" class="visually-hidden">Tìm kiếm sản phẩm công nghệ</label>
                    <input id="search-input" class="form-control" type="search" name="q"
                           placeholder="Tìm laptop, điện thoại, linh kiện theo chi nhánh…"
                           value="<c:out value='${param.q}'/>" autocomplete="off">
                    <button class="btn btn-primary px-3" type="submit" aria-label="Tìm kiếm">
                        <i class="bi bi-search" aria-hidden="true"></i>
                    </button>
                </div>
                <div id="search-suggestions" class="list-group position-absolute w-100 top-100 mt-1 shadow d-none" style="z-index: 1050;" aria-live="polite"></div>
            </form>

            <!-- Tiện ích mua sắm & Tài khoản -->
            <ul class="navbar-nav ms-auto align-items-lg-center gap-1">
                <li class="nav-item">
                    <a class="tc-nav-action" href="${pageContext.request.contextPath}/compare" aria-label="So sánh cấu hình sản phẩm">
                        <i class="bi bi-sliders2" aria-hidden="true"></i>
                        <span class="d-lg-none d-xl-inline">So sánh</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="tc-nav-action" href="${pageContext.request.contextPath}/wishlist" aria-label="Danh sách sản phẩm yêu thích">
                        <i class="bi bi-heart" aria-hidden="true"></i>
                        <span class="d-lg-none d-xl-inline">Yêu thích</span>
                    </a>
                </li>
                <li class="nav-item me-lg-2">
                    <a class="tc-nav-action position-relative" href="${pageContext.request.contextPath}/cart" aria-label="Giỏ hàng của bạn">
                        <i class="bi bi-bag-check" aria-hidden="true"></i>
                        <span>Giỏ hàng</span>
                        <span id="cart-badge" class="badge rounded-pill bg-primary tc-tabular" aria-live="polite">
                            <c:out value="${cartCount != null ? cartCount : 0}"/>
                        </span>
                    </a>
                </li>

                <c:choose>
                    <c:when test="${not empty currentUser}">
                        <li class="nav-item dropdown">
                            <button class="btn btn-sm btn-outline-light dropdown-toggle d-flex align-items-center gap-2"
                                    type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="bi bi-person-check-fill text-info" aria-hidden="true"></i>
                                <span class="text-truncate" style="max-width: 150px;"><c:out value="${currentUser.fullName}"/></span>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-2">
                                <li class="px-3 py-2 border-bottom">
                                    <div class="fw-semibold small text-dark"><c:out value="${currentUser.fullName}"/></div>
                                    <div class="text-secondary" style="font-size: 0.76rem;"><c:out value="${currentUser.email}"/></div>
                                    <span class="tc-badge tc-badge-primary mt-1"><c:out value="${currentUser.role}"/></span>
                                </li>
                                <c:if test="${currentUser.role == 'ADMIN' || currentUser.role == 'STAFF'}">
                                    <li>
                                        <a class="dropdown-item fw-semibold text-primary py-2" href="${pageContext.request.contextPath}/admin/users">
                                            <i class="bi bi-shield-lock me-2" aria-hidden="true"></i>Bảng điều khiển quản trị
                                        </a>
                                    </li>
                                    <li><hr class="dropdown-divider my-1"></li>
                                </c:if>
                                <li>
                                    <a class="dropdown-item py-2" href="${pageContext.request.contextPath}/profile">
                                        <i class="bi bi-person-vcard me-2 text-secondary" aria-hidden="true"></i>Hồ sơ &amp; Sổ địa chỉ
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item py-2" href="${pageContext.request.contextPath}/orders">
                                        <i class="bi bi-box-seam me-2 text-secondary" aria-hidden="true"></i>Đơn hàng &amp; Đổi trả
                                    </a>
                                </li>
                                <li><hr class="dropdown-divider my-1"></li>
                                <li>
                                    <form action="${pageContext.request.contextPath}/auth/logout" method="post" class="px-2 py-1">
                                        <c:if test="${not empty _csrf}">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                        </c:if>
                                        <button type="submit" class="btn btn-sm btn-outline-danger w-100 justify-content-start">
                                            <i class="bi bi-box-arrow-right me-2" aria-hidden="true"></i>Đăng xuất
                                        </button>
                                    </form>
                                </li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item">
                            <a class="btn btn-sm btn-outline-light" href="${pageContext.request.contextPath}/auth/login">Đăng nhập</a>
                        </li>
                        <li class="nav-item">
                            <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/auth/register">Đăng ký</a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</header>

<main id="main-content" class="flex-grow-1 py-4">
    <div class="container">
        <sitemesh:write property="body"/>
    </div>
</main>

<footer class="tc-header text-light py-4 mt-auto">
    <div class="container">
        <div class="row g-4 align-items-center">
            <div class="col-md-6">
                <div class="d-flex align-items-center gap-2 fw-bold mb-1" translate="no">
                    <span class="tc-brand-mark" style="width: 26px; height: 26px; font-size: 0.85rem;" aria-hidden="true"><i class="bi bi-cpu"></i></span>
                    <span>TechCommerce</span>
                </div>
                <p class="text-secondary small mb-0">
                    Nền tảng thương mại điện tử thiết bị công nghệ đa chi nhánh. Đồng bộ tồn kho thời gian thực tại Hà Nội, TP.HCM và Đà Nẵng.
                </p>
            </div>
            <div class="col-md-6 text-md-end small">
                <div class="d-flex flex-wrap justify-content-md-end gap-3 mb-1">
                    <a href="${pageContext.request.contextPath}/" class="text-light text-decoration-none">Trang chủ</a>
                    <a href="${pageContext.request.contextPath}/profile" class="text-light text-decoration-none">Sổ địa chỉ</a>
                    <a href="${pageContext.request.contextPath}/auth/login" class="text-light text-decoration-none">Tài khoản</a>
                    <a href="${pageContext.request.contextPath}/api/health" class="text-info text-decoration-none tc-mono">Trạng thái hệ thống: UP</a>
                </div>
                <div class="text-secondary">
                    Triển khai qua Cloudflare Named Tunnel &amp; Supabase PostgreSQL · <span class="tc-mono" translate="no">https://techcommerce.store</span>
                </div>
            </div>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
