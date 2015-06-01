angular.module("classe1914.service").factory "ArcadesGame", [
    'Boot'
    'MainMenu'
    'Preloader'
    'Shot'
    'Interactive'
    (Boot, MainMenu, Preloader, Shot, Interactive)->

        new class ArcadesGame
            constructor: ->

            LaunchGame: (model, interactiveBg)=>
                console.log "interactiveBg : "+interactiveBg
                if interactiveBg is undefined
                    @DestroyGame(game) if game?
                    @RemoveCanvas

                    game = new Phaser.Game('100%', '100%', Phaser.AUTO, 'gameCanvas')

                    # Preload, settings & Menu
                    game.state.add('Boot', Boot)
                    game.state.add('Preloader', Preloader)
                    game.state.add('MainMenu', MainMenu) if model isnt 'interactive'

                    # Launch different game
                    game.state.add('Game', Shot) if model is 'shot'
                    game.state.add('Game', Interactive) if model is 'interactive'

                    game.state.start('Boot')

            DestroyGame: (game) =>
                game.destroy()

            RemoveCanvas: =>
                # Select all the canvas in the document
                canvas = document.getElementsByTagName('canvas')
                if canvas?
                # Loop to remove all the canvas
                    while(canvas.length > 0)
                        canvas[0].parentNode.removeChild(canvas[0])


]