package com.techcommerce.auth;

import com.techcommerce.common.mail.EmailService;
import com.techcommerce.store.Store;
import com.techcommerce.store.StoreRepository;
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
    private StoreRepository storeRepository;

    @Autowired
    private EmailVerificationOtpRepository otpRepository;

    @Autowired
    private EmailService emailService;

    @Autowired
    private RefreshTokenRepository refreshTokenRepository;

    @Autowired
    private JwtService jwtService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @BeforeEach
    void setUp() {
        userRepository.deleteAll();
        otpRepository.deleteAll();
    }

    @Test
    void registrationSendOtpEnforcesCsrfAndRejectsExistingEmail() throws Exception {
        // Without CSRF token -> 403 Forbidden
        mockMvc.perform(post("/auth/register/send-otp")
                        .param("fullName", "Khách Hàng Mới")
                        .param("email", "newcustomer@techcommerce.store")
                        .param("phone", "0901112222")
                        .param("password", "Secret123!")
                        .param("confirmPassword", "Secret123!"))
                .andExpect(status().isForbidden());

        // With CSRF -> 200 (renders register-otp view), no JWT cookie yet
        mockMvc.perform(post("/auth/register/send-otp")
                        .with(csrf())
                        .param("fullName", "Khách Hàng Mới")
                        .param("email", "newcustomer@techcommerce.store")
                        .param("phone", "0901112222")
                        .param("password", "Secret123!")
                        .param("confirmPassword", "Secret123!"))
                .andExpect(status().isOk())
                .andExpect(result -> assertThat(result.getResponse().getCookie(JwtService.ACCESS_COOKIE_NAME)).isNull());

        // Email already registered -> 409
        User existing = new User();
        existing.setEmail("taken@techcommerce.store");
        existing.setFullName("Taken User");
        existing.setPasswordHash(passwordEncoder.encode("Pass123!"));
        existing.setRole("CUSTOMER");
        userRepository.save(existing);

        mockMvc.perform(post("/auth/register/send-otp")
                        .with(csrf())
                        .param("fullName", "Người Dùng Mới")
                        .param("email", "taken@techcommerce.store")
                        .param("password", "Secret123!")
                        .param("confirmPassword", "Secret123!"))
                .andExpect(status().isConflict());
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

        // STAFF can enter the Branch Admin Center (GET /admin/dashboard) but CANNOT access /admin/users or create staff (ADMIN only)
        Store store = storeRepository.findByCode("HN-01").orElseGet(() -> {
            Store st = new Store();
            st.setCode("HN-01");
            st.setName("TechCommerce Hà Nội");
            st.setAddress("120 Thái Hà");
            st.setCity("Hà Nội");
            st.setPhone("02473008899");
            return storeRepository.saveAndFlush(st);
        });
        User staff = new User();
        staff.setEmail("staff@techcommerce.store");
        staff.setFullName("Staff Member");
        staff.setPasswordHash(passwordEncoder.encode("StaffPass123"));
        staff.setRole("STAFF");
        staff.setStoreId(store.getId());
        userRepository.save(staff);

        MvcResult staffLogin = mockMvc.perform(post("/auth/login")
                        .with(csrf())
                        .param("email", "staff@techcommerce.store")
                        .param("password", "StaffPass123"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/admin/dashboard"))
                .andReturn();

        Cookie staffCookie = staffLogin.getResponse().getCookie(JwtService.ACCESS_COOKIE_NAME);
        assertThat(staffCookie).isNotNull();

        mockMvc.perform(get("/admin/dashboard").cookie(staffCookie))
                .andExpect(status().isOk());

        mockMvc.perform(get("/admin/users").cookie(staffCookie))
                .andExpect(status().isForbidden());

        mockMvc.perform(post("/admin/users/staff")
                        .with(csrf())
                        .cookie(staffCookie)
                        .param("fullName", "Unauthorized Staff")
                        .param("email", "unauth@techcommerce.store")
                        .param("password", "Pass1234!"))
                .andExpect(status().isForbidden());

        // Repeated navigation to unimplemented/404 feature routes preserves currentUser in model & request
        for (String path : new String[]{"/products", "/orders", "/cart"}) {
            MvcResult notFoundRes = mockMvc.perform(get(path).cookie(staffCookie))
                    .andExpect(status().isNotFound())
                    .andReturn();
            assertThat(notFoundRes.getRequest().getAttribute("currentUser")).isInstanceOf(UserPrincipal.class);
        }
    }

    @Test
    void verifyOtpEndpointsHandleValidationInvalidExpiredMaxAttemptsAndSuccess() throws Exception {
        mockMvc.perform(get("/auth/login").param("error", "1").param("logout", "1"))
                .andExpect(status().isOk());
        mockMvc.perform(get("/auth/register"))
                .andExpect(status().isOk());

        // Blank fields -> 400
        mockMvc.perform(post("/auth/register/send-otp")
                        .with(csrf())
                        .param("fullName", " ")
                        .param("email", "")
                        .param("password", "Secret123!")
                        .param("confirmPassword", "Secret123!"))
                .andExpect(status().isBadRequest());

        // Password mismatch / too short -> 400
        mockMvc.perform(post("/auth/register/send-otp")
                        .with(csrf())
                        .param("fullName", "User")
                        .param("email", "u@techcommerce.store")
                        .param("password", "short")
                        .param("confirmPassword", "short"))
                .andExpect(status().isBadRequest());

        // Send valid OTP
        emailService.clearRecordedEmails();
        mockMvc.perform(post("/auth/register/send-otp")
                        .with(csrf())
                        .param("fullName", "Verified Buyer")
                        .param("email", "verifyme@techcommerce.store")
                        .param("phone", "0908889999")
                        .param("password", "Secret123!")
                        .param("confirmPassword", "Secret123!"))
                .andExpect(status().isOk());

        String validCode = emailService.getRecordedEmails().get(0).body();

        // Wrong OTP -> 401
        mockMvc.perform(post("/auth/register/verify-otp")
                        .with(csrf())
                        .param("email", "verifyme@techcommerce.store")
                        .param("otp", "000000"))
                .andExpect(status().isUnauthorized());

        // Correct OTP -> 302 redirect to / and sets ACCESS_TOKEN + REFRESH_TOKEN cookies
        MvcResult okRes = mockMvc.perform(post("/auth/register/verify-otp")
                        .with(csrf())
                        .param("email", "verifyme@techcommerce.store")
                        .param("otp", validCode))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/"))
                .andReturn();
        Cookie accessCookie = okRes.getResponse().getCookie(JwtService.ACCESS_COOKIE_NAME);
        assertThat(accessCookie).isNotNull();
        assertThat(okRes.getResponse().getCookie(JwtService.REFRESH_COOKIE_NAME)).isNotNull();

        // Double-submit of verify-otp right after first click invalidated CSRF session (or with valid CSRF) redirects cleanly to /
        mockMvc.perform(post("/auth/register/verify-otp")
                        .cookie(accessCookie)
                        .param("email", "verifyme@techcommerce.store")
                        .param("otp", validCode))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/"));

        mockMvc.perform(post("/auth/register/verify-otp")
                        .with(csrf())
                        .cookie(accessCookie)
                        .param("email", "verifyme@techcommerce.store")
                        .param("otp", validCode))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/"));

        // Expired OTP -> 410 Gone
        emailService.clearRecordedEmails();
        mockMvc.perform(post("/auth/register/send-otp")
                        .with(csrf())
                        .param("fullName", "Expired Buyer")
                        .param("email", "exp@techcommerce.store")
                        .param("password", "Secret123!")
                        .param("confirmPassword", "Secret123!"))
                .andExpect(status().isOk());
        String expCode = emailService.getRecordedEmails().get(0).body();
        EmailVerificationOtp expOtp = otpRepository
                .findFirstByEmailAndVerifiedAtIsNullOrderByCreatedAtDesc("exp@techcommerce.store")
                .orElseThrow();
        expOtp.setExpiresAt(java.time.Instant.now().minusSeconds(60));
        otpRepository.saveAndFlush(expOtp);

        mockMvc.perform(post("/auth/register/verify-otp")
                        .with(csrf())
                        .param("email", "exp@techcommerce.store")
                        .param("otp", expCode))
                .andExpect(status().isGone());
    }

    @Test
    void logoutRevokesRefreshTokenInDatabaseClearsCookiesAndRedirects() throws Exception {
        User u = new User();
        u.setEmail("logoutuser@techcommerce.store");
        u.setFullName("Logout User");
        u.setPasswordHash(passwordEncoder.encode("Secret123!"));
        u.setRole("CUSTOMER");
        u = userRepository.saveAndFlush(u);

        String access = jwtService.generateAccessToken(u);
        String refresh = jwtService.issueRefreshToken(u.getId());

        mockMvc.perform(post("/auth/logout")
                        .with(csrf())
                        .cookie(
                                new Cookie(JwtService.ACCESS_COOKIE_NAME, access),
                                new Cookie(JwtService.REFRESH_COOKIE_NAME, refresh)
                        ))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/auth/login?logout=true"))
                .andExpect(cookie().maxAge(JwtService.ACCESS_COOKIE_NAME, 0))
                .andExpect(cookie().maxAge(JwtService.REFRESH_COOKIE_NAME, 0));

        RefreshToken stored = refreshTokenRepository.findByTokenHash(JwtService.sha256Hex(refresh)).orElseThrow();
        assertThat(stored.getRevokedAt()).isNotNull();
    }
}
