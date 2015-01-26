<img src="http://assets.tropicloud.net/wpstack/logo-wpstack-light.png" width="240" border="0" style="display: block; max-width:100%;">

WordPress stack for **Docker** and **Dokku-alt**

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


Deploy with Dokku-alt
-------------

#### Create App on Dokku Host
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

#### Clone the Repo
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

Now visit  [http://wpstack.example.com](#) to check the installation.


SSL Support
-------------

#### Create wildcard SSL cert.
```shell
mkdir -p /var/ssl
 
curl -L http://git.io/kmRbDw | sed "s/localhost/*.example.com/g" > /var/ssl/openssl.conf
openssl req -nodes -sha256 -newkey rsa:2048 -keyout /var/ssl/server.key -out /var/ssl/server.csr -config /var/ssl/openssl.conf -batch
openssl rsa -in /var/ssl/server.key -out /var/ssl/server.key
openssl x509 -req -days 365 -in /var/ssl/server.csr -signkey /var/ssl/server.key -out /var/ssl/server.crt
``` 

#### Create App on Dokku Host
```shell
app="wpstack"

dokku create $app
dokku mariadb:create $app 
dokku mariadb:link $app $app
cat /var/ssl/server.crt | dokku ssl:certificate $app
cat /var/ssl/server.key | dokku ssl:key $app
dokku config:set $app \
  DOMAIN=$app.cloudapp.ml \
  SSL=true \
  WP_USER=wp_user \
  WP_PASS=wp_pass \
  WP_MAIL=user@example.com
dokku config $app
```

#### Clone the Repo
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
