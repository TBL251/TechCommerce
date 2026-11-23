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
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:ital,wght@0,400;0,500;0,600;0,700;1,400&family=JetBrains+Mono:wght@400;500;600&family=Public+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        "on-primary-fixed-variant": "#00419c",
                        "on-primary-fixed": "#001945",
                        "primary-fixed-dim": "#b0c6ff",
                        "secondary-fixed-dim": "#c1c6db",
                        "on-secondary-container": "#5e6476",
                        "secondary-fixed": "#dde2f8",
                        "tertiary-fixed-dim": "#68dba9",
                        "on-primary-container": "#bcceff",
                        "primary-fixed": "#d9e2ff",
                        "inverse-primary": "#b0c6ff",
                        "secondary-container": "#dde2f8",
                        "tertiary-container": "#006545",
                        "tertiary-fixed": "#85f8c4",
                        "secondary": "#585e70",
                        "on-secondary-fixed-variant": "#414658",
                        "surface-dim": "#d8dadc",
                        "surface-variant": "#e0e3e5",
                        "on-secondary-fixed": "#151b2b",
                        "tertiary": "#004b32",
                        "surface-bright": "#f7f9fb",
                        "surface-container-lowest": "#ffffff",
                        "on-tertiary-container": "#70e4b1",
                        "error": "#ba1a1a",
                        "background": "#f7f9fb",
                        "surface-tint": "#1d59c1",
                        "on-error-container": "#93000a",
                        "outline-variant": "#c3c6d5",
                        "surface-container-highest": "#e0e3e5",
                        "on-primary": "#ffffff",
                        "inverse-surface": "#2d3133",
                        "on-surface-variant": "#434653",
                        "on-tertiary-fixed": "#002114",
                        "primary-container": "#0f52ba",
                        "on-tertiary": "#ffffff",
                        "inverse-on-surface": "#eff1f3",
                        "on-error": "#ffffff",
                        "error-container": "#ffdad6",
                        "surface-container-high": "#e6e8ea",
                        "surface-container": "#eceef0",
                        "surface": "#f7f9fb",
                        "on-tertiary-fixed-variant": "#005137",
                        "on-background": "#191c1e",
                        "outline": "#737784",
                        "primary": "#003c90",
                        "on-surface": "#191c1e",
                        "on-secondary": "#ffffff",
                        "surface-container-low": "#f2f4f6"
                    },
                    fontFamily: {
                        headline: ["Be Vietnam Pro", "sans-serif"],
                        display: ["Be Vietnam Pro", "sans-serif"],
                        body: ["Be Vietnam Pro", "sans-serif"],
                        label: ["Public Sans", "sans-serif"],
                        mono: ["JetBrains Mono", "monospace"]
                    }
                }
            }
        };
    </script>
    <link href="${pageContext.request.contextPath}/assets/css/main.css?v=3.2" rel="stylesheet">
    <c:if test="${not empty _csrf}">
        <meta name="_csrf" content="${_csrf.token}"/>
        <meta name="_csrf_header" content="${_csrf.headerName}"/>
    </c:if>
    <sitemesh:write property="head"/>
</head>
<body class="bg-surface font-body text-on-surface min-h-screen flex flex-col antialiased">
<a href="#main-content" class="skip-link visually-hidden-focusable">Chuyển tới nội dung chính</a>

