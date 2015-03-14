function wps_config() {

	mv $home/wp-config.php $home/wp-config.bkp

	# ------------------------
	# WP CONFIG
	# ------------------------

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

	wps_permissions
	
}
