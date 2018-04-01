#!/bin/bash

# install repos
yum -y install epel-release
curl -O https://dl.iuscommunity.org/pub/ius/stable/CentOS/7/x86_64/ius-release-1.0-15.ius.centos7.noarch.rpm
rpm -Uvh ius-release*.rpm
rm ius-release*.rpm

# run updates
yum -y update

# install required packages
yum -y install httpd
yum -y install mod_php71u \
			   php71u-bcmath \
			   php71u-cli \
			   php71u-common \
			   php71u-dba \
			   php71u-dbg \
			   php71u-devel \
			   php71u-embedded \
			   php71u-enchant \
			   php71u-fpm \
			   php71u-fpm-httpd \
			   php71u-gd \
			   php71u-gmp \
			   php71u-imap \
			   php71u-interbase \
			   php71u-intl \
			   php71u-json \
			   php71u-ldap \
			   php71u-mbstring \
			   php71u-mcrypt \
			   php71u-mysqlnd \
			   php71u-odbc \
			   php71u-opcache \
			   php71u-pdo \
			   php71u-pdo-dblib \
			   php71u-pgsql \
			   php71u-process \
			   php71u-pspell \
			   php71u-recode \
			   php71u-pecl-redis \
			   php71u-pecl-xdebug \
			   php71u-xml \
			   git \
			   cifs-utils \
			   nano \
			   lsof
			   

# harden configs
sed -i 's/SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config
sed -i 's/expose_php.*/expose_php = Off/' /etc/php.ini
> /etc/httpd/conf.d/welcome.conf			   
echo "ServerTokens Prod" >> /etc/httpd/conf/httpd.conf
echo "ServerSignature Off" >> /etc/httpd/conf/httpd.conf

# install docker, docker-compose, composer
yum -y install docker \
				docker-client \
				docker-compose

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer 
chmod +x /usr/local/bin/composer

# chuck something in webroot just as a test
echo "<?php phpinfo(); ?>" > /var/www/html/index.php

# start apache
chkconfig httpd on
service httpd start

# start docker
chkconfig docker on
groupadd docker
usermod -aG docker vagrant
service docker start

# tidy up
yum clean all && yum makecache fast
reboot