<?php

namespace app;

function app_autoload ($class) {
    $class = '../'.str_replace('\\', '/', $class) . '.php';
    if(file_exists($class)){
        require_once($class);
    }
};

//Create a queue of autoload functions
spl_autoload_register('app\app_autoload');