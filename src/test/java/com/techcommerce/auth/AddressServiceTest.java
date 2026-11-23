package com.techcommerce.auth;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
@ActiveProfiles("test")
@Transactional
class AddressServiceTest {

    @Autowired
    private AddressService addressService;

    @Autowired
    private UserRepository userRepository;

    private User user1;
    private User user2;

    @BeforeEach
    void setUp() {
        userRepository.deleteAll();

        User u1 = new User();
        u1.setEmail("u1@techcommerce.store");
        u1.setFullName("User One");
        user1 = userRepository.save(u1);

        User u2 = new User();
        u2.setEmail("u2@techcommerce.store");
        u2.setFullName("User Two");
        user2 = userRepository.save(u2);
    }

    @Test
    void managesDefaultAddressAndBlocksCrossUserIdorAccess() {
        // First address becomes default automatically
        UserAddress a1 = addressService.addAddress(user1.getId(), "Người Nhận 1", "0901111111", "Số 1 Lê Lợi", "TP.HCM", false);
        assertThat(a1.isDefaultAddress()).isTrue();

        // Second address with makeDefault=true switches default from a1 to a2
        UserAddress a2 = addressService.addAddress(user1.getId(), "Người Nhận 2", "0902222222", "Số 2 Nguyễn Huệ", "TP.HCM", true);
        assertThat(a2.isDefaultAddress()).isTrue();

        List<UserAddress> list = addressService.listUserAddresses(user1.getId());
        assertThat(list).hasSize(2);
        assertThat(list.get(0).getId()).isEqualTo(a2.getId());
        assertThat(list.get(0).isDefaultAddress()).isTrue();
        assertThat(list.get(1).isDefaultAddress()).isFalse();

        // Anti-IDOR: user2 cannot set default or delete user1's address
        assertThat(addressService.setDefaultAddress(user2.getId(), a1.getId())).isFalse();
        assertThat(addressService.deleteAddress(user2.getId(), a1.getId())).isFalse();

        // Deleting default address a2 promotes remaining address a1 to default
        assertThat(addressService.deleteAddress(user1.getId(), a2.getId())).isTrue();
        List<UserAddress> remaining = addressService.listUserAddresses(user1.getId());
        assertThat(remaining).hasSize(1);
        assertThat(remaining.get(0).isDefaultAddress()).isTrue();
    }
}
