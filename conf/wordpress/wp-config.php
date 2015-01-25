<?php

// ** WP Keys ** //
define('AUTH_KEY',         'unique phrase here');
define('SECURE_AUTH_KEY',  'unique phrase here');
define('LOGGED_IN_KEY',    'unique phrase here');
define('NONCE_KEY',        'unique phrase here');
define('AUTH_SALT',        'unique phrase here');
define('SECURE_AUTH_SALT', 'unique phrase here');
define('LOGGED_IN_SALT',   'unique phrase here');
define('NONCE_SALT',       'unique phrase here');

// ** MariaDB ** //
$database_url = parse_url(exec('cat /etc/environment | grep DATABASE_URL | cut -d= -f2'));
$table_prefix = 'wp_';

define('DB_NAME', trim($database_url['path'],'/'));
define('DB_USER', $database_url['user']);
define('DB_PASSWORD', $database_url['pass']);
define('DB_HOST', $database_url['host'].':'.$database_url['port']);
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

// ** WP Cache ** //
define('WPCACHEHOME', '/app/wordpress/wp-content/plugins/wp-super-cache/');
define('WP_CACHE', true);

// ** WP SSL ** //
//define('FORCE_SSL_LOGIN', true);
//define('FORCE_SSL_ADMIN', true);
define('DISALLOW_FILE_EDIT', true);



/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