<!-- Top Navigation Bar (CellphoneS-style clean layout on TechCommerce Sapphire/Obsidian theme) -->
<header class="sticky top-0 left-0 right-0 w-full z-50 bg-[#0b1120] text-white border-b border-[#1e293b] shadow-md">
    <div class="h-16 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 flex items-center justify-between gap-3">
        <!-- 1. Brand Logo -->
        <a class="flex items-center gap-2 text-white text-decoration-none hover:opacity-95 transition-opacity shrink-0"
           href="${pageContext.request.contextPath}/" translate="no">
            <div class="w-9 h-9 rounded-xl bg-primary-container flex items-center justify-center text-white shadow-sm">
                <span class="material-symbols-outlined text-[20px]">memory</span>
            </div>
            <span class="text-lg font-headline font-bold tracking-tight text-white hidden sm:inline">TechCommerce</span>
        </a>

        <!-- 2. Nút "Danh mục" Dropdown -->
        <div class="dropdown shrink-0">
            <button class="h-10 px-3.5 rounded-xl bg-white/10 hover:bg-white/20 border border-white/10 text-white text-sm font-medium flex items-center gap-2 transition-colors"
                    type="button" data-bs-toggle="dropdown" aria-expanded="false">
                <span class="material-symbols-outlined text-[20px]">grid_view</span>
                <span>Danh mục</span>
                <span class="material-symbols-outlined text-[18px]">expand_more</span>
            </button>
            <ul class="dropdown-menu shadow-xl border border-slate-200 rounded-xl py-2 mt-2" style="min-width: 240px;">
                <li>
                    <a class="dropdown-item flex items-center gap-2.5 py-2 text-xs font-medium text-slate-700"
                       href="${pageContext.request.contextPath}/products?q=laptop">
                        <span class="material-symbols-outlined text-[18px] text-primary-container">laptop_mac</span>
                        <span>Laptop &amp; Workstation</span>
                    </a>
                </li>
                <li>
                    <a class="dropdown-item flex items-center gap-2.5 py-2 text-xs font-medium text-slate-700"
                       href="${pageContext.request.contextPath}/products?q=dien+thoai">
                        <span class="material-symbols-outlined text-[18px] text-primary-container">smartphone</span>
                        <span>Điện thoại &amp; Tablet</span>
                    </a>
                </li>
                <li>
                    <a class="dropdown-item flex items-center gap-2.5 py-2 text-xs font-medium text-slate-700"
                       href="${pageContext.request.contextPath}/products?q=linh+kien">
                        <span class="material-symbols-outlined text-[18px] text-primary-container">developer_board</span>
                        <span>Linh kiện &amp; PC</span>
                    </a>
                </li>
                <li>
                    <a class="dropdown-item flex items-center gap-2.5 py-2 text-xs font-medium text-slate-700"
                       href="${pageContext.request.contextPath}/products?q=man+hinh">
                        <span class="material-symbols-outlined text-[18px] text-primary-container">desktop_windows</span>
                        <span>Màn hình &amp; Phụ kiện</span>
                    </a>
                </li>
                <li><hr class="dropdown-divider my-1"></li>
                <li>
                    <a class="dropdown-item flex items-center gap-2.5 py-2 text-xs font-medium text-slate-700"
                       href="${pageContext.request.contextPath}/compare">
                        <span class="material-symbols-outlined text-[18px] text-slate-500">compare_arrows</span>
                        <span>So sánh cấu hình</span>
                    </a>
                </li>
                <li>
                    <a class="dropdown-item flex items-center gap-2.5 py-2 text-xs font-medium text-slate-700"
                       href="${pageContext.request.contextPath}/wishlist">
                        <span class="material-symbols-outlined text-[18px] text-slate-500">favorite</span>
                        <span>Sản phẩm yêu thích</span>
                    </a>
                </li>
            </ul>
        </div>

        <!-- 3. Nút Chọn Chi nhánh / Tỉnh thành -->
        <div class="dropdown shrink-0">
            <button class="h-10 px-3.5 rounded-xl bg-white/10 hover:bg-white/20 border border-white/10 text-white text-sm font-medium flex items-center gap-2 transition-colors"
                    type="button" data-bs-toggle="dropdown" aria-expanded="false" aria-label="Chọn chi nhánh mua sắm">
                <span class="material-symbols-outlined text-[20px]">location_on</span>
                <span class="truncate max-w-[140px]">
                    <c:choose>
                        <c:when test="${not empty currentStore}">
                            <c:out value="${currentStore.city}"/>
                        </c:when>
                        <c:otherwise>Toàn quốc</c:otherwise>
                    </c:choose>
                </span>
                <span class="material-symbols-outlined text-[18px]">expand_more</span>
            </button>
            <ul class="dropdown-menu shadow-xl border border-slate-200 rounded-xl py-2 mt-2" style="min-width: 240px;">
                <li>
                    <a class="dropdown-item flex items-center justify-between px-3 py-2 text-xs font-medium ${empty currentStore ? 'active' : 'text-slate-700'}"
                       href="${pageContext.request.contextPath}/stores/select?code=ALL">
                        <span>Toàn hệ thống</span>
                        <span class="font-mono text-[11px] opacity-75">ALL</span>
                    </a>
                </li>
                <c:forEach var="storeItem" items="${activeStores}">
                    <li>
                        <a class="dropdown-item flex items-center justify-between px-3 py-2 text-xs font-medium ${not empty currentStore and currentStore.id == storeItem.id ? 'active' : 'text-slate-700'}"
                           href="${pageContext.request.contextPath}/stores/select?storeId=${storeItem.id}">
                            <span><c:out value="${storeItem.city}"/> (<c:out value="${storeItem.name}"/>)</span>
                            <span class="font-mono text-[11px] opacity-75"><c:out value="${storeItem.code}"/></span>
                        </a>
                    </li>
                </c:forEach>
                <c:if test="${empty activeStores}">
                    <li><a class="dropdown-item text-xs py-2" href="${pageContext.request.contextPath}/stores/select?code=HN-01">Hà Nội (HN-01)</a></li>
                    <li><a class="dropdown-item text-xs py-2" href="${pageContext.request.contextPath}/stores/select?code=HCM-01">TP.HCM (HCM-01)</a></li>
                    <li><a class="dropdown-item text-xs py-2" href="${pageContext.request.contextPath}/stores/select?code=DN-01">Đà Nẵng (DN-01)</a></li>
                </c:if>
                <li><hr class="dropdown-divider my-1"></li>
                <li>
                    <a class="dropdown-item flex items-center justify-between px-3 py-2 text-xs font-semibold text-primary-container"
                       href="${pageContext.request.contextPath}/stores">
                        <span>Xem danh sách cửa hàng</span>
                        <span class="material-symbols-outlined text-[15px]">arrow_forward</span>
                    </a>
                </li>
            </ul>
        </div>

        <!-- 4. Ô tìm kiếm nền trắng rộng ở giữa ("Bạn muốn mua gì hôm nay?") -->
        <form class="flex-1 flex-grow-1 min-w-[200px] relative my-0"
              action="${pageContext.request.contextPath}/products" method="get" role="search">
            <div class="relative flex items-center w-full">
                <label for="search-input" class="visually-hidden">Bạn muốn mua gì hôm nay?</label>
                <button type="submit" aria-label="Tìm kiếm"
                        class="absolute left-3 text-slate-600 hover:text-primary-container flex items-center justify-center p-0 border-0 bg-transparent">
                    <span class="material-symbols-outlined text-[22px]">search</span>
                </button>
                <input id="search-input" name="q" type="search" autocomplete="off"
                       value="<c:out value='${param.q}'/>"
                       class="w-full h-10 pl-10 pr-4 rounded-xl bg-white text-sm text-slate-900 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-primary-container shadow-inner border-0"
                       placeholder="Bạn muốn mua gì hôm nay?">
            </div>
            <div id="search-suggestions" class="list-group position-absolute w-100 top-100 mt-1 shadow d-none" style="z-index: 1050;" aria-live="polite"></div>
        </form>

        <!-- 5. Giỏ hàng & Nút Đăng nhập / Tài khoản -->
        <div class="flex items-center gap-3 shrink-0">
            <a class="h-10 px-2.5 rounded-xl hover:bg-white/10 flex items-center gap-2 text-sm font-medium text-white text-decoration-none transition-colors"
               href="${pageContext.request.contextPath}/cart" aria-label="Giỏ hàng">
                <span class="hidden md:inline">Giỏ hàng</span>
                <div class="relative flex items-center">
                    <span class="material-symbols-outlined text-[23px]">shopping_cart</span>
                    <c:if test="${not empty cartCount and cartCount > 0}">
                        <span id="cart-badge" class="absolute -top-1.5 -right-2 bg-primary-container text-white font-mono text-[10px] font-bold h-4 min-w-[16px] px-1 rounded-full flex items-center justify-center">
                            <c:out value="${cartCount}"/>
                        </span>
                    </c:if>
                </div>
            </a>

            <c:choose>
                <c:when test="${not empty currentUser}">
                    <div class="dropdown">
                        <button class="h-10 px-3.5 rounded-xl bg-white/10 hover:bg-white/20 border border-white/10 text-white text-sm font-medium flex items-center gap-2 transition-colors"
                                type="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <span class="truncate max-w-[120px]"><c:out value="${currentUser.fullName}"/></span>
                            <span class="material-symbols-outlined text-[21px]">account_circle</span>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end shadow-xl border border-slate-200 rounded-xl mt-2 py-2" style="min-width: 230px;">
                            <li class="px-3 py-2 border-b border-slate-100">
                                <div class="font-semibold text-xs text-slate-900"><c:out value="${currentUser.fullName}"/></div>
                                <div class="text-slate-500 font-mono text-[11px] truncate"><c:out value="${currentUser.email}"/></div>
                            </li>
                            <c:if test="${currentUser.role == 'ADMIN' || currentUser.role == 'STAFF'}">
                                <li>
                                    <a class="dropdown-item flex items-center gap-2 py-2 text-xs font-semibold text-primary-container"
                                       href="${pageContext.request.contextPath}${currentUser.role == 'ADMIN' ? '/admin/users' : '/admin/dashboard'}">
                                        <span class="material-symbols-outlined text-[18px]">admin_panel_settings</span>
                                        <span>Trung tâm quản trị</span>
                                    </a>
                                </li>
                                <li><hr class="dropdown-divider my-1"></li>
                            </c:if>
                            <li>
                                <a class="dropdown-item flex items-center gap-2 py-2 text-xs text-slate-700"
                                   href="${pageContext.request.contextPath}/profile">
                                    <span class="material-symbols-outlined text-[18px] text-slate-400">badge</span>
                                    <span>Hồ sơ &amp; Sổ địa chỉ</span>
                                </a>
                            </li>
                            <li>
                                <a class="dropdown-item flex items-center gap-2 py-2 text-xs text-slate-700"
                                   href="${pageContext.request.contextPath}/orders">
                                    <span class="material-symbols-outlined text-[18px] text-slate-400">package_2</span>
                                    <span>Đơn hàng của tôi</span>
                                </a>
                            </li>
                            <li><hr class="dropdown-divider my-1"></li>
                            <li>
                                <form action="${pageContext.request.contextPath}/auth/logout" method="post" class="px-2 py-1">
                                    <c:if test="${not empty _csrf}">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                    </c:if>
                                    <button type="submit" class="w-full px-2.5 py-1.5 rounded-lg text-xs font-medium text-error hover:bg-error-container/40 flex items-center gap-2 border-0 bg-transparent">
                                        <span class="material-symbols-outlined text-[18px]">logout</span>
                                        <span>Đăng xuất</span>
                                    </button>
                                </form>
                            </li>
                        </ul>
                    </div>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/auth/login"
                       class="h-10 px-3.5 rounded-xl bg-white/10 hover:bg-white/20 border border-white/10 text-white text-sm font-medium flex items-center gap-2 text-decoration-none transition-colors">
                        <span>Đăng nhập</span>
                        <span class="material-symbols-outlined text-[21px]">account_circle</span>
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>

