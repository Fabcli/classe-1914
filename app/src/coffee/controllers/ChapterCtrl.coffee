class ChapterCtrl
    @$inject: ['$scope', 'Story', 'User', '$filter']
    constructor: (@scope, @Story, @User, @filter) ->
        @scope.story  = @Story
        @scope.user  = @User
        # Establishes a bound between "src" argument
        # provided by the chapter directive and the Controller
        @chapter = @scope.chapter = @scope.src
        # True if the given chapter is visible
        @scope.shouldShowChapter = @shouldShowChapter
        # True to view the case
        @scope.shouldShowCase = @shouldShowCase

        # Returns the class to apply to the Chapter
        @scope.chapterClasses = =>
          "chapter--starting": User.isStartingChapter()
          "chapter--loading" : not User.isReady

        @scope.getBackgrounds = =>
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

    shouldShowChapter: =>
        if @User.isSummary
         return @User.lastChapter is @chapter.id
        else
         return @User.inGame and @chapter.id is @User.chapter


    shouldShowCase: =>
          return yes


angular.module('classe1914.controller').controller("ChapterCtrl", ChapterCtrl)
# EOF
