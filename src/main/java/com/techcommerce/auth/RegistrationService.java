package com.techcommerce.auth;

import com.techcommerce.common.mail.EmailService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.SecureRandom;
import java.time.Instant;
import java.util.Optional;

@Service
public class RegistrationService {

    static final int OTP_TTL_SECONDS = 600;   // 10 phút
    static final int MAX_OTP_ATTEMPTS = 5;

    private final UserRepository userRepository;
    private final EmailVerificationOtpRepository otpRepository;
    private final PasswordEncoder passwordEncoder;
    private final EmailService emailService;
    private final SecureRandom secureRandom = new SecureRandom();

    public RegistrationService(UserRepository userRepository,
                               EmailVerificationOtpRepository otpRepository,
                               PasswordEncoder passwordEncoder,
                               EmailService emailService) {
        this.userRepository = userRepository;
        this.otpRepository = otpRepository;
        this.passwordEncoder = passwordEncoder;
        this.emailService = emailService;
    }

    public enum SendOtpResult { SENT, EMAIL_TAKEN }

    /** Tạo OTP 6 chữ số, lưu hash vào DB, gửi email. Trả về SENT hoặc EMAIL_TAKEN. */
    @Transactional
    public SendOtpResult sendOtp(String email, String fullName, String phone, String rawPassword) {
        if (userRepository.existsByEmailIgnoreCase(email)) {
            return SendOtpResult.EMAIL_TAKEN;
        }
        // Xóa OTP cũ của email này (gửi lại)
        otpRepository.deleteAllByEmail(email);

        String otp = String.format("%06d", secureRandom.nextInt(1_000_000));

        EmailVerificationOtp record = new EmailVerificationOtp();
        record.setEmail(email);
        record.setOtpHash(JwtService.sha256Hex(otp));
        record.setFullName(fullName);
        record.setPhone(phone);
        record.setPasswordHash(passwordEncoder.encode(rawPassword));
        record.setExpiresAt(Instant.now().plusSeconds(OTP_TTL_SECONDS));
        otpRepository.save(record);

        emailService.sendRegistrationOtpEmail(email, fullName, otp);
        return SendOtpResult.SENT;
    }

    public enum VerifyOtpResult { OK, INVALID, EXPIRED, MAX_ATTEMPTS, EMAIL_TAKEN }

    /**
     * Xác nhận OTP và tạo tài khoản nếu hợp lệ.
     * Trả về OK kèm User khi thành công, hoặc lý do thất bại.
     */
    @Transactional
    public VerifyOtpAndCreateResult verifyOtpAndCreate(String email, String rawOtp) {
        if (userRepository.existsByEmailIgnoreCase(email)) {
            return new VerifyOtpAndCreateResult(VerifyOtpResult.EMAIL_TAKEN, null);
        }

        Optional<EmailVerificationOtp> otpOpt = otpRepository.findFirstByEmailAndVerifiedAtIsNullOrderByCreatedAtDesc(email);
        if (otpOpt.isEmpty()) {
            return new VerifyOtpAndCreateResult(VerifyOtpResult.INVALID, null);
        }

        EmailVerificationOtp otp = otpOpt.get();
        Instant now = Instant.now();

        if (!otp.isValid(now)) {
            return new VerifyOtpAndCreateResult(VerifyOtpResult.EXPIRED, null);
        }
        if (otp.getAttempts() >= MAX_OTP_ATTEMPTS) {
            return new VerifyOtpAndCreateResult(VerifyOtpResult.MAX_ATTEMPTS, null);
        }

        otp.setAttempts(otp.getAttempts() + 1);
        if (!JwtService.sha256Hex(rawOtp.trim()).equals(otp.getOtpHash())) {
            otpRepository.save(otp);
            return new VerifyOtpAndCreateResult(VerifyOtpResult.INVALID, null);
        }

        otp.setVerifiedAt(now);
        otpRepository.save(otp);

        User user = new User();
        user.setEmail(email);
        user.setFullName(otp.getFullName());
        user.setPhone(otp.getPhone());
        user.setPasswordHash(otp.getPasswordHash());
        user.setRole("CUSTOMER");
        user.setAuthProvider("LOCAL");
        user.setEnabled(true);
        user = userRepository.save(user);

        // Dọn các OTP còn lại (nếu có) sau khi tạo tài khoản thành công
        otpRepository.deleteAllByEmail(email);

        return new VerifyOtpAndCreateResult(VerifyOtpResult.OK, user);
    }

    public record VerifyOtpAndCreateResult(VerifyOtpResult status, User user) {}
}