<main id="main-content" class="flex-1 w-full bg-surface">
    <sitemesh:write property="body"/>
</main>

<!-- Stitch Clean Dark Obsidian Footer -->
<footer class="w-full bg-[#0b1120] text-slate-300 border-t border-[#1e293b] py-6 mt-auto">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 flex flex-col sm:flex-row items-center justify-between gap-4 text-xs">
        <div class="flex items-center gap-2.5">
            <div class="w-7 h-7 rounded-md bg-primary-container flex items-center justify-center text-white">
                <span class="material-symbols-outlined text-[16px]">memory</span>
            </div>
            <span class="font-headline font-bold text-white" translate="no">TechCommerce</span>
            <span class="text-slate-400">· Hà Nội · TP.HCM · Đà Nẵng · 08:00 – 21:30</span>
        </div>
        <div class="flex flex-wrap items-center gap-5">
            <a href="${pageContext.request.contextPath}/" class="text-slate-300 hover:text-white text-decoration-none">Trang chủ</a>
            <a href="${pageContext.request.contextPath}/products" class="text-slate-300 hover:text-white text-decoration-none">Sản phẩm</a>
            <a href="${pageContext.request.contextPath}/stores" class="text-slate-300 hover:text-white text-decoration-none">Chi nhánh</a>
            <a href="${pageContext.request.contextPath}/orders" class="text-slate-300 hover:text-white text-decoration-none">Đơn hàng</a>
            <a href="${pageContext.request.contextPath}/profile" class="text-slate-300 hover:text-white text-decoration-none">Tài khoản</a>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
