FROM debian:12

WORKDIR /etc/nginx/

RUN apt update -y && apt install -y openssl nginx

RUN mkdir -p /etc/srv-prv/
COPY ./tools/nginx.conf /etc/nginx/conf.d/default.conf


RUN openssl req -x509 -nodes \
    -keyout /etc/srv-prv/nginx_ssl.key \
    -out /etc/srv-prv/nginx_ssl.crt \
    -days 365 \
    -subj "/C=MA/ST=NON/L=NON/O=1337/OU=IT/CN=sait-amm.42.fr/UID=INV"

CMD ["nginx", "-g", "daemon off;"]