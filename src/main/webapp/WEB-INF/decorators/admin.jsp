<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html class="h-full" lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="theme-color" content="#0b1120">
    <title><sitemesh:write property="title" default="Quản trị hệ thống - TechCommerce"/></title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&family=Public+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
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
                        "secondary-fixed": "#dde2f8",
                        "outline": "#737784",
                        "surface-tint": "#1d59c1",
                        "error": "#ba1a1a",
                        "secondary": "#585e70",
                        "surface-container": "#eceef0",
                        "inverse-on-surface": "#eff1f3",
                        "tertiary-container": "#006545",
                        "on-primary-container": "#bcceff",
                        "on-surface-variant": "#434653",
                        "on-secondary-fixed-variant": "#414658",
                        "tertiary-fixed": "#85f8c4",
                        "primary-fixed-dim": "#b0c6ff",
                        "on-secondary-container": "#5e6476",
                        "on-primary": "#ffffff",
                        "on-tertiary": "#ffffff",
                        "surface": "#f7f9fb",
                        "surface-bright": "#f7f9fb",
                        "inverse-surface": "#0b1120",
                        "surface-container-lowest": "#ffffff",
                        "on-error-container": "#93000a",
                        "on-primary-fixed": "#001945",
                        "tertiary": "#004b32",
                        "on-tertiary-fixed-variant": "#005137",
                        "primary": "#003c90",
                        "tertiary-fixed-dim": "#68dba9",
                        "surface-variant": "#e0e3e5",
                        "on-tertiary-fixed": "#002114",
                        "on-tertiary-container": "#70e4b1",
                        "error-container": "#ffdad6",
                        "on-error": "#ffffff",
                        "surface-container-high": "#e6e8ea",
                        "background": "#f7f9fb",
                        "inverse-primary": "#b0c6ff",
                        "surface-container-highest": "#e0e3e5",
                        "outline-variant": "#c3c6d5",
                        "on-secondary-fixed": "#151b2b",
                        "on-background": "#191c1e",
                        "secondary-container": "#dde2f8",
                        "secondary-fixed-dim": "#c1c6db",
                        "on-surface": "#191c1e",
                        "surface-dim": "#d8dadc",
                        "primary-container": "#0f52ba",
                        "on-secondary": "#ffffff",
                        "primary-fixed": "#d9e2ff",
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
<body class="bg-surface font-body text-on-surface antialiased">
<a href="#admin-main-content" class="skip-link visually-hidden-focusable">Chuyển tới nội dung chính</a>

