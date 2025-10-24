#!/bin/bash
set -e

echo "-------------- Starting MariaDB setup"
mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld
chmod 755 /run/mysqld

# Start MariaDB in the background
echo "👉 Starting mysqld_safe..."
mysqld_safe --nowatch &

# Wait until MariaDB is ready to accept connections
until mariadb -u root -e "SELECT 1" &>/dev/null; do
    echo "⏳ Waiting for MariaDB to be ready..."
    sleep 2
done

if [ ! -d "/var/lib/mysql/chek" ]; then
    echo "✅ Initializing database..."
    touch /var/lib/mysql/chek
    mariadb -u root <<EOF
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_USER'@'%';
FLUSH PRIVILEGES;
EOF
    echo "🎉 MariaDB initialization complete!"
fi
mysqladmin -u root -p"$MYSQL_ROOT_PASSWORD" shutdown
echo "-------------- MariaDB setup done"
# Keep MariaDB running in the foreground
mysqld_safe
