angular.module('classe1914.directive').directive "scene", ->
  restrict: "E"
  replace: false
  templateUrl: "partials/scene.html"
  controller: SceneCtrl
  scope:
    src: "="
    chapter: "="