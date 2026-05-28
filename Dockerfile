# Production / staging: optimized Flutter web release served by nginx.
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

ARG DART_DEFINE_ENV_FILE=env/prod.json

RUN flutter config --enable-web

COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .

RUN test -f "${DART_DEFINE_ENV_FILE}" || (echo "Missing ${DART_DEFINE_ENV_FILE}" && exit 1)

RUN flutter build web --release \
  --dart-define-from-file="${DART_DEFINE_ENV_FILE}" \
  --pwa-strategy=none

FROM nginx:1.27-alpine

COPY docker/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
