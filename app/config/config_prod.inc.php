<?php

use RedBean_Facade as R;

if($env == 'production'){
    R::setup('mysql:host=127.0.0.1;dbname=AddYourDBNameHere','AddYourDBUser','AddYourDBPass');
    R::freeze();
}

$app->configureMode('production', function () use ($app) {
    $app->config(array(
        'log.enabled'          => true,
        'debug'                => false,
        'display_debug_toolbar'=> false,
        'cache'                => realpath('../tmp/cache'),
        // assets
        'static_url'           => "/",
        'media_url'            => "/",
        // after this date, switch to the game home page
        'launching_date'       => "2010-01-01T10:00:00"
    ));

});

// EOF
