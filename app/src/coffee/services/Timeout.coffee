angular.module("classe1914.service").factory "Timeout", [
  '$rootScope'
  'User'
  'Story'
  'TimeoutStates'
  'constant.settings'
  '$timeout'
  'Notification'
  ($rootScope, User, Story, TimeoutStates, settings, $timeout, Notification)->
      new class Timeout
          # ──────────────────────────────────────────────────────────────────────────
          # Public method
          # ──────────────────────────────────────────────────────────────────────────
          constructor: ->
              @states = TimeoutStates
              @remainingTime = 0
              @_lastStep = null
              @_timeout = undefined

          cancel: =>
              $timeout.cancel @_timeout
              @_timeout = undefined
              @half_timeout_msg = no
              @remainingTime = 0
              @_lastStep = null

          timeoutStart: =>
              @remainingTime = 0
              @half_timeout_msg = no
              @_timeout = $timeout @timeStep, settings.timeoutRefRate
              @_lastStep = do Date.now

          toggleSequence: (chapterIdx=User.chapter, sceneIdx=User.scene, sequenceIdx=User.sequence) =>
              if sequenceIdx?
                  if @_timeout?
                      @remainingTime = 0
                      @half_timeout_msg = null
                      $timeout.cancel @_timeout
                      @_timeout = undefined
                      @_lastStep = null
                  @sequence = Story.sequence(chapterIdx, sceneIdx, sequenceIdx)
                  return if not @sequence?
                  # Some choices have a delay
                  #if @sequence.isChoice() and @sequence.delay?
                  #   @timeoutStart()
                      # Some sequence are feedbacks that disapear after a short delay
                  if @sequence.isFeedback()
                      if TimeoutStates.feedback isnt undefined
                          $timeout.cancel TimeoutStates.feedback
                          TimeoutStates.feedback = undefined
                      # Simply go to the next scene after a short delay
                      TimeoutStates.feedback = $timeout(
                          # Closure to pass the current sequence object
                          do (sequence=@sequence)->
                              # Simply go to the next scene
                              -> User.goToScene(sequence.next_scene)
                      , settings.feedbackDuration)
                  # when autoplay is on for dialog sequence, go to the next sequence
                  else if User.autoplay is true and User.case.open isnt true and ( @sequence.isDialog() or @sequence.isChoice() )
                      if @sequence.delay is undefined
                          @sequence.delay = settings.defaultDelay
                      @half_timeout_msg = null
                      @timeoutStart()


          timeStep: =>
              console.log "@half_timeout_msg : "+@half_timeout_msg
              return unless @_timeout?
              now = do Date.now
              # remaining time in percentage
              @remainingTime += (now - @_lastStep) * (100 / (@sequence.delay * 1000))
              return if isNaN(@remainingTime)
              console.log Math.floor(@remainingTime)+" %"
              # Launch the countdown
              if @remainingTime < 100
                  if 49 < @remainingTime < 50 and @half_timeout_msg is false
                      # Error message for random choice
                      if @sequence.isChoice()
                          @half_timeout_msg = yes
                          if User.hero?
                              Notification.error ("Un choix va être fait au hasard dans "+@sequence.delay/2+" secondes")
                          else
                              Notification.error ({message : "Le choix du personnage est obligatoire", title: 'IMPORTANT',  delay: 15000})
                  @_timeout = $timeout @timeStep, settings.timeoutRefRate
                  @_lastStep = now
              else
              # the countdown id done
                  @_timeout = undefined
                  _default = 0
                  # For the choice sequence
                  if @sequence.isChoice()
                      # except for the introduction
                      if User.hero?
                          # If there's a default choice in the json file
                          if @sequence.default_option?
                              _default = @sequence.default_option - 1
                          else
                          # If not, a random choice
                              _default = Math.floor(Math.random()* @sequence.options.length)
                          option = @sequence.options[_default]
                          @remainingTime = 0
                          @half_timeout_msg = null
                          @_lastStep = null
                          User.updateCareer choice: _default, scene: User.pos()
                          User.goToScene option.next_scene
                  # For narrative and dialog sequence
                  if @sequence.isDialog()
                      do User.nextSequence

]
# EOF