package com.techcommerce.auth;

import com.techcommerce.store.Store;
import com.techcommerce.store.StoreRepository;
import jakarta.servlet.http.Cookie;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

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
class AdminUserControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private StoreRepository storeRepository;

    @Autowired
    private JwtService jwtService;

    private Store store;
    private Cookie adminCookie;

    @BeforeEach
    void setUp() {
        userRepository.deleteAll();
        userRepository.flush();
        storeRepository.deleteAll();
        storeRepository.flush();

        Store st = new Store();
        st.setCode("HN-01");
        st.setName("TechCommerce Hà Nội");
        st.setAddress("120 Cầu Giấy");
        st.setCity("Hà Nội");
        st.setPhone("02438889999");
        st.setActive(true);
        store = storeRepository.saveAndFlush(st);

        User admin = new User();
        admin.setEmail("rootadmin@techcommerce.store");
        admin.setFullName("Root Admin");
        admin.setRole("ADMIN");
        admin.setEnabled(true);
        admin = userRepository.saveAndFlush(admin);

        adminCookie = new Cookie(JwtService.ACCESS_COOKIE_NAME, jwtService.generateAccessToken(admin));
    }

    @Test
    void adminCanViewDashboardListUsersCreateStaffAndToggleAccountStatus() throws Exception {
        mockMvc.perform(get("/admin/dashboard").cookie(adminCookie))
                .andExpect(status().isOk())
                .andExpect(view().name("admin/dashboard"))
                .andExpect(model().attributeExists("stores"));

        mockMvc.perform(get("/admin/users").cookie(adminCookie))
                .andExpect(status().isOk())
                .andExpect(view().name("admin/users/list"))
                .andExpect(model().attributeExists("users", "stores"));

        // Create staff account
        mockMvc.perform(post("/admin/users/staff")
                        .with(csrf())
                        .cookie(adminCookie)
                        .param("fullName", "Staff Đà Nẵng")
                        .param("email", "staff.dn@techcommerce.store")
                        .param("phone", "0905556666")
                        .param("password", "StaffPass123!")
                        .param("storeId", String.valueOf(store.getId())))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/admin/users"))
                .andExpect(flash().attributeExists("message"));

        User createdStaff = userRepository.findByEmailIgnoreCase("staff.dn@techcommerce.store").orElseThrow();
        assertThat(createdStaff.getRole()).isEqualTo("STAFF");
        assertThat(createdStaff.getStoreId()).isEqualTo(store.getId());

        // Duplicate email flashes error
        mockMvc.perform(post("/admin/users/staff")
                        .with(csrf())
                        .cookie(adminCookie)
                        .param("fullName", "Duplicate Staff")
                        .param("email", "staff.dn@techcommerce.store")
                        .param("password", "StaffPass123!")
                        .param("storeId", String.valueOf(store.getId())))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/admin/users"))
                .andExpect(flash().attributeExists("error"));

        // Toggle status (disable then re-enable)
        mockMvc.perform(post("/admin/users/" + createdStaff.getId() + "/toggle-status")
                        .with(csrf())
                        .cookie(adminCookie))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/admin/users"))
                .andExpect(flash().attributeExists("message"));
        assertThat(userRepository.findById(createdStaff.getId()).orElseThrow().isEnabled()).isFalse();

        mockMvc.perform(post("/admin/users/" + createdStaff.getId() + "/toggle-status")
                        .with(csrf())
                        .cookie(adminCookie))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/admin/users"))
                .andExpect(flash().attributeExists("message"));
        assertThat(userRepository.findById(createdStaff.getId()).orElseThrow().isEnabled()).isTrue();
    }
}
