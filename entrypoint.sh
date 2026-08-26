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
sleep 2

# 3. Nginx im Vordergrund starten
echo "[*] Starte Nginx..."
exec nginx -g "daemon off;"
