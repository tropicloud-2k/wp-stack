# ------------------------
# nps START
# ------------------------

function nps_start() {

	cd $nps

	if [[  ! -f '/var/log/php-fpm.log'  ]]; then touch /var/log/php-fpm.log; fi
	if [[  ! -f '/var/log/nginx.log'    ]]; then touch /var/log/nginx.log; fi
	if [[  ! -f '/app/wp-config.php'    ]]; then nps_wp_install; fi
	
	/usr/bin/supervisord -n -c /etc/supervisord.conf
	
}