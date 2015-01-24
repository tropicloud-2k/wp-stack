# ------------------------
# WPS SETUP
# ------------------------

function wps_setup() {

	# ------------------------
	# REPOS
	# ------------------------
	
	## NGINX
	cat $WPS/conf/yum/nginx.repo > /etc/yum.repos.d/nginx.repo
	
	## EPEL
	rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
	
	## REMI
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
	wget -O --quiet /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x /usr/local/bin/wp
	
	## JQ 
	wget -O --quiet /usr/local/bin/jq http://stedolan.github.io/jq/download/linux64/jq
	chmod +x /usr/local/bin/jq
	
	
	# ------------------------
	# CONFIG
	# ------------------------

	mkdir -p /app/backup
	mkdir -p /app/logs
	mkdir -p /app/html
	mkdir -p /app/ssl
	
	cat $WPS/conf/nginx/nginx.conf > /etc/nginx/nginx.conf
	cat $WPS/conf/php/php-fpm.conf > /etc/php-fpm.d/www.conf
	cat $WPS/conf/supervisor/supervisord.conf > /etc/supervisord.conf
	
}
