package com.techcommerce.auth;

import jakarta.servlet.http.Cookie;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.transaction.annotation.Transactional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.cookie;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrl;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class AuthControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @BeforeEach
    void setUp() {
        userRepository.deleteAll();
    }

    @Test
    void registersNewCustomerSetsHttpOnlyCookiesAndEnforcesCsrf() throws Exception {
        // Without CSRF token -> 403 Forbidden
        mockMvc.perform(post("/auth/register")
                        .param("fullName", "Khách Hàng Mới")
                        .param("email", "newcustomer@techcommerce.store")
                        .param("phone", "0901112222")
                        .param("password", "Secret123!")
                        .param("confirmPassword", "Secret123!"))
                .andExpect(status().isForbidden());

        // With CSRF token -> 302 redirect + HttpOnly cookies + security headers
        mockMvc.perform(post("/auth/register")
                        .with(csrf())
                        .param("fullName", "Khách Hàng Mới")
                        .param("email", "newcustomer@techcommerce.store")
                        .param("phone", "0901112222")
                        .param("password", "Secret123!")
                        .param("confirmPassword", "Secret123!"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/"))
                .andExpect(cookie().exists(JwtService.ACCESS_COOKIE_NAME))
                .andExpect(cookie().httpOnly(JwtService.ACCESS_COOKIE_NAME, true))
                .andExpect(cookie().exists(JwtService.REFRESH_COOKIE_NAME))
                .andExpect(header().string("X-Content-Type-Options", "nosniff"))
                .andExpect(header().string("X-Frame-Options", "SAMEORIGIN"));

        User created = userRepository.findByEmailIgnoreCase("newcustomer@techcommerce.store").orElseThrow();
        assertThat(passwordEncoder.matches("Secret123!", created.getPasswordHash())).isTrue();
    }

    @Test
    void locksAccountFor15MinutesAfter5ConsecutiveFailedLoginAttempts() throws Exception {
        User u = new User();
        u.setEmail("locktest@techcommerce.store");
        u.setFullName("Lock User");
        u.setPasswordHash(passwordEncoder.encode("CorrectPass123"));
        u.setRole("CUSTOMER");
        userRepository.save(u);

        for (int i = 1; i <= 5; i++) {
            mockMvc.perform(post("/auth/login")
                            .with(csrf())
                            .param("email", "locktest@techcommerce.store")
                            .param("password", "WrongPass"))
                    .andExpect(status().isUnauthorized());
        }

        User locked = userRepository.findByEmailIgnoreCase("locktest@techcommerce.store").orElseThrow();
        assertThat(locked.getFailedLoginAttempts()).isEqualTo(5);
        assertThat(locked.getLockedUntil()).isNotNull();

        // Even with the right password, login is blocked while locked
        mockMvc.perform(post("/auth/login")
                        .with(csrf())
                        .param("email", "locktest@techcommerce.store")
                        .param("password", "CorrectPass123"))
                .andExpect(status().isLocked());
    }

    @Test
    void customerCannotAccessAdminRoutesAndGoogleOnlyUserDoesNotCrashLocalLogin() throws Exception {
        User googleOnly = new User();
        googleOnly.setEmail("googleonly@techcommerce.store");
        googleOnly.setFullName("Google User");
        googleOnly.setAuthProvider("GOOGLE");
        googleOnly.setPasswordHash(null);
        googleOnly.setRole("CUSTOMER");
        userRepository.save(googleOnly);

        mockMvc.perform(post("/auth/login")
                        .with(csrf())
                        .param("email", "googleonly@techcommerce.store")
                        .param("password", "AnyPass123"))
                .andExpect(status().isUnauthorized());

        // Login as CUSTOMER and attempt to access /admin/users
        User customer = new User();
        customer.setEmail("cust@techcommerce.store");
        customer.setFullName("Customer");
        customer.setPasswordHash(passwordEncoder.encode("CustPass123"));
        customer.setRole("CUSTOMER");
        userRepository.save(customer);

        MvcResult loginResult = mockMvc.perform(post("/auth/login")
                        .with(csrf())
                        .param("email", "cust@techcommerce.store")
                        .param("password", "CustPass123"))
                .andExpect(status().is3xxRedirection())
                .andReturn();

        Cookie accessCookie = loginResult.getResponse().getCookie(JwtService.ACCESS_COOKIE_NAME);
        assertThat(accessCookie).isNotNull();

        mockMvc.perform(get("/admin/users").cookie(accessCookie))
                .andExpect(status().isForbidden());
    }
}
