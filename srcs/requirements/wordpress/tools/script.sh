#!/bin/bash

echo "DB_NAME=$MYSQL_DATABASE"
echo "DB_USER=$MYSQL_USER"
echo "DB_PASS=$MYSQL_PASSWORD"
echo "DB_HOST=$DB_HOST:$DB_HOST_PORT"

until mysqladmin ping -h "$DB_HOST" -P "$DB_HOST_PORT" --silent -u "$MYSQL_USER" -p"$MYSQL_PASSWORD"; do
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
    --admin_user="$ADMIN" \
    --admin_password="$ADMIN_PASSWORD" \
    --admin_email="$ADMIN_EMAIL" \
    --allow-root
fi

# echo "----------------------------------------------Wordpress setup done"
wp user create $USER_WP $USER_WP_EMAIL \
    --user_pass=$USER_WP_PASSWORD \
    --allow-root
echo "USER=$USER_WP"
echo "USER_EMAIL=$USER_WP_EMAIL"
echo "USER_PASSWORD=$USER_WP_PASSWORD"


php-fpm8.2 -F
