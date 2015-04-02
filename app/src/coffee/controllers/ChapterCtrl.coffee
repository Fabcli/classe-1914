class ChapterCtrl
    @$inject: ['$scope', 'Story', 'User', 'Case', 'Archive', '$filter']
    constructor: (@scope, @Story, @User, @Case, @Archive, @filter) ->
        @scope.story  = @Story
        @scope.user  = @User
        # Establishes a bound between "src" argument
        # provided by the chapter directive and the Controller
        @chapter = @scope.chapter = @scope.src
        # True if the given chapter is visible
        @scope.shouldShowChapter = @shouldShowChapter
        # True to view the case
        @scope.toggleCase = @Case.toggleCase

        # Returns the class to apply to the Chapter
        @scope.chapterClasses = =>
          "chapter--starting": User.isStartingChapter()
          "chapter--loading" : not User.isReady


        # Return an array with the url for the background & archives images
        @scope.getImagesToPreload = =>
            @bgs = @getBackgrounds()
            @archivesUrl = @getArchives()
            @imgs = @bgs.concat @archiveUrl
            @imgs


    shouldShowChapter: =>
        if @User.isSummary
         return @User.lastChapter is @chapter.id
        else
         return @User.inGame and @chapter.id is @User.chapter

    getBackgrounds: =>
        # Cache bgs to avoid infinite digest iteration
        return @bgs if @bgs?
        @bgs = []
        media = @filter('media')
        # Fetch each sequence
        angular.forEach @chapter.scenes, (scene)=>
            # First background is the one from the scene
            @bgs.push media(scene.decor[0].background) if scene.decor? and scene.decor[0].background?
            # Look into each scene's sequence to find the new background
            angular.forEach scene.sequence, (sequence)=>
                if sequence.isNewBg() and sequence.body isnt null
                    # Add the bg to bg list
                    @bgs.push media(sequence.body)
        @bgs

    getArchives: =>
            #cache chapter archive
        return @archiveUrl if @archiveUrl?
        @archivesId = []
        # Fetch each sequence
        angular.forEach @chapter.scenes, (scene)=>
            # First archive if there's in the decor
            if scene.decor? and scene.decor[0].archive?
                angular.forEach scene.decor[0].archive , (a) =>
                    @archivesId.push a if a not in @archivesId
            angular.forEach scene.sequence, (sequence)=>
                if sequence.archive?
                    angular.forEach sequence.archive, (a)=>
                        @archivesId.push a if a not in @archivesId
        @archiveUrl = @Archive.getArchivesUrl (@archivesId)
        @archiveUrl



angular.module('classe1914.controller').controller("ChapterCtrl", ChapterCtrl)
# EOF
