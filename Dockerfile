#SSJ Fase 1
FROM node:22-alpine AS build
WORKDIR /app
COPY *.json .
RUN npm install
COPY . .
RUN npm run build --build
#SSJ Fase 2
FROM nginx:1.27.0-alpine
COPY --from=build /app/dist/when-cobramos-frontend/browser/ /usr/share/nginx/html/
COPY nginx-custom-config.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]


