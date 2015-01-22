<?php

// ** WP Keys ** //
define('AUTH_KEY',         '&<CF0(WcE%2mF7/o(_kT9mA{++ %P-k&=][UuEZ^~>/O<sl>.TM0>sL]>cuduaBe');
define('SECURE_AUTH_KEY',  '/sD43~)mf/!SlKzbpnZA,R/r|mb/ep}^%&SlqS3#JEo-//+8)}4eOr[pPP4wPQrx');
define('LOGGED_IN_KEY',    'Y--;AdM];6k`i}92+*|hW_F5YG|#S|Ta|3C,N9&@j@DsA>a{:y=(_0_B?0n{OQbw');
define('NONCE_KEY',        '=Q|PlQ2cGSDrd5SE*uzq4$3)_d#yyTU7gvenyox4>6kSli!zXWg=XLV|WXT1v9.|');
define('AUTH_SALT',        'R(vmIz`-li2QKZ_gdYDJ@Kj $e#-x9=oSB)c:r[N8cVrx|w~ZOAw|62{B%fV;}4H');
define('SECURE_AUTH_SALT', 'I(c#a2+%#c1t~KT]CgWTD$X^YEOP9S@*V O]is$8R^QF~8Kc|!a!|Ngj!Ftx#b$r');
define('LOGGED_IN_SALT',   'mcb3 s46r&)r@uBMXjLS#:*BMO[WZr8I|w+}2{%~uR|uw|veuijkq.8zaoCfj#j_');
define('NONCE_SALT',       '^LKVxF%v.P1O8Ru{TCNx>_2~=(tTeu3pn`&;_Yk@jG-WI{_0K;H :!Oh}!PV z1z');

// ** MySQL DB ** //
$database_url = parse_url($_ENV['DATABASE_URL']);
$table_prefix = 'wp_';

define('DB_NAME', trim($database_url['path'],'/'));
define('DB_USER', $database_url['user']);
define('DB_PASSWORD', $database_url['pass']);
define('DB_HOST', $database_url['host'].':'.$database_url['port']);
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');


// ** WP Super Cache ** //
define('WPCACHEHOME', '/app/wordpress/wp-content/plugins/wp-super-cache/');
define('WP_CACHE', true);

// ** WP SSL ** //
define('FORCE_SSL_LOGIN', true);
define('FORCE_SSL_ADMIN', true);
define('DISALLOW_FILE_EDIT', true);


/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
