FROM debian:12

# Install dependencies
RUN apt-get update && apt-get install -y php8.2-fpm  php-mysql \
  curl \
  mariadb-client \
  iputils-ping \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html/

RUN curl -o /tmp/latest.tar.gz https://wordpress.org/latest.tar.gz \
  && tar xf /tmp/latest.tar.gz -C /var/www/html --strip-components=1  \
  && rm  -rf /tmp/latest.tar.gz


RUN   curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

RUN chmod +x wp-cli.phar \
  && mv wp-cli.phar /usr/local/bin/wp

COPY ./tools/script.sh /var/www/html/
RUN chmod +x  /var/www/html/script.sh
RUN sed -ir "s/listen = \/run\/php\/php8.2-fpm.sock/listen = 0.0.0.0:9000/1" /etc/php/8.2/fpm/pool.d/www.conf

CMD ["/var/www/html/script.sh"]
