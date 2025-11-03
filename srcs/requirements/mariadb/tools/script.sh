#!/bin/bash
set -e

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld
chmod 777 /run/mysqld

echo "👉 Starting mysqld_safe..."
mysqld_safe &

until mariadb -u root -e "SELECT 1" &>/dev/null; do
    echo "⏳ Waiting for MariaDB to be ready..."
    sleep 2
done

if [ ! -d "/var/lib/mysql/Initialization" ]; then
    echo "✅ Initializing database..."
    touch /var/lib/mysql/Initialization
    mariadb -u root <<EOF
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_USER'@'%';
FLUSH PRIVILEGES;
EOF
    echo "🎉 MariaDB initialization complete!"
fi
mysqladmin shutdown
mysqld_safe
