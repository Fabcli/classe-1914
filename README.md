classe-1914
================

_Juin 2015_
This app is based on the development done by J++
Thanks a million ;)
https://github.com/jplusplus/pltv-jeudinfluences


## Development and demo - June 2015

This part of the manuel explains how to install this project from the master branch and **is not suitable for production, it's just a debug test**.

### Requirements

In this demo version, this application uses the following requirements:

* node 
    * npm
    * grunt
* php5-sqlite

**On Debian**, enter this to install the packages:

```bash 
sudo apt-get install nodejs npm php5-sqlite
sudo npm install -g grunt-cli
``` 

### Set up the application

This command will install (in this order): npm's packages, composer and his packages, and bower's packages.

	make install
	
Choose the 1.3.15 angular version

When this dependancies are installed, you can compile the application
	
	make run


	
## Options

These options are defined into [app/config/config.demo.php](app/config/config.demo.php).

| Option name                     | Default value                                   | Definition
| ------------------------------- | ----------------------------------------------- | -------------------
| **cache**                       | false                                           | Disable or enable server side cache
| **debug**                       | false                                           | Display debug message
| **log.enabled**                 | true                                            | Disable or enable server logs
| **media_url**                   | /medias/Demo_Col/medias			            	| Repository of the large files
| **static_url**                  | /                                               | Assets URL (if you  want to move static files)


