package com.techcommerce.auth;

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
import org.springframework.transaction.annotation.Transactional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrl;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class UserManagementServiceTest {

    @Autowired
    private UserService userService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private StoreRepository storeRepository;

    @Autowired
    private JwtService jwtService;

    @Autowired
    private RefreshTokenRepository refreshTokenRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private MockMvc mockMvc;

    private Store hanoiStore;

    @BeforeEach
    void setUp() {
        userRepository.deleteAll();
        userRepository.flush();
        storeRepository.deleteAll();
        storeRepository.flush();

        Store st = new Store();
        st.setCode("HN-01");
        st.setName("TechCommerce Hà Nội");
        st.setAddress("100 Cầu Giấy");
        st.setCity("Hà Nội");
        st.setPhone("0241234567");
        hanoiStore = storeRepository.saveAndFlush(st);
    }

    @Test
    void createsStaffRequiresValidStoreId() {
        assertThatThrownBy(() -> userService.createStaff("Staff A", "staffa@techcommerce.store", "0901", "Pass1234!", null))
                .isInstanceOf(IllegalArgumentException.class);

        assertThatThrownBy(() -> userService.createStaff("Staff B", "staffb@techcommerce.store", "0902", "Pass1234!", 99999L))
                .isInstanceOf(IllegalArgumentException.class);

        User staff = userService.createStaff("Staff HN", "staffhn@techcommerce.store", "0903", "Pass1234!", hanoiStore.getId());
        assertThat(staff.getRole()).isEqualTo("STAFF");
        assertThat(staff.getStoreId()).isEqualTo(hanoiStore.getId());
    }

    @Test
    void changePasswordVerifiesCurrentPasswordAndSupportsFirstTimeGoogleUserPassword() {
        User localUser = new User();
        localUser.setEmail("local@techcommerce.store");
        localUser.setFullName("Local User");
        localUser.setPasswordHash(passwordEncoder.encode("OldPass123!"));
        localUser = userRepository.save(localUser);

        Long localId = localUser.getId();
        assertThatThrownBy(() -> userService.changePassword(localId, "WrongOldPass", "NewPass123!"))
                .isInstanceOf(IllegalArgumentException.class);

        userService.changePassword(localId, "OldPass123!", "NewPass123!");
        assertThat(passwordEncoder.matches("NewPass123!", userRepository.findById(localId).orElseThrow().getPasswordHash())).isTrue();

        // Google-only user (passwordHash == null) can set initial password without currentPassword
        User googleUser = new User();
        googleUser.setEmail("guser@techcommerce.store");
        googleUser.setFullName("Google User");
        googleUser.setAuthProvider("GOOGLE");
        googleUser.setPasswordHash(null);
        googleUser = userRepository.save(googleUser);

        userService.changePassword(googleUser.getId(), null, "FirstPass123!");
        assertThat(passwordEncoder.matches("FirstPass123!", userRepository.findById(googleUser.getId()).orElseThrow().getPasswordHash())).isTrue();
    }

    @Test
    void disablingAccountRevokesRefreshTokensAndBlocksExistingAccessTokenAtFilter() throws Exception {
        User staff = userService.createStaff("Staff Lock", "stafflock@techcommerce.store", "0909", "Pass1234!", hanoiStore.getId());
        String accessToken = jwtService.generateAccessToken(staff);
        String refreshToken = jwtService.issueRefreshToken(staff.getId());

        userService.toggleUserEnabled(staff.getId());

        assertThat(refreshTokenRepository.findByTokenHash(JwtService.sha256Hex(refreshToken)).orElseThrow().getRevokedAt()).isNotNull();

        // Existing access token is rejected by JwtAuthenticationFilter when user is disabled
        mockMvc.perform(get("/profile").cookie(new Cookie(JwtService.ACCESS_COOKIE_NAME, accessToken)))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/auth/login"));
    }
}
