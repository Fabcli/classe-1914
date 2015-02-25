<?php

namespace app;

require_once __DIR__ . '/../composer_modules/autoload.php';

class ClasseTwigExtension extends \Slim\Views\TwigExtension {

    public function getName() {
        return 'classe-twig-extension';
    }

    public function getFilters() {
        return array(
            new \Twig_SimpleFilter('md5', 'md5_file'),
        );
    }

}

//EOF