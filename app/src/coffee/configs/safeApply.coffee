angular.module('classe1914.config').run ['$rootScope', ($rootScope)->
  $rootScope.safeApply = (fn)->
    phase = @$root.$$phase
    if phase is "$apply" or phase is "$digest"
      do fn if fn and (typeof (fn) is "function")
    else
      @$apply fn
]
#TODO : Find the Role