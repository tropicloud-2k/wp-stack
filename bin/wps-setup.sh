function wps_setup() {
	
	# ------------------------
	# App link
	# ------------------------

	chmod +x /usr/local/wps/wp-stack && ln -s /usr/local/wps/wp-stack /usr/local/bin/wps
	
	# ------------------------
	# Chroot user
	# ------------------------
	
	if [[  -d /app  ]]; then rm -rf /app; fi
	useradd -g nginx -d $home -s /bin/false wpstack
	
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
 	cat $wps/conf/nginx/wp.conf 				> /etc/nginx/conf.d/default.conf

	# ------------------------
	# Permissions
	# ------------------------

	chown -R root:root $home
	chmod 750 $home
	
	chown -R wpstack:nginx $home/wp
	chmod 750 -R $home/wp
	
}