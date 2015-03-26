class GameCtrl
    @$inject: ['$scope', 'Story', 'User', 'Boot', 'Preloader', 'MainMenu', 'Shot']
    constructor: (@scope, @Story, @User, @Boot, @Preloader, @MainMenu, @Shot) ->
        @scope.story  = @Story
        @scope.user  = @User

        game = new Phaser.Game(600, 400, Phaser.AUTO, 'gameCanvas');

        # Load our custom Game object
        #Game      = require('./states')
        #states    = Game.States

        # Add our game states
        game.state.add('Boot', @Boot)
        game.state.add('Preloader', @Preloader)
        game.state.add('MainMenu', @MainMenu)
        game.state.add('Play', @Shot)

        # Start the game
        game.state.start('Boot')

        console.log @Boot
        console.log @Preloader
        console.log @MainMenu
        console.log @Shot

#        console.log "Les indicateurs visible à partir du GameCtrl: "
#        console.log @User.indicators








angular.module('classe1914.controller').controller("GameCtrl", GameCtrl)
# EOF
