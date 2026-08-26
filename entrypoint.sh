#!/bin/sh

# Verzeichnisse absichern
mkdir -p /run/mysqld /run/php
chown -R mysql:mysql /run/mysqld /var/lib/mysql
chown -R nginx:nginx /run/php

# 1. MariaDB im Hintergrund starten
echo "[*] Starte MariaDB..."
mysqld --user=mysql --datadir=/var/lib/mysql &

# 2. PHP-FPM im Hintergrund starten
echo "[*] Starte PHP-FPM..."
php-fpm81

# Kurz warten, bis die Dienste bereit sind
sleep 5

# 3. MariaDB initialisieren, falls noch nicht vorhanden
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking &
    MYSQL_PID=$!

    until mysqladmin -u root ping >/dev/null 2>&1; do
        sleep 1
    done

    mysql -u root <<-EOSQL
        ALTER USER 'root'@'localhost' IDENTIFIED BY 'password';
        CREATE DATABASE IF NOT EXISTS dvwa;
EOSQL

    mysql -u root -ppassword dvwa < /docker-entrypoint-initdb.d/init.sql

    mysqladmin -u root -ppassword shutdown
    wait $MYSQL_PID
fi


# 4. Nginx im Vordergrund starten
echo "[*] Starte Nginx..."
exec nginx -g "daemon off;"
