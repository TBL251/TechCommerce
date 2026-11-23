<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title><c:out value="${appName}"/> - Thiết bị công nghệ chính hãng</title>
</head>
<body>

<%-- SECTION 1: STITCH SPLIT HERO SECTION --%>
<section class="relative w-full py-10 lg:py-14 px-4 sm:px-6 lg:px-8 overflow-hidden bg-surface">
    <div class="absolute -top-24 left-1/4 w-96 h-96 bg-primary-container/5 rounded-full blur-3xl pointer-events-none"></div>
    <div class="absolute top-1/2 right-10 w-80 h-80 bg-tertiary-container/5 rounded-full blur-3xl pointer-events-none"></div>

    <div class="max-w-7xl mx-auto">
        <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 lg:gap-10 items-center">
            <!-- Left Column -->
            <div class="lg:col-span-7 flex flex-col items-start">
                <div class="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-surface-container-highest shadow-sm mb-5">
                    <span class="relative flex h-2 w-2">
                        <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-tertiary-container opacity-75"></span>
                        <span class="relative inline-flex rounded-full h-2 w-2 bg-tertiary"></span>
                    </span>
                    <span class="text-xs font-semibold text-tertiary">
                        <c:choose>
                            <c:when test="${not empty currentStore}">
                                Chi nhánh đang chọn: <c:out value="${currentStore.name}"/> (<c:out value="${currentStore.code}"/>)
                            </c:when>
                            <c:otherwise>Kho hàng đồng bộ 3 miền · Hà Nội · TP.HCM · Đà Nẵng</c:otherwise>
                        </c:choose>
                    </span>
                </div>

                <h1 class="text-3xl sm:text-4xl lg:text-5xl font-headline font-bold text-on-surface tracking-tight leading-[1.12] mb-4">
                    Thiết bị công nghệ <span class="text-primary-container">chính hãng</span>
                </h1>
                <p class="text-sm sm:text-base text-on-surface-variant leading-relaxed max-w-xl mb-6">
                    Laptop, workstation, điện thoại và linh kiện máy tính. Xem tồn kho thực tế từng showroom, đặt giữ hàng nhận tại quầy sau 15&nbsp;phút hoặc đổi trả trong 7&nbsp;ngày.
                </p>

                <div class="flex flex-wrap items-center gap-3">
                    <a href="${pageContext.request.contextPath}/products"
                       class="inline-flex items-center justify-center gap-2 px-6 py-3 rounded-xl bg-primary-container hover:bg-primary text-on-primary font-semibold text-sm shadow-md text-decoration-none transition-all">
                        <span>Xem sản phẩm</span>
                        <span class="material-symbols-outlined text-lg">arrow_forward</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/stores"
                       class="inline-flex items-center justify-center gap-2 px-5 py-3 rounded-xl bg-surface-container-lowest hover:bg-surface-container text-on-surface font-semibold text-sm shadow-sm border border-surface-container-high text-decoration-none transition-colors">
                        <span class="material-symbols-outlined text-primary-container text-lg">storefront</span>
                        <span>Hệ thống chi nhánh</span>
                    </a>
                </div>
            </div>

            <!-- Right Column: Stitch Hero Hardware Card -->
            <div class="lg:col-span-5">
                <div class="relative w-full rounded-2xl bg-surface-container-lowest p-4 shadow-lg border border-surface-container-high overflow-hidden">
                    <div class="relative w-full h-52 rounded-xl overflow-hidden mb-4 bg-surface-container">
                        <img class="w-full h-full object-cover"
                             alt="Không gian trưng bày thiết bị công nghệ TechCommerce"
                             src="https://lh3.googleusercontent.com/aida-public/AB6AXuAUfqg4WXkFUJjl7Neh3Vl4QnLdPEQcNYF2dDTxnrM2VJEDGH3EySBvwfEDvPolYpiqFRc9AxhfPsSIdPsedQ6IXwVzOibct8uLy-p65UcSiWArmNZWvZ6RApjQGTH4_0QtOhjYVrcv8Co9781vJHxIGiPPuOJ6xIS_t8VPhMBuN22wlvz5--HfYgUrVIuwWKftDMv7h31ew45H8BzLjjtj4ZDH2kdmVxnfpuq-hIIJPIdpDkwg2tibY_UwCWtzH8xK0tOFZFymtmI"/>
                        <div class="absolute bottom-3 left-3 right-3 flex items-center justify-between text-xs text-on-surface bg-surface-container-lowest/90 backdrop-blur-md px-3 py-2 rounded-lg">
                            <span class="font-semibold text-primary-container">Showroom 3 Miền</span>
                            <span class="font-mono text-[11px] text-tertiary font-bold">08:00 – 21:30</span>
                        </div>
                    </div>

                    <div class="grid grid-cols-3 gap-2.5 text-center">
                        <div class="p-2.5 rounded-xl bg-surface-container-low">
                            <div class="font-mono text-base font-bold text-primary-container">15'</div>
                            <div class="text-[11px] font-medium text-on-surface-variant">Nhận tại quầy</div>
                        </div>
                        <div class="p-2.5 rounded-xl bg-surface-container-low">
                            <div class="font-mono text-base font-bold text-on-surface">03</div>
                            <div class="text-[11px] font-medium text-on-surface-variant">Showroom</div>
                        </div>
                        <div class="p-2.5 rounded-xl bg-surface-container-low">
                            <div class="font-mono text-base font-bold text-tertiary">07 Ngày</div>
                            <div class="text-[11px] font-medium text-on-surface-variant">Đổi trả</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<%-- SECTION 2: STITCH 4 CATEGORY CARDS WITH PHOTOGRAPHY --%>
