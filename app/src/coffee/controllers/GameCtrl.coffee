class GameCtrl
    @$inject: ['$scope', 'Story', 'User']
    constructor: (@scope, @Story, @User) ->
        @scope.story  = @Story
        @scope.user  = @User



angular.module('classe1914.controller').controller("GameCtrl", GameCtrl)
# EOF
