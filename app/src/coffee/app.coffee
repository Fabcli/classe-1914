angular.module('classe1914.constant',   [])
angular.module('classe1914.animation',  ['ngAnimate', 'classe1914.constant'])
angular.module('classe1914.config',     ['ngRoute', 'ngSanitize', 'classe1914.constant', 'classe1914.service'])
angular.module('classe1914.controller', ['ngResource', 'classe1914.constant',' classe1914.filter'])
angular.module('classe1914.directive',  ['ngResource', 'classe1914.constant'])
angular.module('classe1914.filter',     ['ngResource', 'classe1914.constant'])
angular.module('classe1914.template',   ['ngRoute'])
angular.module('classe1914.service',    ['ngResource', 'LocalStorageModule', 'classe1914.constant'])
angular.module('classe1914.game',       ['ngResource', 'LocalStorageModule', 'classe1914.constant'])

app = angular.module('classe1914', [
  #Angular dependencies
  "ngRoute"
  "ngResource"
  "ngAnimate"
  "ngTouch"
  "ngSanitize"
  # External dependencies
  "nouislider"
  "FBAngular"
  "toggle-switch"
  "bootstrapLightbox"
  "ui-notification"
  "btford.markdown"
  "com.2fdevs.videogular"
  "com.2fdevs.videogular.plugins.controls"
  "com.2fdevs.videogular.plugins.buffering"
  #Internal dependencies
  "classe1914.constant"
  "classe1914.animation"
  "classe1914.config"
  "classe1914.filter"
  "classe1914.service"
  "classe1914.game"
  "classe1914.template"
  "classe1914.directive"
])

## EOF