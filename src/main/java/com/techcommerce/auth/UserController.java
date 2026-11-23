package com.techcommerce.auth;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class UserController {

    private final UserService userService;
    private final AddressService addressService;
    private final PasswordResetService passwordResetService;

    public UserController(
            UserService userService,
            AddressService addressService,
            PasswordResetService passwordResetService
    ) {
        this.userService = userService;
        this.addressService = addressService;
        this.passwordResetService = passwordResetService;
    }

    @GetMapping("/auth/forgot-password")
    public String forgotPasswordPage() {
        return "auth/forgot-password";
    }

    @PostMapping("/auth/forgot-password")
    public String requestForgotPassword(@RequestParam String email, Model model) {
        passwordResetService.requestPasswordReset(email);
        model.addAttribute("message", "Nếu email tồn tại trong hệ thống, liên kết đặt lại mật khẩu đã được gửi.");
        return "auth/forgot-password";
    }

    @GetMapping("/auth/reset-password")
    public String resetPasswordPage(@RequestParam String token, Model model) {
        model.addAttribute("token", token);
        return "auth/reset-password";
    }

    @PostMapping("/auth/reset-password")
    public String handleResetPassword(
            @RequestParam String token,
            @RequestParam String newPassword,
            @RequestParam String confirmPassword,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        if (newPassword == null || !newPassword.equals(confirmPassword)) {
            model.addAttribute("token", token);
            model.addAttribute("error", "Mật khẩu xác nhận không khớp.");
            return "auth/reset-password";
        }
        boolean success = passwordResetService.resetPassword(token, newPassword);
        if (!success) {
            model.addAttribute("token", token);
            model.addAttribute("error", "Liên kết đặt lại mật khẩu không hợp lệ hoặc đã hết hạn 15 phút.");
            return "auth/reset-password";
        }
        redirectAttributes.addFlashAttribute("message", "Đặt lại mật khẩu thành công. Vui lòng đăng nhập lại.");
        return "redirect:/auth/login";
    }

    @GetMapping("/profile")
    public String profilePage(@AuthenticationPrincipal UserPrincipal principal, Model model) {
        User user = userService.getById(principal.id());
        model.addAttribute("user", user);
        model.addAttribute("addresses", addressService.listUserAddresses(principal.id()));
        return "auth/profile";
    }

    @PostMapping("/profile/update")
    public String updateProfile(
            @AuthenticationPrincipal UserPrincipal principal,
            @RequestParam String fullName,
            @RequestParam(required = false) String phone,
            RedirectAttributes redirectAttributes
    ) {
        try {
            userService.updateProfile(principal.id(), fullName, phone);
            redirectAttributes.addFlashAttribute("message", "Đã cập nhật thông tin cá nhân.");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/profile";
    }

    @PostMapping("/profile/change-password")
    public String changePassword(
            @AuthenticationPrincipal UserPrincipal principal,
            @RequestParam(required = false) String currentPassword,
            @RequestParam String newPassword,
            @RequestParam String confirmPassword,
            RedirectAttributes redirectAttributes
    ) {
        if (newPassword == null || !newPassword.equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("error", "Mật khẩu xác nhận không khớp.");
            return "redirect:/profile";
        }
        try {
            userService.changePassword(principal.id(), currentPassword, newPassword);
            redirectAttributes.addFlashAttribute("message", "Đã cập nhật mật khẩu thành công.");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/profile";
    }

    @PostMapping("/profile/addresses")
    public String addAddress(
            @AuthenticationPrincipal UserPrincipal principal,
            @RequestParam String recipientName,
            @RequestParam String phone,
            @RequestParam String addressLine,
            @RequestParam String city,
            @RequestParam(defaultValue = "false") boolean defaultAddress,
            RedirectAttributes redirectAttributes
    ) {
        try {
            addressService.addAddress(principal.id(), recipientName, phone, addressLine, city, defaultAddress);
            redirectAttributes.addFlashAttribute("message", "Đã thêm địa chỉ nhận hàng.");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/profile";
    }

    @PostMapping("/profile/addresses/{id}/default")
    public String setDefaultAddress(
            @AuthenticationPrincipal UserPrincipal principal,
            @PathVariable Long id,
            RedirectAttributes redirectAttributes
    ) {
        addressService.setDefaultAddress(principal.id(), id);
        redirectAttributes.addFlashAttribute("message", "Đã cập nhật địa chỉ mặc định.");
        return "redirect:/profile";
    }

    @PostMapping("/profile/addresses/{id}/delete")
    public String deleteAddress(
            @AuthenticationPrincipal UserPrincipal principal,
            @PathVariable Long id,
            RedirectAttributes redirectAttributes
    ) {
        addressService.deleteAddress(principal.id(), id);
        redirectAttributes.addFlashAttribute("message", "Đã xóa địa chỉ.");
        return "redirect:/profile";
    }
}
