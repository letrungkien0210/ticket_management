# Báo Cáo: Triển Khai Phần Mềm Demo Quản Lý Thông Tin Khách Hàng + Đăng Ký QR Code Check-in

## I. Mục Tiêu Chính Của Phần Mềm Demo

- Xây dựng một ứng dụng web đầy đủ chức năng, dễ bảo trì và mở rộng theo kiến trúc hiện đại.
- Cung cấp một **module Khách hàng độc lập** cho phép khách hàng đăng ký, đăng nhập, xem sự kiện, "mua vé" (thanh toán giả lập, có kiểm tra giới hạn vé) và nhận mã QR. Giao diện sau đăng nhập theo phong cách Material Design.
- Cung cấp một **module Quản lý (Admin) độc lập** cho phép người quản lý (Admin) quản lý sự kiện, khách hàng và thực hiện check-in. Giao diện sau đăng nhập theo phong cách Material Design.
- **Trang chủ và phần giao diện Khách hàng trước khi đăng nhập** sẽ được thiết kế như một website giới thiệu sự kiện/landing page hấp dẫn.
- Hai module đăng nhập (Admin và Customer) hoạt động với **cơ chế xác thực hoàn toàn riêng biệt**.

---

## II. Các Thành Phần (Modules) Cốt Lõi

1.  **Module Quản Lý (Admin Interface):** Xây dựng bằng Next.js, dành cho người quản lý.
2.  **Module Khách Hàng (Customer Interface):** Xây dựng bằng Next.js, dành cho khách hàng.
3.  **Backend API:** Xây dựng bằng Node.js, cung cấp API cho cả hai module frontend.
4.  **Cơ sở dữ liệu (Database):** NoSQL **MongoDB**, được quản lý qua Mongoose ODM.
5.  Toàn bộ dự án được quản lý trong một **Monorepo**.

---

## III. Chức Năng Chính Theo Từng Module

### 1. Module Quản Lý (Admin):
- **Giao diện:** Phong cách Material Design sau khi đăng nhập.
- **Xác thực Admin:** Đăng nhập, Đăng xuất.
- **Quản lý Sự kiện:** Thêm, sửa, xóa sự kiện, đặt giới hạn vé.
- **Quản lý Khách hàng:** Xem danh sách, tìm kiếm, thêm mới, xem chi tiết, sửa, xóa.
- **Check-in Sự Kiện:** Mở camera, quét QR, hiển thị thông tin, xác nhận check-in.

### 2. Module Khách Hàng (Customer):
- **Giao diện công khai (Trước khi đăng nhập):** Phong cách website giới thiệu sự kiện/landing page.
- **Giao diện sau khi đăng nhập:** Phong cách Material Design.
- **Xác thực Khách hàng:** Đăng ký, Đăng nhập, Đăng xuất.
- **Quản lý Tài khoản Cá nhân:** Xem thông tin cá nhân.
- **Tham gia Sự kiện:** Xem danh sách sự kiện, xem chi tiết, "mua vé".

---

## IV. Cấu Trúc Dữ Liệu Chính (MongoDB Collections)

*Lưu ý: Chúng ta sẽ sử dụng Mongoose để định nghĩa Schema cho các collection trong MongoDB. Các mối quan hệ được xử lý bằng cách tham chiếu qua `ObjectId`.*

- **`admins` Collection:**
  - `_id` (ObjectId, Khóa chính)
  - `username` (String, Tên đăng nhập Admin, duy nhất)
  - `password_hash` (String, Mật khẩu đã mã hóa)
  - `full_name` (String, tùy chọn)
  - `email` (String, tùy chọn, duy nhất)
  - `role` (String)
  - `created_at` (Date), `updated_at` (Date)
- **`customers` Collection:**
  - `_id` (ObjectId, Khóa chính)
  - `email` (String, **dùng để đăng nhập, duy nhất**)
  - `password_hash` (String, Mật khẩu đã mã hóa)
  - `full_name` (String)
  - `phone_number` (String, tùy chọn)
  - `created_at` (Date), `updated_at` (Date)
