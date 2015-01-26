# ------------------------
# WPS START
# ------------------------

function wps_start() {

	database_url

	if [[  ! -f '/var/log/php-fpm.log'  ]]; then touch /var/log/php-fpm.log; fi
	if [[  ! -f '/var/log/nginx.log'    ]]; then touch /var/log/nginx.log; fi
	if [[  ! -f '/app/wp-config.php'    ]]; then wps_setup; fi
	
	/usr/bin/supervisord -n -c /etc/supervisord.conf
	
}