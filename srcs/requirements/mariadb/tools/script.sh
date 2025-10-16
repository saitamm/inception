#!/bin/bash
#
#
# echo database $MYSQL_DATABASE
# echo user $MYSQL_USER

if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
	service mariadb start
	mariadb << EOF
SHOW DATABASES;
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_USER'@'%';
FLUSH PRIVILEGES;
EOF
	service mariadb stop
fi

mysqld_safe
