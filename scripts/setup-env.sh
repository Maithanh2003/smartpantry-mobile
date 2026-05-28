#!/usr/bin/env sh
set -e
cd "$(dirname "$0")/.."

copy_if_missing() {
  src="$1"
  dst="$2"
  if [ ! -f "$src" ]; then
    echo "Skip missing template: $src"
    return
  fi
  if [ ! -f "$dst" ]; then
    cp "$src" "$dst"
    echo "Created $dst"
  else
    echo "Keep existing $dst"
  fi
}

copy_if_missing env/local.json.example env/local.json
copy_if_missing env/local.android.json.example env/local.android.json
copy_if_missing env/docker.dev.json.example env/docker.dev.json
copy_if_missing env/staging.json.example env/staging.json
copy_if_missing env/production.json.example env/prod.json

echo "Done. Edit env/*.json for your API_BASE_URL."
