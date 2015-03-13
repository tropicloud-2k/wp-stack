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
	
		if [[  ! -f "/var/log/php-fpm.log"  ]]; then touch /var/log/php-fpm.log; fi
		if [[  ! -f "/var/log/nginx.log"  ]];   then touch /var/log/nginx.log; fi
		if [[  ! -f "$home/wp-config.php"  ]];  then wps_install; else wps_config; fi
		
		exec /usr/bin/supervisord -n -c /etc/supervisord.conf
	
	fi

}

# ------------------------
# WPS RESTART
# ------------------------

function wps_restart() {

	wps_environment

	if [[  -f /tmp/supervisord.pid  ]]; then
	
		if [[  -z $2  ]];
		then /usr/bin/supervisorctl restart all;
		else /usr/bin/supervisorctl restart $2;
		fi
	
	fi
}

# ------------------------
# WPS STOP
# ------------------------

function wps_stop() {

	if [[  -f /tmp/supervisord.pid  ]]; then
	
		if [[  -z $2  ]];
		then /usr/bin/supervisorctl stop all;
		else /usr/bin/supervisorctl stop $2;
		fi
	
	fi
}
