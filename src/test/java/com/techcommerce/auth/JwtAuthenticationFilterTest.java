package com.techcommerce.auth;

import jakarta.servlet.http.Cookie;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.HttpHeaders;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrl;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class JwtAuthenticationFilterTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private JwtService jwtService;

    private User customer;

    @BeforeEach
    void setUp() {
        userRepository.deleteAll();
        User u = new User();
        u.setEmail("filteruser@techcommerce.store");
        u.setFullName("Filter Tester");
        u.setRole("CUSTOMER");
        u.setEnabled(true);
        customer = userRepository.saveAndFlush(u);
    }

    @Test
    void autoRotatesMissingAccessTokenUsingValidRefreshTokenCookie() throws Exception {
        String rawRefresh = jwtService.issueRefreshToken(customer.getId());

        MvcResult res = mockMvc.perform(get("/profile")
                        .cookie(new Cookie(JwtService.REFRESH_COOKIE_NAME, rawRefresh)))
                .andExpect(status().isOk())
                .andReturn();

        assertThat(res.getResponse().getCookie(JwtService.ACCESS_COOKIE_NAME)).isNotNull();
        assertThat(res.getResponse().getCookie(JwtService.REFRESH_COOKIE_NAME)).isNotNull();
        assertThat(res.getResponse().getCookie(JwtService.REFRESH_COOKIE_NAME).getValue()).isNotEqualTo(rawRefresh);
    }

    @Test
    void authenticatesViaAuthorizationBearerHeaderAndRejectsLockedUser() throws Exception {
        String accessToken = jwtService.generateAccessToken(customer);

        mockMvc.perform(get("/profile")
                        .header(HttpHeaders.AUTHORIZATION, "Bearer " + accessToken))
                .andExpect(status().isOk());

        // Lock the user and verify existing access token is rejected at the filter
        customer.setLockedUntil(Instant.now().plusSeconds(600));
        userRepository.saveAndFlush(customer);

        mockMvc.perform(get("/profile")
                        .header(HttpHeaders.AUTHORIZATION, "Bearer " + accessToken))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/auth/login"));
    }
}
