package com.techcommerce.auth;

import com.techcommerce.store.Store;
import com.techcommerce.store.StoreRepository;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import java.util.List;
import java.util.Optional;

@ControllerAdvice
public class CurrentUserAdvice {

    private final StoreRepository storeRepository;

    public CurrentUserAdvice(StoreRepository storeRepository) {
        this.storeRepository = storeRepository;
    }

    @ModelAttribute("currentUser")
    public UserPrincipal currentUser(HttpServletRequest request) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.getPrincipal() instanceof UserPrincipal principal) {
            request.setAttribute("currentUser", principal);
            return principal;
        }
        Object attr = request.getAttribute("currentUser");
        if (attr instanceof UserPrincipal principal) {
            return principal;
        }
        return null;
    }

    @ModelAttribute("activeStores")
    public List<Store> activeStores() {
        return storeRepository.findByActiveTrueOrderByIdAsc();
    }

    @ModelAttribute("currentStore")
    public Store currentStore(HttpServletRequest request) {
        String storeId = readCookie(request, "SELECTED_STORE_ID");
        if (storeId == null) return null;
        try {
            return storeRepository.findById(Long.parseLong(storeId)).filter(Store::isActive).orElse(null);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private static String readCookie(HttpServletRequest request, String name) {
        Cookie[] cookies = request.getCookies();
        if (cookies == null) return null;
        for (Cookie c : cookies) {
            if (name.equals(c.getName())) return c.getValue();
        }
        return null;
    }
}
