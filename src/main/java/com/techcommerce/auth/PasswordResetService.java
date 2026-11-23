package com.techcommerce.auth;

import com.techcommerce.common.mail.EmailService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.security.SecureRandom;
import java.time.Instant;
import java.util.Base64;
import java.util.Optional;

@Service
public class PasswordResetService {

    private static final long RESET_TTL_SECONDS = 900; // 15 minutes

    private final UserRepository userRepository;
    private final PasswordResetTokenRepository tokenRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final EmailService emailService;
    private final String publicUrl;
    private final SecureRandom secureRandom = new SecureRandom();

    public PasswordResetService(
            UserRepository userRepository,
            PasswordResetTokenRepository tokenRepository,
            PasswordEncoder passwordEncoder,
            JwtService jwtService,
            EmailService emailService,
            @Value("${app.public-url:http://localhost:8080}") String publicUrl
    ) {
        this.userRepository = userRepository;
        this.tokenRepository = tokenRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
        this.emailService = emailService;
        this.publicUrl = publicUrl;
    }

    @Transactional
    public Optional<String> requestPasswordReset(String email) {
        if (!StringUtils.hasText(email)) {
            return Optional.empty();
        }
        Optional<User> userOpt = userRepository.findByEmailIgnoreCase(email.trim());
        if (userOpt.isEmpty() || !userOpt.get().isEnabled()) {
            return Optional.empty();
        }

        User user = userOpt.get();
        byte[] bytes = new byte[32];
        secureRandom.nextBytes(bytes);
        String rawToken = Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);

        PasswordResetToken resetToken = new PasswordResetToken();
        resetToken.setUserId(user.getId());
        resetToken.setTokenHash(JwtService.sha256Hex(rawToken));
        resetToken.setExpiresAt(Instant.now().plusSeconds(RESET_TTL_SECONDS));
        tokenRepository.save(resetToken);

        String resetUrl = publicUrl + "/auth/reset-password?token=" + rawToken;
        emailService.sendPasswordResetEmail(user.getEmail(), resetUrl);
        return Optional.of(rawToken);
    }

    @Transactional
    public boolean resetPassword(String rawToken, String newPassword) {
        if (!StringUtils.hasText(rawToken) || newPassword == null || newPassword.length() < 8) {
            return false;
        }
        Instant now = Instant.now();
        String hash = JwtService.sha256Hex(rawToken.trim());
        Optional<PasswordResetToken> tokenOpt = tokenRepository.findByTokenHash(hash);
        if (tokenOpt.isEmpty() || !tokenOpt.get().isValid(now)) {
            return false;
        }

        PasswordResetToken resetToken = tokenOpt.get();
        resetToken.setUsedAt(now);
        tokenRepository.save(resetToken);

        Optional<User> userOpt = userRepository.findById(resetToken.getUserId());
        if (userOpt.isEmpty() || !userOpt.get().isEnabled()) {
            return false;
        }

        User user = userOpt.get();
        user.setPasswordHash(passwordEncoder.encode(newPassword));
        user.setFailedLoginAttempts(0);
        user.setLockedUntil(null);
        userRepository.save(user);

        jwtService.revokeAllUserTokens(user.getId());
        return true;
    }
}
