<?php

$database_url = parse_url($_ENV['cat /etc/environment | grep DATABASE_URL | cut -d= -f2']);

print_r(parse_url($database_url));

?>
