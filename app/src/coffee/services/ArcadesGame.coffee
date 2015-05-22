angular.module("classe1914.service").factory "ArcadesGame", ['User', 'Story', '$rootScope', 'Boot', 'MainMenu', 'Preloader', 'Shot', (User, Story, $rootScope, Boot, MainMenu, Preloader, Shot)->

    new class ArcadesGame
        constructor: ->

        LaunchGame: =>
            @height = window.innerHeight
            @width = window.innerWidth

            console.log @height
            console.log @width

            game = new Phaser.Game(600, 400, Phaser.AUTO, 'gameCanvas')

            game.state.add('Boot', Boot)
            game.state.add('Preloader', Preloader)
            game.state.add('MainMenu', MainMenu)
            game.state.add('Game', Shot)

            game.state.start('Boot')


]