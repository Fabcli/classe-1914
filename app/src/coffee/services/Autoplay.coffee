angular.module('classe1914.service').factory "AutoPlay", [
    'User'
    'Notification'
    'Timeout'
    (User, Notification, Timeout)->

        new class AutoPlay
            constructor: ->


            changeValue:  =>
                if User.inGame is true
                    if User.autoplay is true and not User.pause
                        notif = "Lecture automatique activée"
                        Notification.success(notif)
                    else
                        if User.pause
                            notif = "Lecture en pause"
                            Notification.primary(notif)
                        else
                            notif = "Lecture automatique désactivée"
                            Notification.error(notif)
                    do Timeout.toggleSequence

            nextSequence: =>
                do User.nextSequence if User.autoplay is true

            archiveOpened:  =>
                if User.autoplay is true
                    console.log Math.floor(Timeout.remainingTime)
                    User.autoplay.pause = Math.floor(Timeout.remainingTime)


]
