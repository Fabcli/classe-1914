class MainCtrl
  @$inject: ['$scope', 'Progression', 'Story', 'User', 'Sound']

  constructor: (@scope, @Progression, @Story, @User, @Sound)->
      @scope.user   =   @User
      @scope.story  =   @Story
      @scope.sound  =   @Sound


angular.module('classe1914.controller').controller("MainCtrl", MainCtrl)
# EOF
