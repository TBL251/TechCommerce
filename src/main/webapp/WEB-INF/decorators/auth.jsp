<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="theme-color" content="#f7f9fb">
    <title><sitemesh:write property="title" default="Tài khoản - TechCommerce"/></title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&family=Public+Sans:wght@400;500;600&display=swap" rel="stylesheet">
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
                        "on-primary-fixed": "#001945",
                        "tertiary-container": "#006545",
                        "secondary-container": "#dde2f8",
                        "secondary-fixed-dim": "#c1c6db",
                        "secondary": "#585e70",
                        "on-primary-fixed-variant": "#00419c",
                        "on-tertiary-fixed": "#002114",
                        "on-primary": "#ffffff",
                        "on-secondary-fixed": "#151b2b",
                        "surface-bright": "#f7f9fb",
                        "surface-variant": "#e0e3e5",
                        "surface-container-highest": "#e0e3e5",
                        "tertiary": "#004b32",
                        "on-primary-container": "#bcceff",
                        "inverse-primary": "#b0c6ff",
                        "inverse-surface": "#2d3133",
                        "surface-container-high": "#e6e8ea",
                        "error-container": "#ffdad6",
                        "primary-container": "#0f52ba",
                        "on-tertiary-fixed-variant": "#005137",
                        "on-surface": "#191c1e",
                        "error": "#ba1a1a",
                        "surface-tint": "#1d59c1",
                        "surface-container-low": "#f2f4f6",
                        "inverse-on-surface": "#eff1f3",
                        "surface-container": "#eceef0",
                        "secondary-fixed": "#dde2f8",
                        "surface": "#f7f9fb",
                        "on-tertiary": "#ffffff",
                        "on-error-container": "#93000a",
                        "primary-fixed-dim": "#b0c6ff",
                        "on-secondary-container": "#5e6476",
                        "surface-container-lowest": "#ffffff",
                        "primary": "#003c90",
                        "outline": "#737784",
                        "tertiary-fixed": "#85f8c4",
                        "outline-variant": "#c3c6d5",
                        "primary-fixed": "#d9e2ff",
                        "on-tertiary-container": "#70e4b1",
                        "on-error": "#ffffff",
                        "on-secondary-fixed-variant": "#414658",
                        "on-secondary": "#ffffff",
                        "tertiary-fixed-dim": "#68dba9",
                        "surface-dim": "#d8dadc",
                        "background": "#f7f9fb",
                        "on-surface-variant": "#434653",
                        "on-background": "#191c1e"
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
    <sitemesh:write property="head"/>
</head>
<body class="bg-surface font-body text-on-surface min-h-screen flex flex-col antialiased">
<a href="#auth-main-content" class="skip-link visually-hidden-focusable">Chuyển tới biểu mẫu</a>

<!-- Stitch Minimal Glass Header -->
<header class="sticky top-0 w-full z-50 bg-surface-container-lowest/90 backdrop-blur-xl border-b border-surface-container-high">
    <div class="h-16 max-w-7xl mx-auto px-6 lg:px-12 flex items-center justify-between">
        <a class="flex items-center gap-2.5 text-on-surface text-decoration-none" href="${pageContext.request.contextPath}/" translate="no">
            <div class="w-9 h-9 rounded-lg bg-primary-container flex items-center justify-center text-white shadow-sm">
                <span class="material-symbols-outlined text-[20px]">memory</span>
            </div>
            <span class="text-lg font-headline font-bold tracking-tight text-on-surface">TechCommerce</span>
        </a>
        <a class="inline-flex items-center gap-1.5 px-4 py-2 rounded-lg text-xs font-semibold text-on-surface-variant hover:bg-surface-container-low hover:text-on-surface text-decoration-none transition-colors"
           href="${pageContext.request.contextPath}/">
            <span class="material-symbols-outlined text-[18px]">arrow_back</span>
            <span>Về trang chủ</span>
        </a>
    </div>
</header>

<main id="auth-main-content" class="w-full flex-1 flex items-center justify-center bg-surface px-4 sm:px-6 py-10 relative overflow-hidden">
    <div class="absolute -top-24 -left-24 w-80 h-80 bg-primary-fixed/30 rounded-full blur-3xl pointer-events-none"></div>
    <div class="absolute -bottom-24 -right-24 w-80 h-80 bg-tertiary-fixed/25 rounded-full blur-3xl pointer-events-none"></div>

    <div class="w-full max-w-md mx-auto relative z-10">
        <div class="relative overflow-hidden rounded-2xl bg-surface-container-lowest shadow-xl border border-surface-container-high p-6 sm:p-8">
            <div class="pointer-events-none absolute -top-20 -right-20 w-44 h-44 rounded-full bg-primary-fixed/40 blur-3xl"></div>
            <sitemesh:write property="body"/>
        </div>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
