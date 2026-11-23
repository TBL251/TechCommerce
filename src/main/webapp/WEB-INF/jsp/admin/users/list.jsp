<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản lý Nhân viên & Người dùng - TechCommerce</title>
</head>
<body>
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h1 class="h4 fw-bold mb-1">Nhân viên chi nhánh & Người dùng</h1>
        <p class="text-secondary small mb-0">Phân quyền STAFF theo từng chi nhánh và quản lý trạng thái tài khoản</p>
    </div>
</div>

<c:if test="${not empty error}">
    <div class="alert alert-danger py-2 small"><c:out value="${error}"/></div>
</c:if>
<c:if test="${not empty message}">
    <div class="alert alert-success py-2 small"><c:out value="${message}"/></div>
</c:if>

<div class="card shadow-sm border-0 mb-4">
    <div class="card-header bg-white fw-semibold">Tạo tài khoản Nhân viên chi nhánh (STAFF)</div>
    <div class="card-body">
        <form action="${pageContext.request.contextPath}/admin/users/staff" method="post" class="row g-3">
            <c:if test="${not empty _csrf}">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            </c:if>
            <div class="col-md-3">
                <label class="form-label small fw-semibold">Họ và tên</label>
                <input type="text" name="fullName" class="form-control form-control-sm" required>
            </div>
            <div class="col-md-3">
                <label class="form-label small fw-semibold">Email</label>
                <input type="email" name="email" class="form-control form-control-sm" required>
            </div>
            <div class="col-md-2">
                <label class="form-label small fw-semibold">Mật khẩu khởi tạo</label>
                <input type="password" name="password" class="form-control form-control-sm" minlength="8" required>
            </div>
            <div class="col-md-2">
                <label class="form-label small fw-semibold">Chi nhánh phụ trách</label>
                <select name="storeId" class="form-select form-select-sm" required>
                    <option value="">-- Chọn chi nhánh --</option>
                    <c:forEach var="st" items="${stores}">
                        <option value="${st.id}"><c:out value="${st.name}"/></option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-2 d-flex align-items-end">
                <button type="submit" class="btn btn-primary btn-sm w-100">Tạo STAFF</button>
            </div>
        </form>
    </div>
</div>

<div class="card shadow-sm border-0">
    <div class="card-header bg-white fw-semibold">Danh sách tài khoản</div>
    <div class="table-responsive">
        <table class="table table-hover align-middle mb-0 small">
            <thead class="table-light">
            <tr>
                <th>ID</th>
                <th>Email</th>
                <th>Họ và tên</th>
                <th>Vai trò</th>
                <th>Chi nhánh (Store ID)</th>
                <th>Trạng thái</th>
                <th class="text-end">Thao tác</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="u" items="${users}">
                <tr>
                    <td><c:out value="${u.id}"/></td>
                    <td><c:out value="${u.email}"/></td>
                    <td><c:out value="${u.fullName}"/></td>
                    <td><span class="badge bg-secondary"><c:out value="${u.role}"/></span></td>
                    <td><c:out value="${u.storeId != null ? u.storeId : '-'}"/></td>
                    <td>
                        <c:choose>
                            <c:when test="${u.enabled}"><span class="badge bg-success">Hoạt động</span></c:when>
                            <c:otherwise><span class="badge bg-danger">Đã khóa</span></c:otherwise>
                        </c:choose>
                    </td>
                    <td class="text-end">
                        <form action="${pageContext.request.contextPath}/admin/users/${u.id}/toggle-status" method="post" class="d-inline">
                            <c:if test="${not empty _csrf}">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            </c:if>
                            <button type="submit" class="btn btn-sm ${u.enabled ? 'btn-outline-danger' : 'btn-outline-success'}">
                                <c:out value="${u.enabled ? 'Khóa' : 'Mở khóa'}"/>
                            </button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
