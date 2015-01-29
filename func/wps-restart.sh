# ------------------------
# WPS RESTART
# ------------------------

function wps_restart() {

echo "var1: $1"
echo "var2: $2"
echo "var2: $3"

	if [[  -z $3  ]];
	then /usr/bin/supervisorctl restart all
	else /usr/bin/supervisorctl restart $3
	fi
	
}