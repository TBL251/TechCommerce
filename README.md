# TechCommerce - Hệ thống thương mại điện tử chuỗi cửa hàng công nghệ

TechCommerce là nền tảng bán lẻ thiết bị công nghệ vận hành theo mô hình chuỗi cửa hàng. Khách hàng có thể chọn chi nhánh mua sắm để xem tồn kho thực tế, dự kiến thời gian giao hoặc nhận tại quầy, tìm kiếm sản phẩm tiếng Việt không dấu, so sánh cấu hình, lưu danh sách yêu thích, đăng ký nhận thông báo khi có hàng lại, đặt hàng thanh toán COD hoặc VNPay Sandbox, theo dõi tiến trình đơn hàng theo thời gian thực, nhắn tin trực tiếp với nhân viên chi nhánh và gửi yêu cầu hoàn trả trong vòng 7 ngày.

Tên miền triển khai: `https://techcommerce.store`

## Công nghệ sử dụng

| Thành phần | Công nghệ / Thư viện |
|---|---|
| Ngôn ngữ & Đóng gói | Java 17+ (tương thích JDK 17/21), Maven Wrapper (`mvnw`), đóng gói `war` |
| Backend Framework | Spring Boot 3.3.5 (Web, Data JPA, Security, OAuth2 Client, Validation, WebSocket, Mail, Cache, Scheduling) |
| Giao diện & Layout | JSP, Jakarta JSTL 3.0, Embedded Tomcat Jasper, SiteMesh 3.2.2, Bootstrap 5.3, Chart.js |
| Cơ sở dữ liệu | PostgreSQL 16 (Docker local khi lập trình; Neon.tech vùng Singapore cho môi trường demo chung), Flyway Migration |
| Xác thực & Bảo mật | Spring Security 6, JWT (`jjwt` 0.12.6) lưu qua `HttpOnly` Cookie kèm Refresh Token xoay vòng trong PostgreSQL, Google OAuth2, CSRF, khóa tạm 15 phút khi nhập sai mật khẩu 5 lần |
| Thời gian thực | Spring WebSocket (STOMP + SockJS) cho thông báo đơn hàng/hoàn trả và chat hỗ trợ theo chi nhánh |
| Dịch vụ tích hợp | Cloudinary SDK (lưu trữ và tối ưu ảnh), VNPay Sandbox (HMAC-SHA512), Spring Mail SMTP bất đồng bộ (`@Async`), Mailpit (kiểm thử email local) |
| Hạ tầng & CI/CD | Docker, Docker Compose, Nginx Reverse Proxy, Cloudflare Named Tunnel (`cloudflared`), GitHub Actions + Self-hosted Runner |

## Các chức năng chính theo vai trò

### Khách hàng (`CUSTOMER` và khách vãng lai)
- Chọn chi nhánh đang mua sắm trên thanh điều hướng, xem danh sách chi nhánh (`/stores`), chuyển nhanh sang chi nhánh khác đang còn hàng trong 1 cú bấm.
- Tìm kiếm sản phẩm tiếng Việt không dấu (`unaccent`), gợi ý nhanh khi gõ (autocomplete), lọc theo danh mục/thương hiệu/khoảng giá/tình trạng tồn kho, xem sản phẩm liên quan và lịch sử sản phẩm vừa xem.
- So sánh thông số kỹ thuật (`specs_json`) của 2–3 sản phẩm cạnh nhau, lưu danh sách yêu thích (`Wishlist`) và đăng ký email báo khi có hàng lại.
- Thêm sản phẩm vào giỏ từ lúc chưa đăng nhập (tự động gộp vào giỏ thành viên khi đăng nhập), chọn "Lưu mua sau" hoặc bấm "Mua ngay" đi thẳng tới bước thanh toán.
- Đăng ký, đăng nhập truyền thống hoặc đăng nhập nhanh bằng Google OAuth2, quên mật khẩu qua email SMTP, quản lý hồ sơ và sổ địa chỉ nhận hàng mặc định.
- Áp dụng mã giảm giá toàn chuỗi hoặc theo chi nhánh, đặt giao tận nơi (`DELIVERY`) hoặc nhận tại cửa hàng (`PICKUP`), thanh toán `COD` hoặc `VNPay Sandbox`, nhận email xác nhận đơn hàng.
- Theo dõi thanh tiến trình đơn hàng, nhận thông báo realtime qua WebSocket, bấm "Mua lại" đơn cũ, hủy đơn khi còn ở trạng thái `PENDING` và gửi yêu cầu hoàn trả hàng trong 7 ngày sau khi hoàn tất (`COMPLETED`) kèm ảnh minh chứng.
- Nhắn tin trực tuyến với nhân viên chi nhánh đang chọn, gửi đánh giá kèm ảnh thực tế sau khi mua và đặt câu hỏi công khai (Q&A) dưới trang sản phẩm.

