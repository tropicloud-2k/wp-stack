# ------------------------
# WPS STOP
# ------------------------

function wps_stop() {

	if [[  -z $2  ]];
	then /usr/bin/supervisorctl stop all;
	else /usr/bin/supervisorctl stop $2;
	fi
	
}