<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property="title" default="TechCommerce - Hệ thống bán lẻ công nghệ"/></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
    <c:if test="${not empty _csrf}">
        <meta name="_csrf" content="${_csrf.token}"/>
        <meta name="_csrf_header" content="${_csrf.headerName}"/>
    </c:if>
    <sitemesh:write property="head"/>
</head>
<body class="d-flex flex-column min-vh-100 bg-light">
<header class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/">
            <i class="bi bi-cpu-fill text-info"></i>
            <span>TechCommerce</span>
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNavbar"
                aria-controls="mainNavbar" aria-expanded="false" aria-label="Mở menu">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="mainNavbar">
            <!-- Chọn chi nhánh -->
            <div class="dropdown me-lg-3 my-2 my-lg-0">
                <button class="btn btn-outline-info btn-sm dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="bi bi-shop me-1"></i>
                    <span><c:out value="${not empty currentStore ? currentStore.name : 'Toàn hệ thống'}"/></span>
                </button>
                <ul class="dropdown-menu">
                    <c:forEach var="storeItem" items="${activeStores}">
                        <li>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/stores/select?storeId=${storeItem.id}">
                                <c:out value="${storeItem.name}"/> (<c:out value="${storeItem.city}"/>)
                            </a>
                        </li>
                    </c:forEach>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/stores">Xem tất cả chi nhánh</a></li>
                </ul>
            </div>

            <!-- Ô tìm kiếm không dấu + gợi ý nhanh -->
            <form class="d-flex flex-grow-1 position-relative me-lg-3 my-2 my-lg-0" action="${pageContext.request.contextPath}/products" method="get">
                <div class="input-group input-group-sm">
                    <input id="search-input" class="form-control" type="search" name="q"
                           placeholder="Tìm điện thoại, laptop, phụ kiện (hỗ trợ không dấu)..."
                           value="<c:out value='${param.q}'/>" autocomplete="off">
                    <button class="btn btn-info" type="submit"><i class="bi bi-search"></i></button>
                </div>
                <div id="search-suggestions" class="list-group position-absolute w-100 top-100 mt-1 shadow d-none" style="z-index: 1050;"></div>
            </form>

            <!-- Tiện ích mua sắm & Tài khoản -->
            <ul class="navbar-nav ms-auto align-items-lg-center gap-lg-2">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/compare" title="So sánh cấu hình">
                        <i class="bi bi-arrow-left-right"></i> <span class="d-lg-none">So sánh</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/wishlist" title="Danh sách yêu thích">
                        <i class="bi bi-heart"></i> <span class="d-lg-none">Yêu thích</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link position-relative" href="${pageContext.request.contextPath}/cart" title="Giỏ hàng">
                        <i class="bi bi-cart3"></i>
                        <span id="cart-badge" class="badge rounded-pill bg-info text-dark"><c:out value="${cartCount != null ? cartCount : 0}"/></span>
                    </a>
                </li>

                <c:choose>
                    <c:when test="${not empty currentUser}">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="bi bi-person-circle me-1"></i><c:out value="${currentUser.fullName}"/>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <c:if test="${currentUser.role == 'ADMIN' || currentUser.role == 'STAFF'}">
                                    <li><a class="dropdown-item fw-semibold text-primary" href="${pageContext.request.contextPath}/admin/dashboard">Khu vực quản trị</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                </c:if>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">Hồ sơ & Sổ địa chỉ</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/orders">Đơn hàng của tôi</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <form action="${pageContext.request.contextPath}/auth/logout" method="post" class="px-3 py-1">
                                        <c:if test="${not empty _csrf}">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                        </c:if>
                                        <button type="submit" class="btn btn-sm btn-outline-danger w-100">Đăng xuất</button>
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
                            <a class="btn btn-sm btn-info text-dark fw-semibold" href="${pageContext.request.contextPath}/auth/register">Đăng ký</a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</header>

<main class="flex-grow-1 py-4">
    <div class="container">
        <sitemesh:write property="body"/>
    </div>
</main>

<footer class="bg-dark text-light py-4 mt-auto border-top">
    <div class="container d-flex flex-column flex-md-row justify-content-between align-items-center small">
        <div>
            <strong>TechCommerce</strong> — Hệ thống chuỗi cửa hàng bán lẻ thiết bị công nghệ
        </div>
        <div class="mt-2 mt-md-0">
            <a href="${pageContext.request.contextPath}/stores" class="text-info text-decoration-none me-3">Hệ thống chi nhánh</a>
            <span class="text-secondary">techcommerce.store</span>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
