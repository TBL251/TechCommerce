# TechCommerce - Hệ thống thương mại điện tử chuỗi cửa hàng công nghệ

TechCommerce là nền tảng bán lẻ thiết bị công nghệ vận hành theo mô hình chuỗi cửa hàng đa chi nhánh (Hà Nội, TP.HCM, Đà Nẵng). Hệ thống cho phép khách hàng chọn chi nhánh mua sắm để xem tồn kho thực tế, ước tính thời gian giao hàng hoặc nhận tại quầy, tìm kiếm sản phẩm tiếng Việt không dấu, so sánh cấu hình kỹ thuật, lưu danh sách yêu thích, đăng ký nhận email khi có hàng lại, đặt hàng thanh toán qua COD hoặc VNPay Sandbox, theo dõi tiến trình đơn hàng theo thời gian thực qua WebSocket, nhắn tin trực tiếp với nhân viên chi nhánh và gửi yêu cầu đổi trả trong vòng 7 ngày.

- Tên miền chính thức: https://techcommerce.store
- Kho mã nguồn GitHub: https://github.com/TBL251/TechCommerce
- Tài liệu kiến trúc chi tiết: [tasks/plan.md](tasks/plan.md)
- Danh sách 21 hạng mục công việc & tiêu chí nghiệm thu: [tasks/todo.md](tasks/todo.md)

---

## Mục lục

