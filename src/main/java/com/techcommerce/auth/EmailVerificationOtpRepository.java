package com.techcommerce.auth;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import java.util.Optional;

public interface EmailVerificationOtpRepository extends JpaRepository<EmailVerificationOtp, Long> {

    // Lấy OTP chưa dùng mới nhất theo email (Spring Data tự thêm LIMIT)
    Optional<EmailVerificationOtp> findFirstByEmailAndVerifiedAtIsNullOrderByCreatedAtDesc(String email);

    // Xóa toàn bộ OTP cũ của email sau khi xác nhận thành công hoặc đăng ký lại
    @Modifying
    @Query("DELETE FROM EmailVerificationOtp o WHERE o.email = :email")
    void deleteAllByEmail(String email);
}
