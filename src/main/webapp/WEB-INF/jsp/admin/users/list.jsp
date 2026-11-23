<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản lý tài khoản - TechCommerce</title>
</head>
<body>
<div class="tc-hero-enter">
    <h1 class="h4 fw-bold mb-4">Quản lý tài khoản &amp; Nhân viên</h1>

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

    <%-- Thêm nhân viên chi nhánh --%>
    <section class="tc-card mb-4" aria-labelledby="create-staff-heading">
        <div class="tc-card-header">
            <h2 id="create-staff-heading" class="h6 fw-bold mb-0">Thêm nhân viên chi nhánh</h2>
        </div>
        <div class="p-4">
            <form action="${pageContext.request.contextPath}/admin/users/staff" method="post" class="row g-3 align-items-end">
                <c:if test="${not empty _csrf}">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                </c:if>
                <div class="col-md-3">
                    <label for="staffFullName" class="form-label">Họ và tên</label>
                    <input type="text" id="staffFullName" name="fullName" class="form-control form-control-sm"
                           required autocomplete="off" placeholder="Lê Hoàng Nam">
                </div>
                <div class="col-md-3">
                    <label for="staffEmail" class="form-label">Email</label>
                    <input type="email" id="staffEmail" name="email" class="form-control form-control-sm"
                           required autocomplete="off" inputmode="email" spellcheck="false" placeholder="staff.dn@techcommerce.store">
                </div>
                <div class="col-md-2">
                    <label for="staffPassword" class="form-label">Mật khẩu</label>
                    <input type="password" id="staffPassword" name="password" class="form-control form-control-sm"
                           minlength="8" required autocomplete="new-password" placeholder="Tối thiểu 8 ký tự">
                </div>
                <div class="col-md-2">
                    <label for="staffStoreId" class="form-label">Chi nhánh</label>
                    <select id="staffStoreId" name="storeId" class="form-select form-select-sm" required>
                        <option value="">Chọn chi nhánh…</option>
                        <c:forEach var="st" items="${stores}">
                            <option value="${st.id}"><c:out value="${st.name}"/> (<c:out value="${st.code}"/>)</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-primary btn-sm w-100">Tạo tài khoản</button>
                </div>
            </form>
        </div>
    </section>

    <%-- Danh sách tài khoản --%>
    <section class="tc-card" aria-labelledby="users-table-heading">
        <div class="tc-card-header">
            <h2 id="users-table-heading" class="h6 fw-bold mb-0">Danh sách tài khoản</h2>
        </div>
        <div class="table-responsive">
            <table class="table table-hover tc-table align-middle mb-0 small">
                <thead>
                <tr>
                    <th scope="col" class="ps-4">ID</th>
                    <th scope="col">Email</th>
                    <th scope="col">Họ và tên</th>
                    <th scope="col">Vai trò</th>
                    <th scope="col">Chi nhánh</th>
                    <th scope="col">Trạng thái</th>
                    <th scope="col" class="text-end pe-4">Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="u" items="${users}">
                    <tr>
                        <td class="ps-4 tc-mono text-secondary">#<c:out value="${u.id}"/></td>
                        <td class="tc-mono text-dark"><c:out value="${u.email}"/></td>
                        <td class="fw-semibold"><c:out value="${u.fullName}"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${u.role == 'ADMIN'}"><span class="tc-badge tc-badge-primary">ADMIN</span></c:when>
                                <c:when test="${u.role == 'STAFF'}"><span class="tc-badge tc-badge-warning">STAFF</span></c:when>
                                <c:otherwise><span class="tc-badge tc-badge-neutral"><c:out value="${u.role}"/></span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty u.storeId}">
                                    <c:set var="matchedStoreName" value=""/>
                                    <c:forEach var="st" items="${stores}">
                                        <c:if test="${st.id == u.storeId}">
                                            <c:set var="matchedStoreName" value="${st.name}"/>
                                        </c:if>
                                    </c:forEach>
                                    <span><c:out value="${not empty matchedStoreName ? matchedStoreName : '#'.concat(u.storeId)}"/></span>
                                </c:when>
                                <c:otherwise><span class="text-secondary">—</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${u.enabled}"><span class="tc-badge tc-badge-success">Hoạt động</span></c:when>
                                <c:otherwise><span class="tc-badge tc-badge-danger">Đã khóa</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-end pe-4">
                            <form action="${pageContext.request.contextPath}/admin/users/${u.id}/toggle-status" method="post" class="d-inline"
                                  onsubmit="return ${u.enabled ? 'confirm(\'Khóa tài khoản này?\')' : 'true'};">
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
    </section>
</div>
</body>
</html>
