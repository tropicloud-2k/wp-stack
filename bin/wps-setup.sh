function wps_setup() {
	
	chmod +x /usr/local/wps/wp-stack
	ln -s /usr/local/wps/wp-stack /usr/local/bin/wps
	
	# ------------------------
	# cerate chroot user
	# ------------------------
	
	useradd -g nginx -d $home -s /bin/false wpstack
	chown root:root $home
	chmod 755 $home
	
	chown wpstack:nginx /var/log/nginx
	chown wpstack:nginx /var/log/php-fpm
	
	# ------------------------
	# config files
	# ------------------------

	cat $wps/conf/supervisor/supervisord.conf > /etc/supervisord.conf
 	cat $wps/conf/nginx/wordpress.conf > /etc/nginx/conf.d/default.conf
	cat $wps/conf/nginx/wpsecure.conf > /etc/nginx/wpsecure.conf
	cat $wps/conf/nginx/wpsupercache.conf > /etc/nginx/wpsupercache.conf
	
}