### Nhân viên chi nhánh (`STAFF` — gắn cố định với một `store_id`)
- Quản lý và cập nhật số lượng tồn kho cho các biến thể sản phẩm tại chi nhánh được phân công (hệ thống tự gửi email cho khách đã đăng ký theo dõi khi nhập hàng từ `0` lên `> 0`).
- Nhận thông báo đơn hàng mới và yêu cầu hoàn trả theo thời gian thực qua WebSocket, xử lý vòng đời đơn hàng và duyệt yêu cầu hoàn trả (tùy chọn cộng lại kho nếu máy nguyên vẹn hoặc giữ nguyên kho nếu hàng lỗi).
- Trả lời tin nhắn chat của khách hàng gửi tới chi nhánh mình và giải đáp câu hỏi Q&A sản phẩm.
- Xem báo cáo doanh thu ròng (đã trừ đơn hoàn trả `REFUNDED`), thống kê đơn hàng và xuất file CSV trong phạm vi chi nhánh mình.

### Quản trị tổng (`ADMIN`)
- Quản lý danh sách chi nhánh cửa hàng, danh mục, thương hiệu, sản phẩm, biến thể SKU, ảnh Cloudinary và mã giảm giá toàn hệ thống hoặc theo từng chi nhánh.
- Tạo và quản lý tài khoản nhân viên chi nhánh (`STAFF`), khóa hoặc mở khóa tài khoản người dùng (tự động thu hồi toàn bộ phiên đăng nhập khi khóa).
- Giám sát đơn hàng, yêu cầu hoàn trả, hội thoại chat, kiểm duyệt đánh giá/hỏi đáp và xem báo cáo doanh thu so sánh toàn chuỗi cửa hàng.

## Phân công công việc nhóm 4 thành viên

Chi tiết kiến trúc nằm trong [tasks/plan.md](tasks/plan.md) và danh sách 21 task kèm tiêu chí nghiệm thu nằm trong [tasks/todo.md](tasks/todo.md).

| Thành viên | Phụ trách chính | Package & Thư mục | Flyway Migration |Task |
|---|---|---|---|---|
| TV1 | Tech Lead, Auth (JWT, Refresh Token, Google OAuth2), Hồ sơ & Sổ địa chỉ, EmailService, SiteMesh Layout, Docker, Cloudflare Tunnel & CI/CD | `config/`, `auth/`, `common/`, `decorators/`, `docker/`, `.github/` | `V1`, `V5` | Task 1–4, 19–20 |
| TV2 | CloudinaryService, Quản lý chuỗi chi nhánh, Catalog sản phẩm/biến thể, Tồn kho chi nhánh, Tìm kiếm không dấu, Voucher, So sánh, Wishlist & Báo khi có hàng | `store/`, `catalog/`, `jsp/store/`, `jsp/catalog/`, `jsp/admin/catalog/` | `V2`, `V5` | Task 5–9 |
| TV3 | Giỏ hàng (vãng lai + thành viên + Lưu mua sau), Checkout (Mua ngay + sổ địa chỉ + voucher), COD & VNPay Sandbox (kèm job hủy đơn treo 15 phút), Quản lý đơn (Stepper + Mua lại) & Hoàn trả hàng | `order/`, `jsp/order/`, `jsp/admin/orders/` | `V3` | Task 10–14 |
| TV4 | WebSocket STOMP/SockJS xác thực JWT, Thông báo realtime đơn hàng/hoàn trả, Chat trực tuyến theo chi nhánh, Đánh giá kèm ảnh + biểu đồ sao, Hỏi đáp Q&A & Dashboard doanh thu (Chart.js + CSV) | `realtime/`, `report/`, `jsp/chat/`, `jsp/admin/dashboard/` | `V4` | Task 15–18 |

Task 21 (seed dữ liệu mẫu `V5`, kiểm thử toàn trình trên `https://techcommerce.store` và diễn tập bật máy dự phòng) do cả 4 thành viên phối hợp thực hiện.

## Hướng dẫn cài đặt và chạy ở máy cá nhân (Dev local)

### 1. Yêu cầu công cụ
- JDK 17 hoặc JDK 21 (khuyến nghị Eclipse Temurin). Nếu biến `JAVA_HOME` của máy đang trỏ về bản Java cũ, hãy trỏ lại về thư mục JDK 17/21 trước khi chạy.
- Docker Desktop (để chạy PostgreSQL 16 và Mailpit cục bộ).
- Git. Không bắt buộc cài sẵn Maven vì dự án đã đi kèm `mvnw` và `mvnw.cmd`.

### 2. Cấu hình biến môi trường
Sao chép file mẫu `.env.example` thành `.env` ở thư mục gốc dự án (file `.env` đã được chặn trong `.gitignore`, không đẩy lên Git):

```powershell
Copy-Item .env.example .env
```

Ở môi trường lập trình cục bộ, các biến mặc định trong `application-dev.yml` đã khớp sẵn với container PostgreSQL (`localhost:5432`) và Mailpit (`localhost:1025`). Các khóa tích hợp bên thứ ba (`GOOGLE_CLIENT_ID`, `CLOUDINARY_*`, `VNPAY_*`) có thể để trống khi chưa test đến tính năng đó mà không làm lỗi khởi động ứng dụng.

