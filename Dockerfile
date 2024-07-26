FROM ghcr.io/cirruslabs/flutter:3.22.3 AS build
WORKDIR /app
COPY . .
RUN flutter pub get
RUN flutter build web --release
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx-custom-config.conf /etc/nginx/nginx.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
