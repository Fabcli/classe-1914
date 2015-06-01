<?php

namespace app;

//Load app autoloader
require_once __DIR__ . '/autoload.php';

//Load environment config
require_once __DIR__ . '/config/config_dev.inc.php';
require_once __DIR__ . '/config/config_demo.inc.php';
require_once __DIR__ . '/config/config_prod.inc.php';

require_once __DIR__ . '/filters.php';

//Load routes
foreach (glob(__DIR__ . "/routes/*.php") as $filename)
{
    require $filename;
}

//EOF