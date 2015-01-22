<?php

$db = parse_url($_SERVER["DATABASE_URL"]);

print_r(parse_url($db));
echo parse_url($db, PHP_URL_PATH);

?>
