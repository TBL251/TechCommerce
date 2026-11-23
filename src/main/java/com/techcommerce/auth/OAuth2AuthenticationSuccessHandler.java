package com.techcommerce.auth;

import com.techcommerce.common.cart.GuestCartMerger;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.io.IOException;
import java.time.Instant;
import java.util.Optional;

@Component
public class OAuth2AuthenticationSuccessHandler implements AuthenticationSuccessHandler {

    private final UserRepository userRepository;
    private final JwtService jwtService;
    private final Optional<GuestCartMerger> guestCartMerger;

    public OAuth2AuthenticationSuccessHandler(
            UserRepository userRepository,
            JwtService jwtService,
            @Autowired(required = false) GuestCartMerger guestCartMerger
    ) {
        this.userRepository = userRepository;
        this.jwtService = jwtService;
        this.guestCartMerger = Optional.ofNullable(guestCartMerger);
    }

    @Override
    @Transactional
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication)
            throws IOException {
        OAuth2User oauth2User = (OAuth2User) authentication.getPrincipal();
        String email = oauth2User.getAttribute("email");
        Boolean emailVerifiedAttr = oauth2User.getAttribute("email_verified");
        boolean emailVerified = Boolean.TRUE.equals(emailVerifiedAttr);
        String fullName = oauth2User.getAttribute("name");
        String providerId = oauth2User.getAttribute("sub");
        String avatarUrl = oauth2User.getAttribute("picture");

        handleGoogleSuccess(email, emailVerified, fullName, providerId, avatarUrl, request, response);
    }

    @Transactional
    public void handleGoogleSuccess(String email, boolean emailVerified, String fullName,
                                    String providerId, String avatarUrl,
                                    HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (!emailVerified || !StringUtils.hasText(email)) {
            response.sendRedirect(request.getContextPath() + "/auth/login?error=unverified_email");
            return;
        }

        Instant now = Instant.now();
        Optional<User> existingOpt = userRepository.findByEmailIgnoreCase(email.trim());
        User user;
        if (existingOpt.isPresent()) {
            user = existingOpt.get();
            if (!user.isEnabled() || user.isCurrentlyLocked(now)) {
                response.sendRedirect(request.getContextPath() + "/auth/login?error=account_disabled");
                return;
            }
            if (!StringUtils.hasText(user.getProviderId()) && StringUtils.hasText(providerId)) {
                user.setProviderId(providerId);
            }
            if (!StringUtils.hasText(user.getAvatarUrl()) && StringUtils.hasText(avatarUrl)) {
                user.setAvatarUrl(avatarUrl);
            }
            user = userRepository.save(user);
        } else {
            user = new User();
            user.setEmail(email.trim().toLowerCase());
            user.setFullName(StringUtils.hasText(fullName) ? fullName.trim() : email.trim());
            user.setRole("CUSTOMER");
            user.setAuthProvider("GOOGLE");
            user.setProviderId(providerId);
            user.setAvatarUrl(avatarUrl);
            user.setEnabled(true);
            user = userRepository.save(user);
        }

        String accessToken = jwtService.generateAccessToken(user);
        String refreshToken = jwtService.issueRefreshToken(user.getId());
        jwtService.addAuthCookies(response, accessToken, refreshToken);

        Long selectedStoreId = JwtService.readCookie(request, "SELECTED_STORE_ID")
                .map(val -> {
                    try { return Long.valueOf(val); } catch (NumberFormatException e) { return null; }
                })
                .orElse(null);
        Long finalUserId = user.getId();
        guestCartMerger.ifPresent(merger -> merger.mergeGuestCart(finalUserId, selectedStoreId, request, response));

        String targetUrl = ("ADMIN".equals(user.getRole()) || "STAFF".equals(user.getRole()))
                ? request.getContextPath() + "/admin/dashboard"
                : (StringUtils.hasText(request.getContextPath()) ? request.getContextPath() + "/" : "/");
        response.sendRedirect(targetUrl);
    }
}
