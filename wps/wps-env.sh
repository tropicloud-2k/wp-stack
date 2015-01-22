# ------------------------
# ENV
# ------------------------

# DB_HOST=$(env | grep -o 'MARIADB_PORT_3306_TCP_ADDR'.* | cut -d= -f2)
# DB_PORT=$(env | grep -o 'MARIADB_PORT_3306_TCP_PORT'.* | cut -d= -f2)

DB_HOST=$(echo $DATABASE_URL | grep -o @.* | cut -d: -f1 | sed 's/@//g')
DB_PORT=$(echo $DATABASE_URL | grep -o @.* | cut -d: -f2 | cut -d/ -f1 )

DB_NAME=$(env | grep -o 'DATABASE_URL'.* | cut -d@ -f2 | cut -d\/ -f2)
DB_USER=$(env | grep -o 'DATABASE_URL'.* | cut -d: -f2 | sed 's|//||g')
DB_PASS=$(env | grep -o 'DATABASE_URL'.* | cut -d: -f3 | cut -d@ -f1)

