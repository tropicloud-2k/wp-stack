# ------------------------
# WPS RESTART
# ------------------------

function wps_restart() {

	if [[  -z $2  ]];
	then /usr/bin/supervisorctl restart all;
	else /usr/bin/supervisorctl restart $2;
	fi
	
}