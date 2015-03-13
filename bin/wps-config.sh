function wps_config() {

	rm -f $home/wp-config.php

	cd $home/wp
	
	wp --allow-root core config \
	   --dbname=${DB_NAME} \
	   --dbuser=${DB_USER} \
	   --dbpass=${DB_PASS} \
	   --dbhost=${DB_HOST}:${DB_PORT} \
	   --extra-php <<PHP
define('WPCACHEHOME', '/var/wps/wp/wp-content/plugins/wp-super-cache/');
define('DISALLOW_FILE_EDIT', true);
define('WP_CACHE', true);
PHP

	mv wp-config.php ../

	chown wpstack:nginx -R $home/wp
	chmod 775 -R $home/wp
	
	chown wpstack:nginx $home/wp-config.php
	chmod 770 -R $home/wp-config.php

}
