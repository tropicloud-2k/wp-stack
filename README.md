WP-STACK
==============
WordPress stack for Docker.  

* [NGINX 1.7.9](http://nginx.com)
* [PHP-FPM 5.6.4](http://php.net)
* [CentOS 7](http://www.centos.org)


#### Install Dokku-alt
   
    ln -s /home/dokku ~/
    ln -s /usr ~/
    ln -s /var ~/
    ln -s /etc ~/
    
    ssl="/var/ssl"
    mkdir -p $ssl
    
    curl -s https://raw.githubusercontent.com/tropicloud/np-stack/master/conf/nginx/openssl.conf \
    | sed "s/localhost/*.cloudapp.ml/g" > $ssl/openssl.conf
    
    openssl req -nodes -sha256 -newkey rsa:2048 -keyout $ssl/server.key -out $ssl/server.csr -config $ssl/openssl.conf -batch
    openssl rsa -in $ssl/server.key -out $ssl/server.key
    openssl x509 -req -days 365 -in $ssl/server.csr -signkey $ssl/server.key -out $ssl/server.crt
    
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/dokku-alt/dokku-alt/master/bootstrap.sh)" < /dev/null
    
    curl https://gist.githubusercontent.com/tropicloud/036560ca2f5f9d81945e/raw/9d668d978809ca751ceb47c04c07bbc44ce5e280/post-deploy > /var/lib/dokku-alt/plugins/nginx-vhosts/post-deploy
    dokku plugins-install
    dokku mariadb:create testdb && dokku mariadb:delete testdb


#### Deplay App 

    app="wpstack"
    
    dokku create $app
    dokku mariadb:create $app 
    dokku mariadb:link $app $app
    cat $ssl/server.crt | dokku ssl:certificate $app
    cat $ssl/server.key | dokku ssl:key $app
    dokku config:set $app WP_URL=$app.cloudapp.ml WP_SSL=true WP_USER=guigo2k WP_PASS=2532xd9f WP_MAIL=guigo2k@guigo2k.com
    dokku config $app
    
    dokku config:set $app DOKKU_ENABLE_HTTP_HOST=1


#### Delete App

    dokku delete $app && dokku mariadb:delete $app

