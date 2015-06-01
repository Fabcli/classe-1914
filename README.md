classe-1914
================

_Juin 2015_
This app is based on the development done by J++
Thanks a million ;)
https://github.com/jplusplus/pltv-jeudinfluences


## Production

This part of the manuel explains how to install this project from the production branch.

1. Check these prerequisites
	* PHP 5.3 is prerequired
	* Your Apache configuration must support **URL Rewritting**
1. Setup a virtualhost in your Apache Webserver with a DocumentRoot to `public/`
1. To configure the app:
	* Change the MySQL URI in [app/config/config.production.php](app/config/config.production.php) (line 6). 
	* Change the [available options](#options) following your needs.
1. Install the composer dependancies:  
    ```
    curl -sS https://getcomposer.org/installer | php && php composer.phar install
    ```
1. Open your browser and go the website! **RedBean** will take care of installing the database for you.

## Development

This part of the manuel explains how to install this project from the master branch and **is not suitable for production**.

### Requirements

In development, this application uses the following requirements:

* node 
    * npm
    * grunt
* php5-sqlite

**On Ubuntu**, enter this to install the packages:

```bash 
sudo apt-get install nodejs npm php5-sqlite
sudo npm install -g grunt-cli
``` 

### Set up the application

This command will install (in this order): npm's packages, composer and his packages, and bower's packages.

	make install

### Run the development Server

	make run
	
## Options

These options are defined into [app/config/config.production.php](app/config/config.production.php).

| Option name                     | Default value                                   | Definition
| ------------------------------- | ----------------------------------------------- | -------------------
| **cache**                       | false                                           | Disable or enable server side cache
| **debug**                       | false                                            | Display debug message
| **log.enabled**                 | true                                            | Disable or enable server logs
| **media_url**                   | /medias/Demo_Col/medias			            	| Repository of the video sounds and large files (use Cloudfront by Amazon)
| **static_url**                  | /                                               | Assets URL (if you  want to move static files)


