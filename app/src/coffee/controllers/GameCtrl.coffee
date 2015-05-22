class GameCtrl
    @$inject: ['$scope', '$element','$attrs', '$rootScope', '$injector', 'Story', 'User', 'ArcadesGame']
    constructor: (@scope, @element, @attrs, @rootScope, @injector, @Story, @User, @ArcadesGame) ->
        @scope.story        =   @Story
        @scope.user         =   @User
        @scope.arcadesGame  =   @ArcadesGame

        console.log "@ArcadesGame dans GameCtrl"
        console.log @ArcadesGame

        @scope.launchGame = @ArcadesGame.LaunchGame


angular.module('classe1914.controller').controller("GameCtrl", GameCtrl)
# EOF
