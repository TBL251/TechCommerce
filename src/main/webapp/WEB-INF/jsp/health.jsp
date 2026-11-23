<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title><c:out value="${appName}"/> - Thiết bị công nghệ chính hãng</title>
</head>
<body>

<%-- Hero --%>
<section class="tc-card p-4 p-lg-5 mb-4">
    <div class="col-lg-8">
        <h1 class="display-6 fw-bold mb-3">Thiết bị công nghệ chính hãng</h1>
        <p class="text-secondary mb-4" style="max-width: 60ch; font-size: 1.02rem;">
            Laptop, điện thoại, linh kiện — xem tồn kho theo chi nhánh, nhận tại quầy sau 15&nbsp;phút
            hoặc giao tận nơi. Đổi trả miễn phí trong 7&nbsp;ngày.
        </p>
        <div class="d-flex flex-wrap gap-2">
            <a href="${pageContext.request.contextPath}/products" class="btn btn-primary btn-lg">
                <i class="bi bi-grid" aria-hidden="true"></i>
                <span>Xem sản phẩm</span>
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
</section>

<%-- 3 chi nhánh --%>
<section class="mb-4" aria-labelledby="branches-heading">
    <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-end mb-3">
        <div>
            <h2 id="branches-heading" class="h5 fw-bold mb-1">Hệ thống chi nhánh</h2>
            <p class="text-secondary small mb-0">Đặt online, nhận tại quầy trong 15 phút · Mở cửa 08:00 – 21:30</p>
        </div>
    </div>

    <div class="row g-3">
        <div class="col-md-4">
            <article class="tc-card tc-hover-lift h-100 p-4 d-flex flex-column justify-content-between">
                <div>
                    <span class="tc-badge tc-badge-primary tc-mono mb-2 d-inline-block">HN-01</span>
                    <h3 class="h6 fw-bold mb-1">Hà Nội</h3>
                    <p class="text-secondary small mb-0">
                        <i class="bi bi-geo-alt me-1 text-primary" aria-hidden="true"></i>120 Cầu Giấy, Quận Cầu Giấy
                    </p>
                </div>
                <div class="pt-3 mt-3 border-top d-flex justify-content-between align-items-center small">
                    <span class="tc-mono text-dark">024-3838-0001</span>
                    <span class="tc-badge tc-badge-success">Đang mở</span>
                </div>
            </article>
        </div>

        <div class="col-md-4">
            <article class="tc-card tc-hover-lift h-100 p-4 d-flex flex-column justify-content-between">
                <div>
                    <span class="tc-badge tc-badge-primary tc-mono mb-2 d-inline-block">HCM-01</span>
                    <h3 class="h6 fw-bold mb-1">TP.HCM</h3>
                    <p class="text-secondary small mb-0">
                        <i class="bi bi-geo-alt me-1 text-primary" aria-hidden="true"></i>268 Lý Thường Kiệt, Quận 10
                    </p>
                </div>
                <div class="pt-3 mt-3 border-top d-flex justify-content-between align-items-center small">
                    <span class="tc-mono text-dark">028-3838-0002</span>
                    <span class="tc-badge tc-badge-success">Đang mở</span>
                </div>
            </article>
        </div>

        <div class="col-md-4">
            <article class="tc-card tc-hover-lift h-100 p-4 d-flex flex-column justify-content-between">
                <div>
                    <span class="tc-badge tc-badge-primary tc-mono mb-2 d-inline-block">DN-01</span>
                    <h3 class="h6 fw-bold mb-1">Đà Nẵng</h3>
                    <p class="text-secondary small mb-0">
                        <i class="bi bi-geo-alt me-1 text-primary" aria-hidden="true"></i>54 Nguyễn Lương Bằng, Liên Chiểu
                    </p>
                </div>
                <div class="pt-3 mt-3 border-top d-flex justify-content-between align-items-center small">
                    <span class="tc-mono text-dark">0236-3838-0003</span>
                    <span class="tc-badge tc-badge-success">Đang mở</span>
                </div>
            </article>
        </div>
    </div>
</section>

</body>
</html>
