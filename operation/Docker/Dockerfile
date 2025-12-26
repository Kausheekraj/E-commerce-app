# Building React app
# FROM node:18 AS builder
# WORKDIR  /app 
# COPY application/package*.json ./
# RUN npm install
# COPY application ./
# RUN npm run build
# Nginx as server
FROM nginx:stable-alpine
COPY ../application/deploy-app/build /usr/share/nginx/html
COPY operation/Docker/nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

