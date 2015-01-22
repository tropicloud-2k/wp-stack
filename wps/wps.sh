#!/usr/bin/env bash

# ------------------------
# Tropicloud's WP-STACK
# ------------------------
# @author: Guigo (guigo.pw)
# version: 0.1
# ------------------------

# DB_HOST=$( echo $DATABASE_URL | grep -o @.* | cut -d: -f1 | cut -d@ -f2 )
# DB_PORT=$( echo $DATABASE_URL | grep -o @.* | cut -d: -f2 | cut -d/ -f1 )
# DB_NAME=$( echo $DATABASE_URL | grep -o @.* | cut -d/ -f2 )
# DB_USER=$( echo $DATABASE_URL | cut -d: -f2 | sed 's|//||g' )
# DB_PASS=$( echo $DATABASE_URL | cut -d: -f3 | cut -d@ -f1 )

# load functions
for f in /usr/local/wps/func/*; do . $f; done

# ------------------------
# WP-STACK Functions
# ------------------------

  if [[  ${1} == 'setup'  ]];	then wps_setup
elif [[  ${1} == 'start'  ]];	then wps_start
elif [[  ${1} == 'stop'  ]];	then wps_stop

# ------------------------
# WP-STACK Commands
# ------------------------

else echo "
----------------------------------------------------
  WP-STACK  - www.tropicloud.net
----------------------------------------------------  

  HOW TO USE:
  
  wps info <hostname>
  wps create --hostname=<hostname>
  wps destroy -c --confirm <hostname>
  wps add <hostname>
  wps drop <hostname>
  wps import <hostname>
  wps export <hostname>
  wps backup <hostname> --all
  wps dbprefix
  wps image

----------------------------------------------------  

"
fi