- **`events` Collection:**
  - `_id` (ObjectId, Khóa chính)
  - `event_name` (String)
  - `event_date` (Date)
  - `description` (String)
  - `ticket_limit` (Number)
  - `images` (Array of Strings - URL hình ảnh sự kiện)
  - `created_at` (Date), `updated_at` (Date)
- **`tickets` Collection:**
  - `_id` (ObjectId, Khóa chính)
  - `customer_id` (ObjectId, Tham chiếu đến `_id` trong collection `customers`)
  - `event_id` (ObjectId, Tham chiếu đến `_id` trong collection `events`)
  - `qr_code_data` (String, duy nhất)
  - `payment_status` (String)
  - `check_in_status` (String)
  - `checked_in_at` (Date)
  - `checked_in_by` (ObjectId, Tham chiếu đến `_id` trong collection `admins`)
  - `created_at` (Date), `updated_at` (Date)

---

## V. Backend API Endpoints Chính

- **Xác thực Module Admin:**
  - `POST /api/auth/login`: Đăng nhập cho **Admin**.
  - `POST /api/auth/admin/logout`: Đăng xuất cho **Admin**.
- **Xác thực & Quản lý Tài khoản Khách hàng (Customer Account):**
  - `POST /api/customer/register`: Khách hàng tự đăng ký.
  - `POST /api/customer/login`: Đăng nhập cho **Khách hàng**.
  - `POST /api/customer/logout`: Đăng xuất cho **Khách hàng**.
  - `GET /api/customer/me`: (Yêu cầu Authentication Customer) Lấy thông tin chi tiết của khách hàng đang đăng nhập.
- **Quản lý Sự kiện (Yêu cầu Authentication Admin):**
  - `POST /api/admin/events`: Admin tạo sự kiện mới.
  - `PUT /api/admin/events/{eventId}`: Admin cập nhật thông tin sự kiện.
  - `DELETE /api/admin/events/{eventId}`: Admin xóa sự kiện.
- **Quản lý Khách hàng bởi Admin (Yêu cầu Authentication Admin):**
  - `POST /api/customer/`: Admin tạo khách hàng.
  - `GET /api/admin/customers`: Lấy danh sách khách hàng.
- **Tương tác Sự kiện từ Khách hàng (Yêu cầu Authentication Customer):**
  - `GET /api/events`: Khách hàng xem danh sách sự kiện.
  - `GET /api/events/{eventId}`: Khách hàng xem chi tiết một sự kiện.
  - `POST /api/events/{eventId}/purchase`: Khách hàng "mua vé".
- **Check-in (Yêu cầu Authentication Admin):**
  - `GET /api/checkin/verify?qr_code=[qrCodeData]`: Admin gửi QR data để xác minh.
  - `POST /api/checkin/confirm`: Admin xác nhận check-in.

---

## VI. Các Lưu Ý Đặc Biệt Cho Bản Demo

- **Thao tác thanh toán:** Được giả lập bằng một nút "Payment".
- **Chức năng Check-in:** Được tích hợp vào Module Quản lý Admin.
- **Tính độc lập của Module:** Admin và Customer có giao diện, luồng đăng nhập/đăng xuất, và token/session riêng biệt.
- **Hiển thị thông tin khách hàng:** Sau khi khách hàng đăng nhập, frontend gọi API `GET /api/customer/me` để lấy thông tin cá nhân.

---

## VII. Lộ Trình Phát Triển Chi Tiết

### **Bước 0: Thiết lập nền tảng (Foundation Setup)**
- **Mục tiêu:** Chuẩn bị môi trường, công cụ và cấu hình cốt lõi.
- **Hành động:**
  1.  **Khởi tạo Monorepo:** Dùng `pnpm` để tạo một monorepo, quản lý hai package: `backend` và `frontend`.
  2.  **Thiết lập Backend:** Trong thư mục `backend`, khởi tạo project Node.js với `TypeScript` (sử dụng `Express.js`). Cài đặt `Mongoose` để làm việc với MongoDB.
  3.  **Thiết lập Frontend:** Trong thư mục `frontend`, khởi tạo project `Next.js` với `TypeScript`. Cài đặt và cấu hình `Material-UI (MUI)`.
  4.  **Cấu hình Docker & Debugging:** Tạo `Dockerfile` cho backend và `docker-compose.yml` để khởi chạy `backend`, `frontend`, và database (`MongoDB`). Cấu hình để debug backend.
  5.  **Cài đặt Linting & Formatting:** Cấu hình `ESLint` và `Prettier` cho cả hai project.

