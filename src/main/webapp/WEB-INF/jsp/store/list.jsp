<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Hệ thống chi nhánh - TechCommerce</title>
</head>
<body>
<section class="w-full py-10 px-4 sm:px-6 lg:px-8 bg-surface">
    <div class="max-w-7xl mx-auto">
        <div class="flex flex-col sm:flex-row sm:items-end justify-between gap-4 mb-8">
            <div>
                <h1 class="text-2xl sm:text-3xl font-headline font-bold tracking-tight text-on-surface mb-1">
                    Hệ thống chi nhánh TechCommerce
                </h1>
                <p class="text-xs sm:text-sm text-on-surface-variant mb-0">
                    Chọn điểm mua sắm để đồng bộ tồn kho thực tế và nhận máy tại quầy sau 15&nbsp;phút.
                </p>
            </div>
            <c:if test="${not empty currentStore}">
                <a href="${pageContext.request.contextPath}/stores/select?code=ALL"
                   class="h-10 px-4 rounded-lg bg-surface-container hover:bg-surface-container-high text-on-surface text-xs font-semibold inline-flex items-center gap-1.5 text-decoration-none shrink-0 transition-colors">
                    <span class="material-symbols-outlined text-[16px]">refresh</span>
                    <span>Xem toàn hệ thống</span>
                </a>
            </c:if>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
            <c:forEach var="store" items="${stores}">
                <c:set var="isSelected" value="${not empty currentStore and currentStore.id == store.id}"/>
                <c:set var="branchPhoto" value="https://lh3.googleusercontent.com/aida-public/AB6AXuDzvE-Vv3CoVjwuO9Jz4XW9gPk-NQtsGd8aeBVE96WrviENvetm3yjb4WZy-k9lOOdMfpcmaLmDQuWPShcYjs42GI0I2vnGRiAuI_X5ZXD3SmTkLQnUqbF6I51ViDaUbetyC6KzrSfiSHg6oVj9wcN4XcsdxjIguHLjEObiPLP-X7N5-Hmfez3bmP37e7T5tVdMGMTzF6kev_fLif6bYO-D1YKxO5LoYKW2cT1KQpqbim-P_lph-7tgqxh0IMuN7uJfRysxzC8QXBg"/>
                <c:if test="${store.code == 'HCM-01'}">
                    <c:set var="branchPhoto" value="https://lh3.googleusercontent.com/aida-public/AB6AXuD9-lm4c1MzsdGZWSA3z2jD4IkhIWUGN4TAqfU1UDgqdVzjaGWZUy6sJKI72Gm8EmEEE3Jc_KbFgWrCw66qtfiOvOofjmj57gGlA5W5QayCKdZ26_89eWMBrDs0jjQm_enWixlJDAC3-TJsYUCZ_pdaAoVEQg6HGPCS2cOu6GAvW6HaLOZT5YnfIVryNCkZTKORX48MuULcs80IT7rvZczfyHh6hyGFO-Ymvl9FvuLDgcXKMAJrvWcNtaLLFkMI36Gir6mJWJkS52o"/>
                </c:if>
                <c:if test="${store.code == 'DN-01'}">
                    <c:set var="branchPhoto" value="https://lh3.googleusercontent.com/aida-public/AB6AXuBhKAuh-vfNNR1oQxlFCHED7dRxn1MzGa02PGT1-a4m0XZrt4qJfQ4QPkukNnsG5j65XaveeL6RfYEn_jrv1tVW4_WtMD2zeMV4geMZ7gMZzQMi_kMTNV173gRgaMNph8ss50kzcu5x4FiP7N_r81a-52rkKlBSskSzyrMxyJnOolpy3xickReD1vKNbKcivMLh-hbKCRntJwEsfqSmATb4ehZU1fMxpsRxeiVlfGnwofCFiAu6Nq6YmUckLAv2guJMvAvYo5VX5Ng"/>
                </c:if>

                <article class="bg-surface-container-lowest rounded-xl shadow-md flex flex-col justify-between overflow-hidden transition-all duration-200 hover:shadow-lg ${isSelected ? 'ring-2 ring-tertiary-container' : 'border border-surface-container-high'}">
                    <div class="h-1.5 w-full ${isSelected ? 'bg-tertiary-container' : 'bg-primary-container'}"></div>
                    <div class="p-6 flex flex-col gap-4 flex-1">
                        <div class="flex items-center justify-between gap-2">
                            <span class="px-2.5 py-1 rounded bg-primary-container text-on-primary font-mono text-xs font-bold tracking-wider">
                                <c:out value="${store.code}"/>
                            </span>
                            <div class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full bg-tertiary-fixed text-on-tertiary-fixed text-[11px] font-semibold">
                                <span class="w-1.5 h-1.5 rounded-full bg-tertiary-container"></span>
                                <span><c:out value="${store.openingHours}"/></span>
                            </div>
                        </div>

                        <div>
                            <h2 class="text-lg font-headline font-bold text-on-surface mb-1"><c:out value="${store.name}"/></h2>
                            <p class="text-xs text-on-surface-variant flex items-start gap-1.5 mb-0">
                                <span class="material-symbols-outlined text-[16px] text-outline shrink-0 mt-0.5">location_on</span>
                                <span><c:out value="${store.address}"/></span>
                            </p>
                        </div>

                        <div class="relative w-full h-36 rounded-lg overflow-hidden bg-surface-container">
                            <img class="w-full h-full object-cover" alt="${store.name}" src="${branchPhoto}"/>
                        </div>

                        <div class="flex items-center justify-between text-xs text-on-surface-variant pt-1">
                            <span class="flex items-center gap-1.5">
                                <span class="material-symbols-outlined text-[16px] text-outline">call</span>
                                <span>Hotline:</span>
                            </span>
                            <span class="font-mono font-bold text-primary"><c:out value="${store.phone}"/></span>
                        </div>
                    </div>

                    <div class="p-6 pt-0">
                        <a href="${pageContext.request.contextPath}/stores/select?storeId=${store.id}"
                           class="w-full py-2.5 px-4 rounded-lg ${isSelected ? 'bg-tertiary-container text-on-tertiary' : 'bg-primary-container hover:bg-primary text-on-primary'} text-xs font-headline font-bold flex items-center justify-center gap-2 shadow-sm text-decoration-none transition-colors">
                            <span class="material-symbols-outlined text-[18px]">${isSelected ? 'check_circle' : 'storefront'}</span>
                            <span>${isSelected ? 'Đang chọn chi nhánh này' : 'Chọn chi nhánh này'}</span>
                        </a>
                    </div>
                </article>
            </c:forEach>
        </div>
    </div>
</section>
</body>
</html>