<!-- Stitch 272px Dark Obsidian Sidebar -->
<aside class="fixed left-0 top-0 h-full w-[272px] bg-[#0b1120] text-inverse-on-surface z-50 hidden lg:flex flex-col justify-between shadow-lg">
    <div class="flex flex-col flex-1 overflow-y-auto">
        <div class="p-5 pb-4">
            <a href="${pageContext.request.contextPath}/admin/users" class="flex items-center gap-3 text-decoration-none" translate="no">
                <div class="w-9 h-9 rounded-lg bg-primary-container text-on-primary flex items-center justify-center font-headline font-bold text-base shadow-sm">
                    <span class="material-symbols-outlined text-[20px]">memory</span>
                </div>
                <div>
                    <div class="font-headline font-bold tracking-tight text-white text-base leading-tight">TechCommerce</div>
                    <span class="inline-block px-1.5 py-0.5 mt-0.5 text-[10px] font-label font-medium bg-white/10 text-tertiary-fixed rounded uppercase tracking-wider">Quản trị hệ thống</span>
                </div>
            </a>
        </div>

        <c:if test="${not empty currentUser}">
            <div class="px-4 py-3 mx-4 mb-4 rounded-xl bg-white/5 border border-white/10">
                <div class="flex items-center gap-3">
                    <div class="relative shrink-0">
                        <div class="w-9 h-9 rounded-full bg-primary-container flex items-center justify-center text-on-primary font-semibold text-xs">
                            <span class="material-symbols-outlined text-[18px]">person</span>
                        </div>
                        <span class="absolute bottom-0 right-0 w-2.5 h-2.5 rounded-full bg-emerald-400 ring-2 ring-[#0b1120]"></span>
                    </div>
                    <div class="flex-1 min-w-0">
                        <div class="text-xs font-semibold text-white truncate"><c:out value="${currentUser.fullName}"/></div>
                        <div class="text-[11px] text-tertiary-fixed-dim font-mono"><c:out value="${currentUser.role}"/></div>
                    </div>
                </div>
            </div>
        </c:if>

        <nav class="flex-1 px-3 space-y-5">
            <div class="space-y-1">
                <div class="px-3 py-1 text-[11px] font-label font-semibold text-slate-400 uppercase tracking-wider">Vận hành chi nhánh</div>
                <a class="flex items-center gap-3 px-3 py-2 text-xs rounded-lg text-slate-300 hover:bg-white/10 hover:text-white text-decoration-none transition-colors"
                   href="${pageContext.request.contextPath}/admin/dashboard">
                    <span class="material-symbols-outlined text-[19px]">bar_chart</span>Báo cáo &amp; Doanh thu
                </a>
                <a class="flex items-center gap-3 px-3 py-2 text-xs rounded-lg text-slate-300 hover:bg-white/10 hover:text-white text-decoration-none transition-colors"
                   href="${pageContext.request.contextPath}/admin/orders">
                    <span class="material-symbols-outlined text-[19px]">receipt_long</span>Đơn hàng chi nhánh
                </a>
                <a class="flex items-center gap-3 px-3 py-2 text-xs rounded-lg text-slate-300 hover:bg-white/10 hover:text-white text-decoration-none transition-colors"
                   href="${pageContext.request.contextPath}/admin/returns">
                    <span class="material-symbols-outlined text-[19px]">assignment_return</span>Yêu cầu đổi trả
                </a>
                <a class="flex items-center gap-3 px-3 py-2 text-xs rounded-lg text-slate-300 hover:bg-white/10 hover:text-white text-decoration-none transition-colors"
                   href="${pageContext.request.contextPath}/admin/inventory">
                    <span class="material-symbols-outlined text-[19px]">inventory_2</span>Tồn kho SKU
                </a>
                <a class="flex items-center gap-3 px-3 py-2 text-xs rounded-lg text-slate-300 hover:bg-white/10 hover:text-white text-decoration-none transition-colors"
                   href="${pageContext.request.contextPath}/admin/chat">
                    <span class="material-symbols-outlined text-[19px]">chat_bubble</span>Chat hỗ trợ
                </a>
                <a class="flex items-center gap-3 px-3 py-2 text-xs rounded-lg text-slate-300 hover:bg-white/10 hover:text-white text-decoration-none transition-colors"
                   href="${pageContext.request.contextPath}/admin/questions">
                    <span class="material-symbols-outlined text-[19px]">quiz</span>Hỏi đáp Q&amp;A
                </a>
            </div>

            <c:if test="${empty currentUser || currentUser.role == 'ADMIN'}">
                <div class="space-y-1">
                    <div class="px-3 py-1 text-[11px] font-label font-semibold text-slate-400 uppercase tracking-wider">Quản trị toàn chuỗi</div>
                    <a class="flex items-center gap-3 px-3 py-2 text-xs rounded-lg bg-primary-container text-white font-semibold shadow-sm text-decoration-none transition-colors"
                       href="${pageContext.request.contextPath}/admin/users">
                        <span class="material-symbols-outlined text-[19px]">group</span>Nhân sự &amp; Người dùng
                    </a>
                    <a class="flex items-center gap-3 px-3 py-2 text-xs rounded-lg text-slate-300 hover:bg-white/10 hover:text-white text-decoration-none transition-colors"
                       href="${pageContext.request.contextPath}/admin/stores">
                        <span class="material-symbols-outlined text-[19px]">hub</span>Hệ thống chi nhánh
                    </a>
                    <a class="flex items-center gap-3 px-3 py-2 text-xs rounded-lg text-slate-300 hover:bg-white/10 hover:text-white text-decoration-none transition-colors"
                       href="${pageContext.request.contextPath}/admin/catalog">
                        <span class="material-symbols-outlined text-[19px]">category</span>Danh mục &amp; Sản phẩm
                    </a>
                    <a class="flex items-center gap-3 px-3 py-2 text-xs rounded-lg text-slate-300 hover:bg-white/10 hover:text-white text-decoration-none transition-colors"
                       href="${pageContext.request.contextPath}/admin/vouchers">
                        <span class="material-symbols-outlined text-[19px]">confirmation_number</span>Mã giảm giá
                    </a>
                </div>
            </c:if>
        </nav>
    </div>

    <div class="p-3 mx-3 mb-4 rounded-xl bg-white/5 space-y-1">
        <a class="flex items-center justify-between px-3 py-2 text-xs rounded-lg text-slate-300 hover:bg-white/10 hover:text-white text-decoration-none transition-colors"
           href="${pageContext.request.contextPath}/">
            <span>Mở trang bán hàng</span>
            <span class="material-symbols-outlined text-[17px]">open_in_new</span>
        </a>
        <form action="${pageContext.request.contextPath}/auth/logout" method="post">
            <c:if test="${not empty _csrf}">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            </c:if>
            <button type="submit" class="w-full flex items-center justify-between px-3 py-2 text-xs rounded-lg text-error-container hover:bg-error-container hover:text-on-error-container transition-colors border-0 bg-transparent">
                <span>Đăng xuất</span>
                <span class="material-symbols-outlined text-[17px]">logout</span>
            </button>
        </form>
    </div>
</aside>

<div class="lg:pl-[272px] min-h-screen flex flex-col">
    <header class="sticky top-0 h-16 bg-surface-container-lowest/90 backdrop-blur-xl z-40 border-b border-surface-container-high px-6 flex items-center justify-between">
        <div class="flex items-center gap-3">
            <a href="${pageContext.request.contextPath}/" class="lg:hidden inline-flex items-center justify-center w-9 h-9 rounded-lg bg-surface-container text-on-surface text-decoration-none">
                <span class="material-symbols-outlined text-[20px]">home</span>
            </a>
            <span class="text-sm font-headline font-semibold text-on-surface">Trung tâm quản trị</span>
        </div>
        <div class="flex items-center gap-3">
            <a href="${pageContext.request.contextPath}/profile"
               class="inline-flex items-center gap-2 px-3 py-1.5 rounded-lg bg-surface-container-low hover:bg-surface-container text-xs font-medium text-on-surface text-decoration-none transition-colors">
                <span class="material-symbols-outlined text-[18px] text-primary-container">person</span>
                <span>Tài khoản</span>
            </a>
        </div>
    </header>

    <main id="admin-main-content" class="flex-1 bg-surface p-6 md:p-8 max-w-[1400px] w-full mx-auto">
        <sitemesh:write property="body"/>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
