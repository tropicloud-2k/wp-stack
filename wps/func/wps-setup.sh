function wps_setup() {

	# ------------------------
	# REPOS
	# ------------------------
	
	# NGINX
	cat /usr/local/wps/conf/yum/nginx.repo > /etc/yum.repos.d/nginx.repo
	
	# EPEL
	rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
	
	# REMI
	rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
	
	# ------------------------
	# INSTALL
	# ------------------------
	
	## Dependecies
	yum install -y nano wget zip python-setuptools

	## NGINX + MariaDB Client
	yum install -y nginx mariadb 
	               
	## PHP
	yum install -y --enablerepo=remi,remi-php56 \
	               php-fpm \
	               php-common \
	               php-opcache \
	               php-pecl-apcu \
	               php-cli \
	               php-pear \
	               php-pdo \
	               php-mysqlnd \
	               php-pgsql \
	               php-pecl-mongo \
	               php-pecl-sqlite \
	               php-pecl-memcache \
	               php-pecl-memcached \
	               php-gd php-mbstring \
	               php-mcrypt php-xml
	               
	## Supervisor
	easy_install supervisor
	easy_install supervisor-stdout
	
	## WP-CLI
	wget -O /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x /usr/local/bin/wp
	
	# ------------------------
	# CONFIG
	# ------------------------

	cat /usr/local/wps/conf/nginx/nginx.conf > /etc/nginx/nginx.conf
	cat /usr/local/wps/conf/nginx/wordpress.conf > /etc/nginx/conf.d/wordpress.conf
	cat /usr/local/wps/conf/php/php-fpm.conf > /etc/php-fpm.d/www.conf
	cat /usr/local/wps/conf/supervisor/supervisord.conf > /etc/supervisord.conf
	
	# ------------------------
	# OPENSSL
	# ------------------------
	
	mkdir -p /app/ssl
	cd /app/ssl
	
	openssl req -nodes -sha256 -newkey rsa:2048 -keyout localhost.key -out localhost.csr -config /usr/local/wps/conf/nginx/openssl.conf -batch
	openssl rsa -in localhost.key -out localhost.key
	openssl x509 -req -days 365 -in localhost.csr -signkey localhost.key -out localhost.crt 

	# ------------------------
	# WORDPRESS
	# ------------------------
	
	mkdir -p /app/wordpress
	
	wp --allow-root core download
	cat /usr/local/wps/conf/wordpress/wp-config.php > /app/wp-config.php

# 	wp --allow-root core install --url=${WP_URL} --title=${DOMAIN} --admin_name=${ADM_USER} --admin_email=${ADM_MAIL} --admin_password=${ADM_PASS}

}
