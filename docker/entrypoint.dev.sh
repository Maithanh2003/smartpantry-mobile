#!/bin/sh
set -e

ENV_FILE="${DART_DEFINE_ENV_FILE:-env/docker.dev.json}"

if [ ! -f "$ENV_FILE" ]; then
  echo "Missing dart-define file: $ENV_FILE"
  echo "Copy from env/docker.dev.json.example -> env/docker.dev.json"
  exit 1
fi

flutter pub get

exec flutter run -d web-server \
  --web-hostname=0.0.0.0 \
  --web-port=8080 \
  --dart-define-from-file="$ENV_FILE"
