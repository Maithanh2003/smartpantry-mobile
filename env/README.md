# Flutter environment files (dart-define)

Tương đương backend `env/.env.*.example` — nhưng Flutter dùng **JSON** cho `--dart-define-from-file` (không commit file thật chứa URL riêng của bạn).

| Template (commit) | Copy thành (gitignore) | Dùng khi |
|-------------------|------------------------|----------|
| `local.json.example` | `local.json` | **Chrome / Windows / iOS simulator** → `http://127.0.0.1:8000` |
| `local.android.json.example` | `local.android.json` | **Android emulator** → `http://10.0.2.2:8000` |
| `docker.dev.json.example` | `docker.dev.json` | `docker compose up` (local dev + hot reload) |
| `staging.json.example` | `staging.json` | `docker compose -f docker-compose.staging.yml` |
| `production.json.example` | `prod.json` | `docker compose -f docker-compose.prod.yml` |

Các file cột “Copy thành” **không được commit** (đã liệt kê trong `.gitignore`). Chỉ commit `*.example` và `README.md`.

Nếu đã lỡ stage file nhạy cảm:

```powershell
git rm --cached env/local.json env/local.android.json env/staging.json env/prod.json 2>$null
```

## Biến (map với backend)

| Key | Backend tương đương | Ý nghĩa |
|-----|---------------------|---------|
| `APP_ENV` | `APP_ENV` | `dev` / `staging` / `prod` |
| `API_BASE_URL` | (URL public API) | Base URL backend, **không** hardcode trong `lib/` |
| `API_PREFIX` | API prefix | Mặc định `/api/v1` |

Đọc trong code: `lib/core/config/env.dart` (`String.fromEnvironment`).

## Setup nhanh

**Windows (PowerShell)** — từ `smartpantry_mobile/`:

```powershell
.\scripts\setup-env.ps1
```

**Linux/macOS:**

```bash
./scripts/setup-env.sh
```

## Lưu ý `API_BASE_URL` (quan trọng)

| Nơi chạy Flutter | `API_BASE_URL` |
|------------------|----------------|
| **Chrome / Edge (web)** | `http://127.0.0.1:8000` |
| **Windows desktop** | `http://127.0.0.1:8000` |
| **Android emulator** | `http://10.0.2.2:8000` |
| **Điện thoại thật (cùng Wi‑Fi)** | `http://<IP-máy-tính>:8000` (vd. `192.168.1.10`) |

`10.0.2.2` **chỉ** có nghĩa trên Android emulator. Nếu bạn chọn device **Chrome** khi `flutter run` mà vẫn để `10.0.2.2` → timeout / “took too long to respond”.

**Flutter web trong Docker** (compose frontend): trình duyệt gọi API → `http://127.0.0.1:8000`, không dùng `http://app:8000`.

**Android emulator vẫn lỗi với 10.0.2.2 (Windows):** thử:

```powershell
adb reverse tcp:8000 tcp:8000
```

Rồi dùng `http://127.0.0.1:8000` trong `local.android.json` và:

```powershell
flutter run --dart-define-from-file=env/local.android.json
```

Backend CORS: `.env` backend cần regex cho localhost (đã có `CORS_ORIGIN_REGEX=https?://(localhost|127\.0\.0\.1)(:\d+)?`).

Chi tiết Docker: `docs/docker-environments.md`.
