class GameCtrl
    @$inject: ['$scope', 'Story', 'User', 'ArcadesGame']
    constructor: (@scope, @Story, @User, @ArcadesGame) ->
        @scope.story        =   @Story
        @scope.user         =   @User
        @scope.arcadesGame  =   @ArcadesGame

        @scope.launchGame = @ArcadesGame.LaunchGame

angular.module('classe1914.controller').controller("GameCtrl", GameCtrl)
# EOF
