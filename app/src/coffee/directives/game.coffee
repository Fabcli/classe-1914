angular.module('classe1914.directive').directive "game", ->
    restrict: "E"
    replace: false
    template: '<div id="gameCanvas"></div>'
    controller: GameCtrl
    scope:
        src: "="

#EOF