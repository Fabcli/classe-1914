angular.module("classe1914.animation").animation '.case-entrance-animation', ["constant.settings", (settings)->

    enter: (element, done) ->
        element.css("opacity", 0)
        jQuery(element[0]).animate opacity: 1, settings.caseEntrance, done
        # Catch canceling
        (isCanceled)-> (jQuery(element[0]).stop() if isCanceled)

    leave: (element, done) ->
        element.css("opacity", 1)
        jQuery(element[0]).animate opacity: 0, settings.caseEntrance, done
        # Catch canceling
        (isCanceled)-> (jQuery(element[0]).stop() if isCanceled)
]
# EOF