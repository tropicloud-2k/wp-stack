# ------------------------
# WPS START
# ------------------------

function wps_start() {

	cd $wps

	if [[  ! -f '/var/log/php-fpm.log'  ]]; then touch /var/log/php-fpm.log; fi
	if [[  ! -f '/var/log/nginx.log'    ]]; then touch /var/log/nginx.log; fi
	if [[  ! -f '/app/wp-config.php'    ]]; then
		
		# ------------------------
		# DATABASE URL
		# ------------------------

 		mkdir -p /etc/wps/env
 		env > /etc/wps/env.sh
 		env | grep 'DATABASE_URL'.* | cut -d= -f2 > /etc/wps/env/DATABASE_URL
		
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
		
		cat $wps/conf/wordpress/wp-config.php > /app/wp-config.php
		cat $wps/conf/wordpress/db.php > /app/wordpress/db.php
	
		# ------------------------
		# SSL CERT.
		# ------------------------
		
		mkdir -p /app/ssl
		cd /app/ssl
		
		cat $wps/conf/nginx/openssl.conf | sed "s/localhost/*.cloudapp.ml/g" > openssl.conf

		openssl req -nodes -sha256 -newkey rsa:2048 -keyout app.key -out app.csr -config openssl.conf -batch
		openssl rsa -in app.key -out app.key
		openssl x509 -req -days 365 -in app.csr -signkey app.key -out app.crt
		
		rm -f openssl.conf

 	 	# ------------------------
 	 	# FIX PERMISSIONS
 	 	# ------------------------
 	 	
 	 	chown nginx:nginx -R /app/wordpress && chmod 755 -R /app/wordpress
 	 	chown nginx:nginx /app/wp-config.php && chmod 755 /app/wp-config.php
	 	
	fi
	
	# ------------------------
	# START UP!
	# ------------------------

	/usr/bin/supervisord -n -c /etc/supervisord.conf
	
}