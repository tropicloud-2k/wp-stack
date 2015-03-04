function wps_plugins() {

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
		
}