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
	cat > /app/wp-config.php <<'EOF'
<?php
$database_url = file_get_contents('/etc/env/DATABASE_URL');
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

	# ------------------------
	# WELCOME EMAIL
	# ------------------------
	
	ADM_MAIL='admin@tropicloud.net'
	MANDRILL='JVjDagu4lFHJhgjjY2yfKw'
	
	echo -e "Sending welcome email..."
	curl -s -A 'Mandrill-Curl/1.0' -d '{"key":"'$MANDRILL'","template_name":"wp-stack","template_content":[{"name":"title","content":"[WP-STACK] New WordPress Site"}],"message":{"subject":"[WP-STACK] New WordPress Site","from_email":"'$ADM_MAIL'","from_name":"Tropicloud","to":[{"email":"'$WP_MAIL'","name":"'$WP_USER'","type":"to"}],"headers":{"Reply-To":"'$ADM_MAIL'"},"important":true,"track_opens":true,"track_clicks":true,"auto_text":false,"auto_html":false,"inline_css":false,"url_strip_qs":false,"preserve_recipients":true,"view_content_link":false,"bcc_address":"'$ADM_MAIL'","tracking_domain":null,"signing_domain":null,"return_path_domain":null,"merge":true,"global_merge_vars":[{"name":"WP_URL","content":"'$WP_URL'"},{"name":"WP_USER","content":"'$WP_USER'"},{"name":"WP_PASS","content":"'$WP_PASS'"}]}}' 'https://mandrillapp.com/api/1.0/messages/send-template.json' | jq '.'

	# ------------------------
	# SSL CERT.
	# ------------------------

	cd /app/ssl
	
	curl -L http://git.io/kmRbDw | sed "s/localhost/$WP_DOMAIN/g" > openssl.conf
	openssl req -nodes -sha256 -newkey rsa:2048 -keyout app.key -out app.csr -config openssl.conf -batch
	openssl rsa -in app.key -out app.key
	openssl x509 -req -days 365 -in app.csr -signkey app.key -out app.crt	
	rm -f openssl.conf
	
	# ------------------------
	# FIX PERMISSIONS
	# ------------------------

	chown nginx:nginx -R /app/wordpress && chmod 755 -R /app/wordpress
	chown nginx:nginx /app/wp-config.php && chmod 750 -R /app/wp-config.php

}