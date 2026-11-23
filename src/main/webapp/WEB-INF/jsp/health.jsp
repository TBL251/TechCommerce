<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title><c:out value="${appName}"/> - Thiết bị công nghệ chính hãng</title>
</head>
<body>

<%-- Hero gọn gàng --%>
<section class="tc-hero-surface p-4 p-lg-5 mb-4 tc-hero-enter">
    <div class="col-lg-8">
        <c:if test="${not empty currentStore}">
            <div class="d-inline-flex align-items-center gap-2 px-3 py-1 rounded-pill bg-white border mb-3 small">
                <span class="tc-status-dot" aria-hidden="true"></span>
                <span>Chi nhánh: <strong><c:out value="${currentStore.name}"/></strong></span>
            </div>
        </c:if>
        <h1 class="display-6 fw-bold mb-2">Thiết bị công nghệ chính hãng</h1>
        <p class="text-secondary mb-4" style="max-width: 54ch;">
            Laptop, điện thoại, linh kiện máy tính. Xem tồn kho theo chi nhánh, nhận tại quầy sau 15&nbsp;phút hoặc đổi trả trong 7&nbsp;ngày.
        </p>
        <div class="d-flex flex-wrap gap-2">
            <a href="${pageContext.request.contextPath}/products" class="btn btn-primary btn-lg">
                <i class="bi bi-grid" aria-hidden="true"></i>
                <span>Xem sản phẩm</span>
            </a>
            <c:choose>
                <c:when test="${not empty currentUser}">
                    <a href="${pageContext.request.contextPath}/profile" class="btn btn-light border btn-lg">
                        <i class="bi bi-person" aria-hidden="true"></i>
                        <span>Tài khoản của tôi</span>
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/auth/login" class="btn btn-light border btn-lg">
                        <i class="bi bi-box-arrow-in-right" aria-hidden="true"></i>
                        <span>Đăng nhập</span>
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</section>

<%-- Danh mục chính --%>
<section class="mb-4" aria-labelledby="categories-heading">
    <h2 id="categories-heading" class="h5 fw-bold mb-3">Danh mục sản phẩm</h2>
    <div class="row g-3">
        <div class="col-6 col-lg-3">
            <a href="${pageContext.request.contextPath}/products?q=laptop" class="tc-category-tile h-100 align-items-center">
                <span class="tc-category-icon" aria-hidden="true"><i class="bi bi-laptop"></i></span>
                <div class="fw-semibold">Laptop &amp; PC</div>
            </a>
        </div>
        <div class="col-6 col-lg-3">
            <a href="${pageContext.request.contextPath}/products?q=dien+thoai" class="tc-category-tile h-100 align-items-center">
                <span class="tc-category-icon" aria-hidden="true"><i class="bi bi-phone"></i></span>
                <div class="fw-semibold">Điện thoại &amp; Tablet</div>
            </a>
        </div>
        <div class="col-6 col-lg-3">
            <a href="${pageContext.request.contextPath}/products?q=linh+kien" class="tc-category-tile h-100 align-items-center">
                <span class="tc-category-icon" aria-hidden="true"><i class="bi bi-cpu"></i></span>
                <div class="fw-semibold">Linh kiện máy tính</div>
            </a>
        </div>
        <div class="col-6 col-lg-3">
            <a href="${pageContext.request.contextPath}/products?q=man+hinh" class="tc-category-tile h-100 align-items-center">
                <span class="tc-category-icon" aria-hidden="true"><i class="bi bi-display"></i></span>
                <div class="fw-semibold">Màn hình &amp; Phụ kiện</div>
            </a>
        </div>
    </div>
</section>

<%-- Hệ thống 3 chi nhánh --%>
<section aria-labelledby="branches-heading">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 id="branches-heading" class="h5 fw-bold mb-0">Chi nhánh cửa hàng</h2>
        <c:if test="${not empty currentStore}">
            <a href="${pageContext.request.contextPath}/stores/select?code=ALL" class="btn btn-sm btn-light border">
                Xem toàn hệ thống
            </a>
        </c:if>
    </div>

    <div class="row g-3">
        <c:forEach var="st" items="${activeStores}">
            <c:set var="isSelected" value="${not empty currentStore and currentStore.id == st.id}"/>
            <div class="col-md-4">
                <article class="${isSelected ? 'tc-card-selected' : 'tc-card'} tc-hover-lift h-100 p-4 d-flex flex-column justify-content-between">
                    <div>
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <h3 class="h6 fw-bold mb-0"><c:out value="${st.name}"/></h3>
                            <span class="tc-badge tc-badge-primary tc-mono"><c:out value="${st.code}"/></span>
                        </div>
                        <p class="text-secondary small mb-1">
                            <i class="bi bi-geo-alt me-1 text-primary" aria-hidden="true"></i><c:out value="${st.address}"/>
                        </p>
                        <p class="text-secondary small mb-0">
                            <i class="bi bi-clock me-1 text-primary" aria-hidden="true"></i><c:out value="${st.openingHours}"/>
                            <span class="mx-1">·</span>
                            <span class="tc-mono"><c:out value="${st.phone}"/></span>
                        </p>
                    </div>
                    <div class="pt-3 mt-3 border-top">
                        <a href="${pageContext.request.contextPath}/stores/select?storeId=${st.id}"
                           class="btn btn-sm ${isSelected ? 'btn-success' : 'btn-outline-primary'} w-100">
                            <c:choose>
                                <c:when test="${isSelected}">
                                    <i class="bi bi-check-circle-fill" aria-hidden="true"></i>
                                    <span>Đang chọn</span>
                                </c:when>
                                <c:otherwise>Chọn chi nhánh</c:otherwise>
                            </c:choose>
                        </a>
                    </div>
                </article>
            </div>
        </c:forEach>
    </div>
</section>

</body>
</html>
