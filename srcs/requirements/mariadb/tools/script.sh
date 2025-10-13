#!/bin/bash
set -e

# Initialize database if not already done
if [ ! -d /var/lib/mysql/mysql ]; then
    echo "Initializing MariaDB data directory..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

# Start MariaDB in background
echo "Starting MariaDB..."
mysqld_safe &

# Wait for MariaDB to be ready
until mysqladmin ping &>/dev/null; do
    sleep 1
done

echo "MariaDB started."

# Create database, user, and set root password
mysql -uroot <<EOF
CREATE DATABASE IF NOT EXISTS MySql;
CREATE USER IF NOT EXISTS 'soumaya'@'%' IDENTIFIED BY 'Soumaya2000';
GRANT ALL PRIVILEGES ON MySql.* TO 'soumaya'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY 'soumaya';
FLUSH PRIVILEGES;
EOF

# Stop temporary server
mysqladmin -uroot -psoumaya shutdown

# Start MariaDB normally (foreground)
exec mysqld_safe