<section class="w-full py-10 px-4 sm:px-6 lg:px-8 bg-surface-container-low" id="category-grid">
    <div class="max-w-7xl mx-auto">
        <div class="flex items-end justify-between mb-6">
            <div>
                <h2 class="text-xl sm:text-2xl font-headline font-bold text-on-surface tracking-tight mb-0">Danh mục sản phẩm</h2>
            </div>
            <a href="${pageContext.request.contextPath}/products" class="text-xs font-semibold text-primary-container hover:text-primary text-decoration-none inline-flex items-center gap-1">
                <span>Xem tất cả</span>
                <span class="material-symbols-outlined text-sm">arrow_forward</span>
            </a>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
            <!-- Category 1 -->
            <a href="${pageContext.request.contextPath}/products?q=laptop"
               class="group rounded-2xl bg-surface-container-lowest p-4 shadow-sm hover:shadow-xl transition-all duration-300 flex flex-col justify-between text-decoration-none">
                <div>
                    <div class="w-full h-32 rounded-xl overflow-hidden mb-3.5 bg-surface-container">
                        <img class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
                             alt="Laptop & Workstation"
                             src="https://lh3.googleusercontent.com/aida-public/AB6AXuCYCIrZ0cV7wBvO5Q2r35OOlZ55Im83tKVz4aECDC_w-QesE6B0blwYqTFRw1XxH1M_guyCsbj3F5FKMBsUNzmUa6mxPI_SOX0o4Jj1D-BNGDgzqVyAR0zrneP7nNeWUC3HN_3rGJSWt-17GSzeM7hR65S_8kcXxqG4Dy1Tm6Ql73H8RT-MRdgD9N0946AzNPmjleHdnDmDQ6U-ElUwoivy6eOKOOyggelnyW_J27bAG4w0k61a57qDEmlbG533eTF2Fpsu52qMuMY"/>
                    </div>
                    <h3 class="text-base font-bold text-on-surface font-headline mb-1 group-hover:text-primary-container transition-colors">Laptop &amp; Workstation</h3>
                    <p class="text-xs text-on-surface-variant mb-0">ThinkPad, MacBook Pro, Dell Precision, ROG</p>
                </div>
            </a>

            <!-- Category 2 -->
            <a href="${pageContext.request.contextPath}/products?q=dien+thoai"
               class="group rounded-2xl bg-surface-container-lowest p-4 shadow-sm hover:shadow-xl transition-all duration-300 flex flex-col justify-between text-decoration-none">
                <div>
                    <div class="w-full h-32 rounded-xl overflow-hidden mb-3.5 bg-surface-container">
                        <img class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
                             alt="Điện thoại & Tablet"
                             src="https://lh3.googleusercontent.com/aida-public/AB6AXuDvMredf54k0qIKONzO_18_Hn_sRSGS3-CgRB_xFAoMMJs6sl9zWEJDBi0ZqrJzULu_KkO-K3eB0f7-6qJLmovx34dylSU0Pqsuy1pjVtAsK85ViLt4AtHWnDauV8ZVXWBr7nxq2njoxsG4WwxaJs5qqCtld5Hme5VuB5n99cftjRMD0XYWzucHGU2k0IERbNaxlOxsN2IbLsKxRDiD47rRs1TqH_LymcR7tyZWNOBZ7Tec5W_tZQm2RYs3Jb1q07w32_Lxfvvk0eA"/>
                    </div>
                    <h3 class="text-base font-bold text-on-surface font-headline mb-1 group-hover:text-primary-container transition-colors">Điện thoại &amp; Tablet</h3>
                    <p class="text-xs text-on-surface-variant mb-0">iPhone, Galaxy Ultra, iPad Pro chính hãng</p>
                </div>
            </a>

            <!-- Category 3 -->
            <a href="${pageContext.request.contextPath}/products?q=linh+kien"
               class="group rounded-2xl bg-surface-container-lowest p-4 shadow-sm hover:shadow-xl transition-all duration-300 flex flex-col justify-between text-decoration-none">
                <div>
                    <div class="w-full h-32 rounded-xl overflow-hidden mb-3.5 bg-surface-container">
                        <img class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
                             alt="Linh kiện & PC Custom"
                             src="https://lh3.googleusercontent.com/aida-public/AB6AXuDSeN6biEdRRzO5CtOMIDWux3q6WWsPBj9h4s37hO4gBkcoju5e2pMeDGWbEnI8_oItcaKEQutxJdgZk8-BrxVXZp2BxYtvLYRH7IkpMHCZrDqC_c0ppZNKylZ8w4uA1ohHxiILtjTvjHTTankOY5YZVmurnZFnUp0M88XLiBazj8m_3I0cqeHK5xoluAv-H9FuyXUgNn9aNtGNzgJxMN3JYo69x7XOj2RnszpbZTk0oB9Eym4KPT8ZahDqubiBuwtuq-iMjIJELiw"/>
                    </div>
                    <h3 class="text-base font-bold text-on-surface font-headline mb-1 group-hover:text-primary-container transition-colors">Linh kiện &amp; PC Custom</h3>
                    <p class="text-xs text-on-surface-variant mb-0">CPU, GPU RTX, Mainboard, RAM DDR5, SSD</p>
                </div>
            </a>

            <!-- Category 4 -->
            <a href="${pageContext.request.contextPath}/products?q=man+hinh"
               class="group rounded-2xl bg-surface-container-lowest p-4 shadow-sm hover:shadow-xl transition-all duration-300 flex flex-col justify-between text-decoration-none">
                <div>
                    <div class="w-full h-32 rounded-xl overflow-hidden mb-3.5 bg-surface-container">
                        <img class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
                             alt="Màn hình & Phụ kiện"
                             src="https://lh3.googleusercontent.com/aida-public/AB6AXuC1cViu1Idmvrl7PPVZarlMsaalDhnMUvqksWE6PWfeT_gVOarLm5e8LfXRBHV_MW_7pnYmEtAB6Hu9y98b3L9xwEWh7G6LG5v97JHiySgq55DT3JAOO4zBGSE5eZeSLMt1VAHX4FTUuQvW8qj75zC9AroapdV4Gd1P0L4Zxct05-9_7c9IGZrUxHe_ofCqZ1SP8J_HjI2WXpRdfXJPiiAUy2cJNuPxmQ0HWsxc5VwPJyKzEBdbIJycsfbTo5vGwAxVjWoLzTqya90"/>
                    </div>
                    <h3 class="text-base font-bold text-on-surface font-headline mb-1 group-hover:text-primary-container transition-colors">Màn hình &amp; Phụ kiện</h3>
                    <p class="text-xs text-on-surface-variant mb-0">Màn hình 4K OLED, bàn phím cơ, chuột không dây</p>
                </div>
            </a>
        </div>
    </div>
