function wps_setup() {
	
	chmod +x /usr/local/wps/wp-stack
	ln -s /usr/local/wps/wp-stack /usr/local/bin/wps
	
	rm -rf /app/*
	mkdir -p /app/wp
	mkdir -p /app/ssl
	
 	cat $wps/conf/nginx/wordpress.conf > /etc/nginx/conf.d/default.conf
	cat $wps/conf/nginx/wpsecure.conf > /etc/nginx/wpsecure.conf
	cat $wps/conf/nginx/wpsupercache.conf > /etc/nginx/wpsupercache.conf
	
}