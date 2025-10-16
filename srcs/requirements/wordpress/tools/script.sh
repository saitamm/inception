#!/bin/bash

echo "DB_NAME=$MYSQL_DATABASE"
echo "DB_USER=$MYSQL_USER"
echo "DB_PASS=$MYSQL_PASSWORD"
echo "DB_HOST=$DB_HOST:$DB_HOST_PORT"

until mysqladmin ping -h"$DB_HOST" -P"$DB_HOST_PORT" --silent; do
  echo "Waiting for MariaDB..."
  sleep 2
done

if [ ! -f /var/www/html/wp-config.php ]; then
	wp core download --allow-root
	wp config create \
		--dbname="$MYSQL_DATABASE" \
		--dbuser="$MYSQL_USER" \
		--dbpass="$MYSQL_PASSWORD" \
		--dbhost="$DB_HOST:$DB_HOST_PORT" \
		--allow-root
fi
if ! wp core is-installed --allow-root; then
  wp core install \
    --url="https://sait-amm.42.fr" \
    --title="Inception" \
    --admin_user="$MYSQL_USER" \
    --admin_password="$MYSQL_PASSWORD" \
    --admin_email="$USER_EMAIL" \
    --allow-root
fi


wp user create $USER $USER_EMAIL \
    --user_pass=$USER_PASSWORD \
    --allow-root
echo "USER=$USER"
echo "USER_EMAIL=$USER_EMAIL"
echo "USER_PASSWORD=$USER_PASSWORD"

# echo "soumaaaaaaaaaya wordpress started"

php-fpm8.2 -F
