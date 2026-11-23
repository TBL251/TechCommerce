<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản lý Nhân sự &amp; Người dùng - TechCommerce</title>
</head>
<body>
<div class="tc-hero-enter">
    <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4">
        <div>
            <h1 class="h4 fw-bold mb-1">Nhân sự chi nhánh &amp; Tài khoản người dùng</h1>
            <p class="text-secondary small mb-0">Cấp quyền STAFF gắn theo từng chi nhánh vật lý và kiểm soát trạng thái phiên đăng nhập</p>
        </div>
        <div class="mt-2 mt-md-0">
            <span class="tc-badge tc-badge-neutral tc-tabular">
                <i class="bi bi-database-check text-success" aria-hidden="true"></i>
                Đồng bộ Supabase PostgreSQL
            </span>
        </div>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger py-2 px-3 small d-flex align-items-center gap-2 mb-3" role="alert" aria-live="polite">
            <i class="bi bi-exclamation-octagon-fill" aria-hidden="true"></i>
            <span><c:out value="${error}"/></span>
        </div>
    </c:if>
    <c:if test="${not empty message}">
        <div class="alert alert-success py-2 px-3 small d-flex align-items-center gap-2 mb-3" role="status" aria-live="polite">
            <i class="bi bi-check-circle-fill" aria-hidden="true"></i>
            <span><c:out value="${message}"/></span>
        </div>
    </c:if>

    <!-- Biểu mẫu tạo tài khoản STAFF gắn chi nhánh -->
    <section class="tc-card mb-4" aria-labelledby="create-staff-heading">
        <div class="tc-card-header d-flex align-items-center gap-2">
            <i class="bi bi-person-plus-fill text-primary" aria-hidden="true"></i>
            <h2 id="create-staff-heading" class="h6 fw-bold mb-0">Cấp tài khoản Nhân viên chi nhánh mới (STAFF)</h2>
        </div>
        <div class="p-4">
            <form action="${pageContext.request.contextPath}/admin/users/staff" method="post" class="row g-3 align-items-end">
                <c:if test="${not empty _csrf}">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                </c:if>
                <div class="col-md-3">
                    <label for="staffFullName" class="form-label">Họ và tên nhân viên</label>
                    <input type="text" id="staffFullName" name="fullName" class="form-control form-control-sm"
                           required autocomplete="off" placeholder="Lê Hoàng Nam…">
                </div>
                <div class="col-md-3">
                    <label for="staffEmail" class="form-label">Email công vụ</label>
                    <input type="email" id="staffEmail" name="email" class="form-control form-control-sm"
                           required autocomplete="off" inputmode="email" spellcheck="false" placeholder="staff.dn@techcommerce.store…">
                </div>
                <div class="col-md-2">
                    <label for="staffPassword" class="form-label">Mật khẩu khởi tạo</label>
                    <input type="password" id="staffPassword" name="password" class="form-control form-control-sm"
                           minlength="8" required autocomplete="new-password" placeholder="Tối thiểu 8 ký tự…">
                </div>
                <div class="col-md-2">
                    <label for="staffStoreId" class="form-label">Chi nhánh làm việc</label>
                    <select id="staffStoreId" name="storeId" class="form-select form-select-sm" required>
                        <option value="">Chọn chi nhánh…</option>
                        <c:forEach var="st" items="${stores}">
                            <option value="${st.id}"><c:out value="${st.name}"/> (<c:out value="${st.code}"/>)</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-primary btn-sm w-100">
                        <i class="bi bi-check2-circle" aria-hidden="true"></i>
                        <span>Tạo tài khoản STAFF</span>
                    </button>
                </div>
            </form>
        </div>
    </section>

    <!-- Bảng danh sách tài khoản toàn hệ thống -->
    <section class="tc-card" aria-labelledby="users-table-heading">
        <div class="tc-card-header d-flex justify-content-between align-items-center">
            <div class="d-flex align-items-center gap-2">
                <i class="bi bi-table text-primary" aria-hidden="true"></i>
                <h2 id="users-table-heading" class="h6 fw-bold mb-0">Danh sách tài khoản trên hệ thống</h2>
            </div>
            <span class="small text-secondary">Khóa tài khoản sẽ tự động thu hồi toàn bộ Refresh Token đang hoạt động</span>
        </div>
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0 small">
                <thead class="table-light">
                <tr>
                    <th scope="col" class="ps-4">ID</th>
                    <th scope="col">Email đăng nhập</th>
                    <th scope="col">Họ và tên</th>
                    <th scope="col">Vai trò</th>
                    <th scope="col">Chi nhánh phụ trách</th>
                    <th scope="col">Trạng thái</th>
                    <th scope="col" class="text-end pe-4">Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="u" items="${users}">
                    <tr>
                        <td class="ps-4 tc-mono text-secondary">#<c:out value="${u.id}"/></td>
                        <td class="tc-mono fw-medium text-dark"><c:out value="${u.email}"/></td>
                        <td class="fw-semibold"><c:out value="${u.fullName}"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${u.role == 'ADMIN'}">
                                    <span class="tc-badge tc-badge-primary">ADMIN</span>
                                </c:when>
                                <c:when test="${u.role == 'STAFF'}">
                                    <span class="tc-badge tc-badge-warning">STAFF</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="tc-badge tc-badge-neutral"><c:out value="${u.role}"/></span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty u.storeId}">
                                    <c:set var="matchedStoreName" value=""/>
                                    <c:forEach var="st" items="${stores}">
                                        <c:if test="${st.id == u.storeId}">
                                            <c:set var="matchedStoreName" value="${st.name} (${st.code})"/>
                                        </c:if>
                                    </c:forEach>
                                    <span class="tc-mono fw-medium">
                                        <c:out value="${not empty matchedStoreName ? matchedStoreName : 'Chi nhánh #'.concat(u.storeId)}"/>
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-secondary">Toàn hệ thống / Khách lẻ</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${u.enabled}">
                                    <span class="tc-badge tc-badge-success">
                                        <span class="tc-status-dot" aria-hidden="true"></span> Hoạt động
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="tc-badge tc-badge-danger">Đã khóa</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-end pe-4">
                            <form action="${pageContext.request.contextPath}/admin/users/${u.id}/toggle-status" method="post" class="d-inline"
                                  onsubmit="return ${u.enabled ? 'confirm(\'Khóa tài khoản này và thu hồi toàn bộ phiên đăng nhập đang hoạt động?\')' : 'true'};">
                                <c:if test="${not empty _csrf}">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                </c:if>
                                <button type="submit" class="btn btn-sm ${u.enabled ? 'btn-outline-danger' : 'btn-outline-success'}">
                                    <i class="bi ${u.enabled ? 'bi-lock' : 'bi-unlock'}" aria-hidden="true"></i>
                                    <span><c:out value="${u.enabled ? 'Khóa tài khoản' : 'Mở khóa'}"/></span>
                                </button>
                            </form>
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
