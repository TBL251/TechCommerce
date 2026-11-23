<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title><c:out value="${appName}"/> - Hệ thống bán lẻ công nghệ đa chi nhánh</title>
</head>
<body>
<div class="tc-hero-enter">
    <!-- Khối Hero chính -->
    <section class="tc-card p-4 p-lg-5 mb-4">
        <div class="row g-4 align-items-center">
            <div class="col-lg-7">
                <div class="d-inline-flex align-items-center gap-2 px-3 py-1 rounded-pill mb-3"
                     style="background-color: var(--tc-primary-soft); color: var(--tc-primary-hover); font-size: 0.82rem; font-weight: 600;">
                    <span class="tc-status-dot" aria-hidden="true"></span>
                    <span>Đồng bộ tồn kho trực tuyến 3 miền · Hà Nội · TP.HCM · Đà Nẵng</span>
                </div>
                <h1 id="health-title" class="display-6 fw-bold mb-3"><c:out value="${appName}"/> - OK</h1>
                <p class="text-secondary mb-4" style="max-width: 62ch; font-size: 1.02rem;">
                    Tra cứu chính xác số lượng tồn kho theo từng chi nhánh trước khi đặt, giữ máy nhận tại quầy sau 15&nbsp;phút hoặc giao tận nơi, thanh toán an toàn qua VNPay Sandbox và đổi trả trực tuyến trong 7&nbsp;ngày.
                </p>

                <div class="d-flex flex-wrap gap-2">
                    <c:choose>
                        <c:when test="${not empty currentUser}">
                            <a href="${pageContext.request.contextPath}/profile" class="btn btn-primary btn-lg">
                                <i class="bi bi-person-vcard" aria-hidden="true"></i>
                                <span>Hồ sơ &amp; Sổ địa chỉ (<c:out value="${currentUser.email}"/>)</span>
                            </a>
                            <c:if test="${currentUser.role == 'ADMIN'}">
                                <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-dark btn-lg">
                                    <i class="bi bi-shield-lock" aria-hidden="true"></i>
                                    <span>Quản trị Nhân sự &amp; Chi nhánh</span>
                                </a>
                            </c:if>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/auth/login" class="btn btn-primary btn-lg">
                                <i class="bi bi-box-arrow-in-right" aria-hidden="true"></i>
                                <span>Đăng nhập tài khoản</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/auth/register" class="btn btn-outline-primary btn-lg">
                                <i class="bi bi-person-plus" aria-hidden="true"></i>
                                <span>Tạo tài khoản mới</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/auth/forgot-password" class="btn btn-light border btn-lg">
                                <i class="bi bi-key" aria-hidden="true"></i>
                                <span>Khôi phục mật khẩu</span>
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Bảng trạng thái vận hành trực tiếp -->
            <div class="col-lg-5">
                <div class="tc-surface-subtle p-3 p-md-4">
                    <div class="d-flex justify-content-between align-items-center pb-2 mb-3 border-bottom">
                        <span class="fw-semibold small text-dark">Trạng thái hạ tầng &amp; Bảo mật</span>
                        <span class="tc-badge tc-badge-success">
                            <span class="tc-status-dot" aria-hidden="true"></span> Trực tuyến
                        </span>
                    </div>
                    <div class="d-grid gap-2 small">
                        <div class="d-flex justify-content-between align-items-center py-1">
                            <span class="text-secondary">Xác thực phiên</span>
                            <span class="tc-mono fw-semibold text-dark">JWT HttpOnly + Refresh Rotation</span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center py-1">
                            <span class="text-secondary">Đăng nhập liên kết</span>
                            <span class="tc-mono fw-semibold text-dark">Google OAuth 2.0</span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center py-1">
                            <span class="text-secondary">Cơ sở dữ liệu đám mây</span>
                            <span class="tc-mono fw-semibold text-success">Supabase PostgreSQL (Singapore)</span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center py-1">
                            <span class="text-secondary">Đường truyền bảo mật</span>
                            <span class="tc-mono fw-semibold text-primary">Cloudflare Tunnel + Nginx</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Danh sách 3 chi nhánh vật lý -->
    <section class="mb-4" aria-labelledby="branches-heading">
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-end mb-3">
            <div>
                <h2 id="branches-heading" class="h4 fw-bold mb-1">Hệ thống chi nhánh vật lý</h2>
                <p class="text-secondary small mb-0">Mỗi chi nhánh quản lý định mức tồn kho, nhân viên xử lý đơn và kênh chat hỗ trợ riêng biệt</p>
            </div>
            <span class="tc-mono small text-secondary mt-2 mt-md-0">Giờ mở cửa toàn chuỗi: 08:00 – 21:30</span>
        </div>

        <div class="row g-3">
            <div class="col-md-4">
                <article class="tc-card tc-hover-lift h-100 p-4 d-flex flex-column justify-content-between">
                    <div>
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span class="tc-badge tc-badge-primary tc-mono">HN-01</span>
                            <span class="tc-badge tc-badge-success">Đang mở cửa</span>
                        </div>
                        <h3 class="h5 fw-bold mb-2">TechCommerce Hà Nội</h3>
                        <p class="text-secondary small mb-3">
                            <i class="bi bi-geo-alt me-1 text-primary" aria-hidden="true"></i>120 Cầu Giấy, Quận Cầu Giấy, Hà Nội
                        </p>
                    </div>
                    <div class="pt-3 border-top d-flex justify-content-between align-items-center small">
                        <span class="text-secondary">Nhận tại quầy sau 15&nbsp;phút</span>
                        <span class="tc-mono fw-semibold text-dark">024-3838-0001</span>
                    </div>
                </article>
            </div>

            <div class="col-md-4">
                <article class="tc-card tc-hover-lift h-100 p-4 d-flex flex-column justify-content-between">
                    <div>
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span class="tc-badge tc-badge-primary tc-mono">HCM-01</span>
                            <span class="tc-badge tc-badge-success">Đang mở cửa</span>
                        </div>
                        <h3 class="h5 fw-bold mb-2">TechCommerce TP.HCM</h3>
                        <p class="text-secondary small mb-3">
                            <i class="bi bi-geo-alt me-1 text-primary" aria-hidden="true"></i>268 Lý Thường Kiệt, Quận 10, TP.HCM
                        </p>
                    </div>
                    <div class="pt-3 border-top d-flex justify-content-between align-items-center small">
                        <span class="text-secondary">Nhận tại quầy sau 15&nbsp;phút</span>
                        <span class="tc-mono fw-semibold text-dark">028-3838-0002</span>
                    </div>
                </article>
            </div>

            <div class="col-md-4">
                <article class="tc-card tc-hover-lift h-100 p-4 d-flex flex-column justify-content-between">
                    <div>
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span class="tc-badge tc-badge-primary tc-mono">DN-01</span>
                            <span class="tc-badge tc-badge-success">Đang mở cửa</span>
                        </div>
                        <h3 class="h5 fw-bold mb-2">TechCommerce Đà Nẵng</h3>
                        <p class="text-secondary small mb-3">
                            <i class="bi bi-geo-alt me-1 text-primary" aria-hidden="true"></i>54 Nguyễn Lương Bằng, Quận Liên Chiểu, Đà Nẵng
                        </p>
                    </div>
                    <div class="pt-3 border-top d-flex justify-content-between align-items-center small">
                        <span class="text-secondary">Nhận tại quầy sau 15&nbsp;phút</span>
                        <span class="tc-mono fw-semibold text-dark">0236-3838-0003</span>
                    </div>
                </article>
            </div>
        </div>
    </section>

    <!-- Lối tắt truy cập nhanh các phân hệ tài khoản -->
    <section aria-labelledby="quick-access-heading">
        <div class="tc-card p-4">
            <h2 id="quick-access-heading" class="h5 fw-bold mb-3">Phân hệ Tài khoản, Sổ địa chỉ &amp; Phân quyền chi nhánh</h2>
            <div class="row g-3">
                <div class="col-md-4">
                    <div class="p-3 rounded border bg-light h-100">
                        <div class="fw-semibold mb-1"><i class="bi bi-shield-check text-primary me-1" aria-hidden="true"></i>Bảo mật đăng nhập</div>
                        <p class="small text-secondary mb-2">Tự động khóa tạm 15&nbsp;phút khi nhập sai mật khẩu 5 lần liên tiếp; thu hồi toàn bộ phiên khi phát hiện tái sử dụng Refresh Token.</p>
                        <a href="${pageContext.request.contextPath}/auth/login" class="small fw-semibold text-decoration-none">Đi tới trang đăng nhập</a>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="p-3 rounded border bg-light h-100">
                        <div class="fw-semibold mb-1"><i class="bi bi-journal-bookmark text-success me-1" aria-hidden="true"></i>Sổ địa chỉ nhận hàng</div>
                        <p class="small text-secondary mb-2">Lưu tối đa 5 địa chỉ giao hàng cho mỗi tài khoản, chọn địa chỉ mặc định để tự động điền ở bước thanh toán.</p>
                        <a href="${pageContext.request.contextPath}/profile" class="small fw-semibold text-decoration-none">Quản lý sổ địa chỉ</a>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="p-3 rounded border bg-light h-100">
                        <div class="fw-semibold mb-1"><i class="bi bi-people text-dark me-1" aria-hidden="true"></i>Quản trị nhân sự chi nhánh</div>
                        <p class="small text-secondary mb-2">Admin tạo tài khoản STAFF gắn cứng với từng chi nhánh và khóa/mở khóa tài khoản theo thời gian thực.</p>
                        <a href="${pageContext.request.contextPath}/admin/users" class="small fw-semibold text-decoration-none">Mở bảng quản trị Admin</a>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>
</body>
</html>
