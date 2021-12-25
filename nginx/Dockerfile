FROM nginx:alpine

COPY ./config /etc/nginx/config
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./default.conf /etc/nginx/conf.d/default.conf
COPY ./config/html/error.html /var/www/default/error.html

EXPOSE 80
