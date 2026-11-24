package com.techcommerce.common.mail;

import jakarta.mail.Session;
import jakarta.mail.internet.MimeMessage;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.mail.javamail.JavaMailSender;

import java.util.Properties;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

class EmailServiceTest {

    @Test
    void generatesAllFiveHtmlEmailTemplatesEscapesXssAndDispatchesViaJavaMailSender() {
        JavaMailSender mockSender = Mockito.mock(JavaMailSender.class);
        when(mockSender.createMimeMessage()).thenAnswer(inv -> new MimeMessage((Session) null));

        EmailService service = new EmailService(mockSender, "no-reply@techcommerce.store");
        service.sendRegistrationOtpEmail("u1@techcommerce.store", "<script>alert(\"xss\")</script>", "123456");
        service.sendPasswordResetEmail("u2@techcommerce.store", "https://techcommerce.store/auth/reset-password?token=abc");
        service.sendOrderConfirmationEmail("u3@techcommerce.store", "TC-1001", "TechCommerce Hà Nội", "25.990.000đ");
        service.sendReturnStatusEmail("u4@techcommerce.store", "TC-1001", "APPROVED", "Máy đủ điều kiện đổi mới");
        service.sendStockRestockedEmail("u5@techcommerce.store", "MacBook Pro M4", "TechCommerce TP.HCM", "https://techcommerce.store/products/1");

        assertThat(service.getRecordedEmails()).hasSize(5);
        verify(mockSender, times(5)).send(any(MimeMessage.class));

        String escaped = EmailTemplate.esc("<script>alert(\"a\" & 'b')</script>");
        assertThat(escaped)
                .doesNotContain("<script>")
                .contains("&lt;script&gt;")
                .contains("&quot;a&quot;")
                .contains("&#39;b&#39;")
                .contains("&amp;");
        assertThat(EmailTemplate.badgeSuccess("Hoàn tất")).contains("Hoàn tất");
        assertThat(EmailTemplate.badgePrimary("Mới")).contains("Mới");
        assertThat(EmailTemplate.badgeWarning("Chờ xử lý")).contains("Chờ xử lý");
    }
}
