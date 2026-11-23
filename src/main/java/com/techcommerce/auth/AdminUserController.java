package com.techcommerce.auth;

import com.techcommerce.store.StoreRepository;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/users")
public class AdminUserController {

    private final UserService userService;
    private final StoreRepository storeRepository;

    public AdminUserController(UserService userService, StoreRepository storeRepository) {
        this.userService = userService;
        this.storeRepository = storeRepository;
    }

    @GetMapping
    public String listUsers(Model model) {
        model.addAttribute("users", userService.listAllUsers());
        model.addAttribute("stores", storeRepository.findByActiveTrueOrderByIdAsc());
        return "admin/users/list";
    }

    @PostMapping("/staff")
    public String createStaff(
            @RequestParam String fullName,
            @RequestParam String email,
            @RequestParam(required = false) String phone,
            @RequestParam String password,
            @RequestParam(required = false) Long storeId,
            RedirectAttributes redirectAttributes
    ) {
        try {
            userService.createStaff(fullName, email, phone, password, storeId);
            redirectAttributes.addFlashAttribute("message", "Đã tạo tài khoản nhân viên chi nhánh (STAFF).");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/admin/users";
    }

    @PostMapping("/{id}/toggle-status")
    public String toggleStatus(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            User updated = userService.toggleUserEnabled(id);
            redirectAttributes.addFlashAttribute("message",
                    "Đã " + (updated.isEnabled() ? "mở khóa" : "khóa") + " tài khoản " + updated.getEmail());
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/admin/users";
    }
}
