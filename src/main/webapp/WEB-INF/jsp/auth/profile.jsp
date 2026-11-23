<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Hồ sơ cá nhân &amp; Sổ địa chỉ - TechCommerce</title>
</head>
<body>
<div class="w-full max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-6">
    <!-- Stitch Profile Summary Banner -->
    <section class="w-full rounded-2xl bg-surface-container-lowest shadow-sm border border-surface-container-high overflow-hidden relative">
        <div class="absolute inset-0 bg-gradient-to-r from-primary-fixed/25 via-transparent to-tertiary-fixed/15 pointer-events-none"></div>
        <div class="relative p-5 sm:p-6 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
            <div class="flex items-center gap-4">
                <div class="w-14 h-14 rounded-2xl bg-gradient-to-br from-primary-container to-primary flex items-center justify-center text-white shadow-md shrink-0">
                    <span class="material-symbols-outlined text-2xl">person</span>
                </div>
                <div>
                    <div class="flex flex-wrap items-center gap-2">
                        <h1 class="text-lg sm:text-xl font-headline font-bold text-on-surface mb-0"><c:out value="${user.fullName}"/></h1>
                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-[11px] font-semibold bg-primary-fixed text-primary">
                            <c:out value="${user.role}"/>
                        </span>
                        <span class="inline-flex items-center px-2 py-0.5 rounded-full text-[11px] font-mono bg-surface-container text-on-surface-variant">
                            <c:out value="${not empty user.authProvider ? user.authProvider : 'LOCAL'}"/>
                        </span>
                    </div>
                    <p class="font-mono text-xs text-primary font-medium mb-0 mt-1"><c:out value="${user.email}"/></p>
                </div>
            </div>
        </div>
    </section>

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

    <!-- Stitch 12-Column Two-Panel Workspace -->
    <div class="grid grid-cols-12 gap-6">
        <!-- LEFT COLUMN (5 cols) -->
        <div class="col-span-12 lg:col-span-5 space-y-6">
            <!-- Card 1: Thông tin tài khoản -->
            <div class="bg-surface-container-lowest rounded-2xl shadow-sm border border-surface-container-high p-6 space-y-5">
                <div class="flex items-center gap-2.5">
                    <div class="w-8 h-8 rounded-lg bg-primary-fixed flex items-center justify-center text-primary">
                        <span class="material-symbols-outlined text-lg">badge</span>
                    </div>
                    <h2 class="text-base font-headline font-bold text-on-surface mb-0">Thông tin tài khoản</h2>
                </div>

                <form action="${pageContext.request.contextPath}/profile/update" method="post" class="space-y-4">
                    <c:if test="${not empty _csrf}">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    </c:if>
                    <div>
                        <label class="block text-xs font-semibold text-on-surface mb-1.5" for="profileEmail">Email đăng nhập</label>
                        <div class="relative">
                            <input id="profileEmail" type="email" readonly value="<c:out value='${user.email}'/>"
                                   class="w-full h-11 px-3.5 pr-10 rounded-lg bg-surface-container text-on-surface-variant font-mono text-xs cursor-not-allowed outline-none border-0"/>
                            <span class="material-symbols-outlined absolute right-3 top-3 text-slate-400 text-lg">lock</span>
                        </div>
                    </div>
                    <div>
                        <label class="block text-xs font-semibold text-on-surface mb-1.5" for="fullName">Họ và tên</label>
                        <input id="fullName" name="fullName" type="text" required autocomplete="name"
                               value="<c:out value='${user.fullName}'/>"
                               class="w-full h-11 px-3.5 rounded-lg bg-surface-container-low text-on-surface text-sm focus:bg-surface-container-lowest focus:shadow-[0_0_0_2px_#0f52ba] outline-none transition-all border-0"/>
                    </div>
                    <div>
                        <label class="block text-xs font-semibold text-on-surface mb-1.5" for="phone">Số điện thoại</label>
                        <input id="phone" name="phone" type="tel" autocomplete="tel" inputmode="tel"
                               value="<c:out value='${user.phone}'/>" placeholder="0901234567"
                               class="w-full h-11 px-3.5 rounded-lg bg-surface-container-low text-on-surface font-mono text-sm focus:bg-surface-container-lowest focus:shadow-[0_0_0_2px_#0f52ba] outline-none transition-all border-0"/>
                    </div>
                    <button type="submit"
                            class="w-full h-11 rounded-lg bg-primary-container hover:bg-primary text-white font-semibold text-xs flex items-center justify-center gap-2 transition-all shadow-sm border-0">
                        <span class="material-symbols-outlined text-base">check_circle</span>
                        <span>Lưu thông tin hồ sơ</span>
                    </button>
                </form>
            </div>

            <!-- Card 2: Bảo mật & Mật khẩu -->
            <div class="bg-surface-container-lowest rounded-2xl shadow-sm border border-surface-container-high p-6 space-y-5">
                <div class="flex items-center gap-2.5">
                    <div class="w-8 h-8 rounded-lg bg-secondary-container flex items-center justify-center text-primary">
                        <span class="material-symbols-outlined text-lg">shield_lock</span>
                    </div>
                    <h2 class="text-base font-headline font-bold text-on-surface mb-0">
                        <c:choose>
                            <c:when test="${not empty user.passwordHash}">Đổi mật khẩu</c:when>
                            <c:otherwise>Thiết lập mật khẩu</c:otherwise>
                        </c:choose>
                    </h2>
                </div>

                <form action="${pageContext.request.contextPath}/profile/change-password" method="post" class="space-y-4">
                    <c:if test="${not empty _csrf}">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    </c:if>
                    <c:if test="${not empty user.passwordHash}">
                        <div>
                            <label class="block text-xs font-semibold text-on-surface mb-1.5" for="currentPassword">Mật khẩu hiện tại</label>
                            <input id="currentPassword" name="currentPassword" type="password" required autocomplete="current-password"
                                   placeholder="••••••••••••"
                                   class="w-full h-11 px-3.5 rounded-lg bg-surface-container-low text-on-surface text-sm focus:bg-surface-container-lowest focus:shadow-[0_0_0_2px_#0f52ba] outline-none transition-all border-0"/>
                        </div>
                    </c:if>
                    <div>
                        <label class="block text-xs font-semibold text-on-surface mb-1.5" for="newPassword">Mật khẩu mới</label>
                        <input id="newPassword" name="newPassword" type="password" minlength="8" required autocomplete="new-password"
                               placeholder="Tối thiểu 8 ký tự"
                               class="w-full h-11 px-3.5 rounded-lg bg-surface-container-low text-on-surface text-sm focus:bg-surface-container-lowest focus:shadow-[0_0_0_2px_#0f52ba] outline-none transition-all border-0"/>
                    </div>
                    <div>
                        <label class="block text-xs font-semibold text-on-surface mb-1.5" for="confirmPassword">Xác nhận mật khẩu mới</label>
                        <input id="confirmPassword" name="confirmPassword" type="password" minlength="8" required autocomplete="new-password"
                               placeholder="Nhập lại mật khẩu mới"
                               class="w-full h-11 px-3.5 rounded-lg bg-surface-container-low text-on-surface text-sm focus:bg-surface-container-lowest focus:shadow-[0_0_0_2px_#0f52ba] outline-none transition-all border-0"/>
                    </div>
                    <button type="submit"
                            class="w-full h-11 rounded-lg bg-secondary text-on-secondary hover:bg-on-secondary-fixed transition-all font-semibold text-xs flex items-center justify-center gap-2 border-0">
                        <span class="material-symbols-outlined text-base">lock_reset</span>
                        <span>Cập nhật mật khẩu</span>
                    </button>
                </form>
            </div>
        </div>

        <!-- RIGHT COLUMN (7 cols) -->
        <div class="col-span-12 lg:col-span-7 space-y-6">
            <!-- Card 3: Sổ địa chỉ nhận hàng -->
            <div class="bg-surface-container-lowest rounded-2xl shadow-sm border border-surface-container-high p-6 space-y-5">
                <div class="flex items-center justify-between gap-2">
                    <div class="flex items-center gap-2.5">
                        <div class="w-8 h-8 rounded-lg bg-tertiary-fixed flex items-center justify-center text-on-tertiary-fixed">
                            <span class="material-symbols-outlined text-lg">location_on</span>
                        </div>
                        <h2 class="text-base font-headline font-bold text-on-surface mb-0">Sổ địa chỉ nhận hàng</h2>
                    </div>
                    <span class="text-xs font-mono px-2.5 py-1 rounded-full bg-surface-container font-medium text-on-surface">
                        Tối đa 5 địa chỉ
                    </span>
                </div>

                <c:choose>
                    <c:when test="${empty addresses}">
                        <div class="p-6 rounded-xl bg-surface-container-low text-center text-xs text-on-surface-variant">
                            Chưa có địa chỉ nhận hàng nào được lưu.
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="space-y-3">
                            <c:forEach var="addr" items="${addresses}">
                                <div class="p-4 rounded-xl bg-surface-container-low relative overflow-hidden flex flex-col sm:flex-row sm:items-center justify-between gap-3">
                                    <c:if test="${addr.defaultAddress}">
                                        <div class="absolute left-0 top-0 bottom-0 w-1.5 bg-tertiary"></div>
                                    </c:if>
                                    <div class="space-y-1">
                                        <div class="flex flex-wrap items-center gap-2">
                                            <span class="font-headline font-bold text-sm text-on-surface"><c:out value="${addr.recipientName}"/></span>
                                            <span class="font-mono text-xs text-on-surface-variant font-semibold"><c:out value="${addr.phone}"/></span>
                                            <c:if test="${addr.defaultAddress}">
                                                <span class="inline-flex items-center gap-1 px-2 py-0.5 rounded-full text-[11px] font-semibold bg-tertiary-fixed text-on-tertiary-fixed">
                                                    <span class="material-symbols-outlined text-[13px]">check_circle</span>
                                                    Mặc định
                                                </span>
                                            </c:if>
                                        </div>
                                        <p class="text-xs text-on-surface-variant mb-0">
                                            <c:out value="${addr.addressLine}"/>, <strong class="text-on-surface"><c:out value="${addr.city}"/></strong>
                                        </p>
                                    </div>
                                    <div class="flex items-center gap-2 shrink-0">
                                        <c:if test="${not addr.defaultAddress}">
                                            <form action="${pageContext.request.contextPath}/profile/addresses/${addr.id}/default" method="post">
                                                <c:if test="${not empty _csrf}">
                                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                </c:if>
                                                <button type="submit"
                                                        class="px-3 py-1.5 rounded-lg bg-primary-fixed hover:bg-primary text-on-primary-fixed hover:text-white transition-all text-xs font-medium border-0">
                                                    Đặt mặc định
                                                </button>
                                            </form>
                                        </c:if>
                                        <form action="${pageContext.request.contextPath}/profile/addresses/${addr.id}/delete" method="post"
                                              onsubmit="return confirm('Xóa địa chỉ nhận hàng này?');">
                                            <c:if test="${not empty _csrf}">
                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                            </c:if>
                                            <button type="submit"
                                                    class="px-3 py-1.5 rounded-lg bg-error-container text-xs font-medium text-on-error-container hover:bg-error hover:text-on-error transition-colors flex items-center gap-1 border-0">
                                                <span class="material-symbols-outlined text-xs">delete</span>
                                                <span>Xóa</span>
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Card 4: Thêm địa chỉ nhận hàng mới -->
            <div class="bg-surface-container-lowest rounded-2xl shadow-sm border border-surface-container-high p-6 space-y-5">
                <div class="flex items-center gap-2.5">
                    <div class="w-8 h-8 rounded-lg bg-primary-fixed-dim flex items-center justify-center text-primary">
                        <span class="material-symbols-outlined text-lg">add_location_alt</span>
                    </div>
                    <h2 class="text-base font-headline font-bold text-on-surface mb-0">Thêm địa chỉ nhận hàng mới</h2>
                </div>

                <form action="${pageContext.request.contextPath}/profile/addresses" method="post" class="space-y-4">
                    <c:if test="${not empty _csrf}">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    </c:if>
                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                        <div>
                            <label class="block text-xs font-semibold text-on-surface mb-1.5" for="recipientName">Họ tên người nhận</label>
                            <input id="recipientName" name="recipientName" type="text" required autocomplete="name"
                                   placeholder="Nguyễn Văn A"
                                   class="w-full h-11 px-3.5 rounded-lg bg-surface-container-low text-on-surface text-sm focus:bg-surface-container-lowest focus:shadow-[0_0_0_2px_#0f52ba] outline-none transition-all border-0"/>
                        </div>
                        <div>
                            <label class="block text-xs font-semibold text-on-surface mb-1.5" for="addrPhone">Số điện thoại nhận hàng</label>
                            <input id="addrPhone" name="phone" type="tel" required autocomplete="tel" inputmode="tel"
                                   placeholder="0901234567"
                                   class="w-full h-11 px-3.5 rounded-lg bg-surface-container-low text-on-surface font-mono text-sm focus:bg-surface-container-lowest focus:shadow-[0_0_0_2px_#0f52ba] outline-none transition-all border-0"/>
                        </div>
                    </div>
                    <div class="grid grid-cols-1 sm:grid-cols-12 gap-4">
                        <div class="sm:col-span-8">
                            <label class="block text-xs font-semibold text-on-surface mb-1.5" for="addressLine">Địa chỉ chi tiết</label>
                            <input id="addressLine" name="addressLine" type="text" required autocomplete="street-address"
                                   placeholder="Số nhà, đường, phường/xã, quận/huyện"
                                   class="w-full h-11 px-3.5 rounded-lg bg-surface-container-low text-on-surface text-sm focus:bg-surface-container-lowest focus:shadow-[0_0_0_2px_#0f52ba] outline-none transition-all border-0"/>
                        </div>
                        <div class="sm:col-span-4">
                            <label class="block text-xs font-semibold text-on-surface mb-1.5" for="city">Tỉnh / Thành phố</label>
                            <input id="city" name="city" type="text" required autocomplete="address-level1"
                                   placeholder="Hà Nội"
                                   class="w-full h-11 px-3.5 rounded-lg bg-surface-container-low text-on-surface text-sm focus:bg-surface-container-lowest focus:shadow-[0_0_0_2px_#0f52ba] outline-none transition-all border-0"/>
                        </div>
                    </div>
                    <label class="flex items-center gap-2.5 cursor-pointer">
                        <input id="defaultAddress" name="defaultAddress" value="true" type="checkbox"
                               class="w-4 h-4 rounded text-primary-container focus:ring-primary-container cursor-pointer"/>
                        <span class="text-xs text-on-surface font-medium">Đặt làm địa chỉ nhận hàng mặc định</span>
                    </label>
                    <button type="submit"
                            class="px-6 h-11 rounded-lg bg-primary-container hover:bg-primary text-white font-semibold text-xs flex items-center justify-center gap-2 transition-all shadow-sm border-0">
                        <span class="material-symbols-outlined text-base">add_circle</span>
                        <span>Lưu vào sổ địa chỉ</span>
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>
