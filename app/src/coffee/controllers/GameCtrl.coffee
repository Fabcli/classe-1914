class GameCtrl
    @$inject: ['$scope', 'Story', 'User', 'Boot', 'Preloader', 'MainMenu', 'Shot']
    constructor: (@scope, @Story, @User, @Boot, @Preloader, @MainMenu, @Shot) ->
        @scope.story        =   @Story
        @scope.user         =   @User
        @scope.boot         =   @Boot
        @scope.preloader    =   @Preloader
        @scope.mainMenu     =   @MainMenu
        @scope.shot         =   @Shot

        @fullscreenButton     =   @MainMenu.fullscreenButton
        @cursors              =   @MainMenu.cursors
        @spacebar             =   @MainMenu.spacebar
        @b_key                =   @MainMenu.b_key
        @z_key                =   @MainMenu.z_key
        @click                =   @MainMenu.click

        #TODO : Inject the Preloader assets !!!
        # http://www.ng-newsletter.com/posts/building-games-with-angular.html




        game = new Phaser.Game(600, 400, Phaser.AUTO, 'gameCanvas');

        # Load our custom Game object
        #Game      = require('./states')
        #states    = Game.States

        # Add our game states
        game.state.add('Boot', @Boot)
        game.state.add('Preloader', @Preloader)
        game.state.add('MainMenu', @MainMenu)
        game.state.add('Game', @Shot)

        # Start the game
        game.state.start('Boot')




#        console.log "Les indicateurs visible à partir du GameCtrl: "
#        console.log @User.indicators








angular.module('classe1914.controller').controller("GameCtrl", GameCtrl)
# EOF
