# Docker — Flutter frontend (local / staging / production)

Triết lý giống `smartpantry-backend`: môi trường tách bằng file config, **không hardcode** URL trong source; Docker inject đúng file `dart-define` qua biến `DART_DEFINE_ENV_FILE`.

## File compose

| File | Mục đích |
|------|----------|
| `docker-compose.yml` | **Local dev** — Flutter web + **hot reload**, mount source |
| `docker-compose.staging.yml` | **Staging** — build release web + nginx |
| `docker-compose.prod.yml` | **Production** — build release tối ưu + nginx |

## Chuẩn bị env

```powershell
cd smartpantry_mobile
.\scripts\setup-env.ps1
```

Chỉnh `env/docker.dev.json` nếu backend không chạy ở `http://127.0.0.1:8000`.

Backend local (repo `smartpantry-backend`):

```powershell
docker compose up -d
```

## 1) Local dev + hot reload

```powershell
docker compose up --build
```

- App: http://127.0.0.1:8080  
- Hot reload: sửa file trong `lib/` → lưu → Flutter web reload (volume `.:/app`).
- Env: `DART_DEFINE_ENV_FILE=env/docker.dev.json` (override bằng biến môi trường host nếu cần).

```powershell
$env:DART_DEFINE_ENV_FILE="env/docker.dev.json"
docker compose up --build
```

## 2) Staging

```powershell
# Đảm bảo env/staging.json tồn tại (từ staging.json.example)
docker compose -f docker-compose.staging.yml up -d --build
```

- http://127.0.0.1:8081 (đổi `FLUTTER_WEB_PORT` nếu cần)
- API URL được **bake** vào build lúc `flutter build web --release`.

## 3) Production

```powershell
# env/prod.json từ production.json.example, điền API thật
docker compose -f docker-compose.prod.yml up -d --build
```

- http://127.0.0.1:80 (mặc định)
- Nginx phục vụ static `build/web`, gzip + cache asset.

## Chạy không Docker (host)

```bash
flutter run --dart-define-from-file=env/local.json
```

## So sánh với backend

| | Backend | Flutter mobile |
|---|---------|----------------|
| Local config | `.env` từ `env/.env.local.example` | `env/local.json` / `env/docker.dev.json` |
| Staging | `.env` + `docker-compose.yml` | `env/staging.json` + `docker-compose.staging.yml` |
| Prod | `.env` + `docker-compose.prod.yml` | `env/prod.json` + `docker-compose.prod.yml` |
| Runtime env | `APP_ENV` trong `.env` | `APP_ENV` trong JSON → `Env.appEnv` |

## Giới hạn cần biết

- Docker dev hiện target **Flutter web** (hot reload ổn định trong container).
- Build **APK/IPA** trong CI: dùng cùng `Dockerfile` với stage build khác hoặc workflow riêng (Phase sau).
- CORS: backend phải cho phép origin frontend (staging/prod URL) trong `CORS_ORIGINS`.
