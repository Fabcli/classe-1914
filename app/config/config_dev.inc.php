<?php

use RedBean_Facade as R;

if($env == 'development'){
    R::setup('sqlite:../db.sqlite', NULL, NULL);
}


$app->configureMode('development', function () use ($app) {
    $app->config(array(
            'log.enabled'          => true,
            'debug'                => true,
            'cache'                => false,
        // assets
            'static_url'           => "/",
            'media_url'           => "/medias",
        // after this date, switch to the game home page
            'launching_date'       => "2015-01-01T10:00:00"
    ));
});

// EOF