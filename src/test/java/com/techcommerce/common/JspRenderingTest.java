package com.techcommerce.common;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;

import java.nio.file.Files;
import java.nio.file.Path;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@SpringBootTest
@ActiveProfiles("test")
class JspRenderingTest {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Test
    void healthJspFileContainsJakartaJstlOutTag() throws Exception {
        String content = Files.readString(Path.of("src/main/webapp/WEB-INF/jsp/health.jsp"));
        assertThat(content)
                .contains("uri=\"jakarta.tags.core\"")
                .contains("<c:out value=\"${appName}\"/>");
    }

    @Test
    void flywayV1CreatesAllCoreTablesAndEnforcesStaffStoreConstraint() {
        Integer tableCount = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM information_schema.tables " +
                        "WHERE LOWER(table_schema) = 'public' AND LOWER(table_name) IN ('stores', 'users', 'password_reset_tokens', 'refresh_tokens', 'user_addresses')",
                Integer.class
        );
        assertThat(tableCount).isEqualTo(5);

        assertThatThrownBy(() -> jdbcTemplate.update(
                "INSERT INTO users (email, full_name, role, store_id) VALUES ('staff@techcommerce.store', 'Staff No Store', 'STAFF', NULL)"
        )).isInstanceOf(DataIntegrityViolationException.class);
    }
}
