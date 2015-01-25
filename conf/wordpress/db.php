<?php

$database_url = exec('cat /etc/wps/env/DATABASE_URL');
print_r(parse_url($database_url));
echo parse_url($database_url, PHP_URL_PATH);

?>
