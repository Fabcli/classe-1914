angular.module("classe1914.service").factory "Story", [
  '$http'
  'constant.api'
  'constant.settings'
  'constant.characters'
  'constant.types'
  ($http, api, settings, characters, types)->
      new class Story
          sequenceWrappingObject:
              # help us to know if we already wrapped a sequence
              _wrapped: yes

              lowerType: -> this.type.toLowerCase()

              isDialog: ->
                  settings.sequenceDialog.indexOf( this.lowerType() ) > -1

              isSkipped: ->
                  settings.sequenceSkip.indexOf( this.lowerType() ) > -1

              isChoice: ->
                  this.lowerType() is types.sequence.choice

              isPlayer: ->
                  this.lowerType() is types.sequence.player

              isVideo: ->
                  this.lowerType() is types.sequence.video

              isGame: ->
                  this.lowerType() is types.sequence.game

              isNewBg: ->
                  this.lowerType() is types.sequence.newBackground

              isArchive: ->
                  this.lowerType() is types.sequence.archive

              isVideoBg: ->
                  this.lowerType() is types.sequence.videoBackground

              isGameOver: ->
                  this.lowerType() is types.sequence.gameOver

              isNotification: ->
                  this.lowerType() is types.sequence.notification

              isNotificationWithButton: ->
                  (this.lowerType() is types.sequence.notification) and this.next_button

              isFeedback: ->
                  this.lowerType() is types.sequence.feedback

              hasConditions: ->
                  this.condition?

              hasNext: ->
                   settings.sequenceWithNext.indexOf( this.lowerType() ) > -1

              hasExit: ->
                  this.isPlayer() or
                  this.isDialog() or
                  this.isChoice() or
                  this.isFeedback() or
                  this.isNotificationWithButton() or
                  this.isVideoBg()

              getEmbedSrc: ->
                  isSafari = navigator.userAgent.toLowerCase().indexOf('safari') != -1
                  # Force HTML5 player only with Safari
                  this.body = this.body.replace("&html=1", "") unless isSafari

              getAvatarSrc: ->
                   if this.character?
                        # slugify the character name (to avoid error)
                        character = this.character.toLowerCase().replace(/[^\w-]+/g,'')
                        # Just returns the URL
                        characters[character] #TODO: Add a small function to add _child option in avatar characters


          # ─────────────────────────────────────────────────────────────────
          # Public methods
          # ─────────────────────────────────────────────────────────────────
          constructor: ->
              @chapters = []
              # Get story TODO : $http.get(api.story) avec les héros
              $http.get(api.story).success (chapters)=>
                  @chapters = @wrapChapters chapters
              return @

          wrapSequence: (sequence)=>
              sequence = sequence or { type: "" }
              unless sequence._wrapped
                sequence = _.extend sequence, @sequenceWrappingObject
              sequence

          wrapChapters: (chapters)=>
              for c in chapters
                  for s in c.scenes
                     s.sequence = _.map s.sequence, @wrapSequence
              chapters


          # Getter shortcuts
          chapter : (chapterId)=>
              # Fetch the chapters list
              _.find @chapters or [], (chapter)-> chapter.id is chapterId

          scene   : (chapterId, sceneId)=>
              chapter = @chapter(chapterId) or {}
              # Fetch the chapters list and its scenes
              _.find chapter.scenes or [], (scene)-> scene.id is sceneId

          sequence: (chapterId, sceneId, sequenceIdx)=>
              # Find a scene, inside a chapter, then takes the given element
              scene = @scene(chapterId, sceneId) or { sequence: [] }
              scene.sequence[sequenceIdx]

]

# EOF
