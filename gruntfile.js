var jslibrary = [
    'bower_modules/jquery/dist/jquery.min.js',
    'bower_modules/modernizr/modernizr.js',
    'bower_modules/underscore/underscore.js',
    'bower_modules/angular/angular.min.js',
    'bower_modules/nouislider/jquery.nouislider.js',
    'bower_modules/angular-nouislider/src/nouislider.js',
    'bower_modules/angular-animate/angular-animate.min.js',
    'bower_modules/angular-local-storage/dist/angular-local-storage.js',
    'bower_modules/angular-route/angular-route.min.js',
    'bower_modules/angular-resource/angular-resource.min.js',
    'bower_modules/angular-sanitize/angular-sanitize.min.js',
    'bower_modules/angular-touch/angular-touch.min.js',
    'bower_modules/angular-markdown-directive/markdown.js',
    'bower_modules/circles/index.js',
    'bower_modules/howler/howler.min.js',
    'bower_modules/showdown/src/showdown.js'
];

var csslibrary = [
    'bower_modules/nouislider/jquery.nouislider.css'
];


module.exports = function(grunt) {
    var parallel = ['php:server','watch'];
    if( ! grunt.option("disable-browser") ) {
        parallel.push("browser");
    }

    // Load all grunt tasks matching the `grunt-*` pattern
    require('load-grunt-tasks')(grunt);

    // Project configuration.
    grunt.initConfig({
        concat: {
            bower_js: {
                src: jslibrary,
                dest: 'public/js/lib.min.js'
            },
            bower_css: {
                src: csslibrary,
                dest: 'public/css/lib.css'
            },
            coffee_src: {
                src: [
                    'app/src/coffee/app.coffee',
                    'app/src/coffee/*/*.coffee'
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
                    "public/dev/css/styles.css": "app/src/less/styles.less"
                }
            }
        },

        clean: {
            development: ["tmp"]
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
                livereloadOnError: false
            },
            coffee: {
                files: ['**/*.coffee','**/*.twig'],
                tasks: ['concat:coffee_src','coffee','uglify:app']
            },
            less: {
                files: ['**/*.less','**/*.twig'],
                tasks: ['less'],
                options: {
                    livereload: false
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

        open: {
            dev : {
                path: 'http://docgame.classe-1914.dev/',
                app: 'Google Chrome'
            }
        },

        php: {
            server: {
                options: {
                    port: 80,
                    keepalive: true,
                    open: false,
                    base: 'public',
                    hostname: "0.0.0.0"
                }
            }
        },

        parallel: {
            server: {
                options: {
                    grunt: true,
                    stream: true
                },
                tasks: parallel
            }
        }

    });

    // Load task
    grunt.registerTask('default', ['development']);
    grunt.registerTask('build', ['concat:coffee_src','coffee','uglify:app','less']);
    grunt.registerTask('lib', ['concat:bower_js']);

    // Setup environment for development
    grunt.registerTask('development', ['copy:angular_map', 'ngtemplates', 'build','lib', 'clean:development','mkdir:clean', 'open:dev', 'watch']);

    grunt.registerTask('server', function(env){
        if(env == 'production'){
            grunt.task.run(['production','parallel:server']);
        } else {
            grunt.task.run(['default','parallel:server']);
        }
    });

};