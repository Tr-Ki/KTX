# Ứng dụng Bản đồ 3D Ẩm thực KTX Khu B · ĐHQG TP.HCM

Hệ thống bản đồ 3D tương tác trực quan kết hợp nền tảng tìm kiếm, khám phá và đánh giá các điểm bán đồ ăn tại Ký túc xá Khu B – Đại học Quốc gia TP. Hồ Chí Minh.

---

## 🌟 Tính năng nổi bật

### 1. Bản đồ 3D khuôn viên KTX Khu B chuẩn ảnh vệ tinh
- **Mô phỏng 3D chính xác**: Tái hiện toàn bộ các cụm tòa nhà Khu B (B01–B05), Khu BA (BA1–BA5), Khu C (C01–C06), Khu D (D01–D06), Khu E (E01–E04), bùng binh trung tâm và Cổng chính KTX.
- **Tương tác trực quan**: Xoay (chuột trái / 1 ngón tay), phóng to / thu nhỏ (cuộn chuột / 2 ngón), kéo di chuyển (chuột phải) và chạm/click trực tiếp vào từng tòa để xem danh sách quán ăn đang mở tại tòa đó.
- **Chế độ hiển thị linh hoạt**: Tùy chọn bật/tắt đồ họa chi tiết cao (bóng đổ mặt trời, cây cối, xe đạp, ghế đá, bồn hoa, mây trôi).

### 2. Khám phá & Tìm kiếm ẩm thực
- **Tìm kiếm thông minh**: Tìm nhanh theo tên món ăn, tên quán hoặc mã tòa nhà (ví dụ: `cơm tấm`, `B01`, `E02`...).
- **Phân loại danh mục phong phú**: Lọc theo `Món chính`, `Ăn sáng`, `Đồ uống`, `Ăn vặt` và `Khác` với các biểu tượng vector Remix Icon hiện đại.
- **Thẻ món ăn trực quan**: Hiển thị số lượng tòa nhà có bán, điểm đánh giá trung bình kèm số lượng lượt đánh giá.
- **Thông tin chi tiết từng quán**: Giờ mở/đóng cửa kèm đèn báo trạng thái hoạt động (🟢 Đang mở cửa / 🔴 Đã đóng cửa), giá bán tham khảo và ghi chú vị trí (sảnh, tầng, quầy số).

### 3. Đánh giá & Nhận xét cộng đồng (Ratings & Reviews)
- **Đánh giá sao linh hoạt**: Chấm điểm từ 1 đến 5 sao (hỗ trợ hiển thị nửa sao chuẩn xác) kèm nhận xét ngắn tối đa 200 ký tự.
- **Phân bổ đánh giá**: Biểu đồ trực quan tỉ lệ phần trăm từng mức sao (1★ - 5★) và tính năng lọc xem bình luận theo từng số sao.
- **Bảo mật & Quyền riêng tư**: Đánh giá được lưu trữ trên Supabase với Row Level Security (RLS) — người dùng có thể xem tất cả đánh giá nhưng chỉ có thể chỉnh sửa hoặc xóa đánh giá của chính mình.
- **Hoàn tác xóa**: Hỗ trợ nút hoàn tác (Undo) ngay sau khi xóa đánh giá.

### 4. Dành cho Chủ quán (Quản lý món ăn & Thực đơn)
- **Đăng quán mới**: Hỗ trợ chủ quán hoặc sinh viên tự đăng điểm bán của mình lên sơ đồ.
- **Chọn nhiều tòa nhà cùng lúc**: Dễ dàng đánh dấu các tòa nhà mà quán phục vụ theo từng cụm (Khu B, BA, C, D, E).
- **Tải ảnh thực đơn (Menu Photos)**: Tải lên tối đa 5 ảnh menu (JPG, PNG, WebP, dung lượng tối đa 5 MB/ảnh) lưu trữ trực tiếp trên Supabase Storage bucket `ktx-menu-photos`.
- **Nhập dữ liệu hàng loạt (Bulk Import từ Excel / CSV)**:
  - Cung cấp tính năng tải file mẫu CSV chuẩn.
  - Hỗ trợ tải file bảng định dạng `.csv`, `.xls` hoặc `.xlsx`.
  - Bảng xem trước dữ liệu có đánh dấu lỗi, cho phép chỉnh sửa trực tiếp trên từng ô hoặc loại trừ toàn bộ các dòng lỗi chỉ với 1 click.
  - Mỗi tài khoản tối đa 20 điểm bán; quy tắc được kiểm tra cả trong giao diện lẫn trigger Supabase.

### 5. Đăng nhập tiện lợi bằng Magic Link (Passwordless OTP)
- Đăng nhập bảo mật qua liên kết gửi một lần về email — **không cần ghi nhớ mật khẩu**.
- Tự động đồng bộ và di chuyển dữ liệu cũ từ LocalStorage lên tài khoản Supabase ngay sau khi đăng nhập thành công.
- Chuyển dữ liệu cũ có kiểm tra trùng để tránh tạo lại quán đã được chuyển trước đó.
- Hộp thoại quản lý tài khoản cá nhân, xem số lượng quán đã đăng và đăng xuất an toàn.

