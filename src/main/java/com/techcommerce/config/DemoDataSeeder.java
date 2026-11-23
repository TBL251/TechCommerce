package com.techcommerce.config;

import com.techcommerce.auth.User;
import com.techcommerce.auth.UserRepository;
import com.techcommerce.store.Store;
import com.techcommerce.store.StoreRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

@Component
public class DemoDataSeeder implements ApplicationRunner {

    private static final Logger log = LoggerFactory.getLogger(DemoDataSeeder.class);

    private final StoreRepository storeRepository;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final boolean seedOnStartup;

    public DemoDataSeeder(
            StoreRepository storeRepository,
            UserRepository userRepository,
            PasswordEncoder passwordEncoder,
            @Value("${app.seed-demo-data:false}") boolean seedOnStartup
    ) {
        this.storeRepository = storeRepository;
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.seedOnStartup = seedOnStartup;
    }

    @Override
    @Transactional
    public void run(ApplicationArguments args) {
        if (seedOnStartup) {
            seedIfEmpty();
        }
    }

    @Transactional
    public void seedIfEmpty() {
        Store hn = ensureStore("HN-01", "TechCommerce Hà Nội", "120 Cầu Giấy, Quận Cầu Giấy", "Hà Nội", "02438889999");
        Store hcm = ensureStore("HCM-01", "TechCommerce TP.HCM", "245 Nguyễn Thị Minh Khai, Quận 1", "TP.HCM", "02838889999");
        ensureStore("DN-01", "TechCommerce Đà Nẵng", "88 Nguyễn Văn Linh, Quận Hải Châu", "Đà Nẵng", "02363888999");

        String defaultHash = passwordEncoder.encode("Password123!");
        ensureUser("admin@techcommerce.store", "Quản Trị Tổng", "0901000001", defaultHash, "ADMIN", null);
        ensureUser("staff.hn@techcommerce.store", "Nhân Viên Chi Nhánh Hà Nội", "0901000002", defaultHash, "STAFF", hn.getId());
        ensureUser("staff.hcm@techcommerce.store", "Nhân Viên Chi Nhánh TP.HCM", "0901000003", defaultHash, "STAFF", hcm.getId());
        ensureUser("customer@techcommerce.store", "Khách Hàng Mẫu", "0901000004", defaultHash, "CUSTOMER", null);
        log.info("Ensured demo stores (HN-01, HCM-01, DN-01) and default accounts are seeded.");
    }

    private Store ensureStore(String code, String name, String address, String city, String phone) {
        return storeRepository.findByCode(code).orElseGet(() -> {
            Store st = new Store();
            st.setCode(code);
            st.setName(name);
            st.setAddress(address);
            st.setCity(city);
            st.setPhone(phone);
            st.setOpeningHours("08:00 - 21:30");
            st.setActive(true);
            return storeRepository.save(st);
        });
    }

    private void ensureUser(String email, String fullName, String phone, String passwordHash, String role, Long storeId) {
        if (userRepository.existsByEmailIgnoreCase(email)) {
            return;
        }
        User u = new User();
        u.setEmail(email);
        u.setFullName(fullName);
        u.setPhone(phone);
        u.setPasswordHash(passwordHash);
        u.setRole(role);
        u.setStoreId(storeId);
        u.setAuthProvider("LOCAL");
        u.setEnabled(true);
        userRepository.save(u);
    }
}
