angular.module("classe1914.service").factory "Progression", [
      '$rootScope'
      '$timeout'
      'constant.doors'
      'constant.keys'
      'constant.settings'
      'Story'
      'User'
      'Sound'
      'Archive'
      'Timeout'
      'KeyboardCommands'
      'AutoPlay'
      'Video'
      ($rootScope, $timeout, doors, keys, settings, Story, User, Sound, Archive, Timeout, KeyboardCommands, AutoPlay, Video)->
            new class Progression
                  # ──────────────────────────────────────────────────────────────────────────
                  # Public method
                  # ──────────────────────────────────────────────────────────────────────────
                  constructor: ->
                      $rootScope.$watch (=>User.inGame),  @onInGameChanged,  yes
                      $rootScope.$watch (=>User.isGameOver), (newVal, oldVal)=>
                          if newVal is no and User.gameOverReason
                            User.gameOverReason = undefined

                      $rootScope.$watch (=>User.chapter), @onChapterChanged, yes
                      $rootScope.$watch (=>User.scene),   @onSceneChanged,   yes
                      $rootScope.$watch (=>User.isReady), User.saveChapterChanging, yes

                      # Update local storage
                      $rootScope.$watch (=>User), User.updateLocalStorage, yes
                      # Scene is changing
                      $rootScope.$watch (=> [Story.chapters, User.scene] ), (->
                          if User.inGame
                             do Sound.startScene
                             do Archive.startScene
                      ), yes
                      # Sequence is changing
                      $rootScope.$watch (=>(User.scene+User.sequence)), ->
                          if User.inGame
                              do Timeout.toggleSequence
                              do Sound.toggleSequence
                              do Archive.toggleSequence

                      $rootScope.$watch (=>do User.isStartingChapter), ->
                         do Sound.toggleSequence
                         do Archive.toggleSequence
                         do Timeout.toggleSequence

                      # User open the case
                      $rootScope.$watch (=>User.case.open ), ->
                          do Timeout.toggleSequence
                          do Video.openCase if settings.activeBgPause

                      # Autoplay is changing
                      $rootScope.$watch (=>User.autoplay), ->
                         do AutoPlay.changeValue


                      $rootScope.$watch (=> User.isGameOver), (new_value, old_value) ->
                          if new_value and (not old_value)
                              do Sound.stopVoiceTrack
                              do Timeout.cancel

                      # Update the volume
                      $rootScope.$watch (=>User.volume), Sound.updateVolume

                      $rootScope.$watch (=>User.isGameDone),  @singMeTheEnd,  yes

                      # keyboard commands parametering
                      KeyboardCommands.register keys.next, @onKeyPressed


                  onChapterChanged: (newId, oldId)->
                      i = (v)-> parseInt v # little alias to parseInt
                      should_show_summary = false
                      new_chapter = Story.chapter newId
                      old_chapter = Story.chapter oldId

                      # results are show in a single way (when moving forward in
                      # the story) so we check user is going in the good way
                      should_show_summary = newId > oldId and
                        old_chapter and old_chapter.bilan

                      if should_show_summary
                          # User.isSummary will trigger the chapter results summary
                          # showing if set to true
                          User.isSummary = true
                      else
                          User.saveChapterChanging newId

                      User.lastChapter = oldId

                  onSceneChanged: (newScene, oldScene)=>
                    User.lastScene = oldScene

                  onInGameChanged: =>
                      # special treatment for triggering end of the game, we need to
                      # trigger sound ending (only for voices)
                      if User.isGameDone
                        Sound.stopTracks yes, no
                      else
                          # Record begining date of a chapter
                          do Sound.startScene
                          User.saveChapterChanging true


                  onKeyPressed: (e)=>
                      inGame = User.inGame
                      isSummary = User.isSummary
                      gameOver = User.isGameOver
                      isStartingChapter = User.isStartingChapter()

                      if _.every [ inGame, not isSummary, not gameOver,
                                   not isStartingChapter]
                          seq = Story.sequence(User.chapter, User.scene, User.sequence)
                          if seq.hasNext()
                             do User.nextSequence
                      if isSummary and inGame and not gameOver
                         do User.leaveSummary


                  singMeTheEnd: (done) =>
                      return unless console? and console
                      if done
                          i = 0
                          for sentence in doors.theEnd
                              lapse = 3500 * i
                              $timeout(do(phrase=sentence)->
                                  -> console.log phrase
                              , lapse)
                              i++

]
# EOF