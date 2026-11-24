package com.techcommerce.store;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequestMapping("/stores")
public class StoreController {

    private static final String COOKIE_NAME = "SELECTED_STORE_ID";
    private static final int COOKIE_MAX_AGE = 60 * 60 * 24 * 90; // 90 ngày

    private final StoreRepository storeRepository;

    public StoreController(StoreRepository storeRepository) {
        this.storeRepository = storeRepository;
    }

    /** Chọn chi nhánh — đặt cookie rồi redirect về trang trước (bỏ query ?branch= cũ nếu có). */
    @GetMapping("/select")
    public String select(@RequestParam(required = false) Long storeId,
                         @RequestParam(required = false) String code,
                         HttpServletRequest request,
                         HttpServletResponse response) {
        if (storeId == null && (code == null || code.isBlank() || "ALL".equalsIgnoreCase(code))) {
            Cookie cookie = new Cookie(COOKIE_NAME, "");
            cookie.setPath("/");
            cookie.setMaxAge(0);
            cookie.setAttribute("SameSite", "Lax");
            response.addCookie(cookie);
        } else {
            var storeOpt = (storeId != null)
                    ? storeRepository.findById(storeId)
                    : storeRepository.findByCode(code.trim());
            storeOpt.filter(Store::isActive).ifPresent(store -> {
                Cookie cookie = new Cookie(COOKIE_NAME, String.valueOf(store.getId()));
                cookie.setPath("/");
                cookie.setMaxAge(COOKIE_MAX_AGE);
                cookie.setHttpOnly(false);
                cookie.setAttribute("SameSite", "Lax");
                response.addCookie(cookie);
            });
        }

        String referer = request.getHeader("Referer");
        if (referer != null && !referer.isBlank()) {
            try {
                java.net.URI uri = java.net.URI.create(referer);
                String path = uri.getPath();
                if (path == null || path.isBlank() || !path.startsWith("/") || path.startsWith("//")) {
                    path = "/";
                }
                return "redirect:" + path;
            } catch (IllegalArgumentException ignored) {
                // fallback về trang chủ
            }
        }
        return "redirect:/";
    }

    /** Trang danh sách tất cả chi nhánh. */
    @GetMapping
    public String list(Model model) {
        List<Store> stores = storeRepository.findByActiveTrueOrderByIdAsc();
        model.addAttribute("stores", stores);
        return "store/list";
    }
}
