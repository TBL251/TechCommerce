package com.techcommerce.store;

import jakarta.servlet.http.Cookie;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.cookie;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.model;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrl;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.view;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class StoreControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private StoreRepository storeRepository;

    @Test
    void storeListPageRendersActiveStores() throws Exception {
        mockMvc.perform(get("/stores"))
                .andExpect(status().isOk())
                .andExpect(view().name("store/list"))
                .andExpect(model().attributeExists("stores", "activeStores"));
    }

    @Test
    void selectStoreSetsCookieAndStripsStaleBranchQueryFromReferer() throws Exception {
        Store hn = storeRepository.findByCode("HN-01").orElseGet(() -> {
            Store s = new Store();
            s.setCode("HN-01");
            s.setName("TechCommerce Hà Nội");
            s.setAddress("120 Cầu Giấy");
            s.setCity("Hà Nội");
            s.setPhone("024-3838-0001");
            s.setActive(true);
            return storeRepository.save(s);
        });

        mockMvc.perform(get("/stores/select")
                        .param("storeId", String.valueOf(hn.getId()))
                        .header("Referer", "https://techcommerce.store/?branch=DN-01"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/"))
                .andExpect(cookie().value("SELECTED_STORE_ID", String.valueOf(hn.getId())));

        mockMvc.perform(get("/").cookie(new Cookie("SELECTED_STORE_ID", String.valueOf(hn.getId()))))
                .andExpect(status().isOk())
                .andExpect(model().attributeExists("currentStore"));
    }

    @Test
    void selectAllClearsStoreCookie() throws Exception {
        mockMvc.perform(get("/stores/select").param("code", "ALL"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/"))
                .andExpect(cookie().maxAge("SELECTED_STORE_ID", 0));
    }

    @Test
    void selectStoreSupportsCodeIgnoresInactiveStoreAndBlocksProtocolRelativeOpenRedirect() throws Exception {
        Store activeStore = storeRepository.findByCode("HN-01").orElseGet(() -> {
            Store s = new Store();
            s.setCode("HN-01");
            s.setName("TechCommerce Hà Nội");
            s.setAddress("120 Cầu Giấy");
            s.setCity("Hà Nội");
            s.setPhone("024-3838-0001");
            s.setActive(true);
            return storeRepository.saveAndFlush(s);
        });

        Store inactiveStore = new Store();
        inactiveStore.setCode("CLOSED-01");
        inactiveStore.setName("Closed Branch");
        inactiveStore.setAddress("1 Closed St");
        inactiveStore.setCity("Hà Nội");
        inactiveStore.setPhone("024-0000-0000");
        inactiveStore.setActive(false);
        inactiveStore = storeRepository.saveAndFlush(inactiveStore);

        // Select by code + block protocol-relative //evil.com referer open redirect
        mockMvc.perform(get("/stores/select")
                        .param("code", "HN-01")
                        .header("Referer", "https://techcommerce.store//evil.com/phish"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/"))
                .andExpect(cookie().value("SELECTED_STORE_ID", String.valueOf(activeStore.getId())));

        // Selecting inactive store does not set cookie
        mockMvc.perform(get("/stores/select")
                        .param("storeId", String.valueOf(inactiveStore.getId())))
                .andExpect(status().is3xxRedirection())
                .andExpect(cookie().doesNotExist("SELECTED_STORE_ID"));

        // Cookie pointing to inactive store or non-numeric string resolves currentStore to null
        mockMvc.perform(get("/").cookie(new Cookie("SELECTED_STORE_ID", String.valueOf(inactiveStore.getId()))))
                .andExpect(status().isOk())
                .andExpect(model().attributeDoesNotExist("currentStore"));

        mockMvc.perform(get("/").cookie(new Cookie("SELECTED_STORE_ID", "not-a-number")))
                .andExpect(status().isOk())
                .andExpect(model().attributeDoesNotExist("currentStore"));
    }
}