---

## 🛠️ Công nghệ sử dụng (Tech Stack)

| Thành phần | Công nghệ | Chi tiết |
| :--- | :--- | :--- |
| **Giao diện & 3D** | HTML5, CSS3, Vanilla JavaScript (ES Modules) | Kiến trúc Single Page Application (`tuff.html`), Glassmorphism Dark Theme |
| **Đồ họa 3D** | [Three.js r160](https://threejs.org/) | OrbitControls, CSS2DRenderer, MeshStandardMaterial, DirectionalLight shadows |
| **Typography** | [Plus Jakarta Sans](https://fonts.google.com/specimen/Plus+Jakarta+Sans) | Google Fonts tối ưu tiếng Việt |
| **Icon System** | [Remix Icon v4.2.0](https://remixicon.com/) | Vector icon CDN hiện đại, đồng bộ toàn hệ thống |
| **Xử lý bảng tính** | [SheetJS (xlsx 0.18.5)](https://docs.sheetjs.com/) | Đọc & parse file CSV, Excel cho tính năng Bulk Import |
| **Backend & Database** | [Supabase](https://supabase.com/) | PostgreSQL, Row Level Security (RLS), Supabase Storage |
| **CI/CD & Hosting** | GitHub Pages & GitHub Actions | Tự động chạy database migrations và triển khai static web |

---

## 📁 Cấu trúc thư mục

```text
TrKien-KTX/
├── .github/
│   └── workflows/
│       └── deploy.yml            # Pipeline CI/CD tự động deploy Supabase & GitHub Pages
├── supabase/
│   ├── config.toml               # Cấu hình dự án Supabase cục bộ
│   └── migrations/
│       ├── 202611190001_init_ktx.sql           # Khởi tạo bảng dữ liệu, bucket & RLS policies
│       ├── 202611190002_add_shared_ratings.sql # Bảng đánh giá chia sẻ cộng đồng
│       └── 202611200001_harden_shops.sql        # Giới hạn/quy tắc quán phía database
├── index.html                    # Trang chuyển tiếp cục bộ hỗ trợ callback token Supabase
├── tuff.html                     # Ứng dụng nguồn duy nhất (triển khai thành index.html trên Pages)
└── readme.md                     # Tài liệu hướng dẫn dự án
```

---

## 🚀 Hướng dẫn chạy cục bộ (Local Development)

Vì ứng dụng được thiết kế dạng Single Page Application thuần sử dụng ES Modules, bạn có thể chạy bằng bất kỳ HTTP server cục bộ nào:

### 1. Sử dụng Python
```bash
python -m http.server 8080
```
Sau đó truy cập: `http://localhost:8080` (hoặc `http://localhost:8080/tuff.html`)

### 2. Sử dụng Node.js (npx serve hoặc http-server)
```bash
npx serve .
```

### 3. Sử dụng VS Code Live Server
Mở file `tuff.html` trong VS Code, nhấn chuột phải và chọn **Open with Live Server**.

---

## 🔐 Cấu hình Xác thực & Supabase

### Cấu hình URL Redirect trong Supabase
Để liên kết Magic Link không quay về `localhost` hoặc các URL test, ứng dụng gửi callback cố định về GitHub Pages:
1. Đăng nhập vào trang quản trị [Supabase Dashboard](https://supabase.com/dashboard).
2. Chọn dự án KTX (`fbwvypwbrpgpgcgryjbs`).
3. Vào **Authentication → URL Configuration**:
   - **Site URL**: `https://tr-ki.github.io/KTX/`
   - **Redirect URLs (Allow list)**: Bấm **Add URL** và thêm các URL hợp lệ sau:
     - `https://tr-ki.github.io/KTX/**`
     - `https://tr-ki.github.io/KTX/`
4. Bấm **Save changes**.

### Biến môi trường cho GitHub Actions
Để pipeline tự động cập nhật Database và triển khai GitHub Pages khi push code lên nhánh `main`, cần cấu hình các secrets sau trong **Repository Settings → Secrets and variables → Actions**:
- `SUPABASE_ACCESS_TOKEN`: Token truy cập tài khoản Supabase CLI.
- `SUPABASE_DB_PASSWORD`: Mật khẩu cơ sở dữ liệu PostgreSQL.
- `SUPABASE_PROJECT_REF`: Mã định danh dự án (`fbwvypwbrpgpgcgryjbs`).

---

## 👥 Đóng góp & Bản quyền

Dự án phát triển vì mục đích hỗ trợ cộng đồng sinh viên Ký túc xá Đại học Quốc gia TP.HCM. Mọi đóng góp, báo lỗi hoặc đề xuất tính năng mới đều được hoan nghênh qua GitHub Issues và Pull Requests!