### 3. Khởi động cơ sở dữ liệu và Mailpit
```powershell
docker compose up -d
```
- PostgreSQL 16 chạy tại cổng `5432` (database: `techcommerce`, user: `techcommerce`, password: `techcommerce_dev`).
- Giao diện web Mailpit để xem email quên mật khẩu / xác nhận đơn hàng khi test local: `http://localhost:8025`.

### 4. Chạy kiểm thử và khởi động ứng dụng
```powershell
# Chạy toàn bộ bộ kiểm thử tự động (sử dụng H2 chế độ tương thích PostgreSQL)
.\mvnw.cmd test

# Đóng gói file executable WAR (target/techcommerce.war)
.\mvnw.cmd clean package

# Chạy ứng dụng ở chế độ dev (http://localhost:8080)
.\mvnw.cmd spring-boot:run
```
Kiểm tra nhanh trạng thái ứng dụng tại `http://localhost:8080/health-jsp` hoặc `http://localhost:8080/api/health`.

### 5. Chi nhánh và tài khoản mẫu tự động khởi tạo ở chế độ dev

Khi khởi động ở profile `dev` (`app.seed-demo-data: true`), `DemoDataSeeder` tự động tạo sẵn 3 chi nhánh (`HN-01` Hà Nội, `HCM-01` TP.HCM, `DN-01` Đà Nẵng) và 4 tài khoản mẫu (mật khẩu chung: `Password123!`):

| Email | Mật khẩu | Vai trò | Chi nhánh gắn |
|---|---|---|---|
| `admin@techcommerce.store` | `Password123!` | `ADMIN` | Toàn hệ thống |
| `staff.hn@techcommerce.store` | `Password123!` | `STAFF` | TechCommerce Hà Nội (`HN-01`) |
| `staff.hcm@techcommerce.store` | `Password123!` | `STAFF` | TechCommerce TP.HCM (`HCM-01`) |
| `customer@techcommerce.store` | `Password123!` | `CUSTOMER` | Khách hàng |

## Quy tắc làm việc nhóm với Git và biến môi trường

1. **Nhánh làm việc**:
   - `main`: nhánh triển khai chính thức (kích hoạt workflow CD khi merge).
   - `develop`: nhánh tích hợp chung của cả nhóm.
   - Khi làm task mới, từng thành viên tách nhánh từ `develop` theo mẫu `feat/m1-auth`, `feat/m2-inventory`, `feat/m3-vnpay`, `feat/m4-chat` và mở Pull Request về `develop`.
2. **Kiểm soát các file dùng chung**:
   - Mọi thay đổi trên `pom.xml`, `SecurityConfig.java`, thư mục `WEB-INF/decorators/` và `src/main/resources/db/migration/` cần được TV1 duyệt PR trước khi merge để tránh đụng độ cấu hình và số thứ tự Flyway.
3. **Đồng bộ biến môi trường an toàn**:
   - Tuyệt đối không commit file `.env` hoặc khóa bí mật thật lên GitHub.
   - Khi một thành viên thêm biến môi trường mới (ví dụ key VNPay hoặc Cloudinary), chỉ thêm tên biến rỗng vào `.env.example` trong PR và khai báo giá trị mặc định rỗng (`${TEN_BIEN:}`) trong `application.yml`.
   - Bộ khóa sandbox dùng chung được chia sẻ trong kênh nội bộ của nhóm; TV1 cập nhật các khóa production vào mục **GitHub Repository Secrets** để pipeline CD tự nạp khi triển khai.

## Vận hành server `techcommerce.store` và bật máy dự phòng

Môi trường demo công khai (`docker-compose.prod.yml`, project `techcommerce-prod`) chạy tách biệt hoàn toàn với môi trường dev local:
- Ứng dụng và Nginx nối ra tên miền `https://techcommerce.store` thông qua container `cloudflared` (Cloudflare Named Tunnel với `CLOUDFLARE_TUNNEL_TOKEN`), không cần mở port modem/router.
- Cơ sở dữ liệu production đặt trên **Neon.tech PostgreSQL 16** (vùng Singapore `ap-southeast-1`, `sslmode=require`) với cấu hình HikariCP `minimum-idle=0` để tự giải phóng kết nối khi rỗi.
- Hệ thống giám sát UptimeRobot ping nhẹ vào `https://techcommerce.store/health-jsp` (endpoint này không truy vấn CSDL để không làm hao giờ compute miễn phí của Neon).
- **Dự phòng khi máy chính (TV1) tắt**: thành viên dự phòng (TV2) chỉ cần chạy lệnh dưới đây với cùng bộ biến môi trường `.env.prod` (chứa URL Neon DB và `CLOUDFLARE_TUNNEL_TOKEN`). Cloudflare sẽ tự động định tuyến lưu lượng `https://techcommerce.store` sang máy đang bật với nguyên vẹn dữ liệu trên Neon:

```powershell
docker compose -p techcommerce-prod -f docker-compose.prod.yml pull
docker compose -p techcommerce-prod -f docker-compose.prod.yml up -d
```
