function wps_setup() {
	
	chmod +x /usr/local/wps/wp-stack && ln -s /usr/local/wps/wp-stack /usr/local/bin/wps
	
	useradd -g nginx -d $home -s /bin/false wpstack
	chown root:root $home && chmod 755 $home
	
	mkdir -p $home/wp
	mkdir -p $home/ssl
	mkdir -p $home/log
	
	cat $wps/conf/nginx/wordpress.conf    > /etc/nginx/conf.d/default.conf
	cat $wps/conf/nginx/wpsecure.conf     > /etc/nginx/wpsecure.conf
	cat $wps/conf/nginx/wpsupercache.conf > /etc/nginx/wpsupercache.conf
	cat $wps/conf/html/index.html         > $home/wp/index.html
	
}