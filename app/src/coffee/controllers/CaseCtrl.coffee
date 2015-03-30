class CaseCtrl
    @$inject: ['$scope', 'User', 'Case']

    constructor: (@scope, @User, @Case)->
        @scope.user     =   @User
        @scope.case     =   @Case

        # Establishes a bound between "src" argument
        # provided by the case directive and the Controller
        @archive = @scope.archive = @scope.src

        console.log @archive

        console.log @Case.caseData
        console.log @scope.case.archives

    shouldShowCase: =>
        true





angular.module('classe1914.controller').controller("CaseCtrl", MainCtrl)
# EOF
