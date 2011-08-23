<?php
/**
 * In dieser Datei werden die Grundeinstellungen für WordPress vorgenommen.
 *
 * Zu diesen Einstellungen gehören: MySQL-Zugangsdaten, Tabellenpräfix,
 * Secret-Keys, Sprache und ABSPATH. Mehr Informationen zur wp-config.php gibt es auf der {@link http://codex.wordpress.org/Editing_wp-config.php
 * wp-config.php editieren} Seite im Codex. Die Informationen für die MySQL-Datenbank bekommst du von deinem Webhoster.
 *
 * Diese Datei wird von der wp-config.php-Erzeugungsroutine verwendet. Sie wird ausgeführt, wenn noch keine wp-config.php (aber eine wp-config-sample.php) vorhanden ist,
 * und die Installationsroutine (/wp-admin/install.php) aufgerufen wird.
 * Man kann aber auch direkt in dieser Datei alle Eingaben vornehmen und sie von wp-config-sample.php in wp-config.php umbenennen und die Installation starten.
 *
 * @package WordPress
 */

/**  MySQL Einstellungen - diese Angaben bekommst du von deinem Webhoster. */
/**  Ersetze database_name_here mit dem Namen der Datenbank, die du verwenden möchtest. */
define('DB_NAME', 'hybreb_ios');

/** Ersetze username_here mit deinem MySQL-Datenbank-Benutzernamen */
define('DB_USER', 'hybreb_ios');

/** Ersetze password_here mit deinem MySQL-Passwort */
define('DB_PASSWORD', 'hybreb_ios');

/** Ersetze localhost mit der MySQL-Serveradresse */
define('DB_HOST', 'localhost');

/** Der Datenbankzeichensatz der beim Erstellen der Datenbanktabellen verwendet werden soll */
define('DB_CHARSET', 'utf8');

/** Der collate type sollte nicht geändert werden */
define('DB_COLLATE', '');

/**#@+
 * Sicherheitsschlüssel
 *
 * Ändere jeden KEY in eine beliebige, möglichst einzigartige Phrase. 
 * Auf der Seite {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service} kannst du dir alle KEYS generieren lassen.
 * Bitte trage für jeden KEY eine eigene Phrase ein. Du kannst die Schlüssel jederzeit wieder ändern, alle angemeldeten Benutzer müssen sich danach erneut anmelden.
 *
 * @seit 2.6.0
 */
define('AUTH_KEY',         'i-I@wS+,{?Vq}J#MZKty9V`2P)tizK$h-bP0p3+3,z,DD%-U%o- %TzA}9;bo$XZ');
define('SECURE_AUTH_KEY',  'vW rgpO1A|+~4|CV + `-#A[Cy[{Dbz&7`}FJ:J>Q$o^jn{v1.]YXg_I)RQw1xCz');
define('LOGGED_IN_KEY',    '-iFt/{+byjg9+[G`_nx5 W<vQTPXtvqY46A!+~ZP+,s,9(pC-^[j&q-+og4;AQ.0');
define('NONCE_KEY',        ']A(lVTL3ST{if8mluiS>+}y?T) gN1YUo6 )Mhu2t@0|k|_]0_IOpa4S+=9Wb$Bm');
define('AUTH_SALT',        'r6u2P_K/.96k_rn@C()x2wd7jWl]%!~-~yj1~Uo27z.B(VQV2s-gs}(qK^fxg>5R');
define('SECURE_AUTH_SALT', 'RhwjlhM-hg,id gk~{L5].KmRiA95W9(C506GO>hg^R|>d-(ji_a}Am Q}H?7o r');
define('LOGGED_IN_SALT',   'z-yl>`$}tH*x::][@3qDhujn<olOY5(UIy=s<A,0Tz.S^{GLnVH%jys#H&8;8b98');
define('NONCE_SALT',       'sF[~@]?*%W#DDx+-lU 9QWZi`&l7WmqTcAH}GEEDn-~g=P(Y@$ `sj?<)RiPW zb');

/**#@-*/

/**
 * WordPress Datenbanktabellen-Präfix
 *
 *  Wenn du verschiedene Präfixe benutzt, kannst du innerhalb einer Datenbank
 *  verschiedene WordPress-Installationen betreiben. Nur Zahlen, Buchstaben und Unterstriche bitte!
 */
$table_prefix  = 'wp_';

/**
 * WordPress Sprachdatei
 *
 * Hier kannst du einstellen, welche Sprachdatei benutzt werden soll. Die entsprechende
 * Sprachdatei muss im Ordner wp-content/languages vorhanden sein, beispielsweise de_DE.mo
 * Wenn du nichts einträgst, wird Englisch genommen.
 */
define('WPLANG', 'de_DE');

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 */
define('WP_DEBUG', true);

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');