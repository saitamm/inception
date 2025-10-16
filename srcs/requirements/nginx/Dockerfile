FROM debian:12

RUN apt-get update -y && apt-get install -y nginx


COPY ./tools/nginx.conf /etc/nginx/conf.d/default.conf
COPY ./tools/serv.key /etc/nginx/certs/
COPY ./tools/cert.crt /etc/nginx/certs/

CMD ["nginx", "-g", "daemon off;"]