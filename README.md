# smartpantry_mobile

Flutter client for SmartPantry.

## Quick start

```powershell
.\scripts\setup-env.ps1
flutter pub get
flutter run --dart-define-from-file=env/local.json
```

## Docker (local / staging / production)

Same philosophy as `smartpantry-backend` — env templates + compose per environment.

| Environment | Compose |
|-------------|---------|
| Local dev (hot reload, web) | `docker compose up --build` |
| Staging | `docker compose -f docker-compose.staging.yml up -d --build` |
| Production | `docker compose -f docker-compose.prod.yml up -d --build` |

See [docs/docker-environments.md](docs/docker-environments.md) and [env/README.md](env/README.md).

Phase A foundation: [README_PHASE_A.md](README_PHASE_A.md).
