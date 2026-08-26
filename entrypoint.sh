#!/bin/sh

set -e

MYSQL_DATA="/var/lib/mysql"
MYSQL_SOCKET="/run/mysqld/mysqld.sock"
INIT_MARKER="/var/lib/mysql/.dvwa_initialized"

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

if [ ! -d "$MYSQL_DATA/mysql" ]; then
    echo "==> Initializing MariaDB..."

    mysql_install_db \
        --user=mysql \
        --datadir="$MYSQL_DATA"
fi

echo "==> Starting MariaDB..."

mysqld \
    --user=mysql \
    --datadir="$MYSQL_DATA" \
    --socket="$MYSQL_SOCKET" \
    --pid-file=/run/mysqld/mysqld.pid \
    --bind-address=127.0.0.1 \
    --port=3306 \
    --skip-networking=0 &

MYSQL_PID=$!

echo "==> Waiting for MariaDB..."

until mysqladmin \
    --socket="$MYSQL_SOCKET" \
    -u root \
    ping >/dev/null 2>&1
do
    sleep 1
done

echo "==> MariaDB is ready."

if [ ! -f "$INIT_MARKER" ]; then

    echo "==> Configuring MariaDB..."

    mysql \
        --socket="$MYSQL_SOCKET" \
        -u root <<-EOSQL
        ALTER USER 'root'@'localhost' IDENTIFIED BY 'password';
        CREATE DATABASE IF NOT EXISTS dvwa;
EOSQL

    echo "==> Importing init.sql..."

    mysql \
        --socket="$MYSQL_SOCKET" \
        -u root \
        -ppassword \
        dvwa < /docker-entrypoint-initdb.d/init.sql

    touch "$INIT_MARKER"

    echo "==> DVWA database initialized."

else

    echo "==> DVWA database already initialized."

fi

echo "==> Starting PHP-FPM..."

php-fpm81 -D

echo "==> Starting Nginx..."

exec nginx -g "daemon off;"
