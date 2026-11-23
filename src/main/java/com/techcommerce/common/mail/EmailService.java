package com.techcommerce.common.mail;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

@Service
public class EmailService {

    private static final Logger log = LoggerFactory.getLogger(EmailService.class);

    public record SentEmail(String to, String subject, String body) {
    }

    private final JavaMailSender mailSender;
    private final String fromAddress;
    private final List<SentEmail> recordedEmails = new CopyOnWriteArrayList<>();

    public EmailService(
            @Autowired(required = false) JavaMailSender mailSender,
            @Value("${app.mail.from:no-reply@techcommerce.store}") String fromAddress
    ) {
        this.mailSender = mailSender;
        this.fromAddress = fromAddress;
    }

    public void sendRegistrationOtpEmail(String toEmail, String fullName, String otp) {
        String subject = "[TechCommerce] Mã xác nhận đăng ký tài khoản";
        String body = "Xin chào " + fullName + ",\n\n"
                + "Mã OTP xác nhận đăng ký tài khoản TechCommerce của bạn là:\n\n"
                + "    " + otp + "\n\n"
                + "Mã có hiệu lực trong 10 phút và chỉ dùng được một lần.\n"
                + "Nếu bạn không thực hiện đăng ký, vui lòng bỏ qua email này.";
        recordAndDispatchAsync(toEmail, subject, body);
    }

    public void sendPasswordResetEmail(String toEmail, String resetUrl) {
        String subject = "[TechCommerce] Đặt lại mật khẩu tài khoản của bạn";
        String body = "Xin chào,\n\nBạn (hoặc ai đó) vừa yêu cầu đặt lại mật khẩu tại TechCommerce.\n"
                + "Liên kết đặt lại mật khẩu (hiệu lực 15 phút, dùng 1 lần):\n" + resetUrl
                + "\n\nNếu bạn không yêu cầu, vui lòng bỏ qua email này.";
        recordAndDispatchAsync(toEmail, subject, body);
    }

    public void sendOrderConfirmationEmail(String toEmail, String orderCode, String storeName, String totalFormatted) {
        String subject = "[TechCommerce] Xác nhận đơn hàng #" + orderCode;
        String body = "Cảm ơn bạn đã đặt hàng tại TechCommerce!\n"
                + "Mã đơn hàng: " + orderCode + "\n"
                + "Chi nhánh xử lý: " + storeName + "\n"
                + "Tổng thanh toán: " + totalFormatted + "\n";
        recordAndDispatchAsync(toEmail, subject, body);
    }

    public void sendReturnStatusEmail(String toEmail, String orderCode, String status, String staffNote) {
        String subject = "[TechCommerce] Cập nhật yêu cầu hoàn trả đơn #" + orderCode;
        String body = "Yêu cầu hoàn trả cho đơn hàng #" + orderCode + " đã chuyển sang trạng thái: " + status + "\n"
                + (StringUtils.hasText(staffNote) ? "Ghi chú từ chi nhánh: " + staffNote : "");
        recordAndDispatchAsync(toEmail, subject, body);
    }

    public void sendStockRestockedEmail(String toEmail, String productName, String storeName, String productUrl) {
        String subject = "[TechCommerce] Sản phẩm " + productName + " đã có hàng trở lại";
        String body = "Sản phẩm '" + productName + "' bạn đăng ký theo dõi đã có hàng lại tại chi nhánh " + storeName + ".\n"
                + "Xem ngay tại: " + productUrl;
        recordAndDispatchAsync(toEmail, subject, body);
    }

    private void recordAndDispatchAsync(String toEmail, String subject, String body) {
        if (!StringUtils.hasText(toEmail)) {
            return;
        }
        recordedEmails.add(new SentEmail(toEmail.trim(), subject, body));
        dispatchSmtpAsync(toEmail.trim(), subject, body);
    }

    @Async
    public void dispatchSmtpAsync(String toEmail, String subject, String body) {
        if (mailSender == null) {
            return;
        }
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(fromAddress);
            message.setTo(toEmail);
            message.setSubject(subject);
            message.setText(body);
            mailSender.send(message);
        } catch (Exception ex) {
            // Never let SMTP failures roll back or fail business transactions
            log.warn("Could not send SMTP email to {} (subject: {}): {}", toEmail, subject, ex.getMessage());
        }
    }

    public List<SentEmail> getRecordedEmails() {
        return List.copyOf(recordedEmails);
    }

    public void clearRecordedEmails() {
        recordedEmails.clear();
    }
}
