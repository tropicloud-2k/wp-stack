<img src="http://assets.tropicloud.net/wpstack/logo-wpstack-light.png" width="240" border="0" style="display: block; max-width:100%;">

WP-STACK is a minimal WordPress stack built for speed and portability. It is platform agnostic and will run on any machine with [Docker](http://docker.com) installed. It also plays nice with Docker orchestrators like [Deis](http://deis.io), [Panamax](http://panamax.io) and [Dokku-alt](https://github.com/dokku-alt/dokku-alt).

Features
-------------
* Environment built on CentOS 7
* NGINX web-server with PHP-FPM
* External MariaDB database
* Supervisor processes control
* WP-CLI command line tool
* WPS command line tool
* Performance optimisation
* WordPress SEO rewrite rules
* Amazon S3 backups (coming soon)
* NewRelic monitoring (coming soon)
* Import existing sites (coming soon)

Deploy with Docker
-------------

#### Create a database
```shell
docker run --name mariadb \
-e MYSQL_ROOT_PASSWORD="password" \
-e MYSQL_USER="username" \
-e MYSQL_PASSWORD="password" \
-e MYSQL_DATABASE="wpstack" \
-d mariadb
```

#### Build the Docker image
```shell
git clone https://github.com/tropicloud/wp-stack.git
docker build -t tropicloud/wp-stack wp-stack
```

#### Deploy the App
```shell
docker run --name wpstack --link mariadb:mariadb \
-e WP_USER="username" \
-e WP_PASS="password" \
-e WP_MAIL="user@example.com" \
-e WP_DOMAIN="example.com" \
-p 80:80 -p 443:443 -d tropicloud/wp-stack
```

Now visit [http://example.com](#) to check the installation.


Deploy with Dokku-alt
-------------

#### Create a new app on Dokku host
```shell
app="wpstack"

dokku create $app
dokku mariadb:create $app 
dokku mariadb:link $app $app
dokku config:set $app \
	WP_DOMAIN=example.com \
	WP_USER=username \
	WP_PASS=pasword \
	WP_MAIL=user@example.com
```

#### Clone the repo locally
```shell
git clone https://github.com/tropicloud/wp-stack.git
```

#### Add Dokku remote
```shell
cd wp-stack
git remote add dokku@example.com:wpstack
```

#### Deploy the App
```shell
git push dokku master
```

Now visit [http://wpstack.example.com](#) to check the installation.


Dokku-alt SSL suport
-------------

#### Create a wildcard SSL certificate
```shell
mkdir -p /var/ssl
 
curl -L http://git.io/kmRbDw | sed "s/localhost/example.com/g" > /var/ssl/openssl.conf
openssl req -nodes -sha256 -newkey rsa:2048 -keyout /var/ssl/server.key -out /var/ssl/server.csr -config /var/ssl/openssl.conf -batch
openssl rsa -in /var/ssl/server.key -out /var/ssl/server.key
openssl x509 -req -days 365 -in /var/ssl/server.csr -signkey /var/ssl/server.key -out /var/ssl/server.crt
``` 

#### Apply Dokku-alt SSL fix
```
curl -L http://git.io/0V6vUA > /var/lib/dokku-alt/plugins/nginx-vhosts/post-deploy
dokku plugins-install
```

#### Create a new app on Dokku host
```shell
app="wpstack"
dokku create $app
dokku mariadb:create $app 
dokku mariadb:link $app $app
cat /var/ssl/server.crt | dokku ssl:certificate $app
cat /var/ssl/server.key | dokku ssl:key $app
dokku config:set $app \
  WP_DOMAIN=example.com \
  WP_SSL=true \
  WP_USER=username \
  WP_PASS=password \
  WP_MAIL=user@example.com
```

#### Clone the repo locally
```shell
git clone https://github.com/tropicloud/wp-stack.git
```

#### Add the Dokku remote locally
```shell
cd wp-stack
git remote add dokku@example.com:wpstack
```

#### Deploy the App
```shell
git push dokku master
```

Now visit [http://wpstack.example.com](#) to check the installation.

dorium dorium