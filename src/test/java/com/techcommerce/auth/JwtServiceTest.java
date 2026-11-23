package com.techcommerce.auth;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
@ActiveProfiles("test")
@Transactional
class JwtServiceTest {

    @Autowired
    private JwtService jwtService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RefreshTokenRepository refreshTokenRepository;

    private User savedUser;

    @BeforeEach
    void setUp() {
        User u = new User();
        u.setEmail("jwtuser@techcommerce.store");
        u.setFullName("JWT Tester");
        u.setRole("CUSTOMER");
        u.setEnabled(true);
        savedUser = userRepository.save(u);
    }

    @Test
    void generatesAndParsesValidAccessToken() {
        String token = jwtService.generateAccessToken(savedUser);

        Optional<UserPrincipal> parsed = jwtService.parseAccessToken(token);
        assertThat(parsed).isPresent();
        assertThat(parsed.get().id()).isEqualTo(savedUser.getId());
        assertThat(parsed.get().email()).isEqualTo("jwtuser@techcommerce.store");
        assertThat(parsed.get().role()).isEqualTo("CUSTOMER");
        assertThat(jwtService.parseAccessToken(token + "tampered")).isEmpty();
    }

    @Test
    void issuesRotatesAndRevokesRefreshTokenStoredAsSha256Hash() {
        String rawRefresh = jwtService.issueRefreshToken(savedUser.getId());
        String expectedHash = JwtService.sha256Hex(rawRefresh);

        Optional<RefreshToken> stored = refreshTokenRepository.findByTokenHash(expectedHash);
        assertThat(stored).isPresent();
        assertThat(stored.get().getRevokedAt()).isNull();

        MockHttpServletResponse response = new MockHttpServletResponse();
        Optional<User> rotatedUser = jwtService.rotateRefreshToken(rawRefresh, response);
        assertThat(rotatedUser).isPresent();
        assertThat(response.getCookie(JwtService.ACCESS_COOKIE_NAME)).isNotNull();
        assertThat(response.getCookie(JwtService.REFRESH_COOKIE_NAME)).isNotNull();

        // Old refresh token cannot be used a second time
        assertThat(refreshTokenRepository.findByTokenHash(expectedHash).orElseThrow().getRevokedAt()).isNotNull();
        assertThat(jwtService.rotateRefreshToken(rawRefresh, new MockHttpServletResponse())).isEmpty();
    }
}
