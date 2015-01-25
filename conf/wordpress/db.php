<?php

$database_url = parse_url(exec('cat /etc/environment | grep DATABASE_URL | cut -d= -f2'));

$db_name = trim($database_url['path'],'/'));
$db_user = $database_url['user']);
$db_pass = $database_url['pass']);
$db_host = $database_url['host'].':'.$database_url['port']);

echo "DB_NAME: $db_name";
echo "DB_USER: $db_user";
echo "DB_PASS: $db_pass";
echo "DB_HOST: $db_host";

?>
