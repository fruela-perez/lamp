#!/bin/bash

apt-get update 
apt-get install -y git vim gnupg htop

apt-get install -y apache2

echo "-- PHP --"

apt-get install -y php php-common php-cli php-fpm php-json php-pdo \
php-mysql php-zip php-gd  php-mbstring php-curl php-xml php-pear \
php-bcmath libapache2-mod-php

service apache2 restart

cp /vagrant_data/phpinfo.php /var/www/html/
