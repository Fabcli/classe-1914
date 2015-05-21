class CaseCtrl
    @$inject: ['$scope', 'Story', 'User', 'Case', 'Archive', 'Notification', '$filter', 'ElevateZoom', 'ThirdParty']

    constructor: (@scope, @Story, @User, @Case, @Archive,  @Notification, @filter, @ElevateZoom, @ThirdParty)->
        @scope.user         =   @User
        @scope.case         =   @Case
        @scope.archive      =   @Archive
        @scope.thirdParty   =   @ThirdParty

        @menu = @User.case.menu
        @unlockedIds = @User.case.unlocked
        @starredIds  = @User.case.starred
        @viewedIds   = @User.case.viewed

        # Establishes a bound between "src" argument
        # provided by the chapter directive and the Controller
        @chapter        =   @scope.chapter

        #To display the case or the archive
        @scope.shouldShowCase = @shouldShowCase

        @scope.getArchs = ()=>
            if  @User.case.archive.open is true
                # Cache bgs to avoid infinite digest iteration
                @archs = []
                # Return an array for unlocked archives
                if @menu isnt 'starred'
                    @archs = @Archive.getArchives(@unlockedIds)
                else
                    @archs = @Archive.getArchives(@starredIds)
                @archs

        # True if we should display the given archive
        @scope.shouldShowArchive = (id) =>
            @shouldShowArchive(id)

        # To navigate in archive when archive is open in the case
        @scope.navArchive = (dir) =>
            @navArchive(dir)


        @scope.shouldShowArchiveMenu = () =>
            return true if @User.case.archive.open and @User.case.archive.id?

        # To close the case or the archive when it's open
        @scope.toggleArchive = =>
            do @toggleArchive

        @scope.toggleCase = =>
            if @User.case.archive.open is true
                do @toggleArchive
            else
                do @Case.toggleCase

        @scope.closeCase = =>
            do @ElevateZoom.removeZoom
            do @Case.toggleCase

        # To close the case or the archive when it's open
        @scope.toggleZoom = =>
            do @toggleZoom


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
                # close or go to the next if the player unstar in archive view
                if @User.case.archive.open is true and @menu is 'starred'
                    if @starredIds.length > 1
                        console.log "archive suivante"
                        @navArchive('next')
                    else
                        console.log "ferme l'archive"
                        @Notification.error("Il n'y a plus d'archive en favoris !!!")
                        @toggleArchive()
                indexOfId = @starredIds.indexOf(id)
                @starredIds.splice(indexOfId,1)
                @Notification.info("Archive supprimée des favoris !!!")
            else if id in @unlockedIds
                @starredIds.push id
                @Notification.info("Archive ajoutée dans les favoris !!!")
            else if id not in @unlockedIds
                @Notification.error("Attention, cette archive n'est pas débloquée !")
            @filter('crescentOrder')(@starredIds)
            @starredIds

        @scope.selectMenu = (value) =>
            @menu = value
            @User.case.menu = value

        @scope.isSelected = (value) =>
            if @menu?
                return true if value is @menu
            else
                return true if value is 'all'

        @scope.displayArchive = (id) =>
            if id not in @unlockedIds
                @Notification.error("Mince, cette archive n'est pas débloquée !")
            else
                @User.case.archive.id = id
                do @toggleArchive

        @scope.unlockAlert = =>
            @Notification.error(" Cette archive est déjà débloquée !")

        @scope.severalArchiveImg = (allUrl) =>
            is_ok = no
            if allUrl?
                is_ok = yes
            is_ok

        @scope.archNewUrl = (newUrl,id,direction=false) =>
            @archNewUrl(newUrl,id, direction)

        #To use with img in background
#        @scope.archImg = (u) =>
#            url = 'url('+u+')'
#            return url

    archNewUrl: (URL,id,direction) =>
        # Delete the lens
        console.log
        # The archive find with the index (id - 1)
        archive = @Case.archives[id-1]
        # for the thumbnail click
        if direction is false
            if archive.url is URL
                @Notification.error(" Cette image est déja séléctionnée !")
            else
                archive.url = URL
        # For the next/previous button
        else
        # For more than 1 image for 1 archive
            # All images url
            allUrl = archive.allUrl
            # Index of the actual archive
            idx = allUrl.indexOf(URL)
            # the number of images
            l = allUrl.length
            if direction is "previous"
                if idx - 1 >= 0
                    newUrl = allUrl[idx - 1]
                else
                    newUrl = allUrl[l - 1]
            if direction is "next"
                if idx + 1 < l
                    newUrl = allUrl[idx + 1]
                else
                    newUrl = allUrl[0]
            archive.url = newUrl

    shouldShowCase: =>
        return @User.inGame and @User.isReady and @User.case.open

    shouldShowArchive: (id) =>
        if @User.case.archive.open and @User.case.archive.id?
            should_show = yes if id is @User.case.archive.id
        should_show

        # To navigate in archive when archive is open in the case
    navArchive: (direction) =>
        if @User.case.archive.open is true
            # The open id archive
            id = @User.case.archive.id
            # Choose the correct array according to the menu
            if @menu isnt 'starred'
                array = @unlockedIds
            else
                array = @starredIds
            # Index of the archive opened in the chosen array
            idx = array.indexOf(id)
            l = array.length
            # The loop according to the chosen direction
            if direction is 'next'
                if idx + 1 < l
                    id = array[idx + 1]
                else
                    id = array[0]
            else if direction is 'previous'
                if idx - 1 >= 0
                    id = array[idx - 1]
                else
                    id = array[l - 1]
            # Update the opened archive
            @User.case.archive.id = id
            @shouldShowArchive(id)

    toggleArchive:  =>
        @User.case.archive.open = !@User.case.archive.open
        # Delete all div.zoomContainer
        if @User.case.archive.open is false
            do @ElevateZoom.removeZoom

    toggleZoom: =>
        @User.case.archive.zoom = !@User.case.archive.zoom
        if @User.case.archive.zoom is true
            @Notification.success "Loupe activée !"
        else
            @Notification.error "Loupe désactivée !"



angular.module('classe1914.controller').controller("CaseCtrl", MainCtrl)
# EOF
