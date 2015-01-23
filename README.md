WP-STACK
==============
NGINX (v1.7.9) + PHP-FPM (v5.6.4) web stack for Docker.  
For database connection you may read:

* [Container Linking](https://docs.docker.com/userguide/dockerlinks/#docker-container-linking)
* [MariaDB](https://registry.hub.docker.com/_/mariadb/)

#### Build from GitHub
    git clone https://github.com/tropicloud/wp-stack.git && cd wp-stack
    docker build -t tropicloud/wp-stack .
    

or

#### Pull from Docker Hub
    docker pull tropicloud/wp-stack
    

then

#### Run the Docker image
    docker run -p 80:80 -p 443:443 \
    -v /usr/share/nginx/html \
    -d tropicloud/wp-stack 
    

Navigate to `http://<docker-host-ip>/` to check the installation.

#### Example Configuration
Make sure to build from GitHub or to include your own config files.

    docker run -p 80:80 -p 443:443 \
    -v /usr/share/nginx/html \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $(pwd)/conf/nginx/conf.d:/etc/nginx/conf.d:ro \
    -v $(pwd)/conf/nginx/nginx.conf:/etc/nginx/nginx.conf \
    -v $(pwd)/conf/php/php-fpm.conf:/etc/php-fpm.d/www.conf \
    -d tropicloud/wp-stack
    
   
#### Dokku

ln -s /usr ~/
ln -s /var ~/
ln -s /etc ~/
ln -s /home/dokku ~/

mkdir ~/ssl && cd ~/ssl

curl -s https://raw.githubusercontent.com/tropicloud/np-stack/master/conf/nginx/openssl.conf > openssl.conf
openssl req -nodes -sha256 -newkey rsa:2048 -keyout server.key -out server.csr -config openssl.conf -batch
openssl rsa -in server.key -out server.key
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt

app='wpstack'

dokku create $app
dokku mariadb:create $app
dokku mariadb:link $app $app
dokku config:set $app DOKKU_ENABLE_HTTP_HOST=1
dokku config $app

cp -R ~/ssl /home/dokku/${app}/ssl
