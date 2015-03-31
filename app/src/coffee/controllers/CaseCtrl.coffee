class CaseCtrl
    @$inject: ['$scope', 'User', 'Case', 'Archive']

    constructor: (@scope, @User, @Case, @Archive)->
        @scope.user     =   @User
        @scope.case     =   @Case

        console.log "Valeur de @Case dans CaseCtrl :"
        console.log @Case

        console.log "Valeur de @Archive dans CaseCtrl :"
        console.log @Archive

        @scope.toggleCase = @Case.toggleCase


angular.module('classe1914.controller').controller("CaseCtrl", MainCtrl)
# EOF
