# ------------------------
# WPS START
# ------------------------

function wps_start() {

	wps_environment

	if [[  -f /tmp/supervisord.pid  ]]; then
	
		if [[  -z $2  ]];
		then /usr/bin/supervisorctl start all;
		else /usr/bin/supervisorctl start $2;
		fi
		
	else
	
		if [[  ! -f '/var/log/php-fpm.log'  ]]; then touch /var/log/php-fpm.log; fi
		if [[  ! -f '/var/log/nginx.log'  ]]; then touch /var/log/nginx.log; fi
		if [[  ! -f '/app/wp-config.php'  ]]; then wps_setup; fi
		
		exec /usr/bin/supervisord -n -c /etc/supervisord.conf
	
	fi

}
