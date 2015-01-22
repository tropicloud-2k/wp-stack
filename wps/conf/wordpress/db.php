<?php

$database_url = exec('cat /app/env/database_url');
print_r(parse_url($database_url));
echo parse_url($database_url, PHP_URL_PATH);

?>
