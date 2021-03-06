angular.module("classe1914.service").factory("User", [
    'constant.api'
    'constant.settings'
    'constant.types'
    'constant.case'
    'TimeoutStates'
    'UserIndicators'
    'Story'
    'localStorageService'
    '$http'
    '$timeout'
    '$location'
    '$rootScope'
    (api, settings, types, initialCase, TimeoutStates, UserIndicators, Story, localStorageService, $http, $timeout, $location, $rootScope)->
        new class User
            # ─────────────────────────────────────────────────────────────────
            # Public method
            # ─────────────────────────────────────────────────────────────────
            constructor: ->
                # This user is saved into local storage
                master = localStorageService.get("user") or {}
                # Set initial value according to the localStorage
                @setInitialValues master
                # User authentication
                @token    = $location.search().token or master.token or null
                @email    = master.email or null
                if (do $location.search).token?
                    @email = yes if @email is null
                    $location.search('token', null)
                # Load the career if a token is given
                do @loadCareer if @token isnt null
                # Load career data from the API when the player enters the game
                $rootScope.$watch (=>@inGame), (newValue, oldValue) =>
                  if @token is null and newValue and not oldValue
                      do @loadCareer
                , yes
                return @


            setInitialValues: (master={})=>
                #-- Initialisation --#
                # Scenes the user passed
                @scenes   = master.scenes or []
                #Case unblocked in past or reset case
                @case   =   master.case or initialCase.case
                # Autoplay value
                @autoplay = if master.autoplay? then master.autoplay else false
                # Sound control
                @volume   = if isNaN(master.volume) then 1 else master.volume
                # Backrgound Video State
                @videoState = null
                # Reset identification token
                [@token, @email] = [null, null]
                # Reset user states
                @inGame = @isGameOver = @isGameDone = @isSummary  = @isReady = no
                #Reset hero choice
                @hero = master.hero = null
                # Reset progression
                [@chapter, @scene, @sequence] = ["1", "1", 0]
                # User indicators
                @indicators =
                    luck     : UserIndicators.luck.meta.start
                    health   : UserIndicators.health.meta.start
                    mood     : UserIndicators.mood.meta.start
                    point    : UserIndicators.point.meta.start
                return @

            pos: ()=> @chapter + "." + @scene

            chapterProgression: ()=>
                return 100 if @isSummary
                inter =_.intersection settings.mainScenes[@chapter], @scenes
                Math.round( Math.min(inter.length, 4)/4 * 100)

            newUser: ()=>
                # Remove value in localStorage
                do localStorageService.clearAll
                do @setInitialValues

            updateLocalStorage: (user=@)=>
                localStorageService.set("user", user) if user?

            updateProgression: (career)=>
                # Do we start acting?
                if career.reached_scene? and typeof(career.reached_scene) is "string"
                    unless TimeoutStates.feedback isnt undefined
                        [@chapter, @scene] = career.reached_scene.split "."
                        # Saved passed scenes
                        @scenes = career.scenes
                        # Save Hero
                        @hero = career.hero
                        # Save indicators
                        for own key, value of career.context
                            @indicators[key] = value
                        # Start to the first sequence
                        @sequence = 0
                        # Check that the sequence's condition is OK
                        if not do @isSequenceConditionOk
                            # If not, go to the next sequence
                            do @nextSequence
                if @checkProgression()
                    @isGameOver = yes


            checkProgression: =>
                # return false if user is in game over
                return unless @inGame
                gameOver = false
                # will check if user progression lead him to a game over.
                #              for key, value of @indicators
                #                  if UserIndicators[key]? and UserIndicators[key].isGameOver(value)
                #                      @gameOverReason = key
                #                      gameOver =yes
                #                      break
                gameOver

            isStartingChapter: =>
                # Chapter is considered as starting during {settings.chapterEntrance} millisecond
                Date.now() - @lastChapterChanging < settings.chapterEntrance or
                # The user may also be ready (all image loaded)
                not @isReady

            saveChapterChanging: (chapter)=>
                # Stop here until a chapter id is set
                return unless chapter?
                @lastChapterChanging = Date.now()
                # Cancel any current timeout
                if @trackChapterChanging? then $timeout.cancel @trackChapterChanging
                # Start the tracking loop
                do @chapterTrackingLoop

            chapterTrackingLoop: =>
                if not @isStartingChapter() and @trackChapterChanging?
                    # Stop until chapter is effectively not starting
                    $timeout.cancel(@trackChapterChanging)
                else
                    # Force Angular to process a digest regulary
                    @trackChapterChanging = $timeout @chapterTrackingLoop, 200

            loadCareer: =>
                # Get career
                if @token?
                    # Get the value using the token
                    $http.get("#{api.career}?token=#{@token}")
                    # Update chapter, scene and sequence according
                    # the last scene given by the career
                    .success( @updateProgression )
                    # Something wrong happens, restores the User model
                    .error (data)=>
                        console.log "Error in api get career"
                        console.log(data)
                        do @newUser if @token? or @email?
                    # Or create a new one
                else
                    @createNewCareer (@email?)

            createNewCareer: (associate=no) =>
                # Get value using the token
                $http.post("#{api.career}", reached_scene: "1.1", hero: @hero)
                # Save the token
                .success (data)=>
                    # Save the token
                    @token = data.token
                    (@associate @email) if associate
                    # And call this function again
                    do @loadCareer

            updateCareer: (choice)=>
                console.log choice
                return no unless @token
                # Add reached scene parameter
                if choice?
                    state = choice
                    [chapterIdx, sceneIdx] = choice.scene.split(".")
                    # Get the current sequence to  update the indicators
                    sequence = Story.sequence(chapterIdx, sceneIdx, @sequence)
                    # Propagate the choices only if this sequence has options
                    if sequence.options? && sequence.hero?
                        option = sequence.options[choice.choice]
                        state.hero = option.hero
                        @restartChapter()
                    else if sequence.options?
                        option = sequence.options[choice.choice]
                        state.reached_scene = option.next_scene
                        #Created the hero for the introduction
                else
                    state = reached_scene: @pos()
                state.is_game_done = @isGameDone
                console.log "Lancement du post token dans User.coffee"
                # Get value using the token
                $http.post("#{api.career}?token=#{@token}", state).success @updateProgression

            nextSequence: =>
                # will show next sequence or next scene if next sequence in
                # current scene doesn't exists
                scene        = Story.scene(@chapter, @scene)
                lastSequence = Story.sequence(@chapter, @scene, @sequence)
                if lastSequence.reset is true
                    do @restart
                    do window.location.reload()
                if lastSequence.result and @isSequenceConditionOk(lastSequence)
                    for key, value of lastSequence.result
                        @indicators[key] += value
                        gameOver = do @checkProgression
                        if gameOver
                            @isGameOver = true
                unless @isGameOver
                      # Go to the next sequence within the current scene
                    if Story.sequence(@chapter, @scene, @sequence + 1)?
                        # Go simply to the next sequence
                        ++@sequence
                        # Retrieve the new sequence and check conditions
                        sequence = Story.sequence(@chapter, @scene, @sequence)
                        if not @isSequenceConditionOk sequence
                            sequence = do @nextSequence
                        # Go the next scene
                    else if scene and scene.next_scene?
                        # Shouldn't we reset to first sequence here?
                        @goToScene scene.next_scene
                        # Return the new sequence
                        sequence = Story.sequence(@chapter, @scene, @sequence)
                sequence

            isSequenceConditionOk: (seq) =>
                # check that every sequence condition are met or not.
                # condition are set with variables while doing some choices
                seq = seq or Story.sequence @chapter, @scene, @sequence
                return true unless seq?
                is_ok = @userMeetSequenceConditions(seq)
                if seq.isSkipped()
                    is_ok = no
                if seq.isGameOver()
                    $rootScope.safeApply =>
                        @isGameOver = true
                is_ok

            userMeetSequenceConditions: (seq)=>
                is_ok = yes
                seq = seq or Story.sequence @chapter, @scene, @sequence
                return true unless seq?
                if seq.condition
                    for key, value of seq.condition
                        user_variable_value = @indicators[key]
                        unless user_variable_value?
                          user_variable_value = false
                        is_ok = is_ok and (user_variable_value is value)
                is_ok

            associate: (email) =>
                return if (not email?) or email is ""
                $http
                    url : "#{api.associate}?token=#{@token}"
                    method : 'POST'
                    data :
                        email : email

            goToScene: (next_scene, shouldUpdateCareer=yes)=>
                if TimeoutStates.feedback
                  # if a previous timeout was set for a previous feedback
                  # we delete it
                  TimeoutStates.feedback = undefined

                if typeof(next_scene) is typeof("")
                  next_scene_str = next_scene
                else
                  health_key = if @indicators.karma >= 50 then 'positif' else 'negatif'
                  health_key_str = next_scene["#{health_key}_health"]

                if next_scene_str is types.scene.theEnd
                  @isGameDone = true
                  @inGame = false
                  do @updateCareer if shouldUpdateCareer
                  return

                [chapter, scene] = next_scene_str.split "."

                # Check that the next step exists
                warn = (m)-> console.warn "#{m} doesn't exist (#{next_scene_str})."
                # Chapter exits?
                return warn('Chapter') unless Story.chapter(chapter)?
                # Scene exits?
                return warn('Scene') unless Story.scene(chapter, scene)?
                # If we effectively change
                if @chapter isnt chapter or @scene isnt scene
                  gameOver = @checkProgression()
                  unless gameOver
                      # Update values
                      [@chapter, @scene, @sequence] = [chapter, scene, 0]

                      # Check that the sequence's condition is OK
                #                      if not do @isSequenceConditionOk
                          # If not, go to the next sequence //TODO : incrementation si condition
                      do @nextSequence
                      # Save the career
                      do @updateCareer if shouldUpdateCareer
                else
                  # Next sequence exits?
                  return warn('Next sequence') unless Story.sequence(chapter, scene, @sequence+1)?
                  # Just go further
                  do @nextSequence

            restart: =>
                @inGame = @isSummary = @isGameDone = @isGameOver = no
                @newUser()

            restartChapter: =>
                # will restart current chapter to its first scene.
                @inGame     = yes
                @isSummary  = no
                @isGameOver = no
                (do @eraseCareerChapter).success @updateProgression


            leaveSummary: =>
                @isSummary = no
                @saveChapterChanging true

            eraseCareerSinceNow: =>
                $http
                    url : "#{api.erase}?token=#{@token}"
                    method : 'POST'
                    data :
                        since : @chapter + '.' + @scene

            eraseCareerChapter: =>
                $http
                    url : "#{api.erase}?token=#{@token}"
                    method : 'POST'
                    data :
                        chapter : @chapter


])
