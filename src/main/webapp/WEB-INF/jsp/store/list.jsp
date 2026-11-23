<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Hệ thống chi nhánh - TechCommerce</title>
</head>
<body>
<main id="main-content" class="container py-5">
    <h1 class="h3 fw-semibold mb-1">Hệ thống chi nhánh</h1>
    <p class="text-secondary mb-4">Chọn chi nhánh để xem tồn kho và nhận hàng tại cửa hàng.</p>

    <div class="row g-4">
        <c:forEach var="store" items="${stores}">
            <div class="col-sm-6 col-lg-4">
                <div class="card h-100 border-0 shadow-sm">
                    <div class="card-body d-flex flex-column gap-2">
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="fw-semibold"><c:out value="${store.name}"/></span>
                            <span class="badge bg-secondary tc-mono"><c:out value="${store.code}"/></span>
                        </div>
                        <p class="text-secondary small mb-0"><i class="bi bi-geo-alt me-1"></i><c:out value="${store.address}"/></p>
                        <p class="text-secondary small mb-0"><i class="bi bi-clock me-1"></i><c:out value="${store.openingHours}"/></p>
                        <p class="text-secondary small mb-0"><i class="bi bi-telephone me-1"></i><c:out value="${store.phone}"/></p>
                    </div>
                    <div class="card-footer bg-transparent border-0 pt-0">
                        <a href="${pageContext.request.contextPath}/stores/select?storeId=${store.id}"
                           class="btn btn-sm btn-outline-primary w-100">
                            <c:choose>
                                <c:when test="${not empty currentStore and currentStore.id == store.id}">
                                    <i class="bi bi-check-circle me-1"></i>Đang chọn
                                </c:when>
                                <c:otherwise>Chọn chi nhánh này</c:otherwise>
                            </c:choose>
                        </a>
                    </div>
                </div>
            </div>
        </c:forEach>
        <c:if test="${empty stores}">
            <div class="col-12 text-secondary">Chưa có chi nhánh nào.</div>
        </c:if>
    </div>
</main>
</body>
</html>
