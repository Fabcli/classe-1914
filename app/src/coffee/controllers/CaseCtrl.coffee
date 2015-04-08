class CaseCtrl
    @$inject: ['$scope', 'Story', 'User', 'Case', 'Archive', 'Notification']

    constructor: (@scope, @Story, @User, @Case, @Archive, @Notification)->
        @scope.user     =   @User
        @scope.case     =   @Case
        @scope.archive  =   @Archive

        @menu = @User.case.menu
        @unlockedIds = @User.case.unlocked
        @starredIds  = @User.case.starred
        @viewedIds   = @User.case.viewed

        # Establishes a bound between "src" argument
        # provided by the chapter directive and the Controller
        @chapter        =   @scope.chapter

        #To display the case
        @scope.shouldShowCase = @shouldShowCase

        # To close the case when it's open
        @scope.toggleCase = @Case.toggleCase

        # to attribute class in a box
        @scope.archiveClass = (id ) =>
            'unlocked'  : id in @unlockedIds
            'starred'   : id in @starredIds
            'locked'    : id not in @unlockedIds
            'unviewed'  : id not in @viewedIds

        # To show active the menu
        @scope.shouldShowBox = (id) =>
            return true if id in @unlockedIds and @menu is 'unlocked'
            return true if id in @starredIds and @menu is 'starred'
            return true if @menu is 'all'

        @scope.shouldShowBoxContent = (id) =>
            return true if id in @unlockedIds


        @scope.toggleStar = (id)  =>
            if id in @starredIds
                indexOfId = @starredIds.indexOf(id)
                @starredIds.splice(indexOfId,1)
            else if id in @unlockedIds
                @starredIds.push id
            else if id not in @unlockedIds
                @Notification.error("Attention, cette archive n'est pas débloquée !")
            @starredIds

        @scope.selectMenu = (value) =>
            @menu = value

        @scope.isSelected = (value) =>
            if @menu?
                return true if value is @menu
            else
                return true if value is 'all'



    shouldShowCase: =>
        return @User.inGame and @User.case.open






angular.module('classe1914.controller').controller("CaseCtrl", MainCtrl)
# EOF
