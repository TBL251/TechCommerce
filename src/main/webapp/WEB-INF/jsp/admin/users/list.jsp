<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản trị Nhân sự &amp; Tài khoản - TechCommerce</title>
</head>
<body>
<div class="space-y-6">
    <!-- Page Header -->
    <div>
        <h1 class="text-2xl font-headline font-bold text-on-surface tracking-tight mb-1">
            Nhân sự chi nhánh &amp; Tài khoản người dùng
        </h1>
        <p class="text-xs text-on-surface-variant mb-0">
            Quản lý tài khoản Quản trị viên, Nhân viên showroom (HN-01, HCM-01, DN-01) và Khách hàng.
        </p>
    </div>

    <c:if test="${not empty error}">
        <div class="p-3 rounded-xl bg-error-container text-on-error-container text-xs font-medium flex items-center gap-2" role="alert">
            <span class="material-symbols-outlined text-[18px] shrink-0">error</span>
            <span><c:out value="${error}"/></span>
        </div>
    </c:if>
    <c:if test="${not empty message}">
        <div class="p-3 rounded-xl bg-tertiary-fixed/40 text-tertiary text-xs font-medium flex items-center gap-2" role="status">
            <span class="material-symbols-outlined text-[18px] shrink-0">check_circle</span>
            <span><c:out value="${message}"/></span>
        </div>
    </c:if>

    <!-- Stitch Quick Creation Horizontal Card (ADMIN only) -->
    <c:choose>
        <c:when test="${empty currentUser || currentUser.role == 'ADMIN'}">
            <section class="p-6 rounded-2xl bg-surface-container-lowest shadow-sm border border-surface-container-high space-y-4">
                <div class="flex items-center gap-2">
                    <span class="material-symbols-outlined text-primary-container text-[22px]">person_add</span>
                    <h2 class="text-base font-headline font-bold text-on-surface mb-0">Cấp tài khoản Nhân viên chi nhánh mới (STAFF)</h2>
                </div>

                <form action="${pageContext.request.contextPath}/admin/users/staff" method="post" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-12 gap-3 items-end">
                    <c:if test="${not empty _csrf}">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    </c:if>
                    <div class="lg:col-span-3">
                        <label class="block text-xs font-semibold text-on-surface mb-1.5" for="staffFullName">Họ và tên nhân viên</label>
                        <input id="staffFullName" name="fullName" type="text" required autocomplete="off"
                               placeholder="Lê Hoàng Nam"
                               class="w-full h-10 px-3.5 text-xs rounded-lg bg-surface-container-low text-on-surface placeholder:text-outline focus:outline-none focus:bg-surface-container-lowest focus:shadow-[0_0_0_2px_#0f52ba] transition-all border-0"/>
                    </div>
                    <div class="lg:col-span-3">
                        <label class="block text-xs font-semibold text-on-surface mb-1.5" for="staffEmail">Email công vụ</label>
                        <input id="staffEmail" name="email" type="email" required autocomplete="off" inputmode="email" spellcheck="false"
                               placeholder="staff.dn@techcommerce.store"
                               class="w-full h-10 px-3.5 text-xs font-mono rounded-lg bg-surface-container-low text-on-surface placeholder:text-outline focus:outline-none focus:bg-surface-container-lowest focus:shadow-[0_0_0_2px_#0f52ba] transition-all border-0"/>
                    </div>
                    <div class="lg:col-span-2">
                        <label class="block text-xs font-semibold text-on-surface mb-1.5" for="staffPassword">Mật khẩu khởi tạo</label>
                        <input id="staffPassword" name="password" type="password" minlength="8" required autocomplete="new-password"
                               placeholder="Tối thiểu 8 ký tự"
                               class="w-full h-10 px-3.5 text-xs rounded-lg bg-surface-container-low text-on-surface placeholder:text-outline focus:outline-none focus:bg-surface-container-lowest focus:shadow-[0_0_0_2px_#0f52ba] transition-all border-0"/>
                    </div>
                    <div class="lg:col-span-2">
                        <label class="block text-xs font-semibold text-on-surface mb-1.5" for="staffStoreId">Chi nhánh làm việc</label>
                        <select id="staffStoreId" name="storeId" required
                                class="w-full h-10 px-3 text-xs rounded-lg bg-surface-container-low text-on-surface focus:outline-none focus:bg-surface-container-lowest focus:shadow-[0_0_0_2px_#0f52ba] transition-all border-0">
                            <option value="">Chọn chi nhánh…</option>
                            <c:forEach var="st" items="${stores}">
                                <option value="${st.id}"><c:out value="${st.code}"/> · <c:out value="${st.name}"/></option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="lg:col-span-2">
                        <button type="submit"
                                class="w-full h-10 px-4 rounded-lg bg-primary-container hover:bg-primary text-on-primary text-xs font-semibold shadow-sm flex items-center justify-center gap-1.5 transition-all border-0">
                            <span class="material-symbols-outlined text-[18px]">person_add</span>
                            <span>Tạo STAFF</span>
                        </button>
                    </div>
                </form>
            </section>
        </c:when>
        <c:otherwise>
            <section class="p-4 rounded-2xl bg-surface-container-lowest shadow-sm border border-surface-container-high flex items-center justify-between gap-4">
                <div class="flex items-center gap-3">
                    <div class="w-10 h-10 rounded-xl bg-primary-fixed text-primary flex items-center justify-center shrink-0">
                        <span class="material-symbols-outlined text-[20px]">badge</span>
                    </div>
                    <div>
                        <div class="text-xs font-headline font-bold text-on-surface">Chế độ Nhân viên vận hành chi nhánh (STAFF)</div>
                        <div class="text-[11px] text-on-surface-variant">Bạn có quyền tra cứu danh sách nhân sự và khách hàng. Thao tác tạo mới hoặc khóa tài khoản chỉ dành cho Quản trị viên (ADMIN).</div>
                    </div>
                </div>
            </section>
        </c:otherwise>
    </c:choose>

    <!-- Stitch Data Table Container -->
    <section class="rounded-2xl bg-surface-container-lowest shadow-sm border border-surface-container-high overflow-hidden flex flex-col">
        <div class="p-5 border-b border-surface-container flex items-center justify-between">
            <h2 class="text-base font-headline font-bold text-on-surface mb-0">Danh sách tài khoản trên hệ thống</h2>
            <span class="text-xs font-mono text-on-surface-variant">Tổng: <c:out value="${not empty users ? users.size() : 0}"/></span>
        </div>

        <div class="overflow-x-auto">
            <table class="w-full text-left text-xs mb-0">
                <thead>
                <tr class="bg-surface-container text-on-surface-variant font-label text-[11px] uppercase tracking-wider font-semibold">
                    <th class="py-3 px-4 pl-6" scope="col">ID</th>
                    <th class="py-3 px-4" scope="col">Họ và tên &amp; Email</th>
                    <th class="py-3 px-4" scope="col">Vai trò</th>
                    <th class="py-3 px-4" scope="col">Chi nhánh phụ trách</th>
                    <th class="py-3 px-4" scope="col">Trạng thái</th>
                    <th class="py-3 px-4 pr-6 text-right" scope="col">Thao tác</th>
                </tr>
                </thead>
                <tbody class="divide-y divide-surface-container-low">
                <c:forEach var="u" items="${users}">
                    <tr class="hover:bg-surface-container-low/60 transition-colors">
                        <td class="py-3.5 px-4 pl-6 font-mono font-semibold text-primary">#<c:out value="${u.id}"/></td>
                        <td class="py-3.5 px-4">
                            <div class="font-headline font-semibold text-on-surface"><c:out value="${u.fullName}"/></div>
                            <div class="text-[11px] text-on-surface-variant font-mono"><c:out value="${u.email}"/></div>
                        </td>
                        <td class="py-3.5 px-4">
                            <c:choose>
                                <c:when test="${u.role == 'ADMIN'}">
                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded text-[11px] font-mono font-bold bg-primary-fixed text-primary">ADMIN</span>
                                </c:when>
                                <c:when test="${u.role == 'STAFF'}">
                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded text-[11px] font-mono font-bold bg-secondary-container text-on-secondary-container">STAFF</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded text-[11px] font-mono font-semibold bg-surface-container text-on-surface-variant"><c:out value="${u.role}"/></span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="py-3.5 px-4">
                            <c:choose>
                                <c:when test="${not empty u.storeId}">
                                    <c:set var="matchedStoreName" value=""/>
                                    <c:forEach var="st" items="${stores}">
                                        <c:if test="${st.id == u.storeId}">
                                            <c:set var="matchedStoreName" value="${st.code} (${st.name})"/>
                                        </c:if>
                                    </c:forEach>
                                    <span class="inline-flex items-center gap-1 px-2 py-0.5 rounded text-[11px] font-mono bg-surface-container text-on-surface-variant">
                                        <span class="w-1.5 h-1.5 rounded-full bg-primary-container"></span>
                                        <c:out value="${not empty matchedStoreName ? matchedStoreName : 'Chi nhánh #'.concat(u.storeId)}"/>
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-on-surface-variant">—</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="py-3.5 px-4">
                            <c:choose>
                                <c:when test="${u.enabled}">
                                    <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-[11px] font-medium bg-tertiary-fixed/40 text-tertiary">
                                        <span class="w-1.5 h-1.5 rounded-full bg-tertiary-container"></span>
                                        Hoạt động
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-[11px] font-medium bg-error-container text-on-error-container">
                                        <span class="w-1.5 h-1.5 rounded-full bg-error"></span>
                                        Đã khóa
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="py-3.5 px-4 pr-6 text-right">
                            <c:choose>
                                <c:when test="${empty currentUser || currentUser.role == 'ADMIN'}">
                                    <form action="${pageContext.request.contextPath}/admin/users/${u.id}/toggle-status" method="post" class="inline"
                                          onsubmit="return ${u.enabled ? 'confirm(\'Khóa tài khoản này?\')' : 'true'};">
                                        <c:if test="${not empty _csrf}">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                        </c:if>
                                        <button type="submit"
                                                class="px-3 py-1.5 rounded-lg text-[11px] font-semibold transition-colors border-0 ${u.enabled ? 'bg-surface-container hover:bg-error-container hover:text-on-error-container text-on-surface-variant' : 'bg-tertiary-fixed hover:bg-tertiary-container text-on-tertiary-fixed hover:text-white'}">
                                            <c:out value="${u.enabled ? 'Khóa tài khoản' : 'Mở khóa'}"/>
                                        </button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-[11px] font-mono text-on-surface-variant">Chỉ xem</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </section>
</div>
</body>
</html>
