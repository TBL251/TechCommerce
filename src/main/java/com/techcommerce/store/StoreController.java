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

    /** Chọn chi nhánh — đặt cookie rồi redirect về trang trước. */
    @GetMapping("/select")
    public String select(@RequestParam Long storeId,
                         HttpServletRequest request,
                         HttpServletResponse response) {
        // Chỉ cho phép storeId hợp lệ và đang hoạt động
        storeRepository.findById(storeId)
                .filter(Store::isActive)
                .ifPresent(store -> {
                    Cookie cookie = new Cookie(COOKIE_NAME, String.valueOf(store.getId()));
                    cookie.setPath("/");
                    cookie.setMaxAge(COOKIE_MAX_AGE);
                    cookie.setHttpOnly(false); // JS không cần đọc, nhưng để tương thích frontend
                    cookie.setAttribute("SameSite", "Lax");
                    response.addCookie(cookie);
                });

        String referer = request.getHeader("Referer");
        return "redirect:" + (referer != null ? referer : "/");
    }

    /** Trang danh sách tất cả chi nhánh. */
    @GetMapping
    public String list(Model model) {
        List<Store> stores = storeRepository.findByActiveTrueOrderByIdAsc();
        model.addAttribute("stores", stores);
        return "store/list";
    }
}
