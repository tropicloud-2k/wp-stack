#!/usr/bin/env bash

# ------------------------
# Tropicloud's WP-STACK
# ------------------------
# @author: Guigo (guigo.pw)
# version: 0.1
# ------------------------

wps='/usr/local/wps'

# ------------------------
# WP-STACK Functions
# ------------------------

for f in /usr/local/wps/_func/*; do . $f; done

  if [[  $1 == 'setup'  ]]; then wps_setup
elif [[  $1 == 'start'  ]]; then wps_start
elif [[  $1 == 'stop'   ]]; then wps_stop

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
