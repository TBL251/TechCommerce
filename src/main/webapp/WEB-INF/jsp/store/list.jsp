<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Hệ thống Showroom &amp; Chi nhánh - TechCommerce</title>
</head>
<body>
<div class="tc-hero-enter">
    <%-- Header & Active Branch Status --%>
    <div class="tc-hero-surface p-4 p-lg-5 mb-4">
        <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-center gap-3">
            <div>
                <div class="d-inline-flex align-items-center gap-2 px-3 py-1 rounded-pill bg-white border mb-2 small">
                    <span class="tc-status-dot" aria-hidden="true"></span>
                    <span class="fw-medium text-secondary">Đồng bộ tồn kho thời gian thực · <span class="tc-mono text-primary">HN-01 · HCM-01 · DN-01</span></span>
                </div>
                <h1 class="h3 fw-bold mb-1">Hệ thống Showroom &amp; Chi nhánh TechCommerce</h1>
                <p class="text-secondary mb-0">
                    Chọn điểm mua sắm để xem đúng số lượng tồn kho tại quầy, đặt giữ máy nhận sau 15&nbsp;phút hoặc gửi yêu cầu bảo hành đổi trả 7&nbsp;ngày.
                </p>
            </div>
            <div class="d-flex flex-wrap align-items-center gap-2 flex-shrink-0">
                <c:if test="${not empty currentStore}">
                    <a href="${pageContext.request.contextPath}/stores/select?code=ALL" class="btn btn-light border">
                        <i class="bi bi-arrow-counterclockwise" aria-hidden="true"></i>
                        <span>Chuyển về Toàn hệ thống</span>
                    </a>
                </c:if>
                <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">
                    <i class="bi bi-grid" aria-hidden="true"></i>
                    <span>Xem danh mục sản phẩm</span>
                </a>
            </div>
        </div>
    </div>

    <%-- 4 Service Commitments Strip --%>
    <div class="row g-3 mb-4">
        <div class="col-sm-6 col-lg-3">
            <div class="tc-metric-tile h-100 d-flex align-items-start gap-3">
                <i class="bi bi-lightning-charge-fill text-primary fs-4" aria-hidden="true"></i>
                <div>
                    <div class="fw-bold small">Nhận tại quầy 15 phút</div>
                    <div class="text-secondary" style="font-size: 0.8rem;">Đặt giữ hàng online, kỹ thuật viên chuẩn bị sẵn máy tại showroom đã chọn.</div>
                </div>
            </div>
        </div>
        <div class="col-sm-6 col-lg-3">
            <div class="tc-metric-tile h-100 d-flex align-items-start gap-3">
                <i class="bi bi-arrow-repeat text-primary fs-4" aria-hidden="true"></i>
                <div>
                    <div class="fw-bold small">Đổi mới 7 ngày toàn chuỗi</div>
                    <div class="text-secondary" style="font-size: 0.8rem;">Hỗ trợ đổi trả chéo giữa 3 chi nhánh Hà Nội, TP.HCM và Đà Nẵng.</div>
                </div>
            </div>
        </div>
        <div class="col-sm-6 col-lg-3">
            <div class="tc-metric-tile h-100 d-flex align-items-start gap-3">
                <i class="bi bi-pc-display text-primary fs-4" aria-hidden="true"></i>
                <div>
                    <div class="fw-bold small">Trạm kỹ thuật &amp; Build PC</div>
                    <div class="text-secondary" style="font-size: 0.8rem;">Khu trải nghiệm thực tế, kiểm tra hiệu năng và lắp ráp máy trạm tại chỗ.</div>
                </div>
            </div>
        </div>
        <div class="col-sm-6 col-lg-3">
            <div class="tc-metric-tile h-100 d-flex align-items-start gap-3">
                <i class="bi bi-chat-dots-fill text-primary fs-4" aria-hidden="true"></i>
                <div>
                    <div class="fw-bold small">Chat trực tiếp chi nhánh</div>
                    <div class="text-secondary" style="font-size: 0.8rem;">Nhắn tin trực tiếp với nhân viên phụ trách showroom để kiểm tra serial tồn kho.</div>
                </div>
            </div>
        </div>
    </div>

    <%-- 3 Detailed Showroom Cards --%>
    <div class="row g-4">
        <c:forEach var="store" items="${stores}">
            <c:set var="isSelected" value="${not empty currentStore and currentStore.id == store.id}"/>
            <div class="col-md-6 col-lg-4">
                <article class="${isSelected ? 'tc-card-selected' : 'tc-card'} tc-hover-lift h-100 d-flex flex-column justify-content-between">
                    <div class="p-4">
                        <div class="d-flex align-items-center justify-content-between mb-3">
                            <span class="tc-badge tc-badge-primary tc-mono"><c:out value="${store.code}"/></span>
                            <span class="tc-badge tc-badge-success">
                                <span class="tc-status-dot" aria-hidden="true"></span>
                                Đang hoạt động
                            </span>
                        </div>

                        <h2 class="h5 fw-bold mb-1"><c:out value="${store.name}"/></h2>
                        <div class="small text-secondary mb-3">Khu vực: <strong class="text-dark"><c:out value="${store.city}"/></strong></div>

                        <div class="tc-surface-subtle p-3 mb-3 d-grid gap-2 small">
                            <div class="d-flex align-items-start gap-2">
                                <i class="bi bi-geo-alt-fill text-primary mt-1" aria-hidden="true"></i>
                                <span><c:out value="${store.address}"/></span>
                            </div>
                            <div class="d-flex align-items-center gap-2">
                                <i class="bi bi-clock-fill text-primary" aria-hidden="true"></i>
                                <span>Giờ mở cửa: <strong class="tc-mono text-dark"><c:out value="${store.openingHours}"/></strong> (Cả T7 &amp; CN)</span>
                            </div>
                            <div class="d-flex align-items-center gap-2">
                                <i class="bi bi-telephone-fill text-primary" aria-hidden="true"></i>
                                <span>Hotline: <strong class="tc-mono text-dark"><c:out value="${store.phone}"/></strong></span>
                            </div>
                        </div>

                        <div class="d-flex flex-wrap gap-1">
                            <span class="tc-badge tc-badge-neutral">Nhận tại quầy 15 phút</span>
                            <span class="tc-badge tc-badge-neutral">Bảo hành đổi trả 7 ngày</span>
                        </div>
                    </div>

                    <div class="p-4 pt-0">
                        <a href="${pageContext.request.contextPath}/stores/select?storeId=${store.id}"
                           class="btn ${isSelected ? 'btn-success' : 'btn-primary'} w-100">
                            <c:choose>
                                <c:when test="${isSelected}">
                                    <i class="bi bi-check-circle-fill" aria-hidden="true"></i>
                                    <span>Đang chọn chi nhánh này</span>
                                </c:when>
                                <c:otherwise>
                                    <i class="bi bi-check2-circle" aria-hidden="true"></i>
                                    <span>Chọn chi nhánh này</span>
                                </c:otherwise>
                            </c:choose>
                        </a>
                    </div>
                </article>
            </div>
        </c:forEach>

        <c:if test="${empty stores}">
            <div class="col-12">
                <div class="tc-card p-5 text-center text-secondary">
                    <i class="bi bi-shop fs-2 d-block mb-2" aria-hidden="true"></i>
                    Chưa có chi nhánh nào đang hoạt động.
                </div>
            </div>
        </c:if>
    </div>
</div>
</body>
</html>
