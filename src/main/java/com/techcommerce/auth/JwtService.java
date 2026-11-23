package com.techcommerce.auth;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.time.Instant;
import java.util.Base64;
import java.util.Date;
import java.util.HexFormat;
import java.util.Optional;

@Service
public class JwtService {

    public static final String ACCESS_COOKIE_NAME = "ACCESS_TOKEN";
    public static final String REFRESH_COOKIE_NAME = "REFRESH_TOKEN";

    private final SecretKey secretKey;
    private final long accessExpirationSeconds;
    private final long refreshExpirationSeconds;
    private final boolean cookieSecure;
    private final RefreshTokenRepository refreshTokenRepository;
    private final UserRepository userRepository;
    private final SecureRandom secureRandom = new SecureRandom();

    public JwtService(
            @Value("${app.jwt.secret}") String secret,
            @Value("${app.jwt.access-expiration-seconds:1200}") long accessExpirationSeconds,
            @Value("${app.jwt.refresh-expiration-seconds:604800}") long refreshExpirationSeconds,
            @Value("${app.cookie-secure:false}") boolean cookieSecure,
            RefreshTokenRepository refreshTokenRepository,
            UserRepository userRepository
    ) {
        this.secretKey = Keys.hmacShaKeyFor(secret.getBytes(StandardCharsets.UTF_8));
        this.accessExpirationSeconds = accessExpirationSeconds;
        this.refreshExpirationSeconds = refreshExpirationSeconds;
        this.cookieSecure = cookieSecure;
        this.refreshTokenRepository = refreshTokenRepository;
        this.userRepository = userRepository;
    }

    public String generateAccessToken(User user) {
        Instant now = Instant.now();
        var builder = Jwts.builder()
                .subject(String.valueOf(user.getId()))
                .claim("email", user.getEmail())
                .claim("fullName", user.getFullName())
                .claim("role", user.getRole())
                .issuedAt(Date.from(now))
                .expiration(Date.from(now.plusSeconds(accessExpirationSeconds)));
        if (user.getStoreId() != null) {
            builder.claim("storeId", user.getStoreId());
        }
        return builder.signWith(secretKey).compact();
    }

    public Optional<UserPrincipal> parseAccessToken(String token) {
        if (!StringUtils.hasText(token)) {
            return Optional.empty();
        }
        try {
            Claims claims = Jwts.parser()
                    .verifyWith(secretKey)
                    .build()
                    .parseSignedClaims(token)
                    .getPayload();
            Long userId = Long.valueOf(claims.getSubject());
            String email = claims.get("email", String.class);
            String fullName = claims.get("fullName", String.class);
            String role = claims.get("role", String.class);
            Number storeNum = claims.get("storeId", Number.class);
            Long storeId = storeNum != null ? storeNum.longValue() : null;
            return Optional.of(new UserPrincipal(userId, email, fullName, role, storeId));
        } catch (JwtException | IllegalArgumentException ex) {
            return Optional.empty();
        }
    }

    @Transactional
    public String issueRefreshToken(Long userId) {
        byte[] bytes = new byte[32];
        secureRandom.nextBytes(bytes);
        String rawToken = Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);

        RefreshToken entity = new RefreshToken();
        entity.setUserId(userId);
        entity.setTokenHash(sha256Hex(rawToken));
        entity.setExpiresAt(Instant.now().plusSeconds(refreshExpirationSeconds));
        refreshTokenRepository.save(entity);
        return rawToken;
    }

    @Transactional
    public Optional<User> rotateRefreshToken(String rawRefreshToken, HttpServletResponse response) {
        if (!StringUtils.hasText(rawRefreshToken)) {
            return Optional.empty();
        }
        Instant now = Instant.now();
        String hash = sha256Hex(rawRefreshToken);
        Optional<RefreshToken> existingOpt = refreshTokenRepository.findByTokenHash(hash);
        if (existingOpt.isEmpty() || !existingOpt.get().isActive(now)) {
            return Optional.empty();
        }

        RefreshToken existing = existingOpt.get();
        existing.setRevokedAt(now);
        refreshTokenRepository.save(existing);

        Optional<User> userOpt = userRepository.findById(existing.getUserId());
        if (userOpt.isEmpty()) {
            return Optional.empty();
        }
        User user = userOpt.get();
        if (!user.isEnabled() || user.isCurrentlyLocked(now)) {
            return Optional.empty();
        }

        String newAccess = generateAccessToken(user);
        String newRefresh = issueRefreshToken(user.getId());
        addAuthCookies(response, newAccess, newRefresh);
        return Optional.of(user);
    }

    @Transactional
    public void revokeRefreshToken(String rawRefreshToken) {
        if (!StringUtils.hasText(rawRefreshToken)) {
            return;
        }
        refreshTokenRepository.findByTokenHash(sha256Hex(rawRefreshToken)).ifPresent(rt -> {
            if (rt.getRevokedAt() == null) {
                rt.setRevokedAt(Instant.now());
                refreshTokenRepository.save(rt);
            }
        });
    }

    @Transactional
    public void revokeAllUserTokens(Long userId) {
        refreshTokenRepository.revokeAllActiveByUserId(userId, Instant.now());
    }

    public void addAuthCookies(HttpServletResponse response, String accessToken, String refreshToken) {
        response.addCookie(buildCookie(ACCESS_COOKIE_NAME, accessToken, (int) accessExpirationSeconds));
        response.addCookie(buildCookie(REFRESH_COOKIE_NAME, refreshToken, (int) refreshExpirationSeconds));
    }

    public void clearAuthCookies(HttpServletResponse response) {
        response.addCookie(buildCookie(ACCESS_COOKIE_NAME, "", 0));
        response.addCookie(buildCookie(REFRESH_COOKIE_NAME, "", 0));
    }

    public static Optional<String> readCookie(HttpServletRequest request, String name) {
        Cookie[] cookies = request.getCookies();
        if (cookies == null) {
            return Optional.empty();
        }
        for (Cookie cookie : cookies) {
            if (name.equals(cookie.getName()) && StringUtils.hasText(cookie.getValue())) {
                return Optional.of(cookie.getValue());
            }
        }
        return Optional.empty();
    }

    private Cookie buildCookie(String name, String value, int maxAgeSeconds) {
        Cookie cookie = new Cookie(name, value);
        cookie.setHttpOnly(true);
        cookie.setSecure(cookieSecure);
        cookie.setPath("/");
        cookie.setMaxAge(maxAgeSeconds);
        cookie.setAttribute("SameSite", "Lax");
        return cookie;
    }

    public static String sha256Hex(String raw) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hashed = digest.digest(raw.getBytes(StandardCharsets.UTF_8));
            return HexFormat.of().formatHex(hashed);
        } catch (NoSuchAlgorithmException ex) {
            throw new IllegalStateException("SHA-256 not available", ex);
        }
    }
}
