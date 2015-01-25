function wps_db_url() {
	
	DB_HOST=$(env | grep -o 'DATABASE_URL'.* | cut -d@ -f2 | cut -d: -f1)
	DB_PORT=$(env | grep -o 'DATABASE_URL'.* | cut -d@ -f2 | cut -d: -f2 | cut -d/ -f1)
	DB_NAME=$(env | grep -o 'DATABASE_URL'.* | cut -d@ -f2 | cut -d\/ -f2)
	DB_USER=$(env | grep -o 'DATABASE_URL'.* | cut -d: -f2 | sed 's|//||g')
	DB_PASS=$(env | grep -o 'DATABASE_URL'.* | cut -d: -f3 | cut -d@ -f1)
	
}