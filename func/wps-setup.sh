function wps_setup() {
	
	# ------------------------
	# ENV. SETUP
	# ------------------------
	
	env | grep = >> /etc/environment && export TERM=xterm
	
	# ------------------------
	# WP INSTALL
	# ------------------------

	mkdir -p /app/wordpress
	cd /app/wordpress
	
	wp --allow-root core download
	if [ ! $? -eq 0 ]; then 
	wget https://wordpress.org/latest.zip
	unzip *.zip && rm -f *.zip
	mv wordpress/* $(pwd)
	rm -rf wordpress
	fi
	
  	cat $wps/conf/nginx/wordpress.conf > /etc/nginx/conf.d/default.conf
	cat $wps/conf/wordpress/wp-config.php > /app/wp-config.php
	
 	wp --allow-root core install \
 	   --title=WP-STACK \
 	   --url=http://$WP_URL \
 	   --admin_name=$WP_USER \
 	   --admin_email=$WP_MAIL \
 	   --admin_password=$WP_PASS
 	   
 	if [[  $WP_SSL == 'true'  ]]; then wp --allow-root option set siteurl https://$WP_URL; fi 	
		
	# ------------------------
	# WP THEME
	# ------------------------
	
	wp --allow-root rewrite structure '/%postname%/'
	wp --allow-root theme install "https://dl.dropboxusercontent.com/s/uchou7x8a5sdwvh/Sprocket%20Responsive%20WordPress%20Theme.zip?dl=1&token_hash=AAHMw2sKVNJ0FEzwI5dEZYw-BSycyaZyNV48K84MdcoMww" --activate	
	wp --allow-root option update tt_options --format=json '{"logo_url":"//s3.tropicloud.net/logo/logo-white-40px.png","site-link-color":"#23b4ea","header-background-color":"#333333","header-background-image":"//s3.tropicloud.net/wps-cli/img/slide-home.jpg","header-link-color":"#ffffff"}'
	wp --allow-root post meta update 2 header_image "//s3.tropicloud.net/wps-cli/img/slide-vantagens.jpg"

	# ------------------------
	# SSL CERT.
	# ------------------------

	cd /app/ssl
	
	cat $WPS/conf/nginx/openssl.conf | sed "s/localhost/$WP_URL/g" > openssl.conf
	openssl req -nodes -sha256 -newkey rsa:2048 -keyout app.key -out app.csr -config openssl.conf -batch
	openssl rsa -in app.key -out app.key
	openssl x509 -req -days 365 -in app.csr -signkey app.key -out app.crt	
	rm -f openssl.conf
	
	# ------------------------
	# FIX PERMISSIONS
	# ------------------------

	chown nginx:nginx -R /app/wordpress && chmod 755 -R /app/wordpress
	chown nginx:nginx /app/wp-config.php && chmod 755 /app/wp-config.php
	
}