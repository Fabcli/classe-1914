class MainCtrl
  @$inject: ['$scope', 'Progression', 'Story', 'Case', 'User', 'Sound', 'Archive']

  constructor: (@scope, @Progression, @Story, @Case, @User, @Sound)->
      @scope.user       =   @User
      @scope.story      =   @Story
      @scope.case       =   @Case
      @scope.sound      =   @Sound


angular.module('classe1914.controller').controller("MainCtrl", MainCtrl)
# EOF
