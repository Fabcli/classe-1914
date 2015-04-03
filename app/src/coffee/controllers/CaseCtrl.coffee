class CaseCtrl
    @$inject: ['$scope', 'Story', 'User', 'Case', 'Archive', 'Notification']

    constructor: (@scope, @Story, @User, @Case, @Archive, @Notification)->
        @scope.user     =   @User
        @scope.case     =   @Case
        @scope.archive  =   @Archive

        # Establishes a bound between "src" argument
        # provided by the chapter directive and the Controller
        @chapter        =   @scope.chapter

        #To display the case
        @scope.shouldShowCase = @shouldShowCase

        # To close the case when it's open
        @scope.toggleCase = @Case.toggleCase

        # To select the unlocked archives
        @scope.shouldShowUnlocked = (archive) =>
            is_unlocked = no
            unlockedIds = @User.case.unlocked
            if archive.id in unlockedIds
                is_unlocked = yes
            is_unlocked

        # To select the unlocked archives
        @scope.shouldShowStarred = (archive) =>
            is_starred = no
            unlockedIds = @User.case.starred
            if archive.id in unlockedIds
                is_starred = yes
            is_starred

        @scope.toggleStar = (id)  =>
            starredIds = @User.case.starred
            unlockedIds = @User.case.unlocked
            if id in starredIds
                indexOfId = starredIds.indexOf(id)
                starredIds.splice(indexOfId,1)
            else if id in unlockedIds
                starredIds.push id
            else if id not in unlockedIds
                @Notification.error("Attention, cette archive n'est pas débloquée !")
            starredIds




    shouldShowCase: =>
        return @User.inGame and @User.case.open






angular.module('classe1914.controller').controller("CaseCtrl", MainCtrl)
# EOF
