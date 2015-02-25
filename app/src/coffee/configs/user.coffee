angular.module('classe1914.config').run ['$rootScope', 'User', ($rootScope, User)->
    #Temporary value till the WelcomeCtrl is ready
    User.inGame = yes
    User.volume = 0.2
    #Definitive value
    $rootScope.user = User
]
#EOF