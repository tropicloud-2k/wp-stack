# ------------------------
# WPS START
# ------------------------

function wps_start() {

# 	if [[  ! -f '/tmp/supervisor.sock'  ]]; then touch /tmp/supervisor.sock; fi
	if [[  ! -f '/var/log/php-fpm.log'  ]]; then touch /var/log/php-fpm.log; fi
	if [[  ! -f '/var/log/nginx.log'    ]]; then touch /var/log/nginx.log; fi
	if [[  ! -f '/app/wp-config.php'    ]]; then

		# ------------------------
		# WP INSTALL
		# ------------------------
		
		mkdir -p /etc/wps/env
		env | grep 'DATABASE_URL'.* | cut -d= -f2 > /etc/wps/env/database_url
		
		mkdir -p /app/wordpress
		cd /app/wordpress
		
		wp --allow-root core download
		
		if [ ! $? -eq 0 ]; then 
			wget https://wordpress.org/latest.zip
			unzip *.zip && rm -f *.zip
			mv wordpress/* $(pwd)
			rm -rf wordpress
		fi
		
		cat /usr/local/wps/conf/wordpress/wp-config.php > /app/wp-config.php
		cat /usr/local/wps/conf/wordpress/db.php > /app/wordpress/db.php
	
 	 	chown nginx:nginx -R /app/wordpress
 	 	chown nginx:nginx /app/wp-config.php
  	 	chmod 755 -R /app/wordpress
 	 	chmod 755 /app/wp-config.php
	 	
	fi
	
	/usr/bin/supervisord -n -c /etc/supervisord.conf
	
}