FROM nginx:stable-alpine
COPY ../application/deploy-app/build /usr/share/nginx/html
COPY operation/Docker/nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

