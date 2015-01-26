<img src="http://assets.tropicloud.net/wpstack/logo-wpstack-light.png" width="240" border="0" style="display: block; max-width:100%;">

WordPress stack for **Docker** and **Dokku-alt**.

----------


Deploy with Docker
-------------

#### Create a database
```shell
docker run --name mariadb \
-e MYSQL_ROOT_PASSWORD="password" \
-e MYSQL_USER="db_user" \
-e MYSQL_PASSWORD="db_pass" \
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
-e WP_USER="wp_user" \
-e WP_PASS="wp_pass" \
-e WP_MAIL="user@example.com" \
-e DOMAIN="wpstack.example.com" \
-p 80:80 -p 443:443 -d tropicloud/wp-stack
```

Now visit  [http://wpstack.example.com](#) to check the installation.


----------


Deploy with Dokku-alt
-------------

#### Create App on Dokku host
```shell
app="wpstack"
 
dokku create $app
dokku mariadb:create $app 
dokku mariadb:link $app $app
dokku config:set $app DOKKU_ENABLE_HTTP_HOST=1
dokku config:set $app \
  DOMAIN=$app.example.com \
  WP_USER=wp_user \
  WP_PASS=wp_pass \
  WP_MAIL=user@example.com
dokku config $app
```

#### Clone the repository
```shell
git clone https://github.com/tropicloud/wp-stack.git
cd wp-stack
```

#### Add Dokku remote
```shell
git remote add dokku@example.com:wpstack
```

#### Deploy the App
```shell
docker run --name wpstack --link mariadb:mariadb \
-e WP_USER="wp_user" \
-e WP_PASS="wp_pass" \
-e WP_MAIL="user@example.com" \
-e DOMAIN="wpstack.example.com" \
-p 80:80 -p 443:443 -d tropicloud/wp-stack
```

Now visit  [http://wpstack.example.com](#) to check the installation.
