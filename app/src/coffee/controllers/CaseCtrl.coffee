class CaseCtrl
    @$inject: ['$scope', 'Story', 'User', 'Case', 'Archive']

    constructor: (@scope, @Story, @User, @Case, @Archive)->
        @scope.user     =   @User
        @scope.case     =   @Case
        @scope.archive  =   @Archive

        # Establishes a bound between "src" argument
        # provided by the chapter directive and the Controller
        @chapter        =   @scope.chapter

        #To display the case
        @scope.shouldShowCase = @shouldShowCase
        # To close the case when it's open
        @scope.toggleCase = @Case.toggleCase

    shouldShowCase: =>
        return @User.inGame and @User.case.open


angular.module('classe1914.controller').controller("CaseCtrl", MainCtrl)
# EOF
