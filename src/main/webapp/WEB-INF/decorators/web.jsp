<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="theme-color" content="#0b1120">
    <title><sitemesh:write property="title" default="TechCommerce - Thiết bị công nghệ chính hãng"/></title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/main.css?v=3.1" rel="stylesheet">
    <c:if test="${not empty _csrf}">
        <meta name="_csrf" content="${_csrf.token}"/>
        <meta name="_csrf_header" content="${_csrf.headerName}"/>
    </c:if>
    <sitemesh:write property="head"/>
</head>
<body class="d-flex flex-column min-vh-100">
<a href="#main-content" class="skip-link visually-hidden-focusable">Chuyển tới nội dung chính</a>

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
            <!-- Bộ chọn chi nhánh -->
            <div class="dropdown me-lg-3 my-2 my-lg-0">
                <button class="tc-branch-pill dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false" aria-label="Chọn chi nhánh">
                    <span class="tc-status-dot" aria-hidden="true"></span>
                    <i class="bi bi-geo-alt-fill text-info" aria-hidden="true"></i>
                    <span><c:out value="${not empty currentStore ? currentStore.name : 'Toàn hệ thống'}"/></span>
                </button>
                <ul class="dropdown-menu dropdown-menu-dark shadow border-secondary mt-1">
                    <li>
                        <a class="dropdown-item d-flex justify-content-between align-items-center gap-3 ${empty currentStore ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/stores/select?code=ALL">
                            <span>Toàn hệ thống</span>
                            <span class="badge bg-secondary tc-mono">ALL</span>
                        </a>
                    </li>
                    <c:forEach var="storeItem" items="${activeStores}">
                        <li>
                            <a class="dropdown-item d-flex justify-content-between align-items-center gap-3 ${not empty currentStore and currentStore.id == storeItem.id ? 'active' : ''}"
                               href="${pageContext.request.contextPath}/stores/select?storeId=${storeItem.id}">
                                <span><c:out value="${storeItem.name}"/></span>
                                <span class="badge bg-secondary tc-mono"><c:out value="${storeItem.code}"/></span>
                            </a>
                        </li>
                    </c:forEach>
                    <c:if test="${empty activeStores}">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/stores/select?code=HN-01">TechCommerce Hà Nội <span class="tc-mono text-info ms-1">HN-01</span></a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/stores/select?code=HCM-01">TechCommerce TP.HCM <span class="tc-mono text-info ms-1">HCM-01</span></a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/stores/select?code=DN-01">TechCommerce Đà Nẵng <span class="tc-mono text-info ms-1">DN-01</span></a></li>
                    </c:if>
                    <li><hr class="dropdown-divider border-secondary"></li>
                    <li>
                        <a class="dropdown-item small text-info" href="${pageContext.request.contextPath}/stores">
                            <i class="bi bi-compass me-1" aria-hidden="true"></i>Danh sách chi nhánh
                        </a>
                    </li>
                </ul>
            </div>

            <!-- Tìm kiếm -->
            <form class="d-flex flex-grow-1 position-relative me-lg-3 my-2 my-lg-0"
                  action="${pageContext.request.contextPath}/products" method="get" role="search">
                <div class="input-group tc-search-group">
                    <label for="search-input" class="visually-hidden">Tìm kiếm sản phẩm</label>
                    <input id="search-input" class="form-control" type="search" name="q"
                           placeholder="Tìm laptop, điện thoại, linh kiện…"
                           value="<c:out value='${param.q}'/>" autocomplete="off">
                    <button class="btn btn-primary px-3" type="submit" aria-label="Tìm kiếm">
                        <i class="bi bi-search" aria-hidden="true"></i>
                    </button>
                </div>
                <div id="search-suggestions" class="list-group position-absolute w-100 top-100 mt-1 shadow d-none" style="z-index: 1050;" aria-live="polite"></div>
            </form>

            <!-- Tiện ích & Tài khoản -->
            <ul class="navbar-nav ms-auto align-items-lg-center gap-1">
                <li class="nav-item">
                    <a class="tc-nav-action" href="${pageContext.request.contextPath}/compare">
                        <i class="bi bi-sliders2" aria-hidden="true"></i>
                        <span class="d-lg-none d-xl-inline">So sánh</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="tc-nav-action" href="${pageContext.request.contextPath}/wishlist">
                        <i class="bi bi-heart" aria-hidden="true"></i>
                        <span class="d-lg-none d-xl-inline">Yêu thích</span>
                    </a>
                </li>
                <li class="nav-item me-lg-2">
                    <a class="tc-nav-action position-relative" href="${pageContext.request.contextPath}/cart">
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
                                <i class="bi bi-person-circle text-info" aria-hidden="true"></i>
                                <span class="text-truncate" style="max-width: 140px;"><c:out value="${currentUser.fullName}"/></span>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-2">
                                <li class="px-3 py-2 border-bottom">
                                    <div class="fw-semibold small text-dark"><c:out value="${currentUser.fullName}"/></div>
                                    <div class="text-secondary tc-mono text-truncate" style="font-size: 0.75rem;"><c:out value="${currentUser.email}"/></div>
                                </li>
                                <c:if test="${currentUser.role == 'ADMIN' || currentUser.role == 'STAFF'}">
                                    <li>
                                        <a class="dropdown-item fw-semibold text-primary py-2" href="${pageContext.request.contextPath}/admin/users">
                                            <i class="bi bi-shield-lock me-2" aria-hidden="true"></i>Trang quản trị
                                        </a>
                                    </li>
                                    <li><hr class="dropdown-divider my-1"></li>
                                </c:if>
                                <li>
                                    <a class="dropdown-item py-2" href="${pageContext.request.contextPath}/profile">
                                        <i class="bi bi-person-vcard me-2 text-secondary" aria-hidden="true"></i>Tài khoản &amp; Địa chỉ
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item py-2" href="${pageContext.request.contextPath}/orders">
                                        <i class="bi bi-box-seam me-2 text-secondary" aria-hidden="true"></i>Đơn hàng
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

<footer class="tc-header text-light py-3 mt-auto">
    <div class="container d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-2 small">
        <div class="d-flex align-items-center gap-2">
            <span class="fw-bold" translate="no">TechCommerce</span>
            <span class="text-secondary">· Hà Nội · TP.HCM · Đà Nẵng · 08:00 – 21:30</span>
        </div>
        <div class="d-flex flex-wrap gap-3">
            <a href="${pageContext.request.contextPath}/" class="text-light text-decoration-none">Trang chủ</a>
            <a href="${pageContext.request.contextPath}/products" class="text-light text-decoration-none">Sản phẩm</a>
            <a href="${pageContext.request.contextPath}/stores" class="text-light text-decoration-none">Chi nhánh</a>
            <a href="${pageContext.request.contextPath}/orders" class="text-light text-decoration-none">Đơn hàng</a>
            <a href="${pageContext.request.contextPath}/profile" class="text-light text-decoration-none">Tài khoản</a>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
