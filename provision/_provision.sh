MYSQL_ROOT_PWD='1234'

apt-get update && apt-get upgrade -y
apt-get install -y git vim gnupg htop

apt-get install -y apache2

apt-get install -y dirmngr
apt-key adv --keyserver pool.sks-keyservers.net --recv-keys 5072E1F5

echo "-- MySQL --"

echo "deb http://repo.mysql.com/apt/debian $(lsb_release -sc) mysql-8.0" | \
tee /etc/apt/sources.list.d/mysql80.listx

debconf-set-selections <<< \
"mysql-community-server mysql-server/default-auth-override select Use Legacy Authentication Method (Retain MySQL 5.x Compatibility)"

apt-get update

debconf-set-selections <<< \
  "mysql-community-server mysql-community-server/root-pass password $MYSQL_ROOT_PWD"

debconf-set-selections <<< \
  "mysql-community-server mysql-community-server/re-root-pass password $MYSQL_ROOT_PWD"

debconf-set-selections <<< \
  "mysql-community-server mysql-server/default-auth-override select Use Legacy Authentication Method (Retain MySQL 5.x Compatibility)"

DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server

echo "-- PHP --"

apt-get install -y php php-common php-cli php-fpm php-json php-pdo \
php-mysql php-zip php-gd  php-mbstring php-curl php-xml php-pear \
php-bcmath php7.3-mysql libapache2-mod-php

service apache2 restart

echo "-- WORDPRESS --"

wget -nv https://es.wordpress.org/latest-es_ES.tar.gz  
tar xzf latest-es_ES.tar.gz -C /var/www/html  

chown $USER:www-data /var/www/html/wordpress/ -R  
chmod g+w /var/www/html/wordpress/ -R  

mysql -u root -p$MYSQL_ROOT_PWD -e "create database wordpress character set utf8 collate utf8_unicode_ci;"
mysql -u root -p$MYSQL_ROOT_PWD -e "create user wordpress@localhost identified by '$MYSQL_ROOT_PWD';"
mysql -u root -p$MYSQL_ROOT_PWD -e "grant all privileges on wordpress.* to wordpress@localhost WITH GRANT OPTION;"
mysql -u root -p$MYSQL_ROOT_PWD -e "flush privileges;"
