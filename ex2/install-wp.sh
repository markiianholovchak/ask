#!/bin/bash

PACKAGES_TO_BE_INSTALLED="mc cowsay tree"
dnf install -y -q ${PACKAGES_TO_BE_INSTALLED}

# Dane bazy danych
DB_NAME="databasename"
DB_USER="user"
DB_PASSWORD="password"

# Dane WordPressa
WP_URL="http://yourdomain.com"
WP_TITLE="Your WordPress Site"
WP_ADMIN_USER="admin"
WP_ADMIN_PASSWORD="adminpassword"
WP_ADMIN_EMAIL="admin@example.com"

# Instalacja pakietów
sudo yum install -y httpd mariadb mariadb-server php php-mysqlnd

# Startowanie usług
sudo systemctl start httpd
sudo systemctl start mariadb

# Tworzenie bazy danych i użytkownika
sudo mysql -u root -e "CREATE DATABASE ${DB_NAME};"
sudo mysql -u root -e "CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASSWORD}';"
sudo mysql -u root -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';"
sudo mysql -u root -e "FLUSH PRIVILEGES;"

# Pobieranie i instalacja WordPressa
wget https://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
sudo cp -R wordpress/* /var/www/html/

# Poprawienie uprawnień i właściciela plików
sudo chown -R apache:apache /var/www/html
sudo chmod -R 755 /var/www/html

# Konfiguracja WordPressa
sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sudo sed -i "s/database_name_here/${DB_NAME}/" /var/www/html/wp-config.php
sudo sed -i "s/username_here/${DB_USER}/" /var/www/html/wp-config.php
sudo sed -i "s/password_here/${DB_PASSWORD}/" /var/www/html/wp-config.php

# Konfiguracja vHost (Apache)
wpConfig="
<VirtualHost *:80>
    ServerAdmin webmaster@example.com
    DocumentRoot /var/www/html
    ServerName \${WP_URL}
    ErrorLog logs/\${WP_URL}-error_log
    CustomLog logs/\${WP_URL}-access_log common
</VirtualHost>"

# Sprawdzenie, czy katalog /etc/httpd/conf.d/ istnieje, jeśli nie, utwórz go
sudo mkdir -p /etc/httpd/conf.d/

# Zapisanie konfiguracji vHost
echo -e "$wpConfig" | sudo tee /etc/httpd/conf.d/wordpress.conf > /dev/null

# Restartowanie serwera Apache
sudo systemctl restart httpd

# Oczekiwanie na uruchomienie Apache
sleep 5

# Otwieranie przeglądarki z adresem WordPressa
xdg-open ${WP_URL}

cowsay "it works"