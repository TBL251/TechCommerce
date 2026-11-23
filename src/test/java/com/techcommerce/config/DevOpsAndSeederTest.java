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
}
