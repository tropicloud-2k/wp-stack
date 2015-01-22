# ------------------------
# ENV
# ------------------------

DB_HOST=$( echo $DATABASE_URL | grep -o @.* | cut -d: -f1 | cut -d@ -f2 )
DB_PORT=$( echo $DATABASE_URL | grep -o @.* | cut -d: -f2 | cut -d/ -f1 )
DB_NAME=$( echo $DATABASE_URL | grep -o @.* | cut -d/ -f2 )
DB_USER=$( echo $DATABASE_URL | cut -d: -f2 | sed 's|//||g' )
DB_PASS=$( echo $DATABASE_URL | cut -d: -f3 | cut -d@ -f1 )
