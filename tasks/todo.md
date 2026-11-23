# Danh sách tác vụ triển khai: TechCommerce

Tài liệu kiến trúc và phân công chi tiết: [plan.md](file:///e:/TechCommerce/tasks/plan.md)

Quy ước người phụ trách:
- `[TV1]` Tech Lead, Auth, Layout & DevOps
- `[TV2]` Chuỗi cửa hàng, Catalog, Tồn kho, Voucher & Tiện ích chọn mua
- `[TV3]` Giỏ hàng, Đặt hàng, Quản lý đơn, Hoàn trả & VNPay
- `[TV4]` WebSocket Realtime, Chat, Đánh giá, Q&A & Báo cáo

---

## Giai đoạn 1: Nền tảng, Layout & Xác thực

### Task 1: Khởi tạo dự án Spring Boot 3 (WAR), PostgreSQL 16, Flyway `V1` và Docker Compose local `[TV1]`

**Mô tả:** Tạo khung dự án Maven đóng gói `war` chạy được JSP trên Embedded Tomcat, bật `@EnableAsync`, `@EnableScheduling`, `@EnableCaching`, đặt `spring.jpa.open-in-view=false`, cấu hình kết nối PostgreSQL 16 và Mailpit (test SMTP local) qua Docker Compose, tạo Flyway migration `V1` (`stores`, `users` kèm cột `auth_provider`/`provider_id`, `password_hash` nullable và cột chống thử sai mật khẩu, `password_reset_tokens`, `refresh_tokens`, `user_addresses` cùng các Index tra cứu chính), cùng các hợp đồng dùng chung trong `common/` (`DomainEvents` và interface `GuestCartMerger`).

**Tiêu chí nghiệm thu:**
- [x] Chạy `docker compose up -d` khởi động được PostgreSQL 16 + Mailpit và ứng dụng áp dụng `V1__init_stores_and_users.sql` không lỗi.
- [x] Trang kiểm thử `/health-jsp` trả về HTTP 200, không truy vấn DB và render đúng thẻ JSTL `<c:out>` khi chạy cả `mvn spring-boot:run` lẫn `java -jar target/*.war`.
- [x] Có sẵn `.env.example` (đủ khóa mẫu DB, JWT, Cloudinary, VNPay, SMTP, Google OAuth2, Cloudflare Tunnel), `application-dev.yml`, `application-prod.yml` (HikariCP `minimum-idle=0` cho Neon, không commit bí mật thật).

**Kiểm chứng:**
- [x] Tests pass: `mvn test`
- [x] Build succeeds: `mvn clean package -DskipTests`
- [x] Manual check: chạy `java -jar target/techcommerce-*.war` và mở `http://localhost:8080/health-jsp`.

**Phụ thuộc:** Không có.

**File dự kiến chạm tới:**
- `pom.xml`
- `docker-compose.yml`
- `src/main/resources/application.yml`
- `src/main/resources/db/migration/V1__init_stores_and_users.sql`
- `src/main/java/com/techcommerce/common/event/DomainEvents.java`

**Quy mô ước tính:** Medium (5 files)

---

### Task 2: Cấu hình SiteMesh 3.2 và khung giao diện Bootstrap 5 `[TV1]`

**Mô tả:** Đăng ký `ConfigurableSiteMeshFilter` tương thích Jakarta EE cho Spring Boot 3, xây dựng 3 layout decorator bằng Bootstrap 5: `web.jsp` (header có ô chọn chi nhánh, ô tìm kiếm kèm vùng dropdown gợi ý, nút So sánh/Yêu thích/Giỏ hàng, menu tài khoản, footer), `admin.jsp` (sidebar quản trị phân vùng theo quyền), `auth.jsp` (khung đăng nhập/đăng ký/quên mật khẩu), cùng `GlobalExceptionHandler` và trang lỗi chuẩn (`403.jsp`, `404.jsp`, `500.jsp`).

**Tiêu chí nghiệm thu:**
- [x] Trang khách (`/`, `/products/**`) tự động ghép layout `web.jsp`; trang quản trị (`/admin/**`, `/staff/**`) ghép `admin.jsp`; `/auth/**` ghép `auth.jsp`.
- [x] Đường dẫn `/api/**`, `/ws/**`, `/assets/**` được loại trừ khỏi SiteMesh và trả về JSON/tài nguyên nguyên bản; lỗi `403`/`404`/`500` hiển thị trang lỗi tiếng Việt gọn thay vì Whitelabel Error Page (riêng `/api/**` trả JSON lỗi).
- [x] Giao diện hiển thị gọn trên cả desktop và màn hình di động (Bootstrap navbar collapse).

**Kiểm chứng:**
- [x] Tests pass: `mvn test -Dtest=SiteMeshConfigTest`
- [x] Build succeeds: `mvn clean package -DskipTests`
- [x] Manual check: kiểm tra view-source trang `/` và `/admin` xác nhận `<sitemesh:write property='body'/>` hoạt động đúng, gọi `/api/health` trả JSON không dính HTML.

**Phụ thuộc:** Task 1

**File dự kiến chạm tới:**
- `src/main/java/com/techcommerce/config/SiteMeshConfig.java`
- `src/main/webapp/WEB-INF/decorators/web.jsp`
- `src/main/webapp/WEB-INF/decorators/admin.jsp`
- `src/main/webapp/WEB-INF/decorators/auth.jsp`
- `src/main/webapp/assets/css/main.css`

**Quy mô ước tính:** Medium (5 files)

---

### Task 3: Xác thực Spring Security 6 + JWT (Access + Refresh Token), Google OAuth2, CSRF và chống thử sai mật khẩu `[TV1]`

**Mô tả:** Cài đặt `JwtService` (Access Token 20 phút + Refresh Token 7 ngày lưu bản băm SHA-256 trong `refresh_tokens`), `JwtAuthenticationFilter` đọc cookie `ACCESS_TOKEN` (fallback header `Bearer`) và tự xoay vòng khi có `REFRESH_TOKEN` hợp lệ chưa bị thu hồi. Tích hợp đăng nhập nhanh bằng Google qua `spring-boot-starter-oauth2-client` + `OAuth2AuthenticationSuccessHandler` (xác nhận `email_verified = true`, tự tạo hoặc liên kết tài khoản, cấp cùng cặp cookie JWT). Bật CSRF cho form JSP/AJAX, cài khóa tạm 15 phút sau 5 lần nhập sai mật khẩu liên tiếp, và xây dựng trang đăng ký/đăng nhập/đăng xuất.

**Tiêu chí nghiệm thu:**
- [x] Đăng ký mã hóa mật khẩu bằng `BCryptPasswordEncoder`, kiểm tra trùng email và validation đầu vào; đăng nhập form thường xử lý an toàn tài khoản tạo từ Google (`password_hash = NULL`).
- [x] Đăng nhập thành công (cả form thường lẫn Google OAuth2) đặt 2 cookie `ACCESS_TOKEN` và `REFRESH_TOKEN` có cờ `HttpOnly; SameSite=Lax`, tự xoay vòng khi `ACCESS_TOKEN` hết hạn, gọi `Optional<GuestCartMerger>` (nếu có bean), chặn tài khoản bị khóa (`enabled = false`) và thu hồi `refresh_tokens` khi đăng xuất.
- [x] Nhập sai mật khẩu 5 lần liên tiếp khóa tạm tài khoản 15 phút; tài khoản `CUSTOMER` vào `/admin/**` bị 403; POST thiếu CSRF bị 403; phản hồi HTTP có đủ Security Headers (`X-Content-Type-Options: nosniff`, `X-Frame-Options: SAMEORIGIN`, `Referrer-Policy`).

**Kiểm chứng:**
- [x] Tests pass: `mvn test -Dtest=JwtServiceTest,AuthControllerTest,OAuth2SuccessHandlerTest`
- [x] Build succeeds: `mvn clean package -DskipTests`
- [x] Manual check: thử đăng nhập thường, thử nút "Đăng nhập bằng Google" trên `localhost:8080`, kiểm tra DevTools thấy cookie `HttpOnly`, thử sai mật khẩu 5 lần thấy khóa tạm, đăng xuất xác nhận `refresh_tokens.revoked_at` được cập nhật.

**Phụ thuộc:** Task 2

**File dự kiến chạm tới:**
- `src/main/java/com/techcommerce/config/SecurityConfig.java`
- `src/main/java/com/techcommerce/auth/JwtService.java`
- `src/main/java/com/techcommerce/auth/JwtAuthenticationFilter.java`
- `src/main/java/com/techcommerce/auth/OAuth2AuthenticationSuccessHandler.java`
- `src/main/java/com/techcommerce/auth/AuthController.java`
- `src/main/webapp/WEB-INF/jsp/auth/login.jsp`

**Quy mô ước tính:** Medium (6 files)

---

### Task 4: Hồ sơ, sổ địa chỉ giao hàng, quên mật khẩu (SMTP) và phân quyền nhân viên theo chi nhánh `[TV1]`

**Mô tả:** Xây dựng `EmailService` dùng chung gửi mail SMTP bất đồng bộ (`@Async` cho quên mật khẩu, xác nhận đơn hàng, kết quả hoàn trả và thông báo có hàng lại), luồng quên/đặt lại mật khẩu (token băm SHA-256 hạn 15 phút, dùng 1 lần, thu hồi toàn bộ `refresh_tokens` sau khi đổi mật khẩu), trang hồ sơ tích hợp CRUD sổ địa chỉ giao hàng (`user_addresses`, chọn địa chỉ mặc định), và màn hình `ADMIN` tạo/sửa/khóa `STAFF` gắn `store_id` cố định.

**Tiêu chí nghiệm thu:**
- [x] Yêu cầu quên mật khẩu luôn trả về thông báo chung (không lộ email có tồn tại), gửi link qua SMTP, đặt lại mật khẩu thành công sẽ vô hiệu hóa token cũ và thu hồi toàn bộ phiên đăng nhập cũ.
- [x] Khách thêm/sửa/xóa và chọn địa chỉ mặc định trong sổ địa chỉ `user_addresses`; đổi mật khẩu bắt buộc khớp mật khẩu cũ (hoặc cho phép thiết lập mật khẩu lần đầu nếu tài khoản tạo qua Google có `password_hash = NULL`).
- [x] `ADMIN` tạo `STAFF` bắt buộc gắn `store_id` hợp lệ; khi khóa tài khoản (`enabled = false`) lập tức thu hồi toàn bộ `refresh_tokens` và chặn phiên hiện tại.

**Kiểm chứng:**
- [x] Tests pass: `mvn test -Dtest=UserManagementServiceTest,PasswordResetServiceTest,AddressServiceTest`
- [x] Build succeeds: `mvn clean package -DskipTests`
- [x] Manual check: test quên mật khẩu qua Mailpit/SMTP, lưu 2 địa chỉ giao hàng, tạo 1 `STAFF` thuộc chi nhánh Hà Nội và thử khóa tài khoản.

**Phụ thuộc:** Task 3

**File dự kiến chạm tới:**
- `src/main/java/com/techcommerce/common/mail/EmailService.java`
- `src/main/java/com/techcommerce/auth/PasswordResetService.java`
- `src/main/java/com/techcommerce/auth/AddressService.java`
- `src/main/java/com/techcommerce/auth/UserController.java`
- `src/main/java/com/techcommerce/auth/AdminUserController.java`
- `src/main/webapp/WEB-INF/jsp/auth/profile.jsp`

**Quy mô ước tính:** Medium (6 files)

---

### Checkpoint Giai đoạn 1: Nền tảng, Layout & Xác thực (Sau Task 1–4)
- [x] `mvn test` và `mvn clean package` xanh 100%.
- [x] Docker Compose local chạy ổn định ứng dụng + PostgreSQL + Mailpit.
- [x] Đăng ký, đăng nhập (Access + Refresh Token, Google OAuth2, khóa tạm sai mật khẩu), quên mật khẩu SMTP, sổ địa chỉ, phân quyền `ADMIN`/`STAFF`/`CUSTOMER`, SiteMesh layout hoạt động trọn vẹn.
- [x] Merge nhánh `develop` để TV2, TV3, TV4 kéo code làm nền chung.

---

## Giai đoạn 2: Chuỗi cửa hàng, Sản phẩm, Tồn kho, Mã giảm giá & Tiện ích chọn mua

### Task 5: Dịch vụ Cloudinary dùng chung và quản lý chuỗi chi nhánh `[TV2]`

**Mô tả:** Tích hợp Cloudinary SDK (`CloudinaryService` hỗ trợ upload kiểm tra định dạng/dung lượng ảnh và xóa theo `public_id`), tạo CRUD quản lý các chi nhánh cửa hàng, trang công khai `/stores` hiển thị danh sách cửa hàng (địa chỉ, giờ mở cửa, ảnh) cho khách, và cơ chế chọn chi nhánh đang mua sắm trên storefront (lưu `SELECTED_STORE_ID` trong cookie + nạp vào model chung qua `@ControllerAdvice`).

**Tiêu chí nghiệm thu:**
- [ ] Upload ảnh hợp lệ (`jpg`, `png`, `webp`, tối đa 5MB, xác thực nội dung ảnh bằng `ImageIO.read()`) trả về `url` (hỗ trợ URL transform `f_auto,q_auto`) và `publicId`; file giả mạo đuôi bị chặn ở server.
- [ ] `ADMIN` thêm/sửa/ẩn-hiện được chi nhánh kèm ảnh cửa hàng; danh sách chi nhánh đang hoạt động được cache bằng `@Cacheable` và tự xóa cache bằng `@CacheEvict` khi thay đổi, đồng thời xóa ảnh cũ trên Cloudinary.
- [ ] Trang `/stores` hiển thị đầy đủ chi nhánh đang hoạt động; khách đổi chi nhánh trên header hoặc tại `/stores`, cookie `SELECTED_STORE_ID` cập nhật nhất quán trên mọi trang JSP.

**Kiểm chứng:**
- [ ] Tests pass: `mvn test -Dtest=StoreServiceTest,CloudinaryServiceTest`
- [ ] Build succeeds: `mvn clean package -DskipTests`
- [ ] Manual check: tạo 2 chi nhánh có ảnh, chuyển đổi chi nhánh ở header và tải lại trang.

**Phụ thuộc:** Task 2, Task 3

**File dự kiến chạm tới:**
- `src/main/java/com/techcommerce/config/CloudinaryConfig.java`
- `src/main/java/com/techcommerce/catalog/CloudinaryService.java`
- `src/main/java/com/techcommerce/store/StoreController.java`
- `src/main/java/com/techcommerce/store/StoreContextAdvice.java`
- `src/main/webapp/WEB-INF/jsp/admin/stores/list.jsp`

**Quy mô ước tính:** Medium (5 files)

---

### Task 6: Quản trị danh mục, thương hiệu, sản phẩm và biến thể `[TV2]`

**Mô tả:** Tạo Flyway migration `V2` bật extension `unaccent` và tạo các bảng `categories`, `brands`, `products`, `product_variants`, `store_inventory`, `vouchers`, `wishlist_items`, `stock_alerts`. Xây dựng màn hình quản trị CRUD danh mục, thương hiệu, sản phẩm (kèm thông số kỹ thuật JSONB) và biến thể SKU kèm ảnh Cloudinary.

**Tiêu chí nghiệm thu:**
- [ ] `V2__init_catalog_inventory_vouchers.sql` chạy sạch trên PostgreSQL 16 (cả Docker local và Neon) với đầy đủ khóa ngoại, Index cho cột lọc/join (`products`, `store_inventory`), `UNIQUE` SKU, `CHECK (quantity >= 0)` và `CHECK (used_count <= usage_limit)`.
- [ ] `ADMIN` tạo được sản phẩm kèm nhiều biến thể (màu sắc, dung lượng, giá, SKU duy nhất) và ảnh thumbnail upload Cloudinary; danh sách danh mục và thương hiệu dùng `@Cacheable`/`@CacheEvict`.
- [ ] Không cho phép xóa danh mục/thương hiệu đang có sản phẩm gắn vào (chỉ ẩn mềm `active = false`).

**Kiểm chứng:**
- [ ] Tests pass: `mvn test -Dtest=ProductServiceTest`
- [ ] Build succeeds: `mvn clean package -DskipTests`
- [ ] Manual check: thêm mới 1 điện thoại gồm 2 biến thể SKU, xác nhận dữ liệu lưu đúng trong PostgreSQL và ảnh hiển thị từ URL Cloudinary.

**Phụ thuộc:** Task 5

**File dự kiến chạm tới:**
- `src/main/resources/db/migration/V2__init_catalog_inventory_vouchers.sql`
- `src/main/java/com/techcommerce/catalog/ProductService.java`
- `src/main/java/com/techcommerce/catalog/AdminProductController.java`
- `src/main/java/com/techcommerce/catalog/AdminTaxonomyController.java`
- `src/main/webapp/WEB-INF/jsp/admin/catalog/product-form.jsp`

**Quy mô ước tính:** Medium (5 files)

---

### Task 7: Tồn kho theo chi nhánh, tìm kiếm không dấu, autocomplete, dự kiến nhận hàng, sắp hết hàng và chuyển nhanh chi nhánh `[TV2]`

**Mô tả:** Xây dựng màn hình cập nhật tồn kho theo chi nhánh (`ADMIN` xem mọi chi nhánh, `STAFF` chỉ sửa chi nhánh `store_id` mình; khi tồn kho chuyển từ `0` lên `> 0` phát `StockRestockedEvent`). Xây dựng trang chủ `/` (`home.jsp` hiển thị sản phẩm nổi bật/mới theo chi nhánh đang chọn + chỗ gắn dải "Bạn vừa xem"), trang danh sách `/products` tìm kiếm tiếng Việt không dấu dùng PostgreSQL `unaccent`, lọc/phân trang, API gợi ý nhanh `/api/products/suggest` cho dropdown autocomplete trên header, và trang chi tiết sản phẩm có: dự kiến thời gian nhận hàng tại chi nhánh/giao tận nơi, cảnh báo *"Chỉ còn X sản phẩm"* khi `1 <= tồn <= 5`, bảng tồn kho từng chi nhánh kèm nút 1-click chuyển nhanh sang chi nhánh còn hàng, khu vực "Sản phẩm liên quan" và cập nhật cookie `RECENTLY_VIEWED`.

**Tiêu chí nghiệm thu:**
- [ ] `STAFF` gửi request sửa tồn kho chi nhánh khác bị chặn 403; nhập kho từ `0` lên `> 0` phát `StockRestockedEvent`.
- [ ] Gõ từ khóa không dấu (`dien thoai`) trả về đúng sản phẩm có dấu (`Điện thoại`); gõ ở thanh tìm kiếm dùng debounce 300ms hiện dropdown gợi ý nhanh qua AJAX; truy vấn danh sách dùng phân trang `Pageable` + `JOIN FETCH`/DTO projection không phát sinh N+1 query.
- [ ] Trang chi tiết hiển thị đúng dự kiến giao/nhận, nhãn sắp hết hàng khi tồn `<= 5`, ảnh dùng Cloudinary transform (`f_auto,q_auto`) + `loading="lazy"`, nút 1-click chuyển sang chi nhánh còn hàng khi chi nhánh hiện tại hết, tối đa 4 sản phẩm liên quan và lưu cookie `RECENTLY_VIEWED` tối đa 8 sản phẩm.

**Kiểm chứng:**
- [ ] Tests pass: `mvn test -Dtest=InventoryServiceTest,ProductSearchTest`
- [ ] Build succeeds: `mvn clean package -DskipTests`
- [ ] Manual check: nhập tồn = 0 ở Hà Nội và tồn = 3 ở TP.HCM, mở sản phẩm ở Hà Nội bấm nút chuyển nhanh sang TP.HCM để thấy nhãn "Chỉ còn 3 sản phẩm" + dự kiến nhận hàng; gõ tìm không dấu ở header.

**Phụ thuộc:** Task 6

**File dự kiến chạm tới:**
- `src/main/java/com/techcommerce/store/InventoryService.java`
- `src/main/java/com/techcommerce/store/AdminInventoryController.java`
- `src/main/java/com/techcommerce/catalog/StorefrontProductController.java`
- `src/main/webapp/WEB-INF/jsp/catalog/detail.jsp`
- `src/main/webapp/assets/js/search-autocomplete.js`

**Quy mô ước tính:** Medium (5 files)

---

### Task 8: Quản lý và xác thực nguyên tử mã giảm giá (`vouchers`) `[TV2]`

**Mô tả:** Xây dựng màn hình `ADMIN` CRUD mã giảm giá toàn chuỗi hoặc giới hạn theo 1 chi nhánh (`store_id`), hỗ trợ giảm theo `%` (có trần `max_discount_amount`) hoặc số tiền cố định `FIXED`, đơn tối thiểu `min_order_amount`, hạn sử dụng và số lượt dùng tối đa. Cung cấp `VoucherService` dùng chung (API xem trước số tiền giảm cho Checkout, hàm trừ lượt nguyên tử `consumeVoucher` và hoàn lượt `releaseVoucher` cho TV3 gọi).

**Tiêu chí nghiệm thu:**
- [ ] Mã hết hạn, chưa tới ngày bắt đầu, không khớp chi nhánh, chưa đạt đơn tối thiểu hoặc hết lượt đều bị từ chối kèm lý do rõ ràng.
- [ ] Tính đúng số tiền giảm cho cả loại `PERCENT` (không vượt `max_discount_amount` và không vượt tổng tiền hàng) lẫn `FIXED`.
- [ ] `consumeVoucher` dùng câu lệnh SQL nguyên tử `UPDATE vouchers SET used_count = used_count + 1 WHERE id = :id AND used_count < usage_limit`, ngăn vượt quá `usage_limit` khi dùng đồng thời.

**Kiểm chứng:**
- [ ] Tests pass: `mvn test -Dtest=VoucherServiceTest`
- [ ] Build succeeds: `mvn clean package -DskipTests`
- [ ] Manual check: tạo 1 voucher toàn chuỗi (giảm 10% tối đa 500k) và 1 voucher riêng chi nhánh Hà Nội, kiểm tra API preview ở cả 2 chi nhánh.

**Phụ thuộc:** Task 6

**File dự kiến chạm tới:**
- `src/main/java/com/techcommerce/catalog/VoucherRepository.java`
- `src/main/java/com/techcommerce/catalog/VoucherService.java`
- `src/main/java/com/techcommerce/catalog/AdminVoucherController.java`
- `src/main/webapp/WEB-INF/jsp/admin/vouchers/list.jsp`

**Quy mô ước tính:** Medium (4 files)

---

### Task 9: So sánh cấu hình 2–3 sản phẩm, sản phẩm vừa xem, Wishlist và báo khi có hàng lại `[TV2]`

**Mô tả:** Xây dựng bảng so sánh cấu hình 2–3 sản phẩm cạnh nhau đọc từ `specs_json` + giá/tồn kho tại chi nhánh hiện tại (lưu tối đa 3 `productId` trong Cookie/HttpSession `COMPARE_IDS`), hiển thị dải "Bạn vừa xem" đọc từ cookie `RECENTLY_VIEWED`, trang Danh sách yêu thích (`wishlist_items`, bật/tắt bằng AJAX) và chức năng "Báo tôi khi có hàng" (`stock_alerts` lắng nghe `StockRestockedEvent` để gửi email SMTP bất đồng bộ qua `EmailService` rồi đánh dấu `notified_at`).

**Tiêu chí nghiệm thu:**
- [ ] Thêm tối đa 3 sản phẩm vào danh sách so sánh (thêm món thứ 4 báo rõ hoặc thay món cũ), trang `/compare` hiển thị bảng thông số kỹ thuật JSONB song song sạch đẹp trên Bootstrap.
- [ ] Dải "Sản phẩm vừa xem" hiển thị đúng thứ tự gần nhất từ cookie `RECENTLY_VIEWED`; Wishlist cho phép lưu/bỏ lưu bằng AJAX và thêm thẳng vào giỏ.
- [ ] Khi biến thể hết hàng ở chi nhánh hiện tại, khách đăng ký email nhận thông báo vào `stock_alerts`; ngay khi `STAFF` nhập kho từ `0` lên `> 0`, `EmailService` gửi mail báo có hàng đúng 1 lần và cập nhật `notified_at`.

**Kiểm chứng:**
- [ ] Tests pass: `mvn test -Dtest=WishlistServiceTest,StockAlertServiceTest`
- [ ] Build succeeds: `mvn clean package -DskipTests`
- [ ] Manual check: chọn 2 điện thoại mở `/compare`, thêm/bỏ Wishlist, đăng ký "Báo tôi khi có hàng" cho món tồn = 0 rồi nhập tồn = 5 và kiểm tra email trên Mailpit.

**Phụ thuộc:** Task 4, Task 7

**File dự kiến chạm tới:**
- `src/main/java/com/techcommerce/catalog/CompareController.java`
- `src/main/java/com/techcommerce/catalog/WishlistService.java`
- `src/main/java/com/techcommerce/store/StockAlertService.java`
- `src/main/webapp/WEB-INF/jsp/catalog/compare.jsp`
- `src/main/webapp/WEB-INF/jsp/catalog/wishlist.jsp`

**Quy mô ước tính:** Medium (5 files)

---

### Checkpoint Giai đoạn 2: Chuỗi cửa hàng, Sản phẩm, Tồn kho, Mã giảm giá & Tiện ích chọn mua (Sau Task 5–9)
- [ ] Toàn bộ quản trị chi nhánh, sản phẩm, biến thể, ảnh Cloudinary, tồn kho và voucher chạy ổn định.
- [ ] Trải nghiệm tìm kiếm không dấu, autocomplete, dự kiến nhận hàng, sắp hết hàng, chuyển nhanh chi nhánh, so sánh cấu hình, vừa xem, Wishlist và báo khi có hàng hoạt động đầy đủ.
- [ ] Không có lỗi lazy initialization trên JSP.

---

## Giai đoạn 3: Giỏ hàng, Đặt hàng, Thanh toán & Hoàn trả

### Task 10: Giỏ hàng khách vãng lai (tự gộp khi đăng nhập), thành viên gắn chi nhánh và "Lưu mua sau" `[TV3]`

**Mô tả:** Tạo Flyway migration `V3` (`cart_items` kèm cột `saved_for_later`, `orders` kèm `status_history_json`, cột voucher/giảm giá và các Index cho `orders(store_id, order_status, created_at)` và `orders(user_id, created_at)`, `order_items`, `return_requests`). Xây dựng API AJAX và trang JSP giỏ hàng hoạt động cho cả khách vãng lai (lưu tối đa 20 dòng trong `HttpSession`/Cookie `GUEST_CART`, cài đặt bean `GuestCartMerger` để tự gộp khi đăng nhập form thường hoặc Google OAuth2 mà không sửa `auth/`) lẫn thành viên (hỗ trợ nút "Lưu mua sau" và "Chuyển lại vào giỏ" bằng cờ `saved_for_later`).

**Tiêu chí nghiệm thu:**
- [ ] Khách chưa đăng nhập thêm/sửa/xóa sản phẩm vào giỏ và kiểm tra tồn kho tại chi nhánh đang chọn bình thường.
- [ ] Khi khách đăng nhập (cả form thường lẫn Google OAuth2), toàn bộ giỏ vãng lai tự gộp vào `cart_items` (cộng dồn nếu trùng biến thể, cắt trần theo tồn kho hiện tại) và xóa giỏ tạm.
- [ ] Thành viên bấm "Lưu mua sau" đẩy món từ giỏ xuống mục "Đã lưu mua sau" (`saved_for_later = true`, không tính vào tổng tiền checkout) và có thể bấm đưa lại vào giỏ; mọi thao tác AJAX gửi kèm CSRF token.

**Kiểm chứng:**
- [ ] Tests pass: `mvn test -Dtest=CartServiceTest,GuestCartMergeTest`
- [ ] Build succeeds: `mvn clean package -DskipTests`
- [ ] Manual check: mở tab ẩn danh thêm 2 món vào giỏ, đăng nhập kiểm tra tự gộp, bấm "Lưu mua sau" 1 món và xác nhận tổng tiền giỏ chỉ tính món còn lại.

**Phụ thuộc:** Task 3, Task 7

**File dự kiến chạm tới:**
- `src/main/resources/db/migration/V3__init_cart_and_orders.sql`
- `src/main/java/com/techcommerce/order/CartService.java`
- `src/main/java/com/techcommerce/order/CartController.java`
- `src/main/webapp/WEB-INF/jsp/order/cart.jsp`
- `src/main/webapp/assets/js/cart.js`

**Quy mô ước tính:** Medium (5 files)

---

### Task 11: Đặt hàng (sổ địa chỉ, voucher, nút "Mua ngay", COD, trừ kho nguyên tử và email xác nhận) `[TV3]`

**Mô tả:** Xây dựng trang Checkout hỗ trợ 2 chế độ: từ giỏ hàng hoặc từ nút **"Mua ngay" (`Buy Now`)** trên trang chi tiết sản phẩm (không làm mất các món đang có trong giỏ). Hỗ trợ chọn `DELIVERY` (điền nhanh từ sổ địa chỉ mặc định `user_addresses` hoặc nhập mới) hay `PICKUP` (nhận tại chi nhánh), áp dụng mã giảm giá qua `VoucherService`, chọn thanh toán `COD`. Khi đặt hàng, trừ tồn kho và trừ lượt voucher nguyên tử trong `@Transactional`, ghi mốc đầu tiên vào `status_history_json`, lưu snapshot `order_items`, phát `OrderCreatedEvent` và gửi email xác nhận đơn hàng bất đồng bộ sau `AFTER_COMMIT`.

**Tiêu chí nghiệm thu:**
- [ ] Nút "Mua ngay" mở thẳng Checkout với đúng biến thể/số lượng đã chọn và địa chỉ mặc định mà không xóa giỏ hàng hiện có của khách; server luôn tự đọc đơn giá từ `product_variants` và tự tính lại giảm giá từ `VoucherService` (không tin giá từ client).
- [ ] Khi 2 luồng đặt cùng lúc món còn tồn bằng 1 (hoặc voucher còn 1 lượt), chỉ 1 đơn thành công và đơn kia rollback, không bao giờ âm tồn kho hay vượt lượt voucher.
- [ ] Sau khi commit thành công, phát `OrderCreatedEvent` và gửi email xác nhận đơn bất đồng bộ; nếu SMTP lỗi chỉ ghi log, không rollback đơn.

**Kiểm chứng:**
- [ ] Tests pass: `mvn test -Dtest=OrderCheckoutConcurrencyTest`
- [ ] Build succeeds: `mvn clean package -DskipTests`
- [ ] Manual check: thử đặt 1 đơn bằng nút "Mua ngay" (dùng địa chỉ mặc định + voucher) và 1 đơn từ giỏ `PICKUP`, kiểm tra tồn kho, lượt voucher và email xác nhận trên Mailpit.

**Phụ thuộc:** Task 4, Task 8, Task 10

**File dự kiến chạm tới:**
- `src/main/java/com/techcommerce/store/StoreInventoryRepository.java`
- `src/main/java/com/techcommerce/order/OrderService.java`
- `src/main/java/com/techcommerce/order/CheckoutController.java`
- `src/main/webapp/WEB-INF/jsp/order/checkout.jsp`
- `src/main/webapp/WEB-INF/jsp/order/order-success.jsp`

**Quy mô ước tính:** Medium (5 files)

---

### Task 12: Tích hợp VNPay Sandbox và `@Scheduled` tự hủy đơn chưa thanh toán quá 15 phút `[TV3]`

**Mô tả:** Tích hợp VNPay Sandbox: tạo URL thanh toán ký HMAC-SHA512 cho đơn `VNPAY`, xử lý Return URL và IPN callback (miễn CSRF, xác thực chữ ký + đối chiếu số tiền + chống xử lý lặp + gửi email xác nhận thanh toán đúng 1 lần). Cài đặt `OrderExpiryJob` (`@Scheduled` chạy mỗi 5 phút) tự động hủy các đơn `VNPAY` ở trạng thái `PENDING + UNPAID` quá 15 phút để hoàn lại tồn kho chi nhánh và lượt dùng voucher.

**Tiêu chí nghiệm thu:**
- [ ] Ký và kiểm tra `vnp_SecureHash` đúng chuẩn VNPay; chữ ký sai bị từ chối với mã `RspCode: 97`.
- [ ] Gọi IPN 2 lần với cùng `vnp_TxnRef` đã thanh toán là idempotent và chỉ gửi email xác nhận đúng 1 lần.
- [ ] Khi khách hủy giao dịch VNPay hoặc tắt trình duyệt quá 15 phút, đơn chuyển `CANCELLED` + `payment_status = FAILED`, đồng thời hoàn nguyên tồn kho chi nhánh và lượt voucher.

**Kiểm chứng:**
- [ ] Tests pass: `mvn test -Dtest=VnPayServiceTest,OrderExpiryJobTest`
- [ ] Build succeeds: `mvn clean package -DskipTests`
- [ ] Manual check: chạy giao dịch thành công và giao dịch hủy trên VNPay Sandbox qua `https://techcommerce.store`; kiểm chứng job hủy đơn quá hạn 15 phút.

**Phụ thuộc:** Task 11

**File dự kiến chạm tới:**
- `src/main/java/com/techcommerce/config/VnPayConfig.java`
- `src/main/java/com/techcommerce/order/VnPayService.java`
- `src/main/java/com/techcommerce/order/VnPayController.java`
- `src/main/java/com/techcommerce/order/OrderExpiryJob.java`
- `src/main/webapp/WEB-INF/jsp/order/payment-result.jsp`

**Quy mô ước tính:** Medium (5 files)

---

### Task 13: Quản lý đơn hàng cho khách (thanh tiến trình + nút "Mua lại"), nhân viên chi nhánh và quản trị tổng `[TV3]`

**Mô tả:** Xây dựng trang lịch sử và chi tiết đơn hàng của khách với thanh tiến trình trực quan (`Order Tracking Stepper` đọc mốc thời gian từ `status_history_json`), cho phép hủy đơn `PENDING` (hoàn kho & hoàn voucher), nút "Mua lại" nạp các món còn hàng ở chi nhánh hiện tại vào giỏ trong 1 bấm; cùng trang xử lý đơn cho `STAFF` (chỉ thấy và xử lý đơn thuộc `store_id` mình) và `ADMIN`. Mỗi lần đổi trạng thái ghi thêm mốc vào `status_history_json` và phát `OrderStatusChangedEvent`.

**Tiêu chí nghiệm thu:**
- [ ] Trang chi tiết đơn của khách hiển thị thanh tiến trình 4–5 bước kèm ngày giờ từng bước cập nhật trạng thái; hủy đơn `PENDING` hoàn nguyên cả `store_inventory` và `vouchers.used_count`.
- [ ] Nút "Mua lại" thêm đúng các biến thể còn hàng vào giỏ hiện tại và thông báo rõ nếu có món hết hàng ở chi nhánh đang chọn.
- [ ] `STAFF` truy cập hoặc cập nhật đơn chi nhánh khác bị chặn 403; luồng chuyển trạng thái chặn mọi bước nhảy không hợp lệ.

**Kiểm chứng:**
- [ ] Tests pass: `mvn test -Dtest=OrderLifecycleServiceTest`
- [ ] Build succeeds: `mvn clean package -DskipTests`
- [ ] Manual check: đi hết vòng đời 1 đơn `PICKUP`, kiểm tra thanh tiến trình hiện đủ mốc thời gian, thử bấm "Mua lại" và thử hủy 1 đơn `PENDING` có dùng voucher.

**Phụ thuộc:** Task 11

**File dự kiến chạm tới:**
- `src/main/java/com/techcommerce/order/CustomerOrderController.java`
- `src/main/java/com/techcommerce/order/AdminOrderController.java`
- `src/main/webapp/WEB-INF/jsp/order/my-orders.jsp`
- `src/main/webapp/WEB-INF/jsp/admin/orders/list.jsp`
- `src/main/webapp/WEB-INF/jsp/admin/orders/detail.jsp`

**Quy mô ước tính:** Medium (5 files)

---

### Task 14: Quản lý yêu cầu hoàn trả hàng theo chi nhánh (`return_requests`) `[TV3]`

**Mô tả:** Xây dựng luồng hoàn trả nguyên đơn hàng cho đơn đã ở trạng thái `COMPLETED` trong vòng 7 ngày: khách chọn lý do và tải ảnh minh chứng lên Cloudinary; hệ thống phát `ReturnRequestEvent` thông báo realtime tới `STAFF` của đúng chi nhánh (`store_id`). Nhân viên duyệt `APPROVED`/`REJECTED` (kèm lý do) hoặc xác nhận đã nhận máy `COMPLETED` với tùy chọn `restock_inventory` (cộng lại tồn kho chi nhánh nếu máy nguyên vẹn, không cộng lại nếu hàng lỗi), cập nhật `orders.payment_status = REFUNDED` và gửi email SMTP + thông báo WebSocket cho khách.

**Tiêu chí nghiệm thu:**
- [ ] Chỉ cho phép gửi tối đa 1 yêu cầu hoàn trả cho đơn `COMPLETED` trong vòng 7 ngày kể từ lúc hoàn thành; đơn quá hạn, chưa hoàn thành hoặc của người khác bị từ chối.
- [ ] `STAFF` chỉ xem và duyệt được yêu cầu hoàn trả của chi nhánh mình (`store_id`); truy cập chi nhánh khác trả về 403.
- [ ] Khi hoàn tất hoàn trả (`COMPLETED`) trong `@Transactional`: nếu `restock_inventory = true` thì cộng lại đúng số lượng vào `store_inventory` của chi nhánh, nếu `false` giữ nguyên tồn kho; luôn cập nhật `orders.payment_status = REFUNDED`, phát `ReturnRequestEvent` và gửi email xác nhận bất đồng bộ.

**Kiểm chứng:**
- [ ] Tests pass: `mvn test -Dtest=ReturnRequestServiceTest` (test quá hạn 7 ngày, chống gửi trùng, `restock_inventory = true/false`, phân quyền chéo chi nhánh)
- [ ] Build succeeds: `mvn clean package -DskipTests`
- [ ] Manual check: gửi yêu cầu hoàn trả kèm ảnh Cloudinary cho 1 đơn `COMPLETED`, đăng nhập `STAFF` duyệt và hoàn tất với cả 2 kịch bản nhập lại kho / không nhập lại kho.

**Phụ thuộc:** Task 4, Task 5, Task 13

**File dự kiến chạm tới:**
- `src/main/java/com/techcommerce/order/ReturnRequestService.java`
- `src/main/java/com/techcommerce/order/ReturnRequestController.java`
- `src/main/java/com/techcommerce/order/AdminReturnController.java`
- `src/main/webapp/WEB-INF/jsp/order/return-form.jsp`
- `src/main/webapp/WEB-INF/jsp/admin/orders/returns.jsp`

**Quy mô ước tính:** Medium (5 files)

---

### Checkpoint Giai đoạn 3: Giỏ hàng, Đặt hàng, Thanh toán & Hoàn trả (Sau Task 10–14)
- [ ] Toàn bộ luồng mua hàng từ giỏ vãng lai / Lưu mua sau / Mua ngay -> chọn địa chỉ & voucher -> đặt COD/VNPay -> job tự hủy treo 15 phút -> theo dõi thanh tiến trình đơn -> mua lại -> hoàn trả hàng hoạt động đầy đủ.
- [ ] Test cạnh tranh tồn kho/voucher, test chữ ký VNPay và test hoàn kho/hoàn trả đều pass.

---

## Giai đoạn 4: WebSocket Realtime, Đánh giá, Q&A & Báo cáo

### Task 15: Cấu hình WebSocket STOMP/SockJS kèm xác thực JWT và thông báo đơn hàng/hoàn trả realtime `[TV4]`

**Mô tả:** Tạo Flyway migration `V4` (`notifications` kèm Index `(recipient_user_id, is_read)`, `chat_rooms`, `chat_messages` kèm Index `(room_id, created_at)`, `reviews` kèm cột ảnh Cloudinary, `product_questions`). Cấu hình Spring WebSocket STOMP (`/ws`) có `HandshakeInterceptor` đọc JWT từ cookie `ACCESS_TOKEN` và `ChannelInterceptor` kiểm tra quyền subscribe topic chi nhánh. Lắng nghe `OrderCreatedEvent`, `OrderStatusChangedEvent` và `ReturnRequestEvent` để lưu bảng `notifications` và đẩy realtime tới đúng chi nhánh / khách hàng.

**Tiêu chí nghiệm thu:**
- [ ] Kết nối WebSocket không có JWT hợp lệ bị từ chối; `STAFF` chi nhánh A bị chặn subscribe `/topic/store/{storeB}/orders`.
- [ ] Khi khách đặt đơn mới hoặc gửi yêu cầu hoàn trả tại chi nhánh A, chuông thông báo ở màn hình `STAFF` chi nhánh A và `ADMIN` bật lên tức thì không cần reload.
- [ ] Khi nhân viên đổi trạng thái đơn hoặc duyệt yêu cầu hoàn trả, khách nhận thông báo realtime và xem lại được trong danh sách thông báo đã lưu.

**Kiểm chứng:**
- [ ] Tests pass: `mvn test -Dtest=NotificationListenerTest,WebSocketAuthTest`
- [ ] Build succeeds: `mvn clean package -DskipTests`
- [ ] Manual check: mở 2 trình duyệt (khách + nhân viên cùng chi nhánh), đặt đơn, đổi trạng thái và gửi yêu cầu hoàn trả để quan sát thông báo đến ngay lập tức.

**Phụ thuộc:** Task 1, Task 3 (tích hợp sự kiện thực với Task 11, 13, 14)

**File dự kiến chạm tới:**
- `src/main/resources/db/migration/V4__init_realtime_reviews_qa.sql`
- `src/main/java/com/techcommerce/config/WebSocketConfig.java`
- `src/main/java/com/techcommerce/realtime/WebSocketAuthInterceptor.java`
- `src/main/java/com/techcommerce/realtime/OrderNotificationListener.java`
- `src/main/webapp/assets/js/notifications.js`

**Quy mô ước tính:** Medium (5 files)

---

### Task 16: Chat hỗ trợ trực tuyến giữa khách hàng và nhân viên theo chi nhánh `[TV4]`

**Mô tả:** Xây dựng widget chat nổi trên storefront cho phép khách nhắn tin trực tiếp với chi nhánh đang chọn, và màn hình hộp thoại chat cho `STAFF` chi nhánh đó (cũng như `ADMIN`). Mọi tin nhắn được lưu vào `chat_messages`, chống XSS khi hiển thị và nạp lại lịch sử khi mở lại trang.

**Tiêu chí nghiệm thu:**
- [ ] Khách mở widget chat tự động lấy hoặc tạo `chat_room` ứng với `(customer_id, store_id)` và tải lại 50 tin nhắn gần nhất.
- [ ] Tin nhắn gửi qua STOMP `/app/chat.send` được lưu DB và phân phối đúng tới khách + nhân viên của chi nhánh đó, không rò rỉ sang phòng chat khác.
- [ ] Nội dung tin nhắn chứa thẻ `<script>` được escape an toàn khi render trên giao diện.

**Kiểm chứng:**
- [ ] Tests pass: `mvn test -Dtest=ChatServiceTest`
- [ ] Build succeeds: `mvn clean package -DskipTests`
- [ ] Manual check: nhắn tin qua lại giữa khách và nhân viên chi nhánh, reload trang kiểm tra lịch sử còn nguyên.

**Phụ thuộc:** Task 15

**File dự kiến chạm tới:**
- `src/main/java/com/techcommerce/realtime/ChatService.java`
- `src/main/java/com/techcommerce/realtime/ChatController.java`
- `src/main/webapp/WEB-INF/jsp/chat/widget.jsp`
- `src/main/webapp/WEB-INF/jsp/admin/chat/inbox.jsp`
- `src/main/webapp/assets/js/chat.js`

**Quy mô ước tính:** Medium (5 files)

---

### Task 17: Đánh giá sản phẩm có ảnh Cloudinary (biểu đồ % sao, "Đã mua hàng") và Hỏi đáp công khai Q&A `[TV4]`

**Mô tả:** Nâng cấp đánh giá sản phẩm cho khách đã có đơn `COMPLETED` (gắn nhãn **"Đã mua hàng"**): hỗ trợ đính kèm ảnh chụp thực tế qua `CloudinaryService`, hiển thị biểu đồ thanh phân bố % từ 1–5 sao, lọc đánh giá theo số sao hoặc "Có hình ảnh" và cho `ADMIN` ẩn/xóa đánh giá vi phạm. Đồng thời xây dựng mục **Hỏi đáp công khai (`product_questions`)** ngay dưới trang chi tiết sản phẩm để khách đặt câu hỏi và `STAFF`/`ADMIN` trả lời công khai.

**Tiêu chí nghiệm thu:**
- [ ] Hệ thống chặn gửi đánh giá nếu chưa có đơn `COMPLETED` chứa sản phẩm hoặc đã đánh giá cho cặp `(user, product, order)`; ảnh đánh giá (tùy chọn) được kiểm tra định dạng và xóa trên Cloudinary nếu `ADMIN` xóa đánh giá.
- [ ] Hiển thị đúng điểm trung bình, thanh phân bố % từng mức 1–5 sao, nhãn "Đã mua hàng" và bộ lọc theo số sao / "Có hình ảnh".
- [ ] Khách đăng nhập đặt được câu hỏi công khai trên trang sản phẩm; cả `STAFF` và `ADMIN` xem danh sách câu hỏi chờ trả lời tại `/admin/questions` và trả lời công khai (hiển thị nhãn "Nhân viên TechCommerce"), riêng `ADMIN` có quyền xóa câu hỏi/trả lời vi phạm; mọi nội dung đều escape an toàn chống XSS.

**Kiểm chứng:**
- [ ] Tests pass: `mvn test -Dtest=ReviewServiceTest,ProductQuestionServiceTest`
- [ ] Build succeeds: `mvn clean package -DskipTests`
- [ ] Manual check: gửi 1 đánh giá 5 sao kèm ảnh thực tế và 1 đánh giá 4 sao không ảnh, kiểm tra biểu đồ % sao và lọc "Có hình ảnh"; đặt 1 câu hỏi Q&A rồi đăng nhập `STAFF` trả lời.

**Phụ thuộc:** Task 5, Task 7, Task 13, Task 15 (`V4`)

**File dự kiến chạm tới:**
- `src/main/java/com/techcommerce/report/ReviewService.java`
- `src/main/java/com/techcommerce/report/ReviewController.java`
- `src/main/java/com/techcommerce/report/ProductQuestionService.java`
- `src/main/java/com/techcommerce/report/ProductQuestionController.java`
- `src/main/webapp/WEB-INF/jsp/catalog/reviews-qa-fragment.jsp`

**Quy mô ước tính:** Medium (5 files)

---

### Task 18: Dashboard báo cáo doanh thu, đơn hàng và sản phẩm bán chạy theo chi nhánh `[TV4]`

**Mô tả:** Xây dựng trang Dashboard thống kê cho `ADMIN` (so sánh doanh thu toàn chuỗi và lọc từng chi nhánh) và `STAFF` (chỉ xem số liệu chi nhánh mình) theo khoảng ngày: tổng doanh thu ròng từ đơn `COMPLETED`/`PAID` đã loại trừ các đơn `REFUNDED` (hoàn trả), số đơn theo trạng thái, số yêu cầu hoàn trả, top 5 sản phẩm bán chạy, biểu đồ cột/đường bằng Chart.js và nút xuất báo cáo CSV.

**Tiêu chí nghiệm thu:**
- [ ] Số liệu tổng hợp truy vấn trực tiếp bằng SQL/JPQL aggregate (không tải toàn bộ danh sách đơn lên RAM Java) và tự loại trừ doanh thu các đơn có `payment_status = REFUNDED`.
- [ ] `STAFF` không thể truyền tham số `storeId` của chi nhánh khác để xem doanh thu chi nhánh đó.
- [ ] File CSV xuất ra có header UTF-8 BOM mở đẹp trên Excel không lỗi font tiếng Việt và khớp số liệu với biểu đồ.

**Kiểm chứng:**
- [ ] Tests pass: `mvn test -Dtest=ReportServiceTest` (kiểm chứng đơn `REFUNDED` không bị cộng vào doanh thu ròng)
- [ ] Build succeeds: `mvn clean package -DskipTests`
- [ ] Manual check: hoàn trả 1 đơn `COMPLETED`, kiểm tra doanh thu ròng trên Dashboard tự giảm tương ứng và đối chiếu với file CSV xuất ra.

**Phụ thuộc:** Task 13, Task 14

**File dự kiến chạm tới:**
- `src/main/java/com/techcommerce/report/ReportRepository.java`
- `src/main/java/com/techcommerce/report/ReportService.java`
- `src/main/java/com/techcommerce/report/AdminReportController.java`
- `src/main/webapp/WEB-INF/jsp/admin/dashboard/index.jsp`

**Quy mô ước tính:** Medium (4 files)

---

### Checkpoint Giai đoạn 4: WebSocket Realtime, Đánh giá, Q&A & Báo cáo (Sau Task 15–18)
- [ ] Toàn bộ tính năng cốt lõi, hoàn trả hàng, đăng nhập Google, đánh giá ảnh + Q&A và các tiện ích mua sắm đã hoàn thiện trên nhánh `develop`.
- [ ] Toàn bộ unit test và integration test xanh.

---

## Giai đoạn 5: CI/CD, Docker Production, Cloudflare Tunnel & Kiểm thử hoàn thiện

### Task 19: Thiết lập GitHub Actions CI `[TV1]`

**Mô tả:** Tạo workflow `.github/workflows/ci.yml` tự động chạy trên mọi Pull Request vào `develop` và `main`: cài Java 17, cache Maven, chạy dịch vụ PostgreSQL 16 (service container) để chạy toàn bộ `mvn verify` và kiểm tra build Docker image không lỗi.

**Tiêu chí nghiệm thu:**
- [x] Mở PR vào `develop` tự động kích hoạt workflow CI và báo trạng thái Pass/Fail ngay trên GitHub.
- [x] Build thất bại nếu có bất kỳ unit/integration test nào fail hoặc `Dockerfile` build lỗi.

**Kiểm chứng:**
- [x] Tests pass: workflow CI xanh trên GitHub Actions với 1 PR thử nghiệm.
- [x] Build succeeds: bước `docker build` trong CI hoàn tất không cảnh báo lỗi.
- [ ] Manual check: thử tạo commit cố tình làm fail 1 test, xác nhận CI báo đỏ và chặn merge.

**Phụ thuộc:** Task 1 (nên dựng sớm ngay sau Checkpoint Giai đoạn 1)

**File dự kiến chạm tới:**
- `.github/workflows/ci.yml`

**Quy mô ước tính:** Small (1 file)

---

### Task 20: Đóng gói Docker Production, Nginx WebSocket, Cloudflare Named Tunnel (`techcommerce.store` + Neon DB) và CD Self-hosted Runner `[TV1]`

**Mô tả:** Tạo `Dockerfile` multi-stage (stage 1 build WAR bằng Maven, stage 2 chạy trên `eclipse-temurin:17-jre-alpine` với user non-root và healthcheck), `docker-compose.prod.yml` (Nginx + App + `cloudflared` chạy Named Tunnel bằng `CLOUDFLARE_TUNNEL_TOKEN` gắn tên miền cố định `https://techcommerce.store`, kết nối PostgreSQL 16 dùng chung trên Neon.tech với HikariCP phù hợp scale-to-zero), cấu hình `server.forward-headers-strategy=framework` và `.github/workflows/cd.yml` gồm 2 job tách biệt: `build-and-push` lên GHCR (`ubuntu-latest`) và `deploy` (`self-hosted` trên máy TV1 có `timeout-minutes: 5`, hỗ trợ `workflow_dispatch`).

**Tiêu chí nghiệm thu:**
- [x] Image Docker hoàn chỉnh chạy ứng dụng bằng user non-root với giới hạn JVM `-Xms256m -Xmx512m`, không chứa mã nguồn hay Maven cache thừa, khởi động sạch và render được JSP.
- [x] `docker-compose.prod.yml` chạy tách biệt hoàn toàn với `docker-compose.yml` (không chiếm cổng `8080`/`5432` của máy dev, đặt `restart: unless-stopped`), kết nối ổn định tới Neon.tech PostgreSQL 16 vùng Singapore (`ap-southeast-1`, `sslmode=require`) và chạy được trên cả máy TV1 lẫn máy dự phòng với cùng dữ liệu.
- [x] Truy cập qua tên miền cố định `https://techcommerce.store` của Cloudflare Named Tunnel tải được JSP, tài nguyên tĩnh (đã bật `gzip on`, `Cache-Control` cho `/assets/**`, `limit_req_zone` chống spam trên `/auth/forgot-password` và đăng ký), upload ảnh Cloudinary (`client_max_body_size 10M`), nhận diện đúng HTTPS header và kết nối WebSocket (`wss://techcommerce.store/ws`) ổn định không bị 400/502.
- [x] Push/merge lên `main` tự động build, gắn tag theo commit SHA + `latest`, push lên GHCR; Self-hosted Runner (Windows Service trên máy TV1) tự động kéo image mới và cập nhật container bằng `docker compose -p techcommerce-prod -f docker-compose.prod.yml up -d`; có hướng dẫn cài UptimeRobot ping `https://techcommerce.store/health-jsp`.

**Kiểm chứng:**
- [x] Tests pass: kiểm tra container healthcheck `healthy` và endpoint `/health-jsp` trả 200 qua `https://techcommerce.store`.
- [x] Build succeeds: `docker build -t techcommerce:local .` và `docker compose -p techcommerce-prod -f docker-compose.prod.yml up -d`.
- [ ] Manual check: bật Self-hosted Runner trên máy TV1, đẩy 1 thay đổi nhỏ lên `main`, xác nhận `cd.yml` chạy xanh và thay đổi hiển thị trên `https://techcommerce.store`; thử tắt máy TV1 và bật container trên máy TV2 xác nhận tên miền sống lại với nguyên vẹn dữ liệu Neon.

**Phụ thuộc:** Task 15, Task 19

**File dự kiến chạm tới:**
- `Dockerfile`
- `docker-compose.prod.yml`
- `docker/nginx/default.conf`
- `.github/workflows/cd.yml`

**Quy mô ước tính:** Medium (4 files)

---

### Task 21: Seed dữ liệu mẫu `V5`, kiểm thử end-to-end, diễn tập dự phòng và rà soát bảo mật `[Cả nhóm]`

**Mô tả:** Tạo migration `V5__seed_demo_data.sql` (3 chi nhánh Hà Nội, TP.HCM, Đà Nẵng; tài khoản mẫu Admin/Staff/Customer; danh mục, sản phẩm kèm `specs_json`, tồn kho và 2 mã giảm giá mẫu), chạy kiểm thử toàn trình trên `https://techcommerce.store` (đăng nhập Google OAuth2, tìm kiếm không dấu, so sánh cấu hình, Wishlist, báo khi có hàng, giỏ vãng lai + Lưu mua sau + Mua ngay, đặt hàng đồng thời với voucher, VNPay Return/IPN + job 15 phút, thanh tiến trình đơn, hoàn trả hàng + đối chiếu doanh thu ròng, đánh giá ảnh + Q&A, WebSocket WSS qua Nginx, phân quyền chéo chi nhánh, Refresh Token revocation) và viết `README.md`.

**Tiêu chí nghiệm thu:**
- [ ] Khởi động mới hoàn toàn có ngay dữ liệu mẫu đầy đủ để trình diễn mọi tính năng chuỗi cửa hàng, so sánh cấu hình và voucher.
- [ ] Toàn bộ kịch bản kiểm thử chéo đạt yêu cầu, không có lỗ hổng truy cập chéo chi nhánh hay âm tồn kho/voucher.
- [ ] `README.md` mô tả rõ cách cấu hình biến môi trường, chạy local, kết nối Neon.tech, mở Cloudflare Named Tunnel, cài Self-hosted Runner, bật máy dự phòng và tài khoản demo.

**Kiểm chứng:**
- [ ] Tests pass: `mvn verify` xanh toàn bộ.
- [ ] Build succeeds: `docker compose -p techcommerce-prod -f docker-compose.prod.yml build` và chạy sạch.
- [ ] Manual check: duyệt trọn bộ kịch bản demo end-to-end từ máy khác/điện thoại qua `https://techcommerce.store` cùng cả 4 thành viên.

**Phụ thuộc:** Task 17, Task 18, Task 20

**File dự kiến chạm tới:**
- `src/main/resources/db/migration/V5__seed_demo_data.sql`
- `README.md`

**Quy mô ước tính:** Small (2 files)

---

### Checkpoint Giai đoạn 5: CI/CD, Docker Production & Bàn giao (Sau Task 19–21)
- [ ] Mọi tiêu chí nghiệm thu của Task 1–21 đều đạt.
- [ ] CI và CD trên GitHub Actions hoạt động ổn định, hệ thống public mượt trên `https://techcommerce.store` qua Cloudflare Named Tunnel + Neon DB.
- [ ] Đã diễn tập bật máy dự phòng (TV2) và rollback bằng image tag SHA trước đó.
