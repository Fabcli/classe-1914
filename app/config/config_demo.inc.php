<?php

use RedBean_Facade as R;

if($env == 'demo'){
        R::setup('sqlite:../db.sqlite', NULL, NULL);
}

$app->configureMode('demo', function () use ($app) {
        $app->config(array(
                'log.enabled'          => true,
                'debug'                => false,
                'display_debug_toolbar'=> false,
                'cache'                => false,
                // assets
                'static_url'           => "/",
                'media_url'           => "/medias/Demo_Col/medias",
                // after this date, switch to the game home page
                'launching_date'       => "2010-01-01T10:00:00"
        ));

});

// EOF
