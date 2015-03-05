function wps_environment() {
	
	# ------------------------
	# DATABASE URL
	# ------------------------
	
	if [[  -z $DATABASE_URL  ]]; then

		DB_HOST=$(env | grep 'MARIADB_PORT_3306_TCP_ADDR' | cut -d= -f2)
		DB_PORT=$(env | grep 'MARIADB_PORT_3306_TCP_PORT' | cut -d= -f2)
		DB_NAME=$(env | grep 'MARIADB_ENV_MYSQL_DATABASE' | cut -d= -f2)
		DB_USER=$(env | grep 'MARIADB_ENV_MYSQL_USER' | cut -d= -f2)
		DB_PASS=$(env | grep 'MARIADB_ENV_MYSQL_PASSWORD' | cut -d= -f2)
		DB_PROT=$(env | grep 'MARIADB_PORT_3306_TCP_PROTO' | cut -d= -f2)
		
		export DATABASE_URL=${DB_PROT}://${DB_USER}:${DB_PASS}@${DB_HOST}:${DB_PORT}/${DB_NAME}

		export DB_HOST=$DB_HOST
		export DB_PORT=$DB_PORT
		export DB_NAME=$DB_NAME
		export DB_USER=$DB_USER
		export DB_PASS=$DB_PASS
		export DB_PROT=$DB_PROT

	else

		DB_HOST=$(env | grep 'DATABASE_URL' | cut -d@ -f2 | cut -d: -f1)
		DB_PORT=$(env | grep 'DATABASE_URL' | cut -d@ -f2 | cut -d: -f2 | cut -d/ -f1)
		DB_NAME=$(env | grep 'DATABASE_URL' | cut -d@ -f2 | cut -d\/ -f2)
		DB_USER=$(env | grep 'DATABASE_URL' | cut -d: -f2 | sed 's|//||g')
		DB_PASS=$(env | grep 'DATABASE_URL' | cut -d: -f3 | cut -d@ -f1)
	
		export DB_HOST=$DB_HOST
		export DB_PORT=$DB_PORT
		export DB_NAME=$DB_NAME
		export DB_USER=$DB_USER
		export DB_PASS=$DB_PASS

	fi

	# ------------------------
	# ENV. SETUP
	# ------------------------

	echo "" > /etc/environment
	env | grep = >> /etc/environment

	mkdir -p /etc/env
	rm -f /etc/env/*

	for var in $(cat /etc/environment); do 
		key=$(echo $var | cut -d= -f1)
		val=$(echo $var | cut -d= -f2)
		echo -ne $val > /etc/env/${key}
	done
	
}