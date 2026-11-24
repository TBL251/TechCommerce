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
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.flash;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.model;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrl;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.view;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class UserControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UserAddressRepository addressRepository;

    @Autowired
    private PasswordResetService passwordResetService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtService jwtService;

    private User user;
    private Cookie authCookie;

    @BeforeEach
    void setUp() {
        userRepository.deleteAll();
        User u = new User();
        u.setEmail("profileuser@techcommerce.store");
        u.setFullName("Profile User");
        u.setPhone("0901112222");
        u.setPasswordHash(passwordEncoder.encode("InitialPass123!"));
        u.setRole("CUSTOMER");
        u.setEnabled(true);
        user = userRepository.saveAndFlush(u);
        authCookie = new Cookie(JwtService.ACCESS_COOKIE_NAME, jwtService.generateAccessToken(user));
    }

    @Test
    void forgotAndResetPasswordEndpointsValidateTokensAndUpdatePassword() throws Exception {
        mockMvc.perform(get("/auth/forgot-password"))
                .andExpect(status().isOk())
                .andExpect(view().name("auth/forgot-password"));

        mockMvc.perform(post("/auth/forgot-password")
                        .with(csrf())
                        .param("email", "profileuser@techcommerce.store"))
                .andExpect(status().isOk())
                .andExpect(view().name("auth/forgot-password"))
                .andExpect(model().attributeExists("message"));

        String rawToken = passwordResetService.requestPasswordReset("profileuser@techcommerce.store").orElseThrow();

        mockMvc.perform(get("/auth/reset-password").param("token", rawToken))
                .andExpect(status().isOk())
                .andExpect(view().name("auth/reset-password"))
                .andExpect(model().attribute("token", rawToken));

        // Mismatched confirmPassword stays on reset-password with error
        mockMvc.perform(post("/auth/reset-password")
                        .with(csrf())
                        .param("token", rawToken)
                        .param("newPassword", "NewSecret123!")
                        .param("confirmPassword", "Mismatch123!"))
                .andExpect(status().isOk())
                .andExpect(view().name("auth/reset-password"))
                .andExpect(model().attributeExists("error"));

        // Invalid token stays on reset-password with error
        mockMvc.perform(post("/auth/reset-password")
                        .with(csrf())
                        .param("token", "invalid-token")
                        .param("newPassword", "NewSecret123!")
                        .param("confirmPassword", "NewSecret123!"))
                .andExpect(status().isOk())
                .andExpect(view().name("auth/reset-password"))
                .andExpect(model().attributeExists("error"));

        // Valid token resets password and redirects to /auth/login
        mockMvc.perform(post("/auth/reset-password")
                        .with(csrf())
                        .param("token", rawToken)
                        .param("newPassword", "NewSecret123!")
                        .param("confirmPassword", "NewSecret123!"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/auth/login"))
                .andExpect(flash().attributeExists("message"));

        User updated = userRepository.findById(user.getId()).orElseThrow();
        assertThat(passwordEncoder.matches("NewSecret123!", updated.getPasswordHash())).isTrue();
    }

    @Test
    void profileUpdateChangePasswordAndAddressBookCrudEndpointsWorkEndToEnd() throws Exception {
        mockMvc.perform(get("/profile").cookie(authCookie))
                .andExpect(status().isOk())
                .andExpect(view().name("auth/profile"))
                .andExpect(model().attributeExists("user", "addresses"));

        // Update profile
        mockMvc.perform(post("/profile/update")
                        .with(csrf())
                        .cookie(authCookie)
                        .param("fullName", "Updated Name")
                        .param("phone", "0909998888"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/profile"))
                .andExpect(flash().attributeExists("message"));
        assertThat(userRepository.findById(user.getId()).orElseThrow().getFullName()).isEqualTo("Updated Name");

        // Blank name flashes error
        mockMvc.perform(post("/profile/update")
                        .with(csrf())
                        .cookie(authCookie)
                        .param("fullName", "   "))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/profile"))
                .andExpect(flash().attributeExists("error"));

        // Change password mismatch -> error flash
        mockMvc.perform(post("/profile/change-password")
                        .with(csrf())
                        .cookie(authCookie)
                        .param("currentPassword", "InitialPass123!")
                        .param("newPassword", "NextPass123!")
                        .param("confirmPassword", "Different123!"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/profile"))
                .andExpect(flash().attributeExists("error"));

        // Change password wrong current -> error flash
        mockMvc.perform(post("/profile/change-password")
                        .with(csrf())
                        .cookie(authCookie)
                        .param("currentPassword", "WrongCurrent!")
                        .param("newPassword", "NextPass123!")
                        .param("confirmPassword", "NextPass123!"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/profile"))
                .andExpect(flash().attributeExists("error"));

        // Change password valid -> message flash
        mockMvc.perform(post("/profile/change-password")
                        .with(csrf())
                        .cookie(authCookie)
                        .param("currentPassword", "InitialPass123!")
                        .param("newPassword", "NextPass123!")
                        .param("confirmPassword", "NextPass123!"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/profile"))
                .andExpect(flash().attributeExists("message"));

        // Add two addresses, switch default, and delete
        mockMvc.perform(post("/profile/addresses")
                        .with(csrf())
                        .cookie(authCookie)
                        .param("recipientName", "Người Nhận 1")
                        .param("phone", "0901111111")
                        .param("addressLine", "100 Cầu Giấy")
                        .param("city", "Hà Nội")
                        .param("defaultAddress", "true"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/profile"))
                .andExpect(flash().attributeExists("message"));

        mockMvc.perform(post("/profile/addresses")
                        .with(csrf())
                        .cookie(authCookie)
                        .param("recipientName", "Người Nhận 2")
                        .param("phone", "0902222222")
                        .param("addressLine", "200 Lê Lợi")
                        .param("city", "TP.HCM")
                        .param("defaultAddress", "false"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/profile"));

        List<UserAddress> addresses = addressRepository.findByUserIdOrderByDefaultAddressDescIdDesc(user.getId());
        assertThat(addresses).hasSize(2);
        Long secondId = addresses.get(1).getId();

        mockMvc.perform(post("/profile/addresses/" + secondId + "/default")
                        .with(csrf())
                        .cookie(authCookie))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/profile"))
                .andExpect(flash().attributeExists("message"));

        assertThat(addressRepository.findById(secondId).orElseThrow().isDefaultAddress()).isTrue();

        mockMvc.perform(post("/profile/addresses/" + secondId + "/delete")
                        .with(csrf())
                        .cookie(authCookie))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/profile"))
                .andExpect(flash().attributeExists("message"));

        assertThat(addressRepository.findByUserIdOrderByDefaultAddressDescIdDesc(user.getId())).hasSize(1);
    }
}
