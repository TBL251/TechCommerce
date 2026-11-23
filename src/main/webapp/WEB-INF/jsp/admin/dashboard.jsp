<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Bảng điều khiển Vận hành Chi nhánh - TechCommerce</title>
</head>
<body>
<div class="space-y-6">
    <!-- Header Banner -->
    <section class="p-6 rounded-2xl bg-surface-container-lowest shadow-sm border border-surface-container-high flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div class="space-y-1">
            <div class="inline-flex items-center gap-2 px-2.5 py-1 rounded-full bg-primary-fixed text-primary text-[11px] font-mono font-bold">
                <span class="material-symbols-outlined text-[15px]">verified_user</span>
                <span>VAI TRÒ: <c:out value="${currentUser.role}"/></span>
            </div>
            <h1 class="text-2xl font-headline font-bold text-on-surface tracking-tight mb-0">
                Trung tâm Vận hành Chi nhánh
            </h1>
            <p class="text-xs text-on-surface-variant mb-0">
                Xin chào <strong><c:out value="${currentUser.fullName}"/></strong> (<span class="font-mono"><c:out value="${currentUser.email}"/></span>).
                <c:if test="${not empty currentUser.storeId}">
                    <c:forEach var="st" items="${stores}">
                        <c:if test="${st.id == currentUser.storeId}">
                            Chi nhánh phân công: <strong><c:out value="${st.code}"/> · <c:out value="${st.name}"/></strong> (<c:out value="${st.address}"/>).
                        </c:if>
                    </c:forEach>
                </c:if>
            </p>
        </div>

        <c:if test="${currentUser.role == 'ADMIN'}">
            <a href="${pageContext.request.contextPath}/admin/users"
               class="inline-flex items-center gap-2 px-4 py-2.5 rounded-xl bg-primary-container hover:bg-primary text-white text-xs font-semibold text-decoration-none shadow-sm transition-colors shrink-0">
                <span class="material-symbols-outlined text-[18px]">person_add</span>
                <span>Quản lý Nhân sự &amp; Cấp tài khoản STAFF</span>
            </a>
        </c:if>
    </section>

    <!-- Notice about STAFF account provisioning -->
    <div class="p-4 rounded-xl bg-surface-container-low border border-surface-container-high flex items-start gap-3">
        <span class="material-symbols-outlined text-primary-container text-[20px] shrink-0 mt-0.5">shield_person</span>
        <div class="text-xs text-on-surface-variant leading-relaxed">
            <strong class="text-on-surface">Quy định phân quyền tài khoản:</strong>
            Trang đăng ký công khai (<span class="font-mono">/auth/register</span>) và Google OAuth2 chỉ tạo tài khoản Khách hàng (<span class="font-mono">CUSTOMER</span>).
            Tài khoản Nhân viên chi nhánh (<span class="font-mono">STAFF</span>) chỉ được khởi tạo và gán chi nhánh trực tiếp bởi Quản trị viên hệ thống (<span class="font-mono">ADMIN</span>) tại mục Quản trị Nhân sự.
        </div>
    </div>

    <!-- Branch Operations Grid -->
    <section class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5">
        <a href="${pageContext.request.contextPath}/admin/orders"
           class="p-5 rounded-2xl bg-surface-container-lowest shadow-sm hover:shadow-md border border-surface-container-high text-decoration-none transition-all flex flex-col justify-between gap-3">
            <div class="flex items-center justify-between">
                <div class="w-10 h-10 rounded-xl bg-primary-fixed text-primary flex items-center justify-center">
                    <span class="material-symbols-outlined text-[22px]">receipt_long</span>
                </div>
                <span class="font-mono text-[11px] text-on-surface-variant">STAFF / ADMIN</span>
            </div>
            <div>
                <h2 class="text-base font-headline font-bold text-on-surface mb-1">Đơn hàng chi nhánh</h2>
                <p class="text-xs text-on-surface-variant mb-0">Tiếp nhận, xác nhận thanh toán và xử lý đơn nhận tại quầy 15 phút.</p>
            </div>
        </a>

        <a href="${pageContext.request.contextPath}/admin/inventory"
           class="p-5 rounded-2xl bg-surface-container-lowest shadow-sm hover:shadow-md border border-surface-container-high text-decoration-none transition-all flex flex-col justify-between gap-3">
            <div class="flex items-center justify-between">
                <div class="w-10 h-10 rounded-xl bg-tertiary-fixed text-on-tertiary-fixed flex items-center justify-center">
                    <span class="material-symbols-outlined text-[22px]">inventory_2</span>
                </div>
                <span class="font-mono text-[11px] text-on-surface-variant">STAFF / ADMIN</span>
            </div>
            <div>
                <h2 class="text-base font-headline font-bold text-on-surface mb-1">Tồn kho SKU chi nhánh</h2>
                <p class="text-xs text-on-surface-variant mb-0">Kiểm tra và cập nhật số lượng tồn kho thực tế tại showroom phụ trách.</p>
            </div>
        </a>

        <a href="${pageContext.request.contextPath}/admin/returns"
           class="p-5 rounded-2xl bg-surface-container-lowest shadow-sm hover:shadow-md border border-surface-container-high text-decoration-none transition-all flex flex-col justify-between gap-3">
            <div class="flex items-center justify-between">
                <div class="w-10 h-10 rounded-xl bg-secondary-container text-on-secondary-container flex items-center justify-center">
                    <span class="material-symbols-outlined text-[22px]">assignment_return</span>
                </div>
                <span class="font-mono text-[11px] text-on-surface-variant">STAFF / ADMIN</span>
            </div>
            <div>
                <h2 class="text-base font-headline font-bold text-on-surface mb-1">Yêu cầu đổi trả 7 ngày</h2>
                <p class="text-xs text-on-surface-variant mb-0">Thẩm định tình trạng thiết bị và duyệt yêu cầu đổi trả tại chi nhánh.</p>
            </div>
        </a>
    </section>
</div>
</body>
</html>
