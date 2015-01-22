# ------------------------
# WPS START
# ------------------------

function wps_start() {

	env > /etc/env
	
	if [[  ! -f '/app/wp-config.php'  ]]; then wps setup; fi
	if [[  ! -f '/var/log/nginx.log'  ]]; then touch /var/log/nginx.log; fi
	if [[  ! -f '/var/log/php-fpm.log'  ]]; then touch /var/log/php-fpm.log; fi
	if [[  ! -f '/tmp/supervisor.sock'  ]]; then touch /tmp/supervisor.sock; fi
	
	/usr/bin/supervisord -n -c /etc/supervisord.conf
	
}