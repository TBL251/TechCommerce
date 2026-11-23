<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Hệ thống chi nhánh - TechCommerce</title>
</head>
<body>
<div class="tc-hero-enter">
    <div class="d-flex flex-column flex-sm-row justify-content-between align-items-sm-center mb-4 gap-2">
        <div>
            <h1 class="h4 fw-bold mb-1">Hệ thống chi nhánh</h1>
            <p class="text-secondary small mb-0">Chọn chi nhánh để xem tồn kho và nhận hàng tại cửa hàng.</p>
        </div>
        <c:if test="${not empty currentStore}">
            <a href="${pageContext.request.contextPath}/stores/select?code=ALL" class="btn btn-sm btn-light border">
                Xem toàn hệ thống
            </a>
        </c:if>
    </div>

    <div class="row g-3">
        <c:forEach var="store" items="${stores}">
            <c:set var="isSelected" value="${not empty currentStore and currentStore.id == store.id}"/>
            <div class="col-md-6 col-lg-4">
                <article class="${isSelected ? 'tc-card-selected' : 'tc-card'} tc-hover-lift h-100 p-4 d-flex flex-column justify-content-between">
                    <div>
                        <div class="d-flex align-items-center justify-content-between mb-2">
                            <h2 class="h6 fw-bold mb-0"><c:out value="${store.name}"/></h2>
                            <span class="tc-badge tc-badge-primary tc-mono"><c:out value="${store.code}"/></span>
                        </div>
                        <p class="text-secondary small mb-1">
                            <i class="bi bi-geo-alt me-1 text-primary" aria-hidden="true"></i><c:out value="${store.address}"/>
                        </p>
                        <p class="text-secondary small mb-1">
                            <i class="bi bi-clock me-1 text-primary" aria-hidden="true"></i><c:out value="${store.openingHours}"/>
                        </p>
                        <p class="text-secondary small mb-0">
                            <i class="bi bi-telephone me-1 text-primary" aria-hidden="true"></i><span class="tc-mono"><c:out value="${store.phone}"/></span>
                        </p>
                    </div>

                    <div class="pt-3 mt-3 border-top">
                        <a href="${pageContext.request.contextPath}/stores/select?storeId=${store.id}"
                           class="btn btn-sm ${isSelected ? 'btn-success' : 'btn-primary'} w-100">
                            <c:choose>
                                <c:when test="${isSelected}">
                                    <i class="bi bi-check-circle-fill" aria-hidden="true"></i>
                                    <span>Đang chọn</span>
                                </c:when>
                                <c:otherwise>Chọn chi nhánh này</c:otherwise>
                            </c:choose>
                        </a>
                    </div>
                </article>
            </div>
        </c:forEach>
        <c:if test="${empty stores}">
            <div class="col-12 text-secondary">Chưa có chi nhánh nào.</div>
        </c:if>
    </div>
</div>
</body>
</html>
