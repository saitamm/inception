FROM debian:12

# Install PHP-FPM and extensions
RUN apt-get update && apt-get install -y \
    php8.2-fpm php8.2-mysql php8.2-cli php8.2-curl php8.2-xml php8.2-mbstring \
    wget unzip mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /var/www/html

# Download WordPress
RUN wget https://wordpress.org/latest.tar.gz \
    && tar -xzf latest.tar.gz --strip-components=1 \
    && rm latest.tar.gz

# Copy PHP-FPM pool config
# COPY ./tools/wordpress.conf /etc/php/8.2/fpm/pool.d/www.conf
# Copy wp-config.php into the container
COPY wp-config.php /var/www/html/wp-config.php

# Set permissions
RUN chown -R www-data:www-data /var/www/html

# Expose PHP-FPM port
EXPOSE 9000

# Start PHP-FPM
CMD ["php-fpm8.2", "-F"]