1. [Kiến trúc hệ thống và luồng triển khai](#1-kiến-trúc-hệ-thống-và-luồng-triển-khai)
2. [Công nghệ và thư viện sử dụng](#2-công-nghệ-và-thư-viện-sử-dụng)
3. [Cấu trúc thư mục mã nguồn](#3-cấu-trúc-thư-mục-mã-nguồn)
4. [Thiết kế cơ sở dữ liệu và Flyway Migration](#4-thiết-kế-cơ-sở-dữ-liệu-và-flyway-migration)
5. [Chức năng hệ thống theo phân quyền](#5-chức-năng-hệ-thống-theo-phân-quyền)
6. [Phân công công việc nhóm 4 thành viên](#6-phân-công-công-việc-nhóm-4-thành-viên)
7. [Hướng dẫn điền chi tiết tệp biến môi trường `.env`](#7-hướng-dẫn-điền-chi-tiết-tệp-biến-môi-trường-env)
8. [Hướng dẫn cài đặt và chạy trên máy cá nhân](#8-hướng-dẫn-cài-đặt-và-chạy-trên-máy-cá-nhân)
9. [Danh sách đường dẫn và tài khoản mẫu để kiểm thử](#9-danh-sách-đường-dẫn-và-tài-khoản-mẫu-để-kiểm-thử)
10. [Quy trình CI/CD tự động và cài đặt Self-Hosted Runner](#10-quy-trình-cicd-tự-động-và-cài-đặt-self-hosted-runner)
11. [Vận hành Production và kịch bản chuyển máy dự phòng](#11-vận-hành-production-và-kịch-bản-chuyển-máy-dự-phòng)
12. [Quy tắc làm việc nhóm với Git](#12-quy-tắc-làm-việc-nhóm-với-git)

---

## 1. Kiến trúc hệ thống và luồng triển khai

Hệ thống được thiết kế theo mô hình Modular Monolith trên nền tảng Spring Boot 3.3.5 đóng gói dạng Executable WAR để hỗ trợ biên dịch JSP thông qua Embedded Tomcat Jasper và bộ khung giao diện SiteMesh 3.

```text
[Người dùng Internet]
        │  HTTPS (TLS 1.3 / Chứng chỉ Cloudflare Edge)
        ▼
[Cloudflare DNS & Edge Proxy (techcommerce.store)]
        │  Đường hầm bảo mật kết nối ra ngoài (Outbound QUIC/HTTP2)
        ▼
[Container: techcommerce-prod-tunnel (cloudflared)]
        │  Mạng nội bộ Docker (tc_prod_net -> http://nginx:80)
        ▼
[Container: techcommerce-prod-nginx (Nginx 1.27 Alpine)]
        ├── Nén Gzip & Cache 7 ngày cho tài nguyên tĩnh (/assets/**)
        ├── Giới hạn tần suất chống spam (limit_req_zone) cho /auth/register, /auth/forgot-password
        ├── Nâng cấp kết nối WebSocket (Upgrade: websocket) cho /ws
        └── Chuyển tiếp HTTP kèm X-Forwarded-Proto / X-Forwarded-Host
        ▼
[Container: techcommerce-prod-app (Spring Boot 3.3.5 WAR - Java 17/21)]
        ├── Supabase PostgreSQL (Session Pooler IPv4 cổng 5432, vùng Singapore ap-southeast-1)
        ├── Google OAuth2 (Đăng nhập một chạm)
        ├── Gmail SMTP (@Async gửi email đặt lại mật khẩu & thông báo đơn hàng)
        ├── Cloudinary API (Lưu trữ ảnh sản phẩm, đánh giá, minh chứng hoàn trả)
        └── VNPay Sandbox (Thanh toán trực tuyến ký số HMAC-SHA512)
```

Cách bố trí này loại bỏ hoàn toàn việc phải mở cổng (Port Forwarding) trên modem mạng gia đình, giữ cố định tên miền `https://techcommerce.store` và cho phép bất kỳ máy tính nào trong nhóm có tệp `.env` đều có thể bật container dự phòng thay thế máy chủ chính trong 30 giây.

---

## 2. Công nghệ và thư viện sử dụng

| Tầng chức năng | Công nghệ / Thư viện | Phiên bản & Ghi chú |
| :--- | :--- | :--- |
| Ngôn ngữ & Công cụ build | Java (Eclipse Temurin), Maven Wrapper (`mvnw`) | Tương thích JDK 17 và JDK 21 LTS, đóng gói `war` |
| Backend cốt lõi | Spring Boot (`spring-boot-starter-web`, `data-jpa`, `validation`, `cache`, `mail`, `websocket`) | `3.3.5` (`open-in-view: false`, múi giờ `UTC`) |
| Giao diện phía máy chủ | JSP, Jakarta JSTL, Embedded Tomcat Jasper, SiteMesh | JSTL `3.0`, SiteMesh `3.2.2`, Bootstrap `5.3.3`, Chart.js |
| Cơ sở dữ liệu & Migration | PostgreSQL, Flyway (`flyway-core`, `flyway-database-postgresql`), H2 (dành riêng cho test) | PostgreSQL 16/17 (Supabase Singapore / Docker Local) |
| Bảo mật & Xác thực | Spring Security 6, `jjwt` (HMAC-SHA256), Spring OAuth2 Client | `jjwt 0.12.6`, lưu JWT trong `HttpOnly` Cookie + xoay vòng Refresh Token |
| Lưu trữ đám mây & Thanh toán | Cloudinary Java SDK, VNPay Sandbox | `cloudinary-http44 1.38.0`, VNPay HMAC-SHA512 |
| Kiểm thử tự động | JUnit 5, Spring Boot Test, Spring Security Test, MockMvc, Mockito (`byte-buddy-agent`) | 22 bài kiểm thử đơn vị và tích hợp cho nền tảng Giai đoạn 1 & 5 |
| Đóng gói & Triển khai | Docker Multi-stage, Docker Compose, Nginx, Cloudflare Tunnel, GitHub Actions | Tự động kiểm thử CI, đẩy image lên GHCR và CD qua Self-Hosted Runner |

---

## 3. Cấu trúc thư mục mã nguồn

```text
TechCommerce/
├── .github/
│   └── workflows/
│       ├── ci.yml                      # Workflow tự động chạy 22 test với Postgres 16 & kiểm tra docker build
│       └── cd.yml                      # Workflow đẩy image lên GHCR & tự động deploy qua Self-Hosted Runner
├── .mvn/wrapper/                       # Cấu hình Maven Wrapper không cần cài Maven toàn cục
├── docker/
│   └── nginx/
│       └── default.conf                # Cấu hình Nginx: Gzip, Cache /assets/, Rate Limit, WebSocket /ws
├── src/
│   ├── main/
│   │   ├── java/com/techcommerce/
│   │   │   ├── auth/                   # [TV1] Entity User, RefreshToken, PasswordResetToken, UserAddress,
│   │   │   │                           #       JwtService, JwtAuthenticationFilter, OAuth2, Controllers, Services
│   │   │   ├── common/                 # [TV1] HealthController, GlobalExceptionHandler, EmailService,
│   │   │   │                           #       CurrentUserAdvice, GuestCartMerger, DomainEvents
│   │   │   ├── config/                 # [TV1] SecurityConfig, SiteMeshConfig, DemoDataSeeder
│   │   │   ├── store/                  # [TV1/TV2] Entity Store, StoreRepository (và quản lý chi nhánh của TV2)
│   │   │   ├── catalog/                # [TV2] Danh mục, thương hiệu, sản phẩm, biến thể, tồn kho, voucher
│   │   │   ├── order/                  # [TV3] Giỏ hàng, thanh toán COD/VNPay, đơn hàng, yêu cầu hoàn trả
│   │   │   ├── realtime/               # [TV4] Cấu hình WebSocket STOMP, thông báo realtime, chat chi nhánh
│   │   │   ├── report/                 # [TV4] Đánh giá kèm ảnh, hỏi đáp Q&A, báo cáo doanh thu & xuất CSV
│   │   │   ├── ServletInitializer.java # Khởi tạo gói WAR
│   │   │   └── TechCommerceApplication.java
│   │   ├── resources/
│   │   │   ├── db/migration/
│   │   │   │   └── V1__init_stores_and_users.sql   # Lược đồ 5 bảng cốt lõi của TV1
│   │   │   ├── application.yml         # Cấu hình dùng chung, tự động nạp tệp .env cục bộ
│   │   │   ├── application-dev.yml     # Cấu hình môi trường lập trình (bật DemoDataSeeder)
│   │   │   └── application-prod.yml    # Cấu hình môi trường production (Cookie Secure, HikariCP tối ưu)
│   │   └── webapp/
│   │       ├── assets/css/main.css     # Định kiểu giao diện dùng chung
│   │       └── WEB-INF/
│   │           ├── decorators/         # 3 khung giao diện SiteMesh: web.jsp, admin.jsp, auth.jsp
│   │           └── jsp/
│   │               ├── admin/users/    # Màn hình quản trị người dùng & gán chi nhánh cho STAFF
│   │               ├── auth/           # Màn hình login.jsp, register.jsp, forgot-password.jsp,
│   │               │                   #          reset-password.jsp, profile.jsp
│   │               ├── error/          # Trang lỗi tùy chỉnh 403.jsp, 404.jsp, 500.jsp
│   │               └── health.jsp      # Trang chủ mặc định & điểm kiểm tra sức khỏe JSP
│   └── test/
│       ├── java/com/techcommerce/      # Bộ 10 lớp kiểm thử JUnit 5 & MockMvc (22 kịch bản kiểm thử)
│       └── resources/
│           └── application-test.yml    # Cấu hình H2 chế độ PostgreSQL cho kiểm thử tự động độc lập
├── tasks/
│   ├── plan.md                         # Bản thiết kế kiến trúc tổng thể
│   └── todo.md                         # Danh sách 21 task chi tiết chia theo 5 giai đoạn
├── .dockerignore
├── .env.example                        # Tệp mẫu các biến môi trường (không chứa khóa mật)
├── .gitignore
├── Dockerfile                          # Đóng gói Multi-stage WAR chạy trên eclipse-temurin:17-jre-alpine (non-root)
├── docker-compose.yml                  # Môi trường phụ trợ local: PostgreSQL 16 + Mailpit
├── docker-compose.prod.yml             # Môi trường Production: App + Nginx + Cloudflare Tunnel
├── mvnw / mvnw.cmd
└── pom.xml
```

---

## 4. Thiết kế cơ sở dữ liệu và Flyway Migration

Mỗi thành viên chịu trách nhiệm một tệp migration Flyway riêng để không xảy ra xung đột khi gộp nhánh:

- **`V1__init_stores_and_users.sql` (TV1 — Đã hoàn thành)**:
  - `stores`: quản lý chi nhánh cửa hàng (`id`, `code`, `name`, `address`, `phone`, `latitude`, `longitude`, `open_hours`, `is_active`).
  - `users`: quản lý tài khoản người dùng (`id`, `email`, `password_hash` cho phép `NULL` với tài khoản đăng nhập qua Google, `auth_provider`, `google_sub`, `full_name`, `phone`, `role` gồm `CUSTOMER`/`STAFF`/`ADMIN`, `store_id` đi kèm ràng buộc `chk_staff_must_have_store` bắt buộc tài khoản `STAFF` phải gắn với một chi nhánh, `failed_login_attempts`, `locked_until`, `is_active`).
  - `user_addresses`: sổ địa chỉ nhận hàng của khách (`user_id`, `recipient_name`, `recipient_phone`, `shipping_address`, `is_default`), giới hạn tối đa 5 địa chỉ mỗi người dùng.
  - `refresh_tokens`: quản lý phiên Refresh Token xoay vòng (`user_id`, `token_hash` lưu mã băm SHA-256, `expires_at`, `revoked`).
  - `password_reset_tokens`: lưu mã khôi phục mật khẩu một lần có hạn 15 phút (`user_id`, `token_hash`, `expires_at`, `used`).
- **`V2__catalog_and_store_inventory.sql` (TV2)**:
  - `categories`, `brands`, `products`, `product_images`, `product_variants` (chứa cột `specs_json` phục vụ so sánh cấu hình), `store_inventories` (tồn kho theo từng cặp chi nhánh và biến thể), `vouchers`, `wishlists`, `stock_notifications`.
- **`V3__cart_and_orders.sql` (TV3)**:
  - `carts`, `cart_items` (hỗ trợ `saved_for_later`), `orders`, `order_items`, `payment_transactions` (chống trùng lặp IPN VNPay bằng `UNIQUE(provider, transaction_no)`), `return_requests` (đổi trả trong 7 ngày).
- **`V4__reviews_and_chat.sql` (TV4)**:
  - `reviews` (hỗ trợ đính kèm tối đa 3 ảnh thực tế `image_urls`), `product_questions` (hỏi đáp Q&A), `chat_rooms`, `chat_messages`, `notifications`.
- **`V5__seed_demo_data.sql` (Cả nhóm)**:
  - Nạp dữ liệu sản phẩm công nghệ thực tế, biến thể cấu hình, tồn kho chênh lệch giữa 3 chi nhánh và đơn hàng mẫu phục vụ báo cáo.

---

## 5. Chức năng hệ thống theo phân quyền

### Khách hàng (`CUSTOMER` và khách vãng lai)
- Chọn chi nhánh mua sắm trên thanh điều hướng, xem danh sách chi nhánh và chuyển nhanh sang chi nhánh còn hàng.
- Tìm kiếm sản phẩm tiếng Việt không dấu, xem gợi ý nhanh khi gõ, lọc theo danh mục, thương hiệu, khoảng giá và tình trạng còn hàng.
- So sánh thông số kỹ thuật của 2 đến 3 sản phẩm cạnh nhau, lưu danh sách yêu thích và đăng ký nhận email khi có hàng lại.
- Quản lý giỏ hàng từ khi chưa đăng nhập (tự động gộp vào giỏ hàng tài khoản ngay khi đăng nhập qua `GuestCartMerger`), đánh dấu "Lưu mua sau" hoặc bấm "Mua ngay".
- Đăng ký tài khoản, đăng nhập bằng email/mật khẩu (tự động khóa 15 phút nếu nhập sai 5 lần liên tiếp) hoặc đăng nhập bằng Google OAuth2, khôi phục mật khẩu qua email SMTP, cập nhật hồ sơ và quản lý sổ địa chỉ nhận hàng mặc định.
- Áp dụng mã giảm giá, chọn giao tận nơi hoặc nhận tại chi nhánh, thanh toán COD hoặc VNPay Sandbox, theo dõi tiến trình đơn hàng theo thời gian thực và gửi yêu cầu hoàn trả trong vòng 7 ngày sau khi đơn hoàn tất.

### Nhân viên chi nhánh (`STAFF`)
- Chỉ được phép thao tác trong phạm vi chi nhánh (`store_id`) đã được Admin phân công.
- Cập nhật số lượng tồn kho tại chi nhánh mình, xử lý trạng thái đơn hàng của chi nhánh, duyệt yêu cầu hoàn trả hàng, phản hồi tin nhắn chat trực tuyến của khách hàng gửi tới chi nhánh, trả lời câu hỏi Q&A và xuất báo cáo doanh thu ròng của chi nhánh ra tệp CSV.

### Quản trị viên hệ thống (`ADMIN`)
- Quản trị toàn bộ danh sách chi nhánh, danh mục, thương hiệu, sản phẩm, biến thể, ảnh Cloudinary và mã giảm giá.
- Tạo mới tài khoản nhân viên (`STAFF`), gán hoặc điều chuyển chi nhánh làm việc, khóa hoặc mở khóa tài khoản người dùng (hệ thống tự động thu hồi toàn bộ Refresh Token đang hoạt động ngay khi khóa tài khoản).
- Xem biểu đồ so sánh doanh thu và thống kê đơn hàng trên toàn chuỗi chi nhánh.

---

## 6. Phân công công việc nhóm 4 thành viên

| Thành viên | Phạm vi phụ trách | Các điểm giao tiếp (Interfaces / Events) | Danh sách Task |
| :--- | :--- | :--- | :--- |
| **TV1** *(Đã hoàn tất 100%)* | Khởi tạo dự án, Lược đồ `V1`, SiteMesh 3 Layout, GlobalExceptionHandler, Xác thực JWT Cookie + Refresh Token + Google OAuth2, Quên mật khẩu `@Async`, Hồ sơ & Sổ địa chỉ, Quản trị User/Staff, `DemoDataSeeder`, Docker, Nginx, Cloudflare Tunnel & GitHub Actions CI/CD | Cung cấp `@AuthenticationPrincipal UserPrincipal`, `${currentUser}` qua `CurrentUserAdvice`, `EmailService`, `GuestCartMerger` và các record sự kiện trong `DomainEvents` | Task 1, 2, 3, 4, 19, 20 |
| **TV2** | `CloudinaryService`, Quản lý chuỗi chi nhánh, Catalog sản phẩm & biến thể, Tồn kho theo chi nhánh, Tìm kiếm không dấu, Voucher, So sánh cấu hình, Wishlist & Đăng ký báo khi có hàng | Phát sự kiện `RestockAlertEvent` khi nhập kho từ `0` lên `> 0`; cung cấp hàm kiểm tra và trừ kho có khóa dòng (`@Lock(PESSIMISTIC_WRITE)`) | Task 5, 6, 7, 8, 9 |
| **TV3** | Giỏ hàng (`GuestCartMergerImpl`), Đặt hàng & áp dụng Voucher, Thanh toán COD & VNPay Sandbox (kèm `@Scheduled` tự hủy đơn quá hạn 15 phút), Quản lý đơn hàng & Yêu cầu đổi trả 7 ngày | Phát sự kiện `OrderCreatedEvent`, `OrderStatusChangedEvent`, `ReturnRequestEvent` thông qua `ApplicationEventPublisher` | Task 10, 11, 12, 13, 14 |
| **TV4** | Cấu hình WebSocket STOMP/SockJS xác thực từ cookie `ACCESS_TOKEN`, Thông báo realtime (`@TransactionalEventListener`), Chat hỗ trợ theo chi nhánh, Đánh giá kèm ảnh, Hỏi đáp Q&A & Dashboard doanh thu (Chart.js + CSV) | Lắng nghe các sự kiện trong `DomainEvents` để đẩy thông báo WebSocket tới `/topic/store/{storeId}/orders` và `/user/queue/orders` | Task 15, 16, 17, 18 |

---

## 7. Hướng dẫn điền chi tiết tệp biến môi trường `.env`

Ứng dụng đã được cấu hình `spring.config.import: optional:file:.env[.properties]` trong [src/main/resources/application.yml](src/main/resources/application.yml) để tự động nạp tệp `.env` ở thư mục gốc khi chạy. Tệp `.env` đã được chặn trong [.gitignore](.gitignore) để bảo vệ thông tin mật.

Khi mới kéo mã nguồn về máy, bạn tạo tệp `.env` từ tệp mẫu [.env.example](.env.example):

```powershell
Copy-Item .env.example .env
```

Cách điền từng nhóm biến trong `.env`:

1. **Cấu hình ứng dụng**:
   ```properties
   SPRING_PROFILES_ACTIVE=dev
   APP_PUBLIC_URL=https://techcommerce.store
   ```
   Khi chạy thử chỉ riêng trên máy cá nhân có thể đặt `APP_PUBLIC_URL=http://localhost:8080`.
2. **Cơ sở dữ liệu PostgreSQL (Supabase hoặc Local Docker)**:
   - Nếu dùng **Supabase PostgreSQL** (vùng Singapore `ap-southeast-1`), hãy chọn mục **Session pooler (cổng 5432, IPv4 compatible)** trong hộp thoại *Connect* của Supabase để chạy ổn định trên cả mạng IPv4 lẫn trong Docker container:
     ```properties
     DB_URL=jdbc:postgresql://aws-1-ap-southeast-1.pooler.supabase.com:5432/postgres?sslmode=require
     DB_USERNAME=postgres.<ma_project_supabase>
     DB_PASSWORD=<mat_khau_database>
     FLYWAY_URL=jdbc:postgresql://aws-1-ap-southeast-1.pooler.supabase.com:5432/postgres?sslmode=require
     ```
   - Nếu dùng **Docker PostgreSQL cục bộ** (chạy từ `docker-compose.yml`):
     ```properties
     DB_URL=jdbc:postgresql://localhost:5432/techcommerce
     DB_USERNAME=techcommerce
     DB_PASSWORD=techcommerce_dev
     FLYWAY_URL=
     ```
3. **Bảo mật JWT**:
   ```properties
   JWT_SECRET=<chuoi_ngau_nhien_toi_thieu_32_ky_tu>
   JWT_ACCESS_EXPIRATION_SECONDS=1200
   JWT_REFRESH_EXPIRATION_SECONDS=604800
   ```
4. **Google OAuth2**:
   Tạo OAuth 2.0 Client ID (loại *Web application*) tại Google Cloud Console, khai báo 2 đường dẫn *Authorized redirect URIs* là `http://localhost:8080/login/oauth2/code/google` và `https://techcommerce.store/login/oauth2/code/google`:
   ```properties
   GOOGLE_CLIENT_ID=<client_id>.apps.googleusercontent.com
   GOOGLE_CLIENT_SECRET=GOCSPX-<client_secret>
   ```
5. **Gửi email SMTP**:
   - Nếu gửi qua **Gmail thật**: bật xác minh 2 bước trên tài khoản Google, tạo *App Password* 16 chữ cái (viết liền không khoảng trắng):
     ```properties
     MAIL_HOST=smtp.gmail.com
     MAIL_PORT=587
     MAIL_USERNAME=<email_cua_ban>@gmail.com
     MAIL_PASSWORD=<16_ky_tu_app_password>
     MAIL_FROM=<email_cua_ban>@gmail.com
     ```
   - Nếu dùng **Mailpit cục bộ** khi test offline: đặt `MAIL_HOST=localhost`, `MAIL_PORT=1025`, để trống `MAIL_USERNAME` và `MAIL_PASSWORD`, xem hộp thư tại `http://localhost:8025`.
6. **Lưu trữ ảnh Cloudinary**:
   Lấy từ trang Cloudinary Console Dashboard:
   ```properties
   CLOUDINARY_CLOUD_NAME=<cloud_name>
   CLOUDINARY_API_KEY=<api_key>
   CLOUDINARY_API_SECRET=<api_secret>
   ```
7. **Cổng thanh toán VNPay Sandbox**:
   Đăng ký tại https://sandbox.vnpayment.vn/devreg/, bấm link kích hoạt trong email đầu tiên để nhận mã `vnp_TmnCode` và `vnp_HashSecret` trong email thứ hai:
   ```properties
   VNPAY_TMN_CODE=<ma_tmn_8_ky_tu>
   VNPAY_HASH_SECRET=<chuoi_hash_secret_32_ky_tu>
   VNPAY_PAY_URL=https://sandbox.vnpayment.vn/paymentv2/vpcpay.html
   VNPAY_RETURN_URL=https://techcommerce.store/payments/vnpay/return
   ```
8. **Cloudflare Named Tunnel**:
   Tạo tunnel `techcommerce-prod` trong mục *Networking -> Tunnels* trên Cloudflare, gắn route `techcommerce.store` trỏ về `http://nginx:80` và dán chuỗi token vào:
   ```properties
   CLOUDFLARE_TUNNEL_TOKEN=eyJhIjoi...
   ```

---

## 8. Hướng dẫn cài đặt và chạy trên máy cá nhân

### Yêu cầu môi trường
- **JDK 17 hoặc JDK 21 LTS** (Eclipse Temurin).
- **Docker Desktop** (nếu dùng PostgreSQL/Mailpit local hoặc chạy bộ container `docker-compose.prod.yml`).
- Không cần cài đặt Maven riêng vì dự án đã tích hợp sẵn `mvnw` và `mvnw.cmd`.

### Các lệnh thường dùng

```powershell
# 1. (Tùy chọn) Bật PostgreSQL 16 và Mailpit local nếu không dùng Supabase
docker compose up -d

# 2. Chạy toàn bộ 22 bài kiểm thử tự động (chạy độc lập trên H2 in-memory)
.\mvnw.cmd test

# 3. Đóng gói tệp thực thi target/techcommerce.war
.\mvnw.cmd clean package -DskipTests

# 4. Khởi chạy server phát triển tại cổng 8080
.\mvnw.cmd spring-boot:run
```

Nếu máy tính của bạn cài nhiều phiên bản Java và biến `JAVA_HOME` mặc định đang trỏ về Java 8, hãy chỉ định `JAVA_HOME` sang thư mục JDK 17/21 trước khi gọi `mvnw.cmd`:

```powershell
$env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-21.0.13.10002-hotspot"
.\mvnw.cmd spring-boot:run
```

---

## 9. Danh sách đường dẫn và tài khoản mẫu để kiểm thử

### Các đường dẫn đã hoạt động (Công việc của TV1)

| Chức năng | Đường dẫn công khai (`techcommerce.store`) | Đường dẫn máy cá nhân (`localhost`) |
| :--- | :--- | :--- |
| Trang chủ mặc định & Health JSP | https://techcommerce.store | http://localhost:8080 |
| Kiểm tra sức khỏe JSON API | https://techcommerce.store/api/health | http://localhost:8080/api/health |
| Đăng nhập (Email & Google OAuth2) | https://techcommerce.store/auth/login | http://localhost:8080/auth/login |
| Đăng ký tài khoản khách hàng | https://techcommerce.store/auth/register | http://localhost:8080/auth/register |
| Quên mật khẩu (gửi link qua email) | https://techcommerce.store/auth/forgot-password | http://localhost:8080/auth/forgot-password |
| Hồ sơ cá nhân & Sổ địa chỉ (tối đa 5) | https://techcommerce.store/profile | http://localhost:8080/profile |
| Quản trị nhân sự & Gán chi nhánh (Admin) | https://techcommerce.store/admin/users | http://localhost:8080/admin/users |

### Bốn tài khoản mẫu tự động khởi tạo (`DemoDataSeeder`)

Khi ứng dụng chạy ở chế độ `dev` (`app.seed-demo-data: true`), hệ thống tự động kiểm tra và khởi tạo 3 chi nhánh (`HN-01`, `HCM-01`, `DN-01`) cùng 4 tài khoản mẫu dùng chung mật khẩu **`Password123!`**:

| Vai trò | Email đăng nhập | Mật khẩu | Phạm vi chi nhánh |
| :--- | :--- | :--- | :--- |
| Quản trị viên (`ADMIN`) | `admin@techcommerce.store` | `Password123!` | Toàn bộ hệ thống |
| Nhân viên Hà Nội (`STAFF`) | `staff.hn@techcommerce.store` | `Password123!` | `HN-01` — TechCommerce Hà Nội (120 Cầu Giấy) |
| Nhân viên TP.HCM (`STAFF`) | `staff.hcm@techcommerce.store` | `Password123!` | `HCM-01` — TechCommerce TP.HCM (268 Lý Thường Kiệt) |
| Khách hàng (`CUSTOMER`) | `customer@techcommerce.store` | `Password123!` | Khách mua lẻ toàn chuỗi |

---

## 10. Quy trình CI/CD tự động và cài đặt Self-Hosted Runner

Hệ thống sử dụng 2 workflow GitHub Actions tự động hóa hoàn toàn từ khâu kiểm tra chất lượng mã nguồn đến khâu cập nhật trang web thực tế:

### Chốt chặn 1: Kiểm thử tự động ([.github/workflows/ci.yml](.github/workflows/ci.yml))
- Kích hoạt trên mọi lệnh `push` hoặc `pull_request` vào nhánh `develop` và `main`.
- Tự động khởi tạo container dịch vụ PostgreSQL 16 trên GitHub, chạy `./mvnw -B verify` (toàn bộ unit test và integration test) và kiểm tra lệnh `docker build`. Nếu bất kỳ bài kiểm thử nào thất bại, Pull Request sẽ báo đỏ để ngăn gộp mã lỗi.

### Chốt chặn 2: Đóng gói GHCR và Triển khai tự động ([.github/workflows/cd.yml](.github/workflows/cd.yml))
- Chỉ kích hoạt khi nhánh `main` nhận code mới (hoặc khi kích hoạt thủ công qua `workflow_dispatch`).
- **Job 1 (`Build & Push Docker Image to GHCR`)**: Chạy lại toàn bộ bài test, đóng gói image Docker multi-stage và đẩy lên kho GitHub Container Registry với 2 thẻ `ghcr.io/tbl251/techcommerce:latest` và `ghcr.io/tbl251/techcommerce:<commit_sha>`.
- **Job 2 (`Deploy to Self-Hosted Server`)**: Chỉ chạy sau khi Job 1 thành công và biến `ENABLE_SELF_HOSTED_DEPLOY=true` được bật. Self-Hosted Runner (`tv1-windows`) trên máy chủ tự động kết xuất tệp `.env.prod` từ GitHub Secrets, kéo image mới từ GHCR và cập nhật bộ container `techcommerce-prod`.

### Các lệnh quản lý nhanh với GitHub CLI (`gh`)

```powershell
# Đồng bộ toàn bộ biến từ tệp .env lên GitHub Actions Secrets
gh secret set -f .env --repo TBL251/TechCommerce

# Bật hoặc tắt chế độ tự động deploy về Self-Hosted Runner
gh variable set ENABLE_SELF_HOSTED_DEPLOY --body "true" --repo TBL251/TechCommerce

# Khởi chạy tiến trình lắng nghe của Self-Hosted Runner trên máy Windows
.\.actions-runner\run.cmd
```

---

## 11. Vận hành Production và kịch bản chuyển máy dự phòng

Bộ container Production được định nghĩa trong [docker-compose.prod.yml](docker-compose.prod.yml) dưới tên project `techcommerce-prod` gồm 3 dịch vụ:
- `techcommerce-prod-app`: chạy tệp WAR với tài khoản non-root `appuser`, giới hạn bộ nhớ `-Xms256m -Xmx512m` và cơ chế tự kiểm tra sức khỏe (`HEALTHCHECK`) tại `/health-jsp`.
- `techcommerce-prod-nginx`: lắng nghe lưu lượng từ Tunnel và cổng nội bộ `127.0.0.1:18080`, hỗ trợ tự động chuyển đổi dự phòng (`upstream techcommerce_app`) giữa container `app:8080` và `host.docker.internal:8080`.
- `techcommerce-prod-tunnel`: duy trì kết nối Cloudflare Named Tunnel ra tên miền `https://techcommerce.store`.

### Lệnh bật/tắt thủ công cụm Production

```powershell
# Khởi động hoặc cập nhật toàn bộ cụm Production
docker compose -p techcommerce-prod -f docker-compose.prod.yml up -d

# Xem trạng thái và nhật ký hoạt động
docker compose -p techcommerce-prod -f docker-compose.prod.yml ps
docker compose -p techcommerce-prod -f docker-compose.prod.yml logs -f app
```

### Kịch bản bật máy dự phòng khi bảo vệ đồ án (Cold-Standby Failover)
Vì cơ sở dữ liệu đặt trên **Supabase PostgreSQL (vùng Singapore)** và tên miền định tuyến qua **Cloudflare Named Tunnel**, trong trường hợp máy chủ chính của TV1 gặp sự cố mất điện hoặc rớt mạng khi đang thuyết trình:
1. Thành viên dự phòng (TV2) đã cài sẵn Docker Desktop và có cùng tệp `.env` chỉ cần mở Terminal chạy:
   ```powershell
   docker compose -p techcommerce-prod -f docker-compose.prod.yml pull
   docker compose -p techcommerce-prod -f docker-compose.prod.yml up -d
   ```
2. Trong vòng 30 giây, container `cloudflared` trên máy TV2 tự động đăng ký replica mới với Cloudflare. Tên miền `https://techcommerce.store` hoạt động trở lại bình thường với 100% dữ liệu tài khoản, sản phẩm và đơn hàng trên Supabase được giữ nguyên.

---

## 12. Quy tắc làm việc nhóm với Git

1. **Chiến lược phân nhánh**:
   - `main`: nhánh sản phẩm ổn định, tự động kích hoạt quy trình CD cập nhật lên `https://techcommerce.store`.
   - `develop`: nhánh tích hợp code của 4 thành viên.
   - Các thành viên tạo nhánh tính năng từ `develop` theo quy ước: `feat/tv2-catalog`, `feat/tv3-checkout`, `feat/tv4-websocket`, sau đó tạo Pull Request về `develop`.
2. **Quy ước thông điệp Commit (Tiếng Việt rõ ràng theo chuẩn Conventional Commits)**:
   - `feat: ...` khi thêm tính năng mới.
   - `fix: ...` khi sửa lỗi.
   - `refactor: ...` khi tái cấu trúc mã nguồn.
   - `test: ...` khi bổ sung bài kiểm thử.
   - `ci: ...` / `build: ...` / `ops: ...` / `docs: ...` cho các thay đổi hạ tầng và tài liệu.
3. **Kiểm soát tệp dùng chung**:
   - Các tệp `pom.xml`, `SecurityConfig.java`, `SiteMeshConfig.java`, thư mục `WEB-INF/decorators/` và thứ tự phiên bản trong `src/main/resources/db/migration/` phải được TV1 rà soát trước khi gộp nhánh.
   - Tuyệt đối không đưa tệp `.env`, `.env.prod` hoặc khóa bí mật thật vào commit. Khi cần thêm biến cấu hình mới, chỉ khai báo tên biến để trống vào `.env.example` và đặt giá trị mặc định an toàn trong `application.yml`.
