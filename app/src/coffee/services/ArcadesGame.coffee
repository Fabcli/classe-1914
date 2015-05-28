angular.module("classe1914.service").factory "ArcadesGame", ['User', 'Story', '$rootScope', 'Boot', 'MainMenu', 'Preloader', 'Shot', (User, Story, $rootScope, Boot, MainMenu, Preloader, Shot)->

    new class ArcadesGame
        constructor: ->

        LaunchGame: ()=>
            console.log "youhou"

            @DestroyGame(game) if game?
            @RemoveCanvas

            game = new Phaser.Game(1920, 1200, Phaser.AUTO, 'gameCanvas')

            game.state.add('Boot', Boot)
            game.state.add('Preloader', Preloader)
            game.state.add('MainMenu', MainMenu)
            game.state.add('Game', Shot)

            game.state.start('Boot')

        DestroyGame: (game) =>
            game.destroy()

        RemoveCanvas: =>
            # Select all the zoom container
            canvas = document.getElementsByTagName('canvas')
            if canvas?
            # Loop to remove all the containers
                while(canvas.length > 0)
                    canvas[0].parentNode.removeChild(canvas[0])


]