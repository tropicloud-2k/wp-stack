function wps_setup() {

	# ------------------------
	# WP INSTALL
	# ------------------------

	mkdir -p /app/wordpress
	cd /app/wordpress

	wp --allow-root core download
	wp --allow-root core config \
	   --dbname=${DB_NAME} \
	   --dbuser=${DB_USER} \
	   --dbpass=${DB_PASS} \
	   --dbhost=${DB_HOST}:${DB_PORT} \
	   --extra-php <<PHP
define('WPCACHEHOME', '/app/wordpress/wp-content/plugins/wp-super-cache/');
define('DISALLOW_FILE_EDIT', true);
define('WP_CACHE', true);
PHP

	if [[  $WP_SSL == "true"  ]]; then WP_URL="https://${WP_DOMAIN}"; else WP_URL="http://${WP_DOMAIN}"; fi
  
   	wp --allow-root core install \
 	   --title=WP-STACK \
 	   --url=$WP_URL \
 	   --admin_name=$WP_USER \
 	   --admin_email=$WP_MAIL \
 	   --admin_password=$WP_PASS
 	   
	# ------------------------
	# WP CONFIG
	# ------------------------
	
 	cat $wps/conf/nginx/wordpress.conf > /etc/nginx/conf.d/default.conf
	cat $wps/conf/nginx/wpsecure.conf > /etc/nginx/wpsecure.conf
	cat $wps/conf/nginx/wpsupercache.conf > /etc/nginx/wpsupercache.conf

	cat > /app/wp-config.php <<'EOF'
<?php
$database_url = parse_url(file_get_contents('/etc/env/DATABASE_URL'));
EOF

 	cat wp-config.php \
 	| sed "s|<?php||g" \
 	| sed "s|define('DB_NAME'.*|define('DB_NAME', trim(\$database_url['path'],'/'));|g" \
 	| sed "s|define('DB_USER'.*|define('DB_USER', \$database_url['user']);|g" \
 	| sed "s|define('DB_PASSWORD'.*|define('DB_PASSWORD', \$database_url['pass']);|g" \
 	| sed "s|define('DB_HOST'.*|define('DB_HOST', \$database_url['host'].':'.\$database_url['port']);|g" \
 	>> /app/wp-config.php && rm -f wp-config.php

	# ------------------------
	# WP THEME
	# ------------------------
	
	wp --allow-root rewrite structure '/%postname%/'
	wp --allow-root theme install "https://dl.dropboxusercontent.com/s/uchou7x8a5sdwvh/Sprocket%20Responsive%20WordPress%20Theme.zip?dl=1&token_hash=AAHMw2sKVNJ0FEzwI5dEZYw-BSycyaZyNV48K84MdcoMww" --activate	
	wp --allow-root option update tt_options --format=json '{"logo_url":"//s3.tropicloud.net/logo/logo-white-40px.png","site-link-color":"#23b4ea","header-background-color":"#333333","header-background-image":"//s3.tropicloud.net/wps-cli/img/slide-home.jpg","header-link-color":"#ffffff"}'
	wp --allow-root post meta update 2 header_image "//s3.tropicloud.net/wps-cli/img/slide-vantagens.jpg"
	
	PLUGINS='true'
	
	if [[  $PLUGINS == 'true'  ]]; then
		# ------------------------
		# Install WP plugins
		# ------------------------
		
		wp --allow-root plugin delete hello
	 	wp --allow-root plugin install bruteprotect --activate
	 	wp --allow-root plugin install disable-xml-rpc --activate
	 	wp --allow-root plugin install jetpack --activate
	 	wp --allow-root plugin install limit-login-attempts --activate
	 	wp --allow-root plugin install wordpress-seo
		wp --allow-root plugin install sucuri-scanner --activate
		wp --allow-root option update sucuriscan_notify_to "$WP_MAIL"
		
		# ------------------------
		# CloudFlare
		# ------------------------

		if [[  ! -z $CF_API || ! -z $CF_MAIL  ]]; then
		wp --allow-root plugin install cloudflare --activate
	 	wp --allow-root option update cloudflare_api_key "$CF_KEY" 
	 	wp --allow-root option update cloudflare_api_email "$ADM_MAIL" 
	 	fi
	
	 	# ------------------------
	 	# Autoptimize
	 	# ------------------------
	 	
	 	wp --allow-root plugin install autoptimize  --activate
	 	wp --allow-root option update autoptimize_html 'on'
	  	wp --allow-root option update autoptimize_html_keepcomments 'on'
	  	wp --allow-root option update autoptimize_js 'on'
	  	wp --allow-root option update autoptimize_css 'on'
	  	wp --allow-root option update autoptimize_css_datauris 'on'
		
		# ------------------------
	  	# WP Super Cache
	  	# ------------------------
	  	
	  	wp --allow-root plugin install wp-super-cache
		WPCACHEHOME="/app/wordpress/wp-content/plugins/wp-super-cache"
		cat > /app/wordpress/wp-content/wp-cache-config.php <<'EOF'
<?php
$wp_cache_front_page_checks = 1; //Added by WP-Cache Manager
$wp_cache_no_cache_for_get = 1; //Added by WP-Cache Manager
$cache_schedule_interval = 'daily'; //Added by WP-Cache Manager
$cache_time_interval = '21600'; //Added by WP-Cache Manager
$cache_scheduled_time = '04:00'; //Added by WP-Cache Manager
$cache_schedule_type = 'time'; //Added by WP-Cache Manager
$wp_cache_slash_check = 1; //Added by WP-Cache Manager
$wp_cache_mod_rewrite = 1; //Added by WP-Cache Manager
EOF
		cat ${WPCACHEHOME}/wp-cache-config-sample.php | sed 's/<?php//g' >> /app/wordpress/wp-content/wp-cache-config.php	
# 		sed -i 's|cache_enabled = false|cache_enabled = true|g' /app/wordpress/wp-content/wp-cache-config.php
		sed -i 's|cache_compression = 0|cache_compression = 1|g' /app/wordpress/wp-content/wp-cache-config.php
		sed -i 's|cache_max_time = 3600|cache_max_time = 86400|g' /app/wordpress/wp-content/wp-cache-config.php
		cat ${WPCACHEHOME}/advanced-cache.php > /app/wordpress/wp-content/advanced-cache.php
	  	wp --allow-root plugin activate wp-super-cache
	
		# ------------------------
		# Ninja Firewall
		# ------------------------
		
		cat >> /app/.htninja <<'EOF'
<?php

// To tell NinjaFirewall where you moved your WP config file,
$wp_config = '/app/wp-config.php';


// Users of Cloudflare CDN:
if (! empty($_SERVER["HTTP_CF_CONNECTING_IP"]) &&
   filter_var($_SERVER["HTTP_CF_CONNECTING_IP"], FILTER_VALIDATE_IP) ) {
	$_SERVER["REMOTE_ADDR"] = $_SERVER["HTTP_CF_CONNECTING_IP"];
}
EOF
	 	wp --allow-root plugin install ninjafirewall --activate
	
	fi

	# ------------------------
	# SSL CERT.
	# ------------------------

	cd /app/ssl
	
	cat $wps/conf/nginx/openssl.conf | sed "s/localhost/$WP_DOMAIN/g" > openssl.conf
	openssl req -nodes -sha256 -newkey rsa:2048 -keyout app.key -out app.csr -config openssl.conf -batch
	openssl rsa -in app.key -out app.key
	openssl x509 -req -days 365 -sha256 -in app.csr -signkey app.key -out app.crt	
	rm -f openssl.conf
	
	# ------------------------
	# FIX PERMISSIONS
	# ------------------------

	chown nginx:nginx -R /app/wordpress && chmod 755 -R /app/wordpress
	chown nginx:nginx /app/wp-config.php && chmod 750 -R /app/wp-config.php

	# ------------------------
	# WELCOME EMAIL
	# ------------------------
	
	$wps/bin/wps-mail welcome -d $WP_URL -u $WP_USER -p $WP_PASS -m $WP_MAIL
	
}