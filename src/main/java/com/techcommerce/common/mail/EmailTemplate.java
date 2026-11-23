package com.techcommerce.common.mail;

/**
 * Render HTML email template dùng chung.
 * Layout: header logo → title → body card → footer nhỏ.
 * Inline CSS để tương thích Gmail / Outlook / Apple Mail.
 */
public final class EmailTemplate {

    private EmailTemplate() {}

    // ── Màu thương hiệu ────────────────────────────────────────────────────────
    private static final String COLOR_BG        = "#f4f6f9";
    private static final String COLOR_CARD      = "#ffffff";
    private static final String COLOR_PRIMARY   = "#1a56db";
    private static final String COLOR_DARK      = "#111827";
    private static final String COLOR_MUTED     = "#6b7280";
    private static final String COLOR_BORDER    = "#e5e7eb";
    private static final String COLOR_SUCCESS   = "#059669";
    private static final String COLOR_WARNING   = "#d97706";

    // ── Wrapper HTML chung ─────────────────────────────────────────────────────
    public static String wrap(String htmlBody, String previewText) {
        return "<!DOCTYPE html>\n"
             + "<html lang=\"vi\">\n"
             + "<head>\n"
             + "  <meta charset=\"UTF-8\">\n"
             + "  <meta name=\"viewport\" content=\"width=device-width,initial-scale=1\">\n"
             + "  <title>TechCommerce</title>\n"
             + "  <style>\n"
             + "    body,table,td,a{-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%}\n"
             + "    table,td{mso-table-lspace:0pt;mso-table-rspace:0pt}\n"
             + "    img{-ms-interpolation-mode:bicubic;border:0;outline:none;text-decoration:none}\n"
             + "    body{margin:0;padding:0;background:" + COLOR_BG + ";font-family:'Helvetica Neue',Helvetica,Arial,sans-serif}\n"
             + "    a{color:" + COLOR_PRIMARY + "}\n"
             + "    @media only screen and(max-width:600px){\n"
             + "      .email-wrapper{width:100%!important;padding:0!important}\n"
             + "      .email-card{border-radius:0!important}\n"
             + "    }\n"
             + "  </style>\n"
             + "</head>\n"
             + "<body>\n"
             // Preview text ẩn (hiện trong inbox snippet)
             + "  <div style=\"display:none;max-height:0;overflow:hidden;mso-hide:all;\">"
             + esc(previewText)
             + "&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;"
             + "</div>\n"
             + "  <table role=\"presentation\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\">\n"
             + "    <tr><td align=\"center\" style=\"padding:32px 16px;\">\n"
             + "      <table class=\"email-wrapper\" role=\"presentation\" width=\"600\" cellpadding=\"0\" cellspacing=\"0\"\n"
             + "             style=\"max-width:600px;width:100%;\">\n"
             // Header logo
             + "        <tr><td style=\"padding:0 0 20px 0;\">\n"
             + "          <table role=\"presentation\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\">\n"
             + "            <tr>\n"
             + "              <td style=\"padding:20px 32px;background:#111827;border-radius:12px 12px 0 0;\">\n"
             + "                <span style=\"font-size:20px;font-weight:700;color:#ffffff;letter-spacing:-0.3px;\">\n"
             + "                  &#9881;&nbsp;TechCommerce\n"
             + "                </span>\n"
             + "              </td>\n"
             + "            </tr>\n"
             + "          </table>\n"
             + "        </td></tr>\n"
             // Card nội dung
             + "        <tr><td class=\"email-card\" style=\"background:" + COLOR_CARD + ";padding:40px 32px;border-radius:0 0 12px 12px;border:1px solid " + COLOR_BORDER + ";border-top:none;\">\n"
             + htmlBody
             + "        </td></tr>\n"
             // Footer
             + "        <tr><td style=\"padding:24px 0 0 0;text-align:center;\">\n"
             + "          <p style=\"margin:0;font-size:12px;color:" + COLOR_MUTED + ";line-height:1.6;\">\n"
             + "            © 2026 TechCommerce &nbsp;·&nbsp; Hà Nội · TP.HCM · Đà Nẵng<br>\n"
             + "            Email này được gửi tự động, vui lòng không trả lời.<br>\n"
             + "            <a href=\"https://techcommerce.store\" style=\"color:" + COLOR_MUTED + ";\">techcommerce.store</a>\n"
             + "          </p>\n"
             + "        </td></tr>\n"
             + "      </table>\n"
             + "    </td></tr>\n"
             + "  </table>\n"
             + "</body></html>";
    }

