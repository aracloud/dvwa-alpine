FROM alpine:3.18

# 1. Systempakete installieren (Nginx, PHP-FPM, MariaDB & Tools)
RUN apk add --no-cache \
    nginx \
    mariadb \
    mariadb-client \
    php81 \
    php81-fpm \
    php81-mysqli \
    php81-pdo_mysql \
    php81-gd \
    php81-json \
    php81-session \
    git \
    curl \
    unzip

# 2. DVWA herunterladen und entpacken (Neuer Pfad für Nginx: /var/www/html)
WORKDIR /var/www/html
RUN git clone --depth 1 https://github.com/digininja/DVWA.git . \
    && chown -R nginx:nginx /var/www/html \
    && chmod -R 777 /var/www/html/external/phpids/0.6/lib/IDS/tmp \
    && chmod -R 777 /var/www/html/hackable/uploads

# 3. Nginx & PHP-FPM konfigurieren
COPY nginx.conf /etc/nginx/nginx.conf
COPY config.inc.php /var/www/html/config/config.inc.php

# PHP-FPM Socket-Verzeichnis und PHP-Einstellungen anpassen
RUN mkdir -p /run/php \
    && sed -i 's/allow_url_include = Off/allow_url_include = On/g' /etc/php81/php.ini \
    && sed -i 's/listen = 127.0.0.1:9000/listen = \/run\/php\/php81-fpm.sock/g' /etc/php81/php-fpm.d/www.conf \
    && sed -i 's/;listen.owner = nobody/listen.owner = nginx/g' /etc/php81/php-fpm.d/www.conf \
    && sed -i 's/;listen.group = nobody/listen.group = nginx/g' /etc/php81/php-fpm.d/www.conf \
    && sed -i 's/user = nobody/user = nginx/g' /etc/php81/php-fpm.d/www.conf \
    && sed -i 's/group = nobody/group = nginx/g' /etc/php81/php-fpm.d/www.conf

# 4. MariaDB initialisieren und DVWA-Datenbank vorab einrichten
RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql \
    && mysqld --user=mysql --datadir=/var/lib/mysql --bootstrap < /usr/share/mariadb/mysql_system_tables.sql \
    && mysqld --user=mysql --datadir=/var/lib/mysql --bootstrap < /usr/share/mariadb/mysql_system_tables_data.sql \
    && (mysqld --user=mysql --datadir=/var/lib/mysql & \
        PID=$!; \
        sleep 3; \
        mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'password';"; \
        mysql -u root -ppassword -e "CREATE DATABASE IF NOT EXISTS dvwa;"; \
        mysql -u root -ppassword dvwa < /var/www/html/_developer_setup/mysql_init.sql; \
        kill "$PID"; \
        wait "$PID")

# 5. Entrypoint-Skript kopieren
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
