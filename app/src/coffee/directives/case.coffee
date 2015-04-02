angular.module('classe1914.directive').directive "case", ->
    restrict: "E"
    replace: false
    templateUrl: "partials/case.html"
    controller: CaseCtrl
    scope:
        src: "="
        chapter: "="

#EOF