# THIÊN ĐỒ V11.150 — KIỂM TOÁN VÀ ỔN ĐỊNH HỆ THỐNG

**Ngày kiểm tra:** 15/10/2026. **Phiên bản:** V11.150. **Quyết định:** **NO-GO** — chưa nghiệm thu production, không mở rộng thuật toán, không triển khai website.

## 1. Đối tượng và tính toàn vẹn

- Repo kiểm thử: [adolfcsix/thiendo_demoo](https://github.com/adolfcsix/thiendo_demoo), branch `audit/v11.150`; giữ nguyên `main` và repo gốc `adolfcsix/thiendo_demo`.
- Đầu vào: ZIP đã lọc 1.855 tệp, SHA-256 `dab5b902d5557d08d5eaab7d5853778505f05248c22a26c723b31fbe954dc0a2`. CI tái dựng từ 7 phần base64, kiểm tra từng tệp theo manifest, áp dụng baseline bất biến, 7 fixtures và ba bản sửa hợp đồng HTTP/SSR có hash kiểm soát.
- **Quan trọng:** mã nguồn hiển thị trong repository dưới dạng các mảnh ZIP và lớp overlay; không phải Git tree source đầy đủ dễ sửa từng tệp. Bản clean-source candidate riêng phải được xác nhận byte-for-byte sau tất cả bản sửa trước khi GO.
- Không sửa `package-lock.json`, dependencies hoặc migration nhằm né lỗi; không thêm tính năng huyền học.

## 2. Bằng chứng đạt

CI baseline [38676478252](https://github.com/adolfcsix/thiendo_demoo/actions/runs/38676478252) tại commit `fe5486ca2af289072bf6cba0b87bc7feba6e4f1e`:
- Registry + pinned `yoctocolors-cjs@2.1.3`, `npm ci`, kiểm tra lockfile, source import/architecture, typecheck, build API/web — PASS.
- Regression suite **2.474/2.474** — PASS.
- PostgreSQL 16 test database isolation, 2 lần migration, HTTP E2E Next/Nest/PostgreSQL và 24 route SSR — PASS.
- Không suy diễn các PASS trên thành kiểm thử browser, sản xuất, backup, OAuth hoặc PayOS.

## 3. Bằng chứng browser phát hiện lỗi

CI run [38678297935](https://github.com/adolfcsix/thiendo_demoo/actions/runs/38678297935) lần đầu bật Chromium browser acceptance: **14/18 suite PASS; 4/18 FAIL**:
- `natal`: test thấy **0** hàng thay vì 10 ở bảng vị trí địa tâm sau khi kết quả Natal được tính.
- `timezone`: xác nhận IANA gap/fold có PASS, nhưng test thấy **0** hàng thay vì 3 ở bảng sensitivity.
- `system-depth`: chờ nút `Chuyển về Cơ bản` nằm trong phần hiển thị đang đóng, khác với topbar state.
- `star-source`: bộ định vị ARIA không tìm thấy bảng tên/hệ thẩm định sao trong 30 giây.

**Không loại bỏ/assertion yếu đi để đạt xanh.** CI branch đã có công cụ chẩn đoán cả DOM `table`, accessible table, nội dung trang và trạng thái ARIA. Cần đối chiếu screenshots + DOM và sửa lỗi thực tế hoặc kiểm thử có hợp đồng không đúng.

### Kết quả bổ sung được kiểm chứng
- [Run #38679170769](https://github.com/adolfcsix/thiendo_demoo/actions/runs/38679170769): Chromium responsive **35/35 PASS** trên 5 route × 7 viewport (320,375,390,768,1024,1440,1920px); không chứng minh toàn bộ trang và máy thật.
- Cùng run: **pg_dump + pg_restore disposable PostgreSQL 16: PASS**, **npm audit production snapshot: 0 high/critical**; browser acceptance vẫn FAIL 4/18.
- Read-only source gate: 932 files inspected, 200 TS/TSX parsed, 644 JS syntax checks and 1,812 relative imports — PASS cục bộ. CSS historical dedupe audit: 17 declaration removal verified, 28 baseline sheets reconstruct. Maintainability inventory: 446 source files; 33 oversized/long-line candidates.
- HTTP E2E baseline exercises real disposable API registration/login, cookie sessions and cross-account chart/study ownership. This is NOT equivalent to real OAuth/production login/browser UI flows.

## 4. Công việc tiếp tục đã commit trên nhánh audit

- Pinned Playwright Chromium `1.56.1` + 18 browser acceptance suites + lưu artifact log.
- Script `ci-scripts/v11150-responsive-matrix.mjs`: Chromium tại **320 / 375 / 390 / 768 / 1024 / 1440 / 1920px**, đo tràn ngang, console pageerror và chức năng search/menu trên 5 route.
- Script `ci-scripts/v11150-backup-restore.sh`: backup `pg_dump` + restore `pg_restore` vào DB **CI tạm riêng**, đối chiếu bảng và migration; khóa database URL để không bao giờ đụng production. **Không chứng minh chiến lược backup production**.
- Workflow báo cáo lỗ hổng dependencies production qua `npm audit --omit=dev`; đánh FAIL khi có lỗ hổng `high`/`critical` hoặc khi registry lỗi.
- `ci-overrides/CHECK_THIEN_DO_V11150_DEPENDENCIES_WINDOWS.bat`: tổng hợp mã lỗi FAIL/BLOCKED đúng và xuất `v11150-evidence/*.log`. Chưa chạy trên Windows thực tế.
- Các bản vá chẩn đoán chỉ trên **CI runner sau khi xác thực checksum**, chưa đổi hành vi sản phẩm.

## 5. Kiến trúc và nợ kỹ thuật

- FE `apps/web` (Next.js), BE `apps/api` (NestJS), shared `packages`, scripts và tests đã được tách trong monorepo và cơ bản qua import/architecture gate.
- Các file lớn cần review có trọng điểm: `apps/web/src/components/auth-provider.tsx`, `apps/web/src/components/shell.tsx`, `apps/web/src/app/ky-mon/page.tsx`, `apps/web/src/app/study/page.tsx`. Tránh chia tách ồ ạt khi browser còn FAIL.
- CSS layer lịch sử vẫn được import; **không xóa CSS theo cảm tính**, cần Chrome coverage và ảnh before/after responsive.
- Hai file JSON Tarot có SHA-identical: `packages/knowledge/src/tarot-depth-78.json` và `packages/knowledge/src/tarot-depth-v11124.json`, giữ nguyên để không gây lỗi import cũ.
- Các file migration, baseline và fixtures đã bị lược nhầm trong bản ZIP public đầu tiên, đã khôi phục có hash trong bản nguồn ứng viên. **Không xóa dữ liệu phục hồi**.

## 6. Ma trận công việc chưa đủ điều kiện nghiệm thu

| Hạng mục | Trạng thái |
| --- | --- |
| `npm ci`, typecheck, build, baseline 2.474 tests | PASS trên một commit đã định danh |
| PostgreSQL migrations và HTTP E2E | PASS tại baseline |
| Chromium UI 18 suites | **FAIL 4 suites** ở lần thử đầu |
| 7 viewport responsive | Đang đưa vào CI, chưa ghi nhận PASS |
| npm security high/critical | Đang đưa vào CI, chưa ghi nhận kết quả |
| PostgreSQL CI pg_dump/restore | Đang đưa vào CI, chưa ghi nhận kết quả |
| API register/login + cookie session, ownership & cross-user 404 | PASS trong PostgreSQL HTTP E2E baseline; cần tăng coverage theo toàn bộ role |
| Browser login/UI với session thật, OAuth Google và RBAC mọi nhóm quyền | Chưa xác minh |
| PayOS webhook/chữ ký/sandbox end-to-end | Chưa xác minh |
| Backup/restore production, rollback, RPO/RTO | Chưa xác minh |
| Tải và độ bền, secrets, threat model và quan sát lỗi | Chưa xác minh |
| Windows `.bat` trên Windows thật | Chưa xác minh |
| Triển khai website | **Chưa được phép, không thực hiện** |

## 7. Điều kiện quyết định GO

Chỉ khi **không còn lỗi nghiêm trọng**, full CI mới nhất PASS với tập source candidate chính thức, Chromium viewport và auth flows PASS, audit bảo mật đã xử lý, backup/restore và rollback có bằng chứng, có source sạch + changelog + runbook + report, và chủ sở hữu xác nhận thì mới xem xét duyệt V11.150. Không suy diễn việc test source được đóng gói thành một website production-ready.

