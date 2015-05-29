angular.module('classe1914.directive').directive "game", ->
    restrict: "E"
    replace : false
    template : '<div id="gameCanvas" ng-init="launchGame(gameModel)"></div>'
    controller : GameCtrl
    scope :
        gameModel : "="
        gameName : "="
    #link: (scope, element, attrs, GameCtrl) ->
        #game = new Phaser.Game(600, 400, Phaser.AUTO, 'gameCanvas')
        #console.log GameCtrl.Boot

        # Add our game states
        #game.state.add('Boot', GameCtrl.Boot)
        #game.state.add('Preloader', GameCtrl.Preloader)
        #game.state.add('MainMenu', GameCtrl.MainMenu)
        #game.state.add('Game', GameCtrl.Shot)

        # Start the game
        #game.state.start('Boot')

#EOF