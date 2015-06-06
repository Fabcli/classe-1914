angular.module("classe1914.service").factory "Sound", ['User', 'Story', '$rootScope', '$filter', (User, Story, $rootScope, $filter)->
  new class Sound
      constructor: ->
          @is_ipad = (navigator.userAgent.match /iPad/i)?

      # ──────────────────────────────────────────────────────────────────────────
      # Public method
      # ──────────────────────────────────────────────────────────────────────────
      startSoundTrack: (tracks) =>
          return if @is_ipad
          if @soundtrack?
              do @soundtrack.stop
              @soundtrack = undefined
          # Create the new sound
          @soundtrack = new Howl
              urls : tracks
              loop : yes
              buffer : yes
              volume : 0
            # Default states
              onplay : => $rootScope.safeApply => @soundtrack.isPlaying = yes
              onpause: => $rootScope.safeApply => @soundtrack.isPlaying = no
              onend  : => $rootScope.safeApply => @soundtrack.isPlaying = no
          # Play the sound with a fadein entrance
          @soundtrack.play => @soundtrack.fade(0, User.volume, 1000)

      startSoundEffect: (effects) =>
          return if @is_ipad
          if @soundeffect?
              console.log "effets sonores"
              do @soundeffect.stop
              @soundeffect = undefined
          # Create the new sound
          @soundeffect = new Howl
              urls : effects
              loop : yes
              buffer : yes
              volume : 0
          # Default states
              onplay : => $rootScope.safeApply => @soundeffect.isPlaying = yes
              onpause: => $rootScope.safeApply => @soundeffect.isPlaying = no
              onend  : => $rootScope.safeApply => @soundeffect.isPlaying = no
          # Play the sound with a fadein entrance
          @soundeffect.play => @soundeffect.fade(0, User.volume, 1000)

      extractAllTracks: (track) =>
          tracks = [track]
          tracks.push tracks[0]
          tracks[1] = tracks[1].split '.'
          tracks[1][tracks[1].length - 1] = 'ogg'
          tracks[1] = tracks[1].join '.'
          return tracks

      stopVoiceTrack: (sequence=null) =>
          if @voicetrack?
              clearInterval @voicetrack._interval
              if sequence? and sequence.type is 'notification'
                  do @voicetrack.pause
              else
                  do @voicetrack.stop
                  @voicetrack = null

      startScene: (chapter=User.chapter, scene=User.scene)=>
          if @notificationtrack?
              do @notificationtrack.stop
              @notificationtrack = null
          do @stopVoiceTrack
          # Start a new scene
          if scene? and Story.chapters.length and Story.scene(chapter, scene)?
              # Get scene object
              scene  = Story.scene(chapter, scene)
              tracks = @extractAllTracks $filter('media')(scene.decor[0].soundtrack)
              effects = @extractAllTracks $filter('media')(scene.decor[0].soundeffect)
              # Update the soundtrack if it is different
              if scene.decor[0].hasOwnProperty 'soundtrack'
                  if scene.decor[0].soundtrack?
                      if (not @soundtrack?)
                         @startSoundTrack tracks
                      else if (not angular.equals( @soundtrack.urls(), tracks))
                          @soundtrack.fade User.volume, 0, 1000, =>
                             @startSoundTrack tracks
                  else if @soundtrack?
                      @soundtrack.fade (do @soundtrack.volume), 0, 1000, =>
                          do @soundtrack.stop
                          @soundtrack = undefined
              if scene.decor[0].hasOwnProperty 'soundeffect'
                  if scene.decor[0].soundeffect?
                      if (not @soundeffect?)
                          console.log "sound effet detecté 1"
                          @startSoundEffect effects
                      else if (not angular.equals( @soundeffect.urls(), effects))
                          console.log "sound effet detecté 2"
                          @soundeffect.fade User.volume, 0, 1000, =>
                              @startSoundEffect effects
                  else if @soundeffect?
                      console.log "ancien sound effect"
                      @soundeffect.fade (do @soundeffect.volume), 0, 1000, =>
                          do @soundeffect.stop
                          @soundeffect = undefined


      toggleSequence: (chapterIdx=User.chapter, sceneIdx=User.scene, sequenceIdx=User.sequence)=>
          if sequenceIdx?
              # Get sequence object
              sequence = Story.sequence(chapterIdx, sceneIdx, sequenceIdx)

              if @notificationtrack?
                  do @notificationtrack.stop
                  @notificationtrack = null

              @stopVoiceTrack sequence

              if @soundtrack?
                  if (do @soundtrack.volume) < User.volume
                      @soundtrack.fade( (do @soundtrack.volume), User.volume, 500 )

              if @soundeffect?
                  if (do @soundeffect.volume) < User.volume
                      @soundeffect.fade( (do @soundeffect.volume), User.volume, 500 )

              return if do User.isStartingChapter

              # Sequence is a voicetrack
              if sequence? and sequence.type is "voixoff"
                  tracks = @extractAllTracks $filter('media')(sequence.body or sequence.sound)
                  # Update the voicetrack if it is different
                  if not @voicetrack? or not angular.equals( @voicetrack.urls(), tracks)
                      # Create the new sound
                      @voicetrack = new Howl
                          urls    : tracks
                          loop    : no
                          buffer  : yes
                          volume  : 0
                          autoplay: no
                        # Default states
                          onload  : =>
                              do @voicetrack.play
                              @voicetrack._interval = setInterval (do =>
                                  @voicetrack._position = (do @voicetrack.pos) or 0
                                  =>
                                      if @voicetrack? and @voicetrack.isPlaying
                                          $rootScope.safeApply =>
                                              @voicetrack._position = do @voicetrack.pos
                              ), 500
                          onplay  : =>
                              $rootScope.safeApply =>
                                if @soundtrack?
                                    @soundtrack.fade( @soundtrack.volume(), User.volume/4, 500 )
                                    # Duration only on starting
                                    duration = if @soundtrack.pos() is 0 then 1000 else 0
                                if @soundeffect?
                                    @soundeffect.fade( @soundeffect.volume(), User.volume/4, 500 )
                                @voicetrack.fade(0, 1, duration)
                                @voicetrack.isPlaying = yes
                          onpause : =>
                              $rootScope.safeApply =>
                                  @voicetrack.isPlaying = no
                          onend   : =>
                              $rootScope.safeApply =>
                                  @soundtrack.fade( @soundtrack.volume(), User.volume, 500 ) if @soundtrack?
                                  @soundeffect.fade( @soundeffect.volume(), User.volume, 500 ) if @soundeffect?
                                  $rootScope.safeApply => @voicetrack._position = @voicetrack._duration
                                  @voicetrack.pos(0)
                                  @voicetrack.isPlaying = no
                                  clearInterval @voicetrack._interval
                                  if User.autoplay is true
                                      do User.nextSequence
                # Just play the voice
                  else if @voicetrack? and not @voicetrack.isPlaying
                      do @voicetrack.play
                    # Pause sound
                  else if @voicetrack? and @voicetrack.isPlaying?
                      do @voicetrack.pause
              else
                  if sequence? and (sequence.type is "notification" or (sequence.type is "choice" and sequence.delay?))
                      tracks = @extractAllTracks $filter('media')(sequence.sound)
                      @notificationtrack = new Howl
                          urls : tracks
                          loop : no
                          buffer : yes
                          volume : 1
                          autoplay : yes
                          onplay : =>
                              $rootScope.safeApply =>
                                  @notificationtrack.isPlaying = yes
                          onpause : =>
                              $rootScope.safeApply =>
                                  @notificationtrack.isPlaying = no
                          onend : =>
                              $rootScope.safeApply =>
                                  @notificationtrack.isPlaying = no

      toggleVoicetrack: =>
          if @voicetrack?
              if @voicetrack.isPlaying
                  do @voicetrack.pause
                  @voicetrack.isPlaying = no
              else
                  do @voicetrack.play
                  @voicetrack.isPlaying = yes

      stopTracks: (stopVoice=yes, stopSound=yes)=>
          if stopVoice and @voicetrack?
              do @voicetrack.stop
          if stopSound and @soundtrack?
              do @soundtrack.stop
          if stopSound and soundeffect?
              do soundeffect.stop

      updateVolume: (volume)=>
          # New volume set
          if volume?
              if @soundtrack?
                 @soundtrack.volume(volume)
              if @soundeffect?
                  @soundeffect.volume(volume)

]
# EOF
