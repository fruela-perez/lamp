#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

PASSWORD='1234'

echo  "+----------------------+"
echo  "|  Actualizar Sistema  |"
echo  "+----------------------+"

sudo apt-get update

echo  "+----------------------+"
echo  "|         VIM          |"
echo  "+----------------------+"

sudo apt-get install -y vim

echo  "+----------------------+"
echo  "|         cURL         |"
echo  "+----------------------+"

sudo apt-get install -y curl

echo  "+----------------------+"
echo  "|        Apache        |"
echo  "+----------------------+"

sudo apt-get install -y apache2

echo  "+----------------------+"
echo  "|        Locales       |"
echo  "+----------------------+"

sudo apt-get install -y software-properties-common
sudo apt-get install -y language-pack-es-base
sudo LC_ALL=es_ES.UTF-8 add-apt-repository ppa:ondrej/php

echo  "+----------------------+"
echo  "|        PHP 7.1       |"
echo  "+----------------------+"

sudo apt-get update
sudo apt install -y php7.1 libapache2-mod-php7.1 php7.1-common \
php7.1-mbstring php7.1-xmlrpc php7.1-soap php7.1-gd php7.1-xml \
php7.1-intl php7.1-mysql php7.1-cli php7.1-mcrypt php7.1-zip php7.1-curl

echo  "+----------------------+"
echo  "|         MySQL        |"
echo  "+----------------------+"

sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"
sudo apt-get -y install mysql-server

echo  "+----------------------+"
echo  "|      phpMyAdmin      |"
echo  "+----------------------+"

sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"

sudo apt-get -y install phpmyadmin

echo  "+----------------------+"
echo  "|     Virtual Host     |"
echo  "+----------------------+"

VHOST=$(cat <<EOF
<VirtualHost *:80>
    ServerName local.dev
    ServerAlias www.local.dev
    DocumentRoot /var/www/html
    <Directory /var/www/html>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-available/000-default.conf

echo  "+----------------------+"
echo  "|   Crear index.php    |"
echo  "+----------------------+"

#sudo rm /var/www/html/index.html
sudo touch /var/www/html/index.php
echo "<?php phpinfo(); ?>" > /var/www/html/index.php

echo  "+----------------------+"
echo  "|      mod_rewrite     |"
echo  "+----------------------+"

sudo a2enmod rewrite

echo  "+----------------------+"
echo  "|      phpMyAdmin      |"
echo  "+----------------------+"

sudo service apache2 restart

echo  "+----------------------+"
echo  "|         GIT          |"
echo  "+----------------------+"

sudo apt-get -y install git

echo  "+----------------------+"
echo  "|       Composer       |"
echo  "+----------------------+"

curl -s https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer