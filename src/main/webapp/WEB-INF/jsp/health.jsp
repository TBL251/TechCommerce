<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title><c:out value="${appName}"/> - Thiết bị công nghệ chính hãng</title>
</head>
<body>

<%-- 1. Split Hero Section (Stitch Design: Storefront Hub) --%>
<section class="tc-hero-surface p-4 p-lg-5 mb-4 tc-hero-enter">
    <div class="row g-4 align-items-center">
        <div class="col-lg-7">
            <div class="d-inline-flex align-items-center gap-2 px-3 py-1 rounded-pill bg-white border mb-3 small">
                <span class="tc-status-dot" aria-hidden="true"></span>
                <span class="fw-medium text-secondary">
                    <c:choose>
                        <c:when test="${not empty currentStore}">
                            Đang xem tồn kho chi nhánh: <strong class="text-dark"><c:out value="${currentStore.name}"/></strong> (<span class="tc-mono text-primary"><c:out value="${currentStore.code}"/></span>)
                        </c:when>
                        <c:otherwise>
                            Kho hàng đồng bộ 3 miền · <span class="tc-mono text-primary">HN-01 · HCM-01 · DN-01</span>
                        </c:otherwise>
                    </c:choose>
                </span>
            </div>

            <h1 class="display-6 fw-bold mb-3">Thiết bị công nghệ chính hãng</h1>
            <p class="text-secondary mb-4" style="max-width: 58ch; font-size: 1.02rem;">
                Hệ thống phân phối laptop, workstation, điện thoại và linh kiện máy tính đa chi nhánh.
                Tra cứu tồn kho thực tế theo từng showroom, đặt giữ hàng nhận tại quầy sau 15&nbsp;phút
                hoặc đổi trả tận nơi trong 7&nbsp;ngày.
            </p>

            <div class="d-flex flex-wrap gap-2 mb-4">
                <span class="tc-badge tc-badge-neutral"><i class="bi bi-check2-circle text-success" aria-hidden="true"></i>Tồn kho thực tế từng showroom</span>
                <span class="tc-badge tc-badge-neutral"><i class="bi bi-lightning-charge text-primary" aria-hidden="true"></i>Nhận tại quầy sau 15 phút</span>
                <span class="tc-badge tc-badge-neutral"><i class="bi bi-arrow-repeat text-primary" aria-hidden="true"></i>Đổi mới 7 ngày 1-đổi-1</span>
            </div>

            <div class="d-flex flex-wrap gap-2">
                <a href="${pageContext.request.contextPath}/products" class="btn btn-primary btn-lg">
                    <i class="bi bi-grid-fill" aria-hidden="true"></i>
                    <span>Xem sản phẩm</span>
                </a>
                <a href="${pageContext.request.contextPath}/stores" class="btn btn-light border btn-lg">
                    <i class="bi bi-shop" aria-hidden="true"></i>
                    <span>Hệ thống chi nhánh</span>
                </a>
                <c:choose>
                    <c:when test="${not empty currentUser}">
                        <a href="${pageContext.request.contextPath}/profile" class="btn btn-outline-secondary btn-lg">
                            <i class="bi bi-person-vcard" aria-hidden="true"></i>
                            <span>Tài khoản của tôi</span>
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/auth/register" class="btn btn-outline-primary btn-lg">
                            <i class="bi bi-person-plus" aria-hidden="true"></i>
                            <span>Tạo tài khoản</span>
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="col-lg-5">
            <div class="d-grid gap-3">
                <div class="tc-metric-tile d-flex align-items-center gap-3">
                    <span class="tc-category-icon" aria-hidden="true"><i class="bi bi-stopwatch"></i></span>
                    <div>
                        <div class="d-flex align-items-center gap-2">
                            <span class="fw-bold tc-mono fs-5 text-primary">15 Phút</span>
                            <span class="tc-badge tc-badge-success">Nhận tại quầy</span>
                        </div>
                        <div class="small text-secondary">Giữ hàng tự động, kiểm tra nguyên seal và bàn giao trực tiếp tại showroom.</div>
                    </div>
                </div>

                <div class="tc-metric-tile d-flex align-items-center gap-3">
                    <span class="tc-category-icon" aria-hidden="true"><i class="bi bi-diagram-3"></i></span>
                    <div>
                        <div class="d-flex align-items-center gap-2">
                            <span class="fw-bold tc-mono fs-5 text-dark">03 Chi nhánh</span>
                            <span class="tc-badge tc-badge-primary tc-mono">HN · HCM · ĐN</span>
                        </div>
                        <div class="small text-secondary">Đồng bộ tồn kho theo biến thể SKU và hỗ trợ chuyển nhanh sang chi nhánh còn hàng.</div>
                    </div>
                </div>

                <div class="tc-metric-tile d-flex align-items-center gap-3">
                    <span class="tc-category-icon" aria-hidden="true"><i class="bi bi-shield-check"></i></span>
                    <div>
                        <div class="d-flex align-items-center gap-2">
                            <span class="fw-bold tc-mono fs-5 text-dark">07 Ngày</span>
                            <span class="tc-badge tc-badge-neutral">Đổi trả bảo hành</span>
                        </div>
                        <div class="small text-secondary">Gửi yêu cầu đổi trả trực tuyến kèm ảnh minh chứng, theo dõi tiến trình realtime.</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<%-- 2. Hardware Category Quick Strip (Stitch Design) --%>
