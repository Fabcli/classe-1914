angular.module('classe1914.directive').directive  'videoControls', [
    ()->
        restrict: "E"
        require: "^videogular"
        templateUrl: "partials/videoControls.html"

]