    // ── Các block tái sử dụng ──────────────────────────────────────────────────

    /** Tiêu đề lớn trong card. */
    public static String heading(String text) {
        return "<h1 style=\"margin:0 0 8px 0;font-size:22px;font-weight:700;color:" + COLOR_DARK + ";\">"
             + esc(text) + "</h1>\n";
    }

    /** Đoạn văn thường. */
    public static String paragraph(String html) {
        return "<p style=\"margin:0 0 16px 0;font-size:15px;color:" + COLOR_MUTED + ";line-height:1.7;\">"
             + html + "</p>\n";
    }

    /** Ô OTP lớn nổi bật. */
    public static String otpBlock(String otp) {
        return "<div style=\"margin:28px 0;text-align:center;\">\n"
             + "  <span style=\"display:inline-block;padding:18px 40px;background:#f0f4ff;"
             + "border:2px solid #c7d7fe;border-radius:10px;"
             + "font-size:36px;font-weight:700;letter-spacing:12px;color:" + COLOR_PRIMARY + ";"
             + "font-family:'Courier New',Courier,monospace;\">"
             + esc(otp)
             + "</span>\n"
             + "</div>\n";
    }

    /** Nút CTA. */
    public static String button(String label, String url) {
        return "<div style=\"margin:28px 0;text-align:center;\">\n"
             + "  <a href=\"" + url + "\" target=\"_blank\"\n"
             + "     style=\"display:inline-block;padding:14px 32px;background:" + COLOR_PRIMARY + ";"
             + "color:#ffffff;text-decoration:none;font-size:15px;font-weight:600;"
             + "border-radius:8px;\">" + esc(label) + "</a>\n"
             + "</div>\n";
    }

    /** Khối thông tin nhỏ dạng key-value. */
    public static String infoRow(String label, String value) {
        return "<tr>\n"
             + "  <td style=\"padding:8px 0;font-size:13px;color:" + COLOR_MUTED + ";width:40%;border-bottom:1px solid " + COLOR_BORDER + ";\">" + esc(label) + "</td>\n"
             + "  <td style=\"padding:8px 0;font-size:13px;color:" + COLOR_DARK + ";font-weight:600;border-bottom:1px solid " + COLOR_BORDER + ";\">" + esc(value) + "</td>\n"
             + "</tr>\n";
    }

    /** Bảng key-value bọc ngoài. */
    public static String infoTable(String... rows) {
        StringBuilder sb = new StringBuilder();
        sb.append("<table role=\"presentation\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\""
                + " style=\"border:1px solid " + COLOR_BORDER + ";border-radius:8px;"
                + "padding:0 16px;margin:20px 0;\">\n");
        for (String row : rows) sb.append(row);
        sb.append("</table>\n");
        return sb.toString();
    }

    /** Cảnh báo nhỏ dưới card. */
    public static String warning(String text) {
        return "<div style=\"margin-top:24px;padding:12px 16px;background:#fefce8;"
             + "border:1px solid #fde68a;border-radius:8px;"
             + "font-size:13px;color:" + COLOR_WARNING + ";line-height:1.6;\">"
             + text + "</div>\n";
    }

    /** Escape HTML cơ bản. */
    public static String esc(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
    }

    // ── Badge màu trạng thái ───────────────────────────────────────────────────
    public static String badge(String text, String color) {
        return "<span style=\"display:inline-block;padding:3px 10px;border-radius:99px;"
             + "background:" + color + "20;color:" + color + ";"
             + "font-size:12px;font-weight:600;\">" + esc(text) + "</span>";
    }

    public static String badgeSuccess(String text) { return badge(text, COLOR_SUCCESS); }
    public static String badgePrimary(String text)  { return badge(text, COLOR_PRIMARY); }
    public static String badgeWarning(String text)  { return badge(text, COLOR_WARNING); }
}
