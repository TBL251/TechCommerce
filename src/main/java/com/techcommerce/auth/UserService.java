package com.techcommerce.auth;

import com.techcommerce.store.StoreRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.List;

@Service
public class UserService {

    private final UserRepository userRepository;
    private final StoreRepository storeRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    public UserService(
            UserRepository userRepository,
            StoreRepository storeRepository,
            PasswordEncoder passwordEncoder,
            JwtService jwtService
    ) {
        this.userRepository = userRepository;
        this.storeRepository = storeRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
    }

    @Transactional(readOnly = true)
    public User getById(Long userId) {
        return userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy người dùng."));
    }

    @Transactional
    public User updateProfile(Long userId, String fullName, String phone) {
        if (!StringUtils.hasText(fullName)) {
            throw new IllegalArgumentException("Họ và tên không được để trống.");
        }
        User user = getById(userId);
        user.setFullName(fullName.trim());
        user.setPhone(StringUtils.hasText(phone) ? phone.trim() : null);
        return userRepository.save(user);
    }

    @Transactional
    public void changePassword(Long userId, String currentPassword, String newPassword) {
        if (newPassword == null || newPassword.length() < 8) {
            throw new IllegalArgumentException("Mật khẩu mới phải từ 8 ký tự trở lên.");
        }
        User user = getById(userId);
        if (StringUtils.hasText(user.getPasswordHash())) {
            if (!StringUtils.hasText(currentPassword) || !passwordEncoder.matches(currentPassword, user.getPasswordHash())) {
                throw new IllegalArgumentException("Mật khẩu hiện tại không chính xác.");
            }
        }
        user.setPasswordHash(passwordEncoder.encode(newPassword));
        userRepository.save(user);
        jwtService.revokeAllUserTokens(userId);
    }

    @Transactional
    public User createStaff(String fullName, String email, String phone, String password, Long storeId) {
        if (storeId == null || !storeRepository.existsById(storeId)) {
            throw new IllegalArgumentException("Nhân viên chi nhánh (STAFF) bắt buộc phải gắn với 1 chi nhánh hợp lệ.");
        }
        if (!StringUtils.hasText(fullName) || !StringUtils.hasText(email)) {
            throw new IllegalArgumentException("Vui lòng nhập đầy đủ họ tên và email nhân viên.");
        }
        if (password == null || password.length() < 8) {
            throw new IllegalArgumentException("Mật khẩu nhân viên phải từ 8 ký tự trở lên.");
        }
        String cleanEmail = email.trim().toLowerCase();
        if (userRepository.existsByEmailIgnoreCase(cleanEmail)) {
            throw new IllegalArgumentException("Email này đã tồn tại trong hệ thống.");
        }

        User staff = new User();
        staff.setEmail(cleanEmail);
        staff.setFullName(fullName.trim());
        staff.setPhone(StringUtils.hasText(phone) ? phone.trim() : null);
        staff.setPasswordHash(passwordEncoder.encode(password));
        staff.setRole("STAFF");
        staff.setStoreId(storeId);
        staff.setAuthProvider("LOCAL");
        staff.setEnabled(true);
        return userRepository.save(staff);
    }

    @Transactional
    public User toggleUserEnabled(Long userId) {
        User user = getById(userId);
        boolean nextState = !user.isEnabled();
        user.setEnabled(nextState);
        User saved = userRepository.save(user);
        if (!nextState) {
            jwtService.revokeAllUserTokens(userId);
        }
        return saved;
    }

    @Transactional(readOnly = true)
    public List<User> listAllUsers() {
        return userRepository.findAllByOrderByIdAsc();
    }
}
