<?php
namespace app\routes;
use RedBean_Facade as R;
#use Mandrill;

# -----------------------------------------------------------------------------
#
#    CASE API
#
# -----------------------------------------------------------------------------
$app->get("/api/case", function() use ($app) {
        /**
         * Load case & archive data.
         */

        // cache on production
        if( $app->getMode() != "development" ) {
                $app->etag('api-case');
                $app->expires('+30 seconds');
        }

        if (!isset($case)) {
                $dir = 'data/archives';

                foreach (glob($dir . '/*.json') as $file) {
                        $content = file_get_contents($file);
                        $archive = json_decode($content, true);
                }
        }
        return ok($archive);

});

// EOF
