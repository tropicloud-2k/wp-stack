function wps_plugin() {

	# ------------------------
	# Install WP plugins
	# ------------------------
	
	wp --allow-root plugin delete hello
 	wp --allow-root plugin install disable-xml-rpc --activate
 	wp --allow-root plugin install jetpack --activate
 	wp --allow-root plugin install limit-login-attempts --activate
 	wp --allow-root plugin install wordpress-seo
	
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
  	wp --allow-root plugin activate wp-super-cache

	# ------------------------
	# Ninja Firewall
	# ------------------------
	
	cat $wps/conf/nginx/htninja > /app/.htninja
 	wp --allow-root plugin install ninjafirewall --activate
		
}