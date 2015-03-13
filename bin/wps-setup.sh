function wps_setup() {
	
	# ------------------------
	# App link
	# ------------------------

	chmod +x /usr/local/wps/wp-stack && ln -s /usr/local/wps/wp-stack /usr/local/bin/wps
	
	# ------------------------
	# Chroot user
	# ------------------------
	
	useradd -g nginx -d $home -s /bin/false wpstack
	chown root:root $home && chmod 750 $home
	
	mkdir -p $home/log
	mkdir -p $home/ssl
	mkdir -p $home/wp
	
	# ------------------------
	# Config files
	# ------------------------

 	cat $wps/conf/supervisor/supervisord.conf	> /etc/supervisord.conf
	cat $wps/conf/nginx/nginx.conf				> /etc/nginx/nginx.conf
 	cat $wps/conf/nginx/wpsecure.conf			> /etc/nginx/wpsecure.conf
	cat $wps/conf/nginx/wpsupercache.conf		> /etc/nginx/wpsupercache.conf
	cat $wps/conf/nginx/block.conf				> /etc/nginx/block.conf
	cat $wps/conf/nginx/drop.conf				> /etc/nginx/drop.conf
	cat $wps/conf/nginx/errorpages.conf			> /etc/nginx/errorpages.conf
 	cat $wps/conf/nginx/wp.conf 				> /app/app.conf

	# ------------------------
	# Permissions
	# ------------------------

	chown -R wpstack:nginx $home/wp
	chown -R wpstack:nginx /var/log/
	chown -R wpstack:nginx /var/cache/

	chmod 770 -R $home/wp
	chmod 770 -R /var/log/
	chmod 770 -R /var/cache/
	
}