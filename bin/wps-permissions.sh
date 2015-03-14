function wps_permissions() {

	# ------------------------
	# FIX PERMISSIONS
	# ------------------------

	chown wpstack:nginx -R $home && chmod 755 -R $home
	chown wpstack:nginx -R $home/wp && chmod 775 -R $home/wp
	chown wpstack:nginx $home/wp-config.php && chmod 770 $home/wp-config.php
	
}
