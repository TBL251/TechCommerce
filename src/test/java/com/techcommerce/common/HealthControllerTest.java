package com.techcommerce.common;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.model;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.view;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class HealthControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    void healthJspReturnsViewWithAppNameWithoutDatabaseQuery() throws Exception {
        mockMvc.perform(get("/health-jsp"))
                .andExpect(status().isOk())
                .andExpect(view().name("health"))
                .andExpect(model().attribute("appName", "TechCommerce"));
    }

    @Test
    void apiHealthReturnsUpJsonAndErrorEndpointsSupportForwardedPostRequests() throws Exception {
        mockMvc.perform(get("/api/health"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value("UP"));

        // Forwarded POST /error/403 (from AccessDeniedHandler on a POST request) must return 403 view, not 500 MethodNotSupported
        mockMvc.perform(post("/error/403"))
                .andExpect(status().isForbidden())
                .andExpect(view().name("error/403"));
        mockMvc.perform(post("/error/404"))
                .andExpect(status().isNotFound())
                .andExpect(view().name("error/404"));
        mockMvc.perform(post("/error/500"))
                .andExpect(status().isInternalServerError())
                .andExpect(view().name("error/500"));
    }
}
