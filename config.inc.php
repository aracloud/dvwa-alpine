<?php

# Database management system
$DBMS = 'MySQL';

# Database variables
$_DVWA = array();
$_DVWA[ 'db_server' ]   = '127.0.0.1';
$_DVWA[ 'db_database' ] = 'dvwa';
$_DVWA[ 'db_user' ]     = 'root';
$_DVWA[ 'db_password' ] = 'password';
$_DVWA[ 'db_port' ]     = '3306';

# ReCAPTCHA settings
$_DVWA[ 'recaptcha_public_key' ]  = '';
$_DVWA[ 'recaptcha_private_key' ] = '';

# Default security level
$_DVWA[ 'default_security_level' ] = 'low';

# Default locale
$_DVWA[ 'default_locale' ] = 'en';

# Disable authentication
$_DVWA[ 'disable_authentication' ] = false;

# SQLi database backends
define ('MYSQL', 'mysql');
define ('SQLITE', 'sqlite');

# SQLi DB Backend
$_DVWA['SQLI_DB'] = MYSQL;

?>