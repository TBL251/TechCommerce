package com.techcommerce.common.mail;

import jakarta.mail.internet.MimeMessage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

import static com.techcommerce.common.mail.EmailTemplate.*;

@Service
public class EmailService {

    private static final Logger log = LoggerFactory.getLogger(EmailService.class);

    /** Dùng cho test để kiểm tra email được gửi, lưu plain-text subject+body. */
    public record SentEmail(String to, String subject, String body) {}

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

    // ── 1. Mã OTP đăng ký ─────────────────────────────────────────────────────

    public void sendRegistrationOtpEmail(String toEmail, String fullName, String otp) {
        String subject = "Mã xác nhận đăng ký tài khoản – TechCommerce";
        String html = wrap(
            heading("Xác nhận địa chỉ email của bạn")
            + paragraph("Xin chào <strong>" + esc(fullName) + "</strong>,")
            + paragraph("Nhập mã 6 chữ số dưới đây để hoàn tất đăng ký tài khoản TechCommerce.")
            + otpBlock(otp)
            + infoTable(
                infoRow("Hiệu lực", "10 phút"),
                infoRow("Số lần dùng", "1 lần duy nhất")
              )
            + warning("Nếu bạn không thực hiện đăng ký, hãy bỏ qua email này. Mã sẽ tự hết hạn."),
            "Mã OTP đăng ký TechCommerce: " + otp
        );
        record(toEmail, subject, otp);
        dispatchHtmlAsync(toEmail, subject, html);
    }

    // ── 2. Đặt lại mật khẩu ───────────────────────────────────────────────────

    public void sendPasswordResetEmail(String toEmail, String resetUrl) {
        String subject = "Đặt lại mật khẩu – TechCommerce";
        String html = wrap(
            heading("Yêu cầu đặt lại mật khẩu")
            + paragraph("Chúng tôi nhận được yêu cầu đặt lại mật khẩu cho tài khoản gắn với email này.")
            + button("Đặt lại mật khẩu", resetUrl)
            + paragraph("<small>Hoặc sao chép đường dẫn sau vào trình duyệt:<br>"
                      + "<span style=\"color:#6b7280;word-break:break-all;font-size:12px;\">"
                      + esc(resetUrl) + "</span></small>")
            + infoTable(
                infoRow("Hiệu lực", "15 phút"),
                infoRow("Số lần dùng", "1 lần duy nhất")
              )
            + warning("Nếu bạn không yêu cầu đặt lại mật khẩu, hãy bỏ qua email này. Mật khẩu hiện tại vẫn không thay đổi."),
            "Đường dẫn đặt lại mật khẩu TechCommerce (hiệu lực 15 phút)"
        );
        record(toEmail, subject, resetUrl);
        dispatchHtmlAsync(toEmail, subject, html);
    }

    // ── 3. Xác nhận đơn hàng ──────────────────────────────────────────────────

    public void sendOrderConfirmationEmail(String toEmail, String orderCode,
                                           String storeName, String totalFormatted) {
        String subject = "Đơn hàng #" + orderCode + " đã được xác nhận – TechCommerce";
        String html = wrap(
            heading("Đặt hàng thành công!")
            + paragraph("Cảm ơn bạn đã mua sắm tại TechCommerce. Đơn hàng của bạn đã được tiếp nhận và đang được xử lý.")
            + infoTable(
                infoRow("Mã đơn hàng", "#" + orderCode),
                infoRow("Chi nhánh xử lý", storeName),
                infoRow("Tổng thanh toán", totalFormatted),
                infoRow("Nhận tại quầy", "Sau 15 phút")
              )
            + paragraph("Bạn có thể theo dõi trạng thái đơn hàng trong mục <strong>Đơn hàng & Đổi trả</strong> trên tài khoản."),
            "Đơn hàng #" + orderCode + " đã được xác nhận"
        );
        record(toEmail, subject, orderCode);
        dispatchHtmlAsync(toEmail, subject, html);
    }

    // ── 4. Cập nhật trạng thái hoàn trả ──────────────────────────────────────

    public void sendReturnStatusEmail(String toEmail, String orderCode,
                                      String status, String staffNote) {
        String subject = "Cập nhật hoàn trả đơn #" + orderCode + " – TechCommerce";
        String noteRow = StringUtils.hasText(staffNote)
                ? infoRow("Ghi chú chi nhánh", staffNote) : "";
        String html = wrap(
            heading("Cập nhật yêu cầu hoàn trả")
            + paragraph("Yêu cầu hoàn trả cho đơn hàng <strong>#" + esc(orderCode) + "</strong> đã được cập nhật.")
            + infoTable(
                infoRow("Mã đơn hàng", "#" + orderCode),
                infoRow("Trạng thái mới", status),
                noteRow
              )
            + paragraph("Nếu bạn có thắc mắc, vui lòng liên hệ chi nhánh xử lý đơn hàng."),
            "Hoàn trả đơn #" + orderCode + ": " + status
        );
        record(toEmail, subject, status);
        dispatchHtmlAsync(toEmail, subject, html);
    }

    // ── 5. Hàng về kho ────────────────────────────────────────────────────────

    public void sendStockRestockedEmail(String toEmail, String productName,
                                        String storeName, String productUrl) {
        String subject = productName + " đã có hàng trở lại – TechCommerce";
        String html = wrap(
            heading("Sản phẩm bạn theo dõi đã có hàng!")
            + paragraph("Sản phẩm <strong>" + esc(productName) + "</strong> tại chi nhánh <strong>"
                      + esc(storeName) + "</strong> vừa được nhập hàng trở lại.")
            + button("Xem ngay trước khi hết", productUrl)
            + warning("Hàng có thể hết nhanh — đặt ngay để giữ máy."),
            productName + " đã có hàng tại " + storeName
        );
        record(toEmail, subject, productName);
        dispatchHtmlAsync(toEmail, subject, html);
    }

    // ── Internals ──────────────────────────────────────────────────────────────

    private void record(String toEmail, String subject, String bodySnippet) {
        if (StringUtils.hasText(toEmail)) {
            recordedEmails.add(new SentEmail(toEmail.trim(), subject, bodySnippet));
        }
    }

    @Async
    public void dispatchHtmlAsync(String toEmail, String subject, String htmlBody) {
        if (mailSender == null) return;
        try {
            MimeMessage mime = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(mime, false, "UTF-8");
            helper.setFrom(fromAddress);
            helper.setTo(toEmail);
            helper.setSubject(subject);
            helper.setText(htmlBody, true); // true = HTML
            mailSender.send(mime);
        } catch (Exception ex) {
            // SMTP failures must never roll back business transactions
            log.warn("Could not send HTML email to {} (subject: {}): {}", toEmail, subject, ex.getMessage());
        }
    }

    public List<SentEmail> getRecordedEmails() { return List.copyOf(recordedEmails); }
    public void clearRecordedEmails()          { recordedEmails.clear(); }
}
