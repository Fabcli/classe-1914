classe-1914
================

_Demo - Juin 2015_

This app is based on the development done by J++.
Thanks a million ;)

https://github.com/jplusplus/pltv-jeudinfluences


## Demo version - June 2015

This part of the manuel explains how to install this project from the demo version and **is not suitable for production, it's just a demo test**.

### Requirements

In this demo version, this application uses the following requirements:

* Server
	* PHP 5.4  
	* URL Rewritting (Apache configuration)

* Setup the document Root in your Apache Web server to `public/`

* node 
    * npm
    * grunt
    
* php5-sqlite

**On Debian**, enter this to install the packages:

```bash 
sudo apt-get install nodejs npm php5-sqlite
sudo npm install -g grunt-cli
``` 

### Setup the application

This command will install (in this order): npm's packages, composer and his packages, and bower's packages.

	make install
	
Choose the 1.3.15 angular version (The migration to the new version 1.4 is on fire)

When this dependancies are installed, you can compile the application (and lanch a dev server to test the compilation ! )
	
	make run


	
## Options

These options are defined into [app/config/config.demo.php](app/config/config_demo.php).

| Option name                     | Default value                                   | Definition
| ------------------------------- | ----------------------------------------------- | -------------------
| **cache**                       | true                                            | Disable or enable server side cache
| **debug**                       | false                                           | Display debug message
| **log.enabled**                 | true                                            | Disable or enable server logs
| **media_url**                   | /medias/Demo_Col/medias			    | Repository of the large files
| **static_url**                  | /                                               | If you  want to move static files


