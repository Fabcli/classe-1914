class GameCtrl
    @$inject: ['$scope', 'Story', 'User', 'ArcadesGame']
    constructor: (@scope, @Story, @User, @ArcadesGame) ->
        @scope.story        =   @Story
        @scope.user         =   @User
        @scope.arcadesGame  =   @ArcadesGame

        @scope.launchGame = @ArcadesGame.LaunchGame

        console.log "@gameModel : "+@scope.gameModel
        console.log "@gameName : "+@scope.gameName

        @ArcadesGame.LaunchGame(@scope.gameModel, @scope.gameName)




angular.module('classe1914.controller').controller("GameCtrl", GameCtrl)
# EOF
