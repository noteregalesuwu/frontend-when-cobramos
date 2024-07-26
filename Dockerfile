FROM ghcr.io/cirruslabs/flutter:3.22.3 AS build
WORKDIR /app
COPY . .
RUN flutter pub get
RUN flutter config --enable-web
RUN flutter build web --release
FROM httpd:2.4.62-alpine
COPY --from=build /app/build/web /usr/local/apache2/htdocs/
EXPOSE 80
CMD ["httpd-foreground"]
