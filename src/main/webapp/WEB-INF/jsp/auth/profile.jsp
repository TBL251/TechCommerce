<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Hồ sơ & Sổ địa chỉ - TechCommerce</title>
</head>
<body>
<div class="row g-4">
    <div class="col-12">
        <h1 class="h3 fw-bold mb-1">Hồ sơ cá nhân & Sổ địa chỉ</h1>
        <p class="text-secondary small mb-0">Quản lý thông tin tài khoản, bảo mật và địa chỉ nhận hàng mặc định</p>
    </div>

    <c:if test="${not empty error}">
        <div class="col-12"><div class="alert alert-danger py-2 small mb-0"><c:out value="${error}"/></div></div>
    </c:if>
    <c:if test="${not empty message}">
        <div class="col-12"><div class="alert alert-success py-2 small mb-0"><c:out value="${message}"/></div></div>
    </c:if>

    <!-- Thông tin cá nhân & Đổi mật khẩu -->
    <div class="col-12 col-lg-5">
        <div class="card shadow-sm border-0 mb-4">
            <div class="card-header bg-white fw-semibold">Thông tin tài khoản</div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/profile/update" method="post">
                    <c:if test="${not empty _csrf}">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    </c:if>
                    <div class="mb-3">
                        <label class="form-label small text-secondary">Email đăng nhập</label>
                        <input type="email" class="form-control bg-light" value="<c:out value='${user.email}'/>" readonly>
                    </div>
                    <div class="mb-3">
                        <label for="fullName" class="form-label small fw-semibold">Họ và tên</label>
                        <input type="text" id="fullName" name="fullName" class="form-control" required
                               value="<c:out value='${user.fullName}'/>">
                    </div>
                    <div class="mb-3">
                        <label for="phone" class="form-label small fw-semibold">Số điện thoại</label>
                        <input type="tel" id="phone" name="phone" class="form-control"
                               value="<c:out value='${user.phone}'/>">
                    </div>
                    <button type="submit" class="btn btn-primary btn-sm">Lưu thông tin</button>
                </form>
            </div>
        </div>

        <div class="card shadow-sm border-0">
            <div class="card-header bg-white fw-semibold">
                <c:choose>
                    <c:when test="${not empty user.passwordHash}">Đổi mật khẩu</c:when>
                    <c:otherwise>Thiết lập mật khẩu cho tài khoản Google</c:otherwise>
                </c:choose>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/profile/change-password" method="post">
                    <c:if test="${not empty _csrf}">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    </c:if>
                    <c:if test="${not empty user.passwordHash}">
                        <div class="mb-3">
                            <label for="currentPassword" class="form-label small fw-semibold">Mật khẩu hiện tại</label>
                            <input type="password" id="currentPassword" name="currentPassword" class="form-control" required>
                        </div>
                    </c:if>
                    <div class="mb-3">
                        <label for="newPassword" class="form-label small fw-semibold">Mật khẩu mới (tối thiểu 8 ký tự)</label>
                        <input type="password" id="newPassword" name="newPassword" class="form-control" minlength="8" required>
                    </div>
                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label small fw-semibold">Xác nhận mật khẩu mới</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" minlength="8" required>
                    </div>
                    <button type="submit" class="btn btn-outline-primary btn-sm">Cập nhật mật khẩu</button>
                </form>
            </div>
        </div>
    </div>

    <!-- Sổ địa chỉ giao hàng -->
    <div class="col-12 col-lg-7">
        <div class="card shadow-sm border-0 mb-4">
            <div class="card-header bg-white fw-semibold">Sổ địa chỉ giao hàng đã lưu</div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${empty addresses}">
                        <p class="text-secondary small mb-0">Bạn chưa lưu địa chỉ giao hàng nào.</p>
                    </c:when>
                    <c:otherwise>
                        <div class="list-group list-group-flush">
                            <c:forEach var="addr" items="${addresses}">
                                <div class="list-group-item px-0 d-flex justify-content-between align-items-start">
                                    <div>
                                        <div class="fw-semibold">
                                            <c:out value="${addr.recipientName}"/> — <c:out value="${addr.phone}"/>
                                            <c:if test="${addr.defaultAddress}">
                                                <span class="badge bg-info text-dark ms-1">Mặc định</span>
                                            </c:if>
                                        </div>
                                        <div class="small text-secondary">
                                            <c:out value="${addr.addressLine}"/>, <c:out value="${addr.city}"/>
                                        </div>
                                    </div>
                                    <div class="d-flex gap-2">
                                        <c:if test="${not addr.defaultAddress}">
                                            <form action="${pageContext.request.contextPath}/profile/addresses/${addr.id}/default" method="post">
                                                <c:if test="${not empty _csrf}">
                                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                </c:if>
                                                <button type="submit" class="btn btn-sm btn-outline-secondary">Đặt mặc định</button>
                                            </form>
                                        </c:if>
                                        <form action="${pageContext.request.contextPath}/profile/addresses/${addr.id}/delete" method="post">
                                            <c:if test="${not empty _csrf}">
                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                            </c:if>
                                            <button type="submit" class="btn btn-sm btn-outline-danger">Xóa</button>
                                        </form>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="card shadow-sm border-0">
            <div class="card-header bg-white fw-semibold">Thêm địa chỉ nhận hàng mới</div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/profile/addresses" method="post" class="row g-3">
                    <c:if test="${not empty _csrf}">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    </c:if>
                    <div class="col-md-6">
                        <label for="recipientName" class="form-label small fw-semibold">Người nhận</label>
                        <input type="text" id="recipientName" name="recipientName" class="form-control" required>
                    </div>
                    <div class="col-md-6">
                        <label for="addrPhone" class="form-label small fw-semibold">Số điện thoại</label>
                        <input type="tel" id="addrPhone" name="phone" class="form-control" required>
                    </div>
                    <div class="col-md-8">
                        <label for="addressLine" class="form-label small fw-semibold">Số nhà, tên đường, phường/xã</label>
                        <input type="text" id="addressLine" name="addressLine" class="form-control" required>
                    </div>
                    <div class="col-md-4">
                        <label for="city" class="form-label small fw-semibold">Tỉnh / Thành phố</label>
                        <input type="text" id="city" name="city" class="form-control" required>
                    </div>
                    <div class="col-12">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="defaultAddress" name="defaultAddress" value="true">
                            <label class="form-check-label small" for="defaultAddress">Đặt làm địa chỉ giao hàng mặc định</label>
                        </div>
                    </div>
                    <div class="col-12">
                        <button type="submit" class="btn btn-primary btn-sm">Thêm vào sổ địa chỉ</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>
