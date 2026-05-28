# Copy dart-define templates (safe to re-run).
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

$pairs = @(
  @("env/local.json.example", "env/local.json"),
  @("env/local.android.json.example", "env/local.android.json"),
  @("env/docker.dev.json.example", "env/docker.dev.json"),
  @("env/staging.json.example", "env/staging.json"),
  @("env/production.json.example", "env/prod.json")
)

foreach ($pair in $pairs) {
  $src, $dst = $pair
  if (-not (Test-Path $src)) {
    Write-Warning "Skip missing template: $src"
    continue
  }
  if (-not (Test-Path $dst)) {
    Copy-Item $src $dst
    Write-Host "Created $dst"
  } else {
    Write-Host "Keep existing $dst"
  }
}

Write-Host "Done. Edit env/*.json for your API_BASE_URL."
