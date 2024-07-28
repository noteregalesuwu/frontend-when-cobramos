FROM ghcr.io/cirruslabs/flutter:3.22.3 AS build
ARG FLUTTER_API_URL
ARG VAPID_KEY_ARG
WORKDIR /app
COPY . .
RUN flutter pub get
RUN flutter build web --profile \
    --dart-define=API_URL=${FLUTTER_API_URL} \                      
    --dart-define=VAPID_KEY=${VAPID_KEY_ARG}
FROM nginx:1.27.0-alpine
COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx-custom-config.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]



