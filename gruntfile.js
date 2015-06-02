var jslibrary = [
    'bower_modules/phaser/build/phaser.min.js',
    'bower_modules/jquery/dist/jquery.min.js',
    'bower_modules/modernizr/modernizr.js',
    'bower_modules/elevatezoom/jquery.elevateZoom-2.*.*.min.js',
    'bower_modules/underscore/underscore.js',
    'bower_modules/angular/angular.min.js',
    'bower_modules/nouislider/jquery.nouislider.js',
    'bower_modules/angular-nouislider/src/nouislider.js',
    'bower_modules/angular-toggle-switch/angular-toggle-switch.min.js',
    'bower_modules/angular-fullscreen/src/angular-fullscreen.js',
    'bower_modules/angular-animate/angular-animate.min.js',
    'bower_modules/angular-local-storage/dist/angular-local-storage.js',
    'bower_modules/angular-route/angular-route.min.js',
    'bower_modules/angular-resource/angular-resource.min.js',
    'bower_modules/angular-sanitize/angular-sanitize.min.js',
    'bower_modules/angular-touch/angular-touch.min.js',
    'bower_modules/angular-bootstrap/ui-bootstrap-tpls.min.js',
    'bower_modules/angular-bootstrap-lightbox/dist/angular-bootstrap-lightbox.min.js',
    'bower_modules/angular-loading-bar/build/loading-bar.min.js',
    'bower_modules/angular-ui-notification/dist/angular-ui-notification.min.js',
    'bower_modules/angular-markdown-directive/markdown.js',
    'bower_modules/videogular/videogular.min.js',
    'bower_modules/videogular-controls/vg-controls.min.js',
    'bower_modules/videogular-buffering/vg-buffering.min.js',
    'bower_modules/circles/index.js',
    'bower_modules/howler/howler.min.js',
    'bower_modules/showdown/src/showdown.js'
];

var csslibrary = [
    //'bower_modules/angular-bootstrap-lightbox/dist/angular-bootstrap-lightbox.min.css',
    'bower_modules/angular-loading-bar/build/loading-bar.min.css',
    'bower_modules/angular-toggle-switch/angular-toggle-switch.css',
    'bower_modules/angular-toggle-switch/angular-toggle-switch-bootstrap.css',
    'bower_modules/nouislider/jquery.nouislider.css'
];


