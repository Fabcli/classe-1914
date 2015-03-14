class MainCtrl
  @$inject: ['$scope', 'Progression', 'Story', 'User', 'Sound', 'Archive']

  constructor: (@scope, @Progression, @Story, @User, @Sound, @Archive)->
      @scope.user       =   @User
      @scope.story      =   @Story
      @scope.sound      =   @Sound
      @scope.archive    =   @Archive


angular.module('classe1914.controller').controller("MainCtrl", MainCtrl)
# EOF