### **Bước 1: Backend - Model và Data Access Layer (DAL)**
- **Mục tiêu:** Định nghĩa cấu trúc dữ liệu và các phương thức truy cập database.
- **Hành động:**
  1.  **Định nghĩa Schema:** Trong `backend/src/models`, tạo các file model sử dụng `Mongoose Schema`.
  2.  **Khởi động Database:** Chạy `docker-compose up -d` để khởi động MongoDB.
  3.  **Tạo Data mẫu (Seeding):** Viết script `seed.ts` sử dụng Mongoose models để điền dữ liệu mẫu.
  4.  **Xây dựng Repositories:** Tạo các lớp Repository (ví dụ: `customer.repository.ts`) sử dụng Mongoose models để thực hiện CRUD.
  5.  **Testing:** Dùng `Jest` để viết unit test, mock Mongoose models.

### **Bước 2: Backend - Service và API Endpoints**
- **Mục tiêu:** Xây dựng logic nghiệp vụ và phơi bày ra ngoài qua RESTful API.
- **Hành động:**
  1.  **Viết lớp Service:** Tạo các lớp Service (ví dụ: `event.service.ts`) chứa logic nghiệp vụ, gọi các phương thức từ tầng Repository.
  2.  **Viết Controller & Routes:** Tạo các file routes và controller để xử lý request HTTP.
  3.  **Error Handling:** Xây dựng một middleware xử lý lỗi tập trung.
  4.  **Testing:** Unit Test (`Jest`) cho Service. Integration Test (`Supertest`) cho API.

### **Bước 3: Frontend - Nền tảng và Kết nối dữ liệu**
- **Mục tiêu:** Dựng cấu trúc frontend, thiết lập state management và phương thức gọi API.
- **Hành động:**
  1.  **Cấu trúc thư mục:** Tổ chức project `Next.js`.
  2.  **Thiết lập môi trường:** Tạo file `.env.local` để lưu `NEXT_PUBLIC_API_URL`.
  3.  **Cấu hình SWR:** Tạo một file wrapper để cấu hình `fetcher` mặc định cho `SWR`.
  4.  **Tạo API Services:** Tạo các file định nghĩa các hàm gọi API.

### **Bước 4: Frontend - Giao diện và Trạng thái**
- **Mục tiêu:** Xây dựng giao diện người dùng và quản lý trạng thái.
- **Hành động:**
  1.  **Xây dựng Components:**
      - **Giao diện sau đăng nhập:** Sử dụng các component có sẵn từ `Material-UI (MUI)`.
      - **Giao diện Landing Page:** Thiết kế tùy chỉnh.
  2.  **Fetch dữ liệu với SWR:** Dùng hook `useSWR` trong các component/trang để gọi dữ liệu.
  3.  **Quản lý State (State Management):** Dùng `React Context + useReducer` cho state cục bộ và `Redux Toolkit (RTK) / Zustand` cho state toàn cục.
  4.  **Testing:** Dùng `Jest` và `React Testing Library` để test component.

### **Bước 5: Tích hợp, Tối ưu & Triển khai**
- **Mục tiêu:** Đảm bảo toàn bộ hệ thống hoạt động trơn tru và sẵn sàng triển khai.
- **Hành động:**
  1.  **E2E Testing (Tùy chọn):** Dùng `Cypress` hoặc `Playwright`.
  2.  **Tối ưu build:** Chạy `next build`. Xây dựng image Docker cho production.
  3.  **Thiết lập CI/CD:** Dùng `GitHub Actions` để tự động hóa quy trình: chạy lint, test, build và deploy.