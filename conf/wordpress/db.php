<?php

$database_url = parse_url(exec('cat /etc/environment | grep DATABASE_URL | cut -d= -f2'));

print_r($database_url);

$db_name = trim($database_url['path'],'/'));
echo $db_name;

?>