</section>

<%-- SECTION 3: STITCH 3-BRANCH SHOWROOM GRID --%>
<section class="w-full py-12 px-4 sm:px-6 lg:px-8 bg-surface" id="showroom-network">
    <div class="max-w-7xl mx-auto">
        <div class="flex flex-col sm:flex-row sm:items-end justify-between mb-6 gap-3">
            <div>
                <h2 class="text-xl sm:text-2xl font-headline font-bold text-on-surface tracking-tight mb-1">Hệ thống chi nhánh</h2>
                <p class="text-xs text-on-surface-variant mb-0">Chọn điểm mua sắm để xem tồn kho thực tế và nhận hàng tại quầy</p>
            </div>
            <c:if test="${not empty currentStore}">
                <a href="${pageContext.request.contextPath}/stores/select?code=ALL"
                   class="px-3.5 py-2 rounded-lg bg-surface-container hover:bg-surface-container-high text-on-surface text-xs font-semibold text-decoration-none transition-colors">
                    Xem toàn hệ thống
                </a>
            </c:if>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
            <c:forEach var="st" items="${activeStores}" varStatus="loop">
                <c:set var="isSelected" value="${not empty currentStore and currentStore.id == st.id}"/>
                <c:set var="branchPhoto" value="https://lh3.googleusercontent.com/aida-public/AB6AXuAHiYAf9HBjg5zw7wa0QTnf1uK09HLrCCBU2JSoBbm_KOr8eoMrbRUCQxV0Ukv0JIaVG59yeXGH8CtAN91XYSeeubaTbbW4vnoQwSH4AOXJnGpMShvp2V1RECC2_CuMXK200LZ19Yakh4mJNKcerbN7H83m0CGlcJfmtEj0yVSnn410QUn2O1ABFCbtsnjIpRvF07Y7CyrBKaj_zSVxWRlSXOLp0m8sOhvd64NeUqfTjWfWm1jkckjdYZHcLsotIBpKZ9pXW121n00"/>
                <c:if test="${st.code == 'HCM-01'}">
                    <c:set var="branchPhoto" value="https://lh3.googleusercontent.com/aida-public/AB6AXuDoPvOt5vASoXru6_olg565mXRGzG2nXBHRO6BTHr79wOwZnTa_QDy7ymnE8s4HgzGYWFUCiSXySV7eS20qYdKBgg6Qks1BsJbbAR_BuJsjNHCE7GamJWk4LEifJGpFsk1OUWb3ODrQ8HjMyl7S4oUslknHwXZhMEyyBFFm09H8vWV9sLMlTzhb4SfeVKh9DthKX2h05XYNabg57lYAPEnSLB7LGPYAB0F6PscF8WEbsx_0ZloK7DdS_B0Fj3lamkOKgOanWVERjdE"/>
                </c:if>
                <c:if test="${st.code == 'DN-01'}">
                    <c:set var="branchPhoto" value="https://lh3.googleusercontent.com/aida-public/AB6AXuBhKAuh-vfNNR1oQxlFCHED7dRxn1MzGa02PGT1-a4m0XZrt4qJfQ4QPkukNnsG5j65XaveeL6RfYEn_jrv1tVW4_WtMD2zeMV4geMZ7gMZzQMi_kMTNV173gRgaMNph8ss50kzcu5x4FiP7N_r81a-52rkKlBSskSzyrMxyJnOolpy3xickReD1vKNbKcivMLh-hbKCRntJwEsfqSmATb4ehZU1fMxpsRxeiVlfGnwofCFiAu6Nq6YmUckLAv2guJMvAvYo5VX5Ng"/>
                </c:if>

                <div class="rounded-2xl bg-surface-container-lowest p-5 shadow-sm hover:shadow-xl transition-all duration-300 flex flex-col justify-between ${isSelected ? 'ring-2 ring-primary-container' : 'border border-surface-container-high'}">
                    <div>
                        <div class="flex items-center justify-between mb-3">
                            <span class="font-mono text-xs font-bold text-on-primary bg-primary-container px-2.5 py-1 rounded-lg"><c:out value="${st.code}"/></span>
                            <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full bg-tertiary-container/15 text-tertiary text-[11px] font-semibold">
                                <span class="h-1.5 w-1.5 rounded-full bg-tertiary"></span>
                                <c:out value="${st.openingHours}"/>
                            </span>
                        </div>

                        <div class="w-full h-36 rounded-xl overflow-hidden mb-4 bg-surface-container">
                            <img class="w-full h-full object-cover" alt="${st.name}" src="${branchPhoto}"/>
                        </div>

                        <h3 class="text-base font-headline font-bold text-on-surface mb-2"><c:out value="${st.name}"/></h3>
                        <div class="flex items-start gap-2 mb-2">
                            <span class="material-symbols-outlined text-primary-container text-base shrink-0 mt-0.5">location_on</span>
                            <span class="text-xs text-on-surface-variant"><c:out value="${st.address}"/></span>
                        </div>
                        <div class="flex items-center gap-2 mb-4 text-xs">
                            <span class="material-symbols-outlined text-outline text-base shrink-0">call</span>
                            <span class="font-mono font-semibold text-on-surface"><c:out value="${st.phone}"/></span>
                        </div>
                    </div>

                    <a href="${pageContext.request.contextPath}/stores/select?storeId=${st.id}"
                       class="w-full py-2.5 px-4 rounded-xl ${isSelected ? 'bg-tertiary-container text-on-tertiary' : 'bg-primary-container hover:bg-primary text-on-primary'} text-xs font-semibold flex items-center justify-center gap-2 shadow-sm text-decoration-none transition-colors">
                        <span class="material-symbols-outlined text-base">${isSelected ? 'check_circle' : 'storefront'}</span>
                        <span>${isSelected ? 'Chi nhánh đang chọn' : 'Chọn chi nhánh này'}</span>
                    </a>
                </div>
            </c:forEach>
        </div>
    </div>
</section>

</body>
</html>
