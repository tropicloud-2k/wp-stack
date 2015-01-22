#!/usr/bin/env bash

export DB_URL=${DATABASE_URL}
 
# Execute the commands passed to this script
# e.g. "./env.sh venv/bin/nosetests --with-xunit
exec "$@"