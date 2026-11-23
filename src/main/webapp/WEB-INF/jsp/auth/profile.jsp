<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Hồ sơ &amp; Sổ địa chỉ - TechCommerce</title>
</head>
<body>
<div class="row g-4 tc-hero-enter">
    <div class="col-12 d-flex flex-column flex-md-row justify-content-between align-items-md-center">
        <div>
            <h1 class="h3 fw-bold mb-1">Hồ sơ cá nhân &amp; Sổ địa chỉ</h1>
            <p class="text-secondary small mb-0">Quản lý thông tin liên hệ, bảo mật mật khẩu và địa chỉ nhận hàng mặc định</p>
        </div>
        <div class="mt-2 mt-md-0 d-flex align-items-center gap-2">
            <span class="tc-badge tc-badge-primary"><c:out value="${user.role}"/></span>
            <span class="tc-badge tc-badge-neutral tc-mono">Phương thức: <c:out value="${not empty user.authProvider ? user.authProvider : 'LOCAL'}"/></span>
        </div>
    </div>

    <c:if test="${not empty error}">
        <div class="col-12">
            <div class="alert alert-danger py-2 px-3 small mb-0 d-flex align-items-center gap-2" role="alert" aria-live="polite">
                <i class="bi bi-exclamation-octagon-fill" aria-hidden="true"></i>
                <span><c:out value="${error}"/></span>
            </div>
        </div>
    </c:if>
    <c:if test="${not empty message}">
        <div class="col-12">
            <div class="alert alert-success py-2 px-3 small mb-0 d-flex align-items-center gap-2" role="status" aria-live="polite">
                <i class="bi bi-check-circle-fill" aria-hidden="true"></i>
                <span><c:out value="${message}"/></span>
            </div>
        </div>
    </c:if>

    <!-- Cột trái: Thông tin cá nhân & Đổi mật khẩu -->
    <div class="col-12 col-lg-5">
        <section class="tc-card mb-4" aria-labelledby="profile-info-heading">
            <div class="tc-card-header d-flex align-items-center gap-2">
                <i class="bi bi-person-badge text-primary" aria-hidden="true"></i>
                <h2 id="profile-info-heading" class="h6 fw-bold mb-0">Thông tin tài khoản</h2>
            </div>
            <div class="p-4">
                <form action="${pageContext.request.contextPath}/profile/update" method="post">
                    <c:if test="${not empty _csrf}">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    </c:if>
                    <div class="mb-3">
                        <label for="profileEmail" class="form-label text-secondary">Email đăng nhập (cố định)</label>
                        <input type="email" id="profileEmail" class="form-control bg-light tc-mono"
                               value="<c:out value='${user.email}'/>" readonly>
                    </div>
                    <div class="mb-3">
                        <label for="fullName" class="form-label">Họ và tên</label>
                        <input type="text" id="fullName" name="fullName" class="form-control" required
                               autocomplete="name" value="<c:out value='${user.fullName}'/>">
                    </div>
                    <div class="mb-3">
                        <label for="phone" class="form-label">Số điện thoại</label>
                        <input type="tel" id="phone" name="phone" class="form-control tc-tabular"
                               autocomplete="tel" inputmode="tel" value="<c:out value='${user.phone}'/>" placeholder="0901234567…">
                    </div>
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-check2" aria-hidden="true"></i>
                        <span>Lưu thông tin hồ sơ</span>
                    </button>
                </form>
            </div>
        </section>

        <section class="tc-card" aria-labelledby="password-heading">
            <div class="tc-card-header d-flex align-items-center gap-2">
                <i class="bi bi-key text-primary" aria-hidden="true"></i>
                <h2 id="password-heading" class="h6 fw-bold mb-0">
                    <c:choose>
                        <c:when test="${not empty user.passwordHash}">Đổi mật khẩu đăng nhập</c:when>
                        <c:otherwise>Thiết lập mật khẩu cho tài khoản Google</c:otherwise>
                    </c:choose>
                </h2>
            </div>
            <div class="p-4">
                <form action="${pageContext.request.contextPath}/profile/change-password" method="post">
                    <c:if test="${not empty _csrf}">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    </c:if>
                    <c:if test="${not empty user.passwordHash}">
                        <div class="mb-3">
                            <label for="currentPassword" class="form-label">Mật khẩu hiện tại</label>
                            <input type="password" id="currentPassword" name="currentPassword" class="form-control"
                                   required autocomplete="current-password" placeholder="Nhập mật khẩu đang dùng…">
                        </div>
                    </c:if>
                    <div class="mb-3">
                        <label for="newPassword" class="form-label">Mật khẩu mới (tối thiểu 8 ký tự)</label>
                        <input type="password" id="newPassword" name="newPassword" class="form-control"
                               minlength="8" required autocomplete="new-password" placeholder="Tối thiểu 8 ký tự…">
                    </div>
                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">Xác nhận mật khẩu mới</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-control"
                               minlength="8" required autocomplete="new-password" placeholder="Nhập lại mật khẩu mới…">
                    </div>
                    <button type="submit" class="btn btn-outline-primary">
                        <i class="bi bi-shield-lock" aria-hidden="true"></i>
                        <span>Cập nhật mật khẩu</span>
                    </button>
                </form>
            </div>
        </section>
    </div>

    <!-- Cột phải: Sổ địa chỉ giao hàng -->
    <div class="col-12 col-lg-7">
        <section class="tc-card mb-4" aria-labelledby="address-book-heading">
            <div class="tc-card-header d-flex justify-content-between align-items-center">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-geo-alt text-primary" aria-hidden="true"></i>
                    <h2 id="address-book-heading" class="h6 fw-bold mb-0">Sổ địa chỉ nhận hàng đã lưu</h2>
                </div>
                <span class="tc-badge tc-badge-neutral tc-tabular">Tối đa 5 địa chỉ</span>
            </div>
            <div class="p-4">
                <c:choose>
                    <c:when test="${empty addresses}">
                        <div class="tc-surface-subtle p-4 text-center">
                            <i class="bi bi-pin-map fs-3 text-secondary d-block mb-2" aria-hidden="true"></i>
                            <div class="fw-semibold mb-1">Chưa có địa chỉ nhận hàng nào</div>
                            <p class="text-secondary small mb-0">Thêm địa chỉ ở biểu mẫu bên dưới để tự động điền thông tin người nhận khi đặt hàng.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="d-grid gap-3">
                            <c:forEach var="addr" items="${addresses}">
                                <div class="p-3 rounded border ${addr.defaultAddress ? 'border-primary bg-light' : 'bg-white'} d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-3">
                                    <div>
                                        <div class="d-flex flex-wrap align-items-center gap-2 mb-1">
                                            <span class="fw-bold"><c:out value="${addr.recipientName}"/></span>
                                            <span class="text-secondary">·</span>
                                            <span class="tc-mono fw-semibold text-dark"><c:out value="${addr.phone}"/></span>
                                            <c:if test="${addr.defaultAddress}">
                                                <span class="tc-badge tc-badge-primary">
                                                    <i class="bi bi-check2-circle" aria-hidden="true"></i> Mặc định
                                                </span>
                                            </c:if>
                                        </div>
                                        <div class="small text-secondary">
                                            <c:out value="${addr.addressLine}"/>, <strong class="text-dark"><c:out value="${addr.city}"/></strong>
                                        </div>
                                    </div>
                                    <div class="d-flex align-items-center gap-2 flex-shrink-0">
                                        <c:if test="${not addr.defaultAddress}">
                                            <form action="${pageContext.request.contextPath}/profile/addresses/${addr.id}/default" method="post">
                                                <c:if test="${not empty _csrf}">
                                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                </c:if>
                                                <button type="submit" class="btn btn-sm btn-outline-primary">Đặt mặc định</button>
                                            </form>
                                        </c:if>
                                        <form action="${pageContext.request.contextPath}/profile/addresses/${addr.id}/delete" method="post"
                                              onsubmit="return confirm('Xóa địa chỉ nhận hàng này khỏi sổ địa chỉ?');">
                                            <c:if test="${not empty _csrf}">
                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                            </c:if>
                                            <button type="submit" class="btn btn-sm btn-outline-danger" aria-label="Xóa địa chỉ của ${addr.recipientName}">
                                                <i class="bi bi-trash3" aria-hidden="true"></i>
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
        </section>

        <section class="tc-card" aria-labelledby="add-address-heading">
            <div class="tc-card-header d-flex align-items-center gap-2">
                <i class="bi bi-plus-circle text-primary" aria-hidden="true"></i>
                <h2 id="add-address-heading" class="h6 fw-bold mb-0">Thêm địa chỉ nhận hàng mới</h2>
            </div>
            <div class="p-4">
                <form action="${pageContext.request.contextPath}/profile/addresses" method="post" class="row g-3">
                    <c:if test="${not empty _csrf}">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    </c:if>
                    <div class="col-md-6">
                        <label for="recipientName" class="form-label">Họ tên người nhận</label>
                        <input type="text" id="recipientName" name="recipientName" class="form-control" required
                               autocomplete="name" placeholder="Nguyễn Văn A…">
                    </div>
                    <div class="col-md-6">
                        <label for="addrPhone" class="form-label">Số điện thoại nhận hàng</label>
                        <input type="tel" id="addrPhone" name="phone" class="form-control tc-tabular" required
                               autocomplete="tel" inputmode="tel" placeholder="0901234567…">
                    </div>
                    <div class="col-md-8">
                        <label for="addressLine" class="form-label">Địa chỉ chi tiết (Số nhà, đường, phường/xã, quận/huyện)</label>
                        <input type="text" id="addressLine" name="addressLine" class="form-control" required
                               autocomplete="street-address" placeholder="Số 120 Cầu Giấy, Phường Quan Hoa…">
                    </div>
                    <div class="col-md-4">
                        <label for="city" class="form-label">Tỉnh / Thành phố</label>
                        <input type="text" id="city" name="city" class="form-control" required
                               autocomplete="address-level1" placeholder="Hà Nội…">
                    </div>
                    <div class="col-12">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="defaultAddress" name="defaultAddress" value="true">
                            <label class="form-check-label small fw-medium" for="defaultAddress">
                                Đặt làm địa chỉ giao hàng mặc định cho các đơn tiếp theo
                            </label>
                        </div>
                    </div>
                    <div class="col-12">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-bookmark-plus" aria-hidden="true"></i>
                            <span>Lưu vào sổ địa chỉ</span>
                        </button>
                    </div>
                </form>
            </div>
        </section>
    </div>
</div>
</body>
</html>