<section class="mb-4" aria-labelledby="categories-heading">
    <div class="d-flex justify-content-between align-items-end mb-3">
        <div>
            <h2 id="categories-heading" class="h5 fw-bold mb-1">Danh mục thiết bị phần cứng</h2>
            <p class="text-secondary small mb-0">Tra cứu cấu hình chi tiết, so sánh thông số kỹ thuật và lọc tồn kho theo chi nhánh</p>
        </div>
        <a href="${pageContext.request.contextPath}/products" class="small fw-semibold text-decoration-none">
            Tất cả danh mục <i class="bi bi-arrow-right" aria-hidden="true"></i>
        </a>
    </div>

    <div class="row g-3">
        <div class="col-sm-6 col-lg-3">
            <a href="${pageContext.request.contextPath}/products?q=laptop" class="tc-category-tile h-100">
                <span class="tc-category-icon" aria-hidden="true"><i class="bi bi-laptop"></i></span>
                <div>
                    <div class="fw-bold mb-1">Laptop &amp; Workstation</div>
                    <div class="small text-secondary mb-2">ThinkPad, MacBook Pro, Dell Precision, ROG Gaming</div>
                    <span class="tc-badge tc-badge-primary tc-mono">Sẵn kho 3 miền</span>
                </div>
            </a>
        </div>
        <div class="col-sm-6 col-lg-3">
            <a href="${pageContext.request.contextPath}/products?q=dien+thoai" class="tc-category-tile h-100">
                <span class="tc-category-icon" aria-hidden="true"><i class="bi bi-phone"></i></span>
                <div>
                    <div class="fw-bold mb-1">Điện thoại &amp; Máy tính bảng</div>
                    <div class="small text-secondary mb-2">iPhone, Galaxy Ultra, iPad Pro chính hãng VN/A</div>
                    <span class="tc-badge tc-badge-primary tc-mono">Nhận sau 15 phút</span>
                </div>
            </a>
        </div>
        <div class="col-sm-6 col-lg-3">
            <a href="${pageContext.request.contextPath}/products?q=linh+kien" class="tc-category-tile h-100">
                <span class="tc-category-icon" aria-hidden="true"><i class="bi bi-cpu"></i></span>
                <div>
                    <div class="fw-bold mb-1">Linh kiện &amp; PC Custom</div>
                    <div class="small text-secondary mb-2">CPU Core Ultra, Ryzen 9, GPU RTX, RAM DDR5, SSD NVMe</div>
                    <span class="tc-badge tc-badge-primary tc-mono">Ráp máy tại quầy</span>
                </div>
            </a>
        </div>
        <div class="col-sm-6 col-lg-3">
            <a href="${pageContext.request.contextPath}/products?q=man+hinh" class="tc-category-tile h-100">
                <span class="tc-category-icon" aria-hidden="true"><i class="bi bi-display"></i></span>
                <div>
                    <div class="fw-bold mb-1">Màn hình &amp; Phụ kiện</div>
                    <div class="small text-secondary mb-2">Màn hình 4K đồ họa, bàn phím cơ, chuột &amp; âm thanh</div>
                    <span class="tc-badge tc-badge-primary tc-mono">Đổi trả 7 ngày</span>
                </div>
            </a>
        </div>
    </div>
