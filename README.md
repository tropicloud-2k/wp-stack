<img src="http://assets.tropicloud.net/wpstack/logo-wpstack-light.png" width="240" border="0" style="display: block; max-width:100%;">

WP-STACK is a minimal WordPress stack for Docker and [Dokku](https://github.com/progrium/dokku).

Features
-------------
* NGINX + PHP-FPM
* SSL/SPDY support
* Web App Firewall (WAF)
* WP-CLI Command line tool
* Amazon S3 backups (soon)
* Import/Export sites (soon)

Deploying with Docker
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
docker run --name wpstack --link mariadb:db \
-e WP_USER="username" \
-e WP_PASS="password" \
-e WP_MAIL="user@example.com" \
-e WP_DOMAIN="example.com" \
-p 80:80 -p 443:443 -d tropicloud/wp-stack
```

Now visit [http://example.com](#) to check the installation.


Deploying with Dokku
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
