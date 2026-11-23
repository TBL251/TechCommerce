package com.techcommerce.auth;

import com.techcommerce.common.mail.EmailService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
@ActiveProfiles("test")
@Transactional
class RegistrationServiceTest {

    @Autowired private RegistrationService registrationService;
    @Autowired private UserRepository userRepository;
    @Autowired private EmailVerificationOtpRepository otpRepository;
    @Autowired private EmailService emailService;

    @BeforeEach
    void setUp() {
        userRepository.deleteAll();
        otpRepository.deleteAll();
        emailService.clearRecordedEmails();
    }

    @Test
    void sendOtpCreatesHashedRecordAndSendsEmail() {
        RegistrationService.SendOtpResult result = registrationService.sendOtp(
                "newuser@techcommerce.store", "Người Dùng Mới", "0901234567", "Secret123!");

        assertThat(result).isEqualTo(RegistrationService.SendOtpResult.SENT);
        assertThat(otpRepository.findFirstByEmailAndVerifiedAtIsNullOrderByCreatedAtDesc(
                "newuser@techcommerce.store")).isPresent();
        assertThat(emailService.getRecordedEmails()).hasSize(1);
        assertThat(emailService.getRecordedEmails().get(0).subject()).contains("xác nhận đăng ký");
    }

    @Test
    void sendOtpRejectsAlreadyRegisteredEmail() {
        User existing = new User();
        existing.setEmail("taken@techcommerce.store");
        existing.setFullName("Taken");
        existing.setPasswordHash("hash");
        existing.setRole("CUSTOMER");
        userRepository.save(existing);

        RegistrationService.SendOtpResult result = registrationService.sendOtp(
                "taken@techcommerce.store", "Ai Đó", null, "Pass123!");

        assertThat(result).isEqualTo(RegistrationService.SendOtpResult.EMAIL_TAKEN);
        assertThat(emailService.getRecordedEmails()).isEmpty();
    }

    @Test
    void verifyCorrectOtpCreatesUserAndCleansUpOtpRecords() {
        // Gửi OTP trước
        registrationService.sendOtp("buyer@techcommerce.store", "Người Mua", null, "BuyPass1!");

        // Lấy OTP thật từ email đã được "ghi lại"
        String emailBody = emailService.getRecordedEmails().get(0).body();
        // Trích OTP 6 chữ số từ nội dung email
        String otp = emailBody.replaceAll("[\\s\\S]*?(\\d{6})[\\s\\S]*", "$1");

        RegistrationService.VerifyOtpAndCreateResult result =
                registrationService.verifyOtpAndCreate("buyer@techcommerce.store", otp);

        assertThat(result.status()).isEqualTo(RegistrationService.VerifyOtpResult.OK);
        assertThat(result.user()).isNotNull();
        assertThat(userRepository.findByEmailIgnoreCase("buyer@techcommerce.store")).isPresent();
        // OTP phải bị xóa sau khi tạo tài khoản
        assertThat(otpRepository.findFirstByEmailAndVerifiedAtIsNullOrderByCreatedAtDesc(
                "buyer@techcommerce.store")).isEmpty();
    }

    @Test
    void verifyWrongOtpIncrementsAttemptsAndRejectsAfterMax() {
        registrationService.sendOtp("locker@techcommerce.store", "Locker", null, "LockPass1!");
        EmailVerificationOtp otp = otpRepository
                .findFirstByEmailAndVerifiedAtIsNullOrderByCreatedAtDesc("locker@techcommerce.store")
                .orElseThrow();

        // 5 lần sai
        for (int i = 0; i < RegistrationService.MAX_OTP_ATTEMPTS; i++) {
            registrationService.verifyOtpAndCreate("locker@techcommerce.store", "000000");
        }

        RegistrationService.VerifyOtpAndCreateResult blocked =
                registrationService.verifyOtpAndCreate("locker@techcommerce.store", "000000");
        assertThat(blocked.status()).isEqualTo(RegistrationService.VerifyOtpResult.MAX_ATTEMPTS);
        assertThat(userRepository.findByEmailIgnoreCase("locker@techcommerce.store")).isEmpty();
    }
}
