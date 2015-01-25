<?php

$database_url = parse_url($_ENV['DATABASE_URL']);

print_r(parse_url($database_url));

echo parse_url($database_url, PHP_URL_PATH);

?>
