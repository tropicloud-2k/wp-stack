<?php

$database_url = parse_url(exec('cat /etc/environment | grep DATABASE_URL | cut -d= -f2'));

print_r(parse_url($database_url));

echo parse_url($database_url, PHP_URL_PATH);

?>
