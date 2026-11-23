package com.techcommerce.config;

import com.techcommerce.auth.UserRepository;
import com.techcommerce.store.StoreRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import java.nio.file.Files;
import java.nio.file.Path;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
@ActiveProfiles("test")
@Transactional
class DevOpsAndSeederTest {

    @Autowired
    private DemoDataSeeder demoDataSeeder;

    @Autowired
    private StoreRepository storeRepository;

    @Autowired
    private UserRepository userRepository;

    @Test
    void seedsDefaultStoresAndDemoAccountsIdempotently() {
        userRepository.deleteAll();
        userRepository.flush();
        storeRepository.deleteAll();
        storeRepository.flush();

        demoDataSeeder.seedIfEmpty();
        assertThat(storeRepository.count()).isEqualTo(3);
        assertThat(userRepository.findByEmailIgnoreCase("admin@techcommerce.store")).isPresent();
        assertThat(userRepository.findByEmailIgnoreCase("staff.hn@techcommerce.store")).isPresent();
        assertThat(userRepository.findByEmailIgnoreCase("customer@techcommerce.store")).isPresent();

        // Calling a second time is idempotent
        demoDataSeeder.seedIfEmpty();
        assertThat(storeRepository.count()).isEqualTo(3);
    }

    @Test
    void verifiesCiCdDockerAndNginxProductionConfigsmeetAllRequirements() throws Exception {
        String ciYml = Files.readString(Path.of(".github/workflows/ci.yml"));
        assertThat(ciYml)
                .contains("pull_request")
                .contains("develop")
                .contains("main")
                .contains("mvnw")
                .contains("docker build");

        String dockerfile = Files.readString(Path.of("Dockerfile"));
        assertThat(dockerfile)
                .contains("eclipse-temurin:")
                .contains("appuser")
                .contains("-Xms256m")
                .contains("-Xmx512m")
                .contains("/health-jsp");

        String composeProd = Files.readString(Path.of("docker-compose.prod.yml"));
        assertThat(composeProd)
                .contains("techcommerce-prod")
                .contains("unless-stopped")
                .contains("cloudflared")
                .contains("CLOUDFLARE_TUNNEL_TOKEN");

        String nginxConf = Files.readString(Path.of("docker/nginx/default.conf"));
        assertThat(nginxConf)
                .contains("gzip on;")
                .contains("limit_req_zone")
                .contains("client_max_body_size 10M;")
                .contains("Upgrade $http_upgrade")
                .contains("X-Forwarded-Proto");

        String cdYml = Files.readString(Path.of(".github/workflows/cd.yml"));
        assertThat(cdYml)
                .contains("build-and-push")
                .contains("self-hosted")
                .contains("timeout-minutes: 5")
                .contains("workflow_dispatch")
                .contains("techcommerce-prod");
    }

    @Test
    void verifiesAllEnvVariablesInApplicationYmlHaveDefaultsAndExistInEnvExample() throws Exception {
        java.util.Set<String> envExampleKeys = new java.util.LinkedHashSet<>();
        for (String line : Files.readAllLines(Path.of(".env.example"))) {
            String trimmed = line.trim();
            if (!trimmed.isEmpty() && !trimmed.startsWith("#") && trimmed.contains("=")) {
                envExampleKeys.add(trimmed.substring(0, trimmed.indexOf('=')).trim());
            }
        }

        java.util.regex.Pattern placeholderPattern = java.util.regex.Pattern.compile("\\$\\{([A-Z0-9_]+)(:)?");
        for (String ymlFile : java.util.List.of("src/main/resources/application.yml", "src/main/resources/application-dev.yml")) {
            String content = Files.readString(Path.of(ymlFile));
            java.util.regex.Matcher matcher = placeholderPattern.matcher(content);
            while (matcher.find()) {
                String varName = matcher.group(1);
                String defaultPart = matcher.group(2);
                assertThat(defaultPart)
                        .as("Biến ${%s} trong %s bắt buộc phải có giá trị mặc định sau dấu ':' (ví dụ ${%s:})", varName, ymlFile, varName)
                        .isNotNull();
                assertThat(envExampleKeys)
                        .as("Biến %s dùng trong %s bắt buộc phải được khai báo trong .env.example", varName, ymlFile)
                        .contains(varName);
            }
        }
    }
}
