function wps_db_url() {
	
	if [[  -z $DATABASE_URL  ]]; then

		DB_HOST=$(env | grep -o 'MARIADB_PORT_3306_TCP_ADDR'.* | cut -d= -f2)
		DB_PORT=$(env | grep -o 'MARIADB_PORT_3306_TCP_PORT'.* | cut -d= -f2)
		DB_NAME=$(env | grep -o 'MARIADB_ENV_MYSQL_DATABASE'.* | cut -d= -f2)
		DB_USER=$(env | grep -o 'MARIADB_ENV_MYSQL_USER'.* | cut -d= -f2)
		DB_PASS=$(env | grep -o 'MARIADB_ENV_MYSQL_PASSWORD'.* | cut -d= -f2)
		DB_PROT=$(env | grep -o 'MARIADB_PORT_3306_TCP_PROTO'.* | cut -d= -f2)
		
		export DATABASE_URL=${DB_PROT}://${DB_USER}:${DB_PASS}@${DB_HOST}:${DB_PORT}/${DB_NAME}

	else

		DB_HOST=$(env | grep -o 'DATABASE_URL'.* | cut -d@ -f2 | cut -d: -f1)
		DB_PORT=$(env | grep -o 'DATABASE_URL'.* | cut -d@ -f2 | cut -d: -f2 | cut -d/ -f1)
		DB_NAME=$(env | grep -o 'DATABASE_URL'.* | cut -d@ -f2 | cut -d\/ -f2)
		DB_USER=$(env | grep -o 'DATABASE_URL'.* | cut -d: -f2 | sed 's|//||g')
		DB_PASS=$(env | grep -o 'DATABASE_URL'.* | cut -d: -f3 | cut -d@ -f1)

	fi
	
}