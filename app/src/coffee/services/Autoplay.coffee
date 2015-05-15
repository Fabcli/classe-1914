angular.module('classe1914.service').factory "AutoPlay", [
    'User'
    'Notification'
    'Timeout'
    (User, Notification, Timeout)->

        new class AutoPlay
            constructor: ->


            changeValue:  =>
                if User.inGame is true
                    if User.autoplay is true
                        @notif = "Lecture automatique activée"
                        Notification.success(@notif)
                    else
                        @notif = "Lecture automatique désactivée"
                        Notification.error(@notif)
                    do Timeout.toggleSequence

            nextSequence: =>
                do User.nextSequence if User.autoplay is true

]
