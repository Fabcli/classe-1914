class CaseCtrl
    @$inject: ['$scope', 'User', 'Case']

    constructor: (@scope, @User, @Case)->
        @scope.user     =   @User
        @scope.case     =   @Case



angular.module('classe1914.controller').controller("CaseCtrl", MainCtrl)
# EOF
