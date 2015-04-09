<?php
/**
 * Created by Kalioppe.
 * User: greg
 * Date: 14/01/15
 * Time: 19:13
 */


//Internet Explorer X-UA FIX
if (isset($_SERVER['HTTP_USER_AGENT']) && (strpos($_SERVER['HTTP_USER_AGENT'], 'MSIE') !== false))
    header('X-UA-Compatible: IE=edge,chrome=1');

//Load App
require_once __DIR__ . '/../app/app.php';