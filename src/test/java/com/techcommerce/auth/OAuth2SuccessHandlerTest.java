package com.techcommerce.auth;

import com.techcommerce.common.cart.GuestCartMerger;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import java.util.concurrent.atomic.AtomicLong;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
@ActiveProfiles("test")
@Transactional
class OAuth2SuccessHandlerTest {

    @TestConfiguration
    static class MergerTestConfig {
        static final AtomicLong LAST_MERGED_USER_ID = new AtomicLong(0);

        @Bean
        public GuestCartMerger testGuestCartMerger() {
            return (Long userId, Long selectedStoreId, HttpServletRequest req, HttpServletResponse res) ->
                    LAST_MERGED_USER_ID.set(userId);
        }
    }

    @Autowired
    private OAuth2AuthenticationSuccessHandler successHandler;

    @Autowired
    private UserRepository userRepository;

    @BeforeEach
    void setUp() {
        userRepository.deleteAll();
        MergerTestConfig.LAST_MERGED_USER_ID.set(0);
    }

    @Test
    void createsOrLinksVerifiedGoogleUserSetsJwtCookiesAndCallsGuestCartMerger() throws Exception {
        MockHttpServletRequest request = new MockHttpServletRequest();
        MockHttpServletResponse response = new MockHttpServletResponse();

        successHandler.handleGoogleSuccess(
                "googlebuyer@techcommerce.store",
                true,
                "Google Buyer",
                "google-sub-123",
                "https://lh3.googleusercontent.com/a/avatar",
                request,
                response
        );

        assertThat(response.getRedirectedUrl()).isEqualTo("/");
        assertThat(response.getCookie(JwtService.ACCESS_COOKIE_NAME)).isNotNull();
        assertThat(response.getCookie(JwtService.REFRESH_COOKIE_NAME)).isNotNull();

        User created = userRepository.findByEmailIgnoreCase("googlebuyer@techcommerce.store").orElseThrow();
        assertThat(created.getAuthProvider()).isEqualTo("GOOGLE");
        assertThat(created.getProviderId()).isEqualTo("google-sub-123");
        assertThat(MergerTestConfig.LAST_MERGED_USER_ID.get()).isEqualTo(created.getId());
    }

    @Test
    void rejectsDisabledOrUnverifiedGoogleAccountWithoutIssuingCookies() throws Exception {
        MockHttpServletRequest req1 = new MockHttpServletRequest();
        MockHttpServletResponse res1 = new MockHttpServletResponse();

        successHandler.handleGoogleSuccess("unverified@techcommerce.store", false, "Unverified", "sub-1", null, req1, res1);
        assertThat(res1.getCookie(JwtService.ACCESS_COOKIE_NAME)).isNull();
        assertThat(res1.getRedirectedUrl()).isEqualTo("/auth/login?error=unverified_email");

        User disabled = new User();
        disabled.setEmail("banned@techcommerce.store");
        disabled.setFullName("Banned User");
        disabled.setEnabled(false);
        userRepository.save(disabled);

        MockHttpServletRequest req2 = new MockHttpServletRequest();
        MockHttpServletResponse res2 = new MockHttpServletResponse();
        successHandler.handleGoogleSuccess("banned@techcommerce.store", true, "Banned User", "sub-2", null, req2, res2);
        assertThat(res2.getCookie(JwtService.ACCESS_COOKIE_NAME)).isNull();
        assertThat(res2.getRedirectedUrl()).isEqualTo("/auth/login?error=account_disabled");
    }

    @Test
    void onAuthenticationSuccessExtractsOAuth2UserLinksExistingLocalAccountAndRedirectsByRole() throws Exception {
        User existingAdmin = new User();
        existingAdmin.setEmail("admin.oauth@techcommerce.store");
        existingAdmin.setFullName("Admin OAuth");
        existingAdmin.setRole("ADMIN");
        existingAdmin.setAuthProvider("LOCAL");
        existingAdmin.setEnabled(true);
        userRepository.saveAndFlush(existingAdmin);

        org.springframework.security.oauth2.core.user.OAuth2User oauth2User =
                new org.springframework.security.oauth2.core.user.DefaultOAuth2User(
                        java.util.List.of(new org.springframework.security.core.authority.SimpleGrantedAuthority("ROLE_USER")),
                        java.util.Map.of(
                                "email", "admin.oauth@techcommerce.store",
                                "email_verified", true,
                                "name", "Admin OAuth",
                                "sub", "google-admin-sub",
                                "picture", "https://lh3.googleusercontent.com/a/admin"
                        ),
                        "email"
                );
        org.springframework.security.core.Authentication auth =
                new org.springframework.security.authentication.TestingAuthenticationToken(oauth2User, null);

        MockHttpServletRequest req = new MockHttpServletRequest();
        MockHttpServletResponse res = new MockHttpServletResponse();
        successHandler.onAuthenticationSuccess(req, res, auth);

        assertThat(res.getRedirectedUrl()).isEqualTo("/admin/users");
        User linked = userRepository.findByEmailIgnoreCase("admin.oauth@techcommerce.store").orElseThrow();
        assertThat(linked.getProviderId()).isEqualTo("google-admin-sub");
        assertThat(linked.getAvatarUrl()).isEqualTo("https://lh3.googleusercontent.com/a/admin");
    }
}