module.exports = function(grunt) {
    var parallel = ['php:server_demo','watch'];
    if( ! grunt.option("disable-browser") ) {
        parallel.push("browser");
    }

    // Load all grunt tasks matching the `grunt-*` pattern
    require('load-grunt-tasks')(grunt);
    // Load task without grunt-* pattern
    grunt.loadNpmTasks('assemble' );

    // Project configuration.
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        exec: {
            composer_install: {
                command: 'curl -sS https://getcomposer.org/installer | php && php composer.phar install',
                stdout: false,
                stderr: false
            }
        },
        concat: {
            bower_js: {
                src: jslibrary,
                dest: 'public/js/lib.min.js'
            },
            bower_css: {
                src: csslibrary,
                dest: 'public/css/lib.min.css'
            },
            coffee_src: {
                src: [
                    'app/src/coffee/app.coffee',
                    'app/src/coffee/*/*.coffee',
                    'app/src/coffee/*/*/*.coffee'
                ],
                dest: 'tmp/app.coffee'
            }
        },

        copy: {
            angular_map: {
                files: [
                    {
                        expand: true,
                        flatten: true,
                        src: ['bower_modules/phaser/build/phaser.map'],
                        dest: 'public/js/',
                        filter: 'isFile'
                    },
                    {
                        expand: true,
                        flatten: true,
                        src: ['bower_modules/angular/angular.min.js.map'],
                        dest: 'public/js/',
                        filter: 'isFile'
                    },
                    {
                        expand: true,
                        flatten: true,
                        src: ['bower_modules/angular-animate/angular-animate.min.js.map'],
                        dest: 'public/js/',
                        filter: 'isFile'
                    },
                    {
                        expand: true,
                        flatten: true,
                        src: ['bower_modules/angular-touch/angular-touch.min.js.map'],
                        dest: 'public/js/',
                        filter: 'isFile'
                    },
                    {
                        expand: true,
                        flatten: true,
                        src: ['bower_modules/angular-route/angular-route.min.js.map'],
                        dest: 'public/js/',
                        filter: 'isFile'
                    }
                ]
            }
        },

        ngtemplates:  {
             'classe1914.template': {
                cwd:  'app/views/',
                src:  'partials/*.html',
                dest: 'public/dev/js/app.template.js'
            }
        },

        bower: {
            install: {
                options: {
                    copy: false
                }
            }
        },

        coffee: {
            compile: {
                options: {
                    bare: true
                },
                files: {
                    'public/dev/js/app.js': ['tmp/app.coffee']
                }
            }
        },

        uglify: {
            app: {
                files: {
                    'public/js/app.min.js': ['public/dev/js/app.js'],
                    'public/js/app.template.min.js': ['public/dev/js/app.template.js']
                }
            }
        },

        less: {
            development: {
                files: {
                    "public/dev/css/styles.css": "app/src/less/styles.less",
                    "public/dev/css/wait.css": "app/src/less/wait.less"
                }
            },
            production: {
                options: {
                    yuicompress: true
                },
                files: {
                    "public/css/styles.min.css": "app/src/less/styles.less",
                    "public/css/wait.min.css": "app/src/less/wait.less"
                }
            }
        },

        clean: {
            development: ["tmp"],
            production: ["public/dev", "tmp"]
        },

        mkdir: {
            options: {
                // Task-specific options go here.
            },
            clean: {
                options: {
                    create: ['tmp','tmp/logs','tmp/cache']
                }
            }
        },

        watch: {
            options: {
                spawn: false,
                livereload: true,
                livereloadOnError: true
            },
            coffee: {
                files: ['**/*.coffee','**/*.twig'],
                tasks: ['concat:coffee_src','coffee','uglify:app']
            },
            less: {
                files: ['**/*.less','**/*.twig'],
                tasks: ['less'],
                options: {
                    livereload: true
                }
            },
            css: {
                files: ['public/css/*.css'],
                tasks: []
            },
            twig: {
                files: ['**/*.twig']
            },
            partials: {
                files: ['app/views/partials/*'],
                tasks: ['ngtemplates']
            }
        },

        assemble: {
            development_php: {
                options: {
                    dev: true,
                    demo: false,
                    prod: false,
                    ext: '.php'
                },
                files: {
                    "app/config/config_settings.inc.php": ["app/src/hbs/config.env.hbs"]
                }
            },
            demo_php: {
                options: {
                    dev: false,
                    demo: true,
                    prod: false,
                    ext: '.php'
                },
                files: {
                    "app/config/config_settings.inc.php": ["app/src/hbs/config.env.hbs"]
                }
            },
            production_php: {
                options: {
                    dev: false,
                    demo: false,
                    prod: true,
                    ext: '.php'
                },
                files: {
                    "app/config/config_settings.inc.php": ["app/src/hbs/config.env.hbs"]
                }
            }
        },

        open: {
            dev : {
                path: 'http://docgame.classe-1914.dev/',
                app: 'Google Chrome'
            },
            demo : {
                path: 'http://localhost:8080'
            }
        },

        php: {
            server_dev: {
                options: {
                    port: 80,
                    keepalive: true,
                    open: false,
                    base: 'www',
                    hostname: "0.0.0.0"
                }
            },
            server_demo: {
                options: {
                    port: 8080,
                    keepalive: true,
                    open: false,
                    base: 'public',
                    hostname: "0.0.0.0"
                }
            }
        },

        parallel: {
            server_demo: {
                options: {
                    grunt: true,
                    stream: true
                },
                tasks: parallel
            }
        }

    });

    //--- Load task ---
        // Default task
    grunt.registerTask('default', ['demo']);
        // Built the js files and put in a tmp folder
    grunt.registerTask('build_js', ['concat:coffee_src','coffee','uglify:app']);
        // Concat the js and css files from Bower libraries
    grunt.registerTask('lib', ['concat:bower_js', 'concat:bower_css']);
        // Install bower and composer
    grunt.registerTask('fetch', ['exec']);


    //--- Setup environment ---
        // For development
    grunt.registerTask('development', ['copy:angular_map', 'ngtemplates', 'build_js','less:development',  'lib', 'assemble:development_php', 'clean:development','mkdir:clean', 'open:dev', 'watch']);
        // For demo
    grunt.registerTask('demo', ['ngtemplates', 'build_js','less:production','lib', 'assemble:demo_php', 'clean:production','mkdir:clean', 'parallel:server_demo', 'browser']);
        // For production
    grunt.registerTask('production', ['ngtemplates', 'build_js','less:production','lib', 'assemble:production_php', 'clean:production','mkdir:clean']);



    grunt.registerTask('browser', function(){
        var done = this.async();
        setTimeout(function(){
            grunt.task.run(['open:demo']);
            done();
        }, 1000);
    });

};