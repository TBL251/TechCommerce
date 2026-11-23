# TechCommerce

Nền tảng bán lẻ thiết bị công nghệ đa chi nhánh, xây dựng bằng Spring Boot 3 + JSP/JSTL + PostgreSQL. Hỗ trợ chọn chi nhánh theo kho thực tế, đặt hàng COD/VNPay, theo dõi đơn hàng qua WebSocket và chat trực tiếp với nhân viên cửa hàng.

**Live:** [techcommerce.store](https://techcommerce.store) · **Repo:** [TBL251/TechCommerce](https://github.com/TBL251/TechCommerce)

---

## Mục lục

1. [Tổng quan hệ thống](#1-tổng-quan-hệ-thống)
2. [Công nghệ sử dụng](#2-công-nghệ-sử-dụng)
3. [Cấu trúc thư mục](#3-cấu-trúc-thư-mục)
4. [Cài đặt môi trường dev](#4-cài-đặt-môi-trường-dev)
5. [Biến môi trường `.env`](#5-biến-môi-trường-env)
6. [Chạy test](#6-chạy-test)
7. [CI/CD và tự động deploy](#7-cicd-và-tự-động-deploy)
8. [Vận hành production](#8-vận-hành-production)
9. [Tài khoản mẫu để kiểm thử](#9-tài-khoản-mẫu-để-kiểm-thử)
10. [Phân công nhóm](#10-phân-công-nhóm)
11. [Quy tắc Git](#11-quy-tắc-git)
12. [Hướng dẫn dùng AI để code](#12-hướng-dẫn-dùng-ai-để-code)

---

## 1. Tổng quan hệ thống

TechCommerce chạy theo mô hình **Modular Monolith** — một WAR duy nhất, chia module theo package, không có microservice riêng biệt. Luồng triển khai:

```
[Người dùng] → HTTPS
     ↓
[Cloudflare Edge – techcommerce.store]
     ↓ Outbound tunnel (QUIC/HTTP2)
[cloudflared container]
     ↓ Docker internal network
[Nginx – reverse proxy, gzip, static cache]
     ↓
[Spring Boot WAR – Embedded Tomcat :8080]
     ↓                        ↓
[Supabase PostgreSQL 17]   [Cloudinary CDN]
```

**Chi nhánh hiện tại:** Hà Nội (HN-01), TP.HCM (HCM-01), Đà Nẵng (DN-01).

---

## 2. Công nghệ sử dụng

| Lớp | Công nghệ |
|---|---|
| Backend | Spring Boot 3.3.5 · Spring MVC · Spring Security 6 · Spring Data JPA |
| View | JSP/JSTL 3.0 · SiteMesh 3.2.2 · Bootstrap 5.3 |
| Database | PostgreSQL 17 (Supabase) · Flyway migration · H2 (test) |
| Xác thực | JWT (HttpOnly cookie) · Google OAuth2 · BCrypt |
| Email | Spring Mail · HTML template tự viết |
| Upload ảnh | Cloudinary SDK |
| Thanh toán | VNPay Sandbox |
| Realtime | WebSocket (STOMP) |
| Hạ tầng | Docker Compose · Nginx · Cloudflare Named Tunnel · GitHub Actions CI/CD · Self-Hosted Runner |

---

## 3. Cấu trúc thư mục

```
TechCommerce/
├── src/main/java/com/techcommerce/
│   ├── auth/           # Đăng ký, đăng nhập, JWT, OAuth2, địa chỉ
│   ├── store/          # Chi nhánh, chọn chi nhánh
│   ├── config/         # Security, SiteMesh, Async, Seeder
│   └── common/         # Email, lỗi toàn cục, tiện ích dùng chung
├── src/main/resources/
│   ├── application.yml
│   ├── application-dev.yml
│   ├── application-prod.yml
│   └── db/migration/   # Flyway V1, V2, ...
├── src/main/webapp/WEB-INF/
│   ├── decorators/     # SiteMesh layouts (web.jsp, admin.jsp, auth.jsp)
│   └── jsp/            # Các trang JSP theo module
├── src/test/           # JUnit 5 + Spring Boot Test
├── .github/workflows/  # CI pipeline
├── docker-compose.yml  # Môi trường production
├── nginx.conf
├── tasks/
│   ├── plan.md         # Kiến trúc chi tiết
│   └── todo.md         # 21 task phân công nhóm
└── .env.example        # Mẫu biến môi trường
```

---

## 4. Cài đặt môi trường dev

**Yêu cầu:** JDK 21 · Maven · Docker Desktop · Git

```bash
# 1. Clone repo
git clone https://github.com/TBL251/TechCommerce.git
cd TechCommerce

# 2. Sao chép và điền biến môi trường
cp .env.example .env
# Chỉnh sửa .env — xem mục 5 bên dưới

# 3. Khởi động PostgreSQL local và Mailpit (test SMTP)
docker compose -f docker-compose.dev.yml up -d

# 4. Chạy ứng dụng
./mvnw spring-boot:run -Dspring-boot.run.profiles=dev
```

Ứng dụng chạy tại `http://localhost:8080`.

> Flyway tự động áp migration khi khởi động. Dữ liệu mẫu (3 chi nhánh, 4 tài khoản demo) được seed bởi `DemoDataSeeder`.

---

## 5. Biến môi trường `.env`

Sao chép từ `.env.example` rồi điền giá trị thực. **Không commit file `.env` lên Git.**

| Biến | Mô tả |
|---|---|
| `DB_URL` | JDBC URL kết nối PostgreSQL |
| `DB_USERNAME` / `DB_PASSWORD` | Thông tin xác thực DB |
| `JWT_SECRET` | Chuỗi ngẫu nhiên ≥ 64 ký tự, dùng ký JWT |
| `GOOGLE_CLIENT_ID` / `GOOGLE_CLIENT_SECRET` | Đăng ký tại [Google Cloud Console](https://console.cloud.google.com) |
| `MAIL_HOST` / `MAIL_PORT` / `MAIL_USERNAME` / `MAIL_PASSWORD` | SMTP gửi email (Brevo, Gmail App Password…) |
| `CLOUDINARY_URL` | URL kết nối Cloudinary (upload ảnh) |
| `VNPAY_TMN_CODE` / `VNPAY_HASH_SECRET` | Thông tin merchant VNPay Sandbox |
| `CLOUDFLARE_TUNNEL_TOKEN` | Token Cloudflare Named Tunnel (chỉ cần trên máy chủ) |

---

## 6. Chạy test

```bash
./mvnw test
```

Test chạy trên H2 in-memory (profile `test`), không cần DB thật. Hiện có **26 test** bao gồm: Auth, Đăng ký OTP, Địa chỉ, Quản lý người dùng, Health, JSP rendering, SiteMesh, Seeder.

Trước khi push bất kỳ commit nào: **26/26 phải xanh**.

---

## 7. CI/CD và tự động deploy

Mỗi lần push lên `main` hoặc `develop`, GitHub Actions chạy pipeline `.github/workflows/ci.yml`:

1. Compile và chạy 26 test trên H2
2. Build Docker image, push lên `ghcr.io/tbl251/techcommerce`
3. Self-Hosted Runner trên máy chủ pull image mới, restart container
4. Cloudflare tunnel tự tiếp tục phục vụ — không có downtime từ phía người dùng

**Cài đặt Self-Hosted Runner lần đầu:**

```bash
# Trên máy chủ Windows
cd .actions-runner
./config.cmd --url https://github.com/TBL251/TechCommerce --token <TOKEN>
./run.cmd   # hoặc cài làm Windows Service
```

---

## 8. Vận hành production

```bash
# Khởi động toàn bộ stack
docker compose up -d

# Xem log Spring Boot
docker compose logs -f app

# Restart chỉ ứng dụng (sau khi CI đã pull image mới)
docker compose up -d --no-deps app

# Kiểm tra tunnel còn sống
docker compose logs tunnel
```

**Chuyển máy dự phòng:** Copy file `.env` và `docker-compose.yml` sang máy mới, chạy `docker compose up -d`. Cloudflare tunnel kết nối lại tự động bằng token.

---

## 9. Tài khoản mẫu để kiểm thử

Mật khẩu chung: `Password123!`

| Tài khoản | Vai trò | Ghi chú |
|---|---|---|
| `admin@techcommerce.store` | Admin chuỗi | Toàn quyền |
| `staff.hn01@techcommerce.store` | Nhân viên HN-01 | Chỉ chi nhánh Hà Nội |
| `staff.hcm01@techcommerce.store` | Nhân viên HCM-01 | Chỉ chi nhánh TP.HCM |
| `khachhang@example.com` | Khách hàng | Mua hàng thông thường |

Ngoài ra có nút **"Điền nhanh tài khoản mẫu"** trên trang đăng nhập cho tiện kiểm thử.

---

## 10. Phân công nhóm

| Thành viên | Module phụ trách |
|---|---|
| TV1 | Tech Lead · Auth · Layout · DevOps |
| TV2 | Chi nhánh · Catalog · Tồn kho · Voucher |
| TV3 | Giỏ hàng · Đặt hàng · Quản lý đơn · VNPay |
| TV4 | WebSocket · Chat · Đánh giá · Báo cáo |

Chi tiết task và tiêu chí nghiệm thu: [tasks/todo.md](tasks/todo.md)  
Kiến trúc chi tiết: [tasks/plan.md](tasks/plan.md)

---

## 11. Quy tắc Git

```
main      ← chỉ merge từ develop sau khi test xanh
develop   ← branch làm việc chính của nhóm
feature/* ← mỗi task mở branch riêng từ develop
fix/*     ← hotfix
```

**Commit message** theo [Conventional Commits](https://www.conventionalcommits.org), tiếng Việt:

```
feat(auth): thêm đăng ký qua OTP email
fix(store): sửa không chuyển được chi nhánh
test(cart): bổ sung test hợp nhất giỏ hàng khách
```

**Quy trình merge:**

```bash
git checkout develop
git pull origin develop
git checkout -b feature/ten-task
# ... code ...
./mvnw test          # phải xanh
git push origin feature/ten-task
# Mở Pull Request → chờ review → merge vào develop
```

Không push thẳng vào `main`. Không force-push nếu chưa báo nhóm.

---

## 12. Hướng dẫn dùng AI để code

Xem chi tiết: [CONTRIBUTING.md](CONTRIBUTING.md)

Tóm tắt nhanh:
- Cho AI đọc file liên quan trước khi yêu cầu viết code
- Luôn chạy `./mvnw test` sau khi áp code từ AI
- Không merge khi test đỏ, dù AI bảo "đã đúng"
- Không để AI tự quyết thêm thư viện mới vào `pom.xml`
