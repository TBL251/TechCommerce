package com.techcommerce.auth;

import com.techcommerce.common.mail.EmailService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
@ActiveProfiles("test")
@Transactional
class PasswordResetServiceTest {

    @Autowired
    private PasswordResetService passwordResetService;

    @Autowired
    private PasswordResetTokenRepository tokenRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private JwtService jwtService;

    @Autowired
    private RefreshTokenRepository refreshTokenRepository;

    @Autowired
    private EmailService emailService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    private User user;

    @BeforeEach
    void setUp() {
        userRepository.deleteAll();
        emailService.clearRecordedEmails();

        User u = new User();
        u.setEmail("resetme@techcommerce.store");
        u.setFullName("Reset User");
        u.setPasswordHash(passwordEncoder.encode("InitialPass123"));
        user = userRepository.save(u);
    }

    @Test
    void issuesSingleUseSha256TokenSendsEmailAndRevokesSessionsOnReset() {
        // Unknown email does not throw or leak
        assertThat(passwordResetService.requestPasswordReset("nonexistent@techcommerce.store")).isEmpty();
        assertThat(emailService.getRecordedEmails()).isEmpty();

        Optional<String> rawTokenOpt = passwordResetService.requestPasswordReset("resetme@techcommerce.store");
        assertThat(rawTokenOpt).isPresent();
        String rawToken = rawTokenOpt.get();

        assertThat(emailService.getRecordedEmails()).hasSize(1);
        assertThat(emailService.getRecordedEmails().get(0).body()).contains(rawToken);

        String activeRefresh = jwtService.issueRefreshToken(user.getId());

        // First use succeeds
        boolean resetOk = passwordResetService.resetPassword(rawToken, "BrandNewPass123!");
        assertThat(resetOk).isTrue();
        assertThat(passwordEncoder.matches("BrandNewPass123!", userRepository.findById(user.getId()).orElseThrow().getPasswordHash())).isTrue();

        // Active refresh tokens are revoked after password reset
        assertThat(refreshTokenRepository.findByTokenHash(JwtService.sha256Hex(activeRefresh)).orElseThrow().getRevokedAt()).isNotNull();

        // Second use with same token is rejected
        assertThat(passwordResetService.resetPassword(rawToken, "AnotherPass123!")).isFalse();
    }

    @Test
    void rejectsExpiredPasswordResetToken() {
        String rawToken = passwordResetService.requestPasswordReset("resetme@techcommerce.store").orElseThrow();
        PasswordResetToken stored = tokenRepository.findByTokenHash(JwtService.sha256Hex(rawToken)).orElseThrow();
        stored.setExpiresAt(Instant.now().minusSeconds(10));
        tokenRepository.save(stored);

        assertThat(passwordResetService.resetPassword(rawToken, "ExpiredPass123!")).isFalse();
    }
}
