# ------------------------
# WPS START
# ------------------------

function wps_start() {

	if [[  -f /tmp/supervisord.pid  ]]; then
		
		if [[  -z $2  ]];
		then /usr/bin/supervisorctl start all;
		else /usr/bin/supervisorctl start $2;
		fi
		
	else
	
		wps_environment
	
		if [[  ! -f '/var/log/php-fpm.log'  ]]; then touch /var/log/php-fpm.log; fi
		if [[  ! -f '/var/log/nginx.log'    ]]; then touch /var/log/nginx.log; fi
		if [[  ! -f '/app/wp-config.php'    ]]; then wps_setup; fi
		
		/usr/bin/supervisord -n -c /etc/supervisord.conf
	
	fi

}