</section>

<%-- 3. Multi-Branch Showroom Grid (Interactive Selection) --%>
<section class="mb-2" aria-labelledby="branches-heading">
    <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-end mb-3 gap-2">
        <div>
            <h2 id="branches-heading" class="h5 fw-bold mb-1">Mạng lưới Showroom &amp; Trạm kỹ thuật 3 miền</h2>
            <p class="text-secondary small mb-0">Chọn chi nhánh gần bạn để đồng bộ tồn kho thực tế và thời gian nhận hàng tại quầy</p>
        </div>
        <div class="d-flex align-items-center gap-2">
            <c:if test="${not empty currentStore}">
                <a href="${pageContext.request.contextPath}/stores/select?code=ALL" class="btn btn-sm btn-light border">
                    <i class="bi bi-globe2" aria-hidden="true"></i>
                    <span>Xem toàn hệ thống</span>
                </a>
            </c:if>
            <a href="${pageContext.request.contextPath}/stores" class="btn btn-sm btn-outline-primary">
                <i class="bi bi-compass" aria-hidden="true"></i>
                <span>Chi tiết 3 chi nhánh</span>
            </a>
        </div>
    </div>

    <div class="row g-3">
        <c:choose>
            <c:when test="${not empty activeStores}">
                <c:forEach var="st" items="${activeStores}">
                    <c:set var="isSelected" value="${not empty currentStore and currentStore.id == st.id}"/>
                    <div class="col-md-4">
                        <article class="${isSelected ? 'tc-card-selected' : 'tc-card'} tc-hover-lift h-100 p-4 d-flex flex-column justify-content-between">
                            <div>
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <span class="tc-badge tc-badge-primary tc-mono"><c:out value="${st.code}"/></span>
                                    <span class="tc-badge tc-badge-success">
                                        <span class="tc-status-dot" aria-hidden="true"></span>
                                        Đang mở · <c:out value="${st.openingHours}"/>
                                    </span>
                                </div>
                                <h3 class="h6 fw-bold mb-2"><c:out value="${st.name}"/></h3>
                                <p class="text-secondary small mb-2">
                                    <i class="bi bi-geo-alt-fill me-1 text-primary" aria-hidden="true"></i><c:out value="${st.address}"/>
                                </p>
                                <p class="text-secondary small mb-0">
                                    <i class="bi bi-telephone-fill me-1 text-primary" aria-hidden="true"></i>Hotline:
                                    <span class="tc-mono fw-semibold text-dark"><c:out value="${st.phone}"/></span>
                                </p>
                            </div>
                            <div class="pt-3 mt-3 border-top">
                                <a href="${pageContext.request.contextPath}/stores/select?storeId=${st.id}"
                                   class="btn btn-sm ${isSelected ? 'btn-success' : 'btn-outline-primary'} w-100">
                                    <c:choose>
                                        <c:when test="${isSelected}">
                                            <i class="bi bi-check-circle-fill" aria-hidden="true"></i>
                                            <span>Đang chọn chi nhánh này</span>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="bi bi-geo-alt" aria-hidden="true"></i>
                                            <span>Chọn chi nhánh này</span>
                                        </c:otherwise>
                                    </c:choose>
                                </a>
                            </div>
                        </article>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="col-md-4">
                    <article class="tc-card tc-hover-lift h-100 p-4 d-flex flex-column justify-content-between">
                        <div>
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <span class="tc-badge tc-badge-primary tc-mono">HN-01</span>
                                <span class="tc-badge tc-badge-success"><span class="tc-status-dot" aria-hidden="true"></span>Đang mở · 08:00 - 21:30</span>
                            </div>
                            <h3 class="h6 fw-bold mb-2">TechCommerce Hà Nội</h3>
                            <p class="text-secondary small mb-2"><i class="bi bi-geo-alt-fill me-1 text-primary" aria-hidden="true"></i>120 Cầu Giấy, Quận Cầu Giấy, Hà Nội</p>
                            <p class="text-secondary small mb-0"><i class="bi bi-telephone-fill me-1 text-primary" aria-hidden="true"></i>Hotline: <span class="tc-mono fw-semibold text-dark">024-3838-0001</span></p>
                        </div>
                        <div class="pt-3 mt-3 border-top">
                            <a href="${pageContext.request.contextPath}/stores/select?code=HN-01" class="btn btn-sm btn-outline-primary w-100">Chọn chi nhánh này</a>
                        </div>
                    </article>
                </div>
                <div class="col-md-4">
                    <article class="tc-card tc-hover-lift h-100 p-4 d-flex flex-column justify-content-between">
                        <div>
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <span class="tc-badge tc-badge-primary tc-mono">HCM-01</span>
                                <span class="tc-badge tc-badge-success"><span class="tc-status-dot" aria-hidden="true"></span>Đang mở · 08:00 - 21:30</span>
                            </div>
                            <h3 class="h6 fw-bold mb-2">TechCommerce TP.HCM</h3>
                            <p class="text-secondary small mb-2"><i class="bi bi-geo-alt-fill me-1 text-primary" aria-hidden="true"></i>268 Lý Thường Kiệt, Quận 10, TP.HCM</p>
                            <p class="text-secondary small mb-0"><i class="bi bi-telephone-fill me-1 text-primary" aria-hidden="true"></i>Hotline: <span class="tc-mono fw-semibold text-dark">028-3838-0002</span></p>
                        </div>
                        <div class="pt-3 mt-3 border-top">
                            <a href="${pageContext.request.contextPath}/stores/select?code=HCM-01" class="btn btn-sm btn-outline-primary w-100">Chọn chi nhánh này</a>
                        </div>
                    </article>
                </div>
                <div class="col-md-4">
                    <article class="tc-card tc-hover-lift h-100 p-4 d-flex flex-column justify-content-between">
                        <div>
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <span class="tc-badge tc-badge-primary tc-mono">DN-01</span>
                                <span class="tc-badge tc-badge-success"><span class="tc-status-dot" aria-hidden="true"></span>Đang mở · 08:00 - 21:30</span>
                            </div>
                            <h3 class="h6 fw-bold mb-2">TechCommerce Đà Nẵng</h3>
                            <p class="text-secondary small mb-2"><i class="bi bi-geo-alt-fill me-1 text-primary" aria-hidden="true"></i>54 Nguyễn Lương Bằng, Liên Chiểu, Đà Nẵng</p>
                            <p class="text-secondary small mb-0"><i class="bi bi-telephone-fill me-1 text-primary" aria-hidden="true"></i>Hotline: <span class="tc-mono fw-semibold text-dark">0236-3838-0003</span></p>
                        </div>
                        <div class="pt-3 mt-3 border-top">
                            <a href="${pageContext.request.contextPath}/stores/select?code=DN-01" class="btn btn-sm btn-outline-primary w-100">Chọn chi nhánh này</a>
                        </div>
                    </article>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</section>

</body>
</html>
