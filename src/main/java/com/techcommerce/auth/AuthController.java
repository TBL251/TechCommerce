package com.techcommerce.auth;

import com.techcommerce.common.cart.GuestCartMerger;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.Instant;
import java.util.Optional;

@Controller
@RequestMapping("/auth")
public class AuthController {

    private static final int MAX_FAILED_ATTEMPTS = 5;
    private static final long LOCK_DURATION_SECONDS = 900; // 15 minutes

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final Optional<GuestCartMerger> guestCartMerger;

    public AuthController(
            UserRepository userRepository,
            PasswordEncoder passwordEncoder,
            JwtService jwtService,
            @Autowired(required = false) GuestCartMerger guestCartMerger
    ) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
        this.guestCartMerger = Optional.ofNullable(guestCartMerger);
    }

    @GetMapping("/login")
    public String loginPage(@RequestParam(required = false) String error,
                            @RequestParam(required = false) String logout,
                            Model model) {
        if (StringUtils.hasText(error)) {
            model.addAttribute("error", "Đăng nhập không thành công hoặc tài khoản đã bị khóa.");
        }
        if (StringUtils.hasText(logout)) {
            model.addAttribute("message", "Bạn đã đăng xuất khỏi hệ thống.");
        }
        return "auth/login";
    }

    @GetMapping("/register")
    public String registerPage() {
        return "auth/register";
    }

    @PostMapping("/register")
    @Transactional
    public String register(
            @RequestParam String fullName,
            @RequestParam String email,
            @RequestParam(required = false) String phone,
            @RequestParam String password,
            @RequestParam String confirmPassword,
            HttpServletRequest request,
            HttpServletResponse response,
            Model model
    ) {
        String cleanEmail = email != null ? email.trim().toLowerCase() : "";
        model.addAttribute("fullName", fullName);
        model.addAttribute("email", cleanEmail);
        model.addAttribute("phone", phone);

        if (!StringUtils.hasText(fullName) || !StringUtils.hasText(cleanEmail)) {
            response.setStatus(HttpStatus.BAD_REQUEST.value());
            model.addAttribute("error", "Vui lòng nhập đầy đủ họ tên và email.");
            return "auth/register";
        }
        if (password == null || password.length() < 8 || !password.equals(confirmPassword)) {
            response.setStatus(HttpStatus.BAD_REQUEST.value());
            model.addAttribute("error", "Mật khẩu phải từ 8 ký tự trở lên và khớp xác nhận.");
            return "auth/register";
        }
        if (userRepository.existsByEmailIgnoreCase(cleanEmail)) {
            response.setStatus(HttpStatus.CONFLICT.value());
            model.addAttribute("error", "Email này đã được đăng ký trong hệ thống.");
            return "auth/register";
        }

        User user = new User();
        user.setEmail(cleanEmail);
        user.setFullName(fullName.trim());
        user.setPhone(StringUtils.hasText(phone) ? phone.trim() : null);
        user.setPasswordHash(passwordEncoder.encode(password));
        user.setRole("CUSTOMER");
        user.setAuthProvider("LOCAL");
        user.setEnabled(true);
        user = userRepository.save(user);

        issueTokensAndMergeCart(user, request, response);
        return "redirect:/";
    }

    @PostMapping("/login")
    @Transactional
    public String login(
            @RequestParam String email,
            @RequestParam String password,
            HttpServletRequest request,
            HttpServletResponse response,
            Model model
    ) {
        String cleanEmail = email != null ? email.trim().toLowerCase() : "";
        model.addAttribute("email", cleanEmail);

        Optional<User> userOpt = userRepository.findByEmailIgnoreCase(cleanEmail);
        if (userOpt.isEmpty()) {
            response.setStatus(HttpStatus.UNAUTHORIZED.value());
            model.addAttribute("error", "Email hoặc mật khẩu không chính xác.");
            return "auth/login";
        }

        User user = userOpt.get();
        Instant now = Instant.now();

        if (!user.isEnabled()) {
            response.setStatus(HttpStatus.FORBIDDEN.value());
            model.addAttribute("error", "Tài khoản của bạn đã bị khóa bởi quản trị viên.");
            return "auth/login";
        }

        if (user.isCurrentlyLocked(now)) {
            response.setStatus(HttpStatus.LOCKED.value());
            model.addAttribute("error", "Tài khoản đang bị tạm khóa 15 phút do nhập sai mật khẩu quá 5 lần.");
            return "auth/login";
        }

        if (!StringUtils.hasText(user.getPasswordHash())) {
            response.setStatus(HttpStatus.UNAUTHORIZED.value());
            model.addAttribute("error", "Tài khoản này được tạo bằng Google. Vui lòng đăng nhập bằng Google hoặc dùng Quên mật khẩu.");
            return "auth/login";
        }

        if (!passwordEncoder.matches(password != null ? password : "", user.getPasswordHash())) {
            int attempts = user.getFailedLoginAttempts() + 1;
            user.setFailedLoginAttempts(attempts);
            if (attempts >= MAX_FAILED_ATTEMPTS) {
                user.setLockedUntil(now.plusSeconds(LOCK_DURATION_SECONDS));
            }
            userRepository.save(user);
            response.setStatus(HttpStatus.UNAUTHORIZED.value());
            model.addAttribute("error", "Email hoặc mật khẩu không chính xác.");
            return "auth/login";
        }

        user.setFailedLoginAttempts(0);
        user.setLockedUntil(null);
        userRepository.save(user);

        issueTokensAndMergeCart(user, request, response);
        if ("ADMIN".equals(user.getRole()) || "STAFF".equals(user.getRole())) {
            return "redirect:/admin/dashboard";
        }
        return "redirect:/";
    }

    @PostMapping("/logout")
    @Transactional
    public String logout(HttpServletRequest request, HttpServletResponse response) {
        JwtService.readCookie(request, JwtService.REFRESH_COOKIE_NAME)
                .ifPresent(jwtService::revokeRefreshToken);
        jwtService.clearAuthCookies(response);
        SecurityContextHolder.clearContext();
        return "redirect:/auth/login?logout=true";
    }

    private void issueTokensAndMergeCart(User user, HttpServletRequest request, HttpServletResponse response) {
        String accessToken = jwtService.generateAccessToken(user);
        String refreshToken = jwtService.issueRefreshToken(user.getId());
        jwtService.addAuthCookies(response, accessToken, refreshToken);

        Long selectedStoreId = JwtService.readCookie(request, "SELECTED_STORE_ID")
                .map(val -> {
                    try { return Long.valueOf(val); } catch (NumberFormatException e) { return null; }
                })
                .orElse(null);
        Long userId = user.getId();
        guestCartMerger.ifPresent(merger -> merger.mergeGuestCart(userId, selectedStoreId, request, response));
    }
}
