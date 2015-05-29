angular.module('classe1914.game').factory 'Interactive', [
    '$rootScope'
    'User'
    'Notification'
    'LoadGameConstant'
    (Story, User, Notification, LoadGameConstant)->
        new class Interactive
            #-----------------------------------//
            create: ->
                #On recupère les réglage du jeu dans la sequence
                @SETTINGS = LoadGameConstant.LoadSettings()

                #On active le mode arcade
                @physics.startSystem Phaser.Physics.ARCADE
                @cursors = @input.keyboard.createCursorKeys()
                #@click = @input.activePointer

                #  Modifie la taille du monde (de la taille de l'image de fond)
                @world.setBounds 0, 0, @SETTINGS.world.width, @SETTINGS.world.height

                @gameover = false
                @buildWorld() #On lance le fonction de création du monde


            #Objets du DOM------
            buildWorld: ->
                @add.sprite 0, 0, "bg" #On ajoute l'image de fond
                @ambianceSound() #On  lance l'audio de fond
                @cameraSettings() #Fonction de réglages de la caméra

            #Reglages de Caméra------
            cameraSettings: ->
                @camera.focusOnXY @world.centerX, @world.centerY #On centre la camera dans le monde

            ambianceSound: ->
                ambiance = @game.add.audio("ambiance", @SETTINGS.audio.ambiance.volume, @SETTINGS.audio.ambiance.loop) #On ajoute le son de shot avec 0% de volume avec une loop
                ambiance.play()
                ambiance.onLoop.add(->
                    ambiance.play()
                )

            #-----------------------------------//
            update: ->
                if @gameover is false
                    #console.log "scaleFactor"+@game.scale
                    @moveWorld() #Le déplacement dans le monde

            moveWorld: ->
                if @gameover is false
                    if @SETTINGS.navigation.horizontal is true
                        @camera.x -= @cursors.left.duration * 0.1 if @cursors.left.isDown #On déplace la camera en fonction de la durée d'appui sur la touche, ce sera la même chose pour toutes les touches
                        @camera.x += @cursors.right.duration * 0.1  if @cursors.right.isDown
                    if @SETTINGS.navigation.vertical is true
                        @camera.y -= @cursors.up.duration * 0.08 if @cursors.up.isDown
                        @camera.y += @cursors.down.duration * 0.08 if @cursors.down.isDown

            #-----------------------------------//
            gameOver: ->
                #User.nextSequence()
                @gameover = true #On active la variable gameover qui empêche les actions du joueur
                User.indicators.point += @point
                Notification.error @gameoverContain
                #User.indicators.point += @point
                # On lance la sequence suivante puis on detruit le jeu au bout de 1,5s
                setTimeout ( ->
                    User.nextSequence()
                    @game.destroy() if @game?
                ), 2000


            render: ->

#                @game.debug.text('Position de la cam => x: '+@camera.x+',y: '+ @camera.y, @game.width/2, 32);
#                @game.debug.text('Taille du monde: ' + @world.width, @game.width/2, 64);
#                @game.debug.text('Source Ratio: ' + @game.scale.sourceAspectRatio, @game.width/2, 96);
#                @game.debug.text('Ratio: ' + @game.scale.aspectRatio, @game.width/2, 128);
#                @game.debug.text('Movement x: ' +@movementX, @game.width/2, 160);
#                @game.debug.text('Movement Y: ' +@movementY, @game.width/2, 192);
#                @game.debug.text('input x: ' +@input.mouse.event.movementX, @game.width/2, 228);
#                @game.debug.text('input y: ' +@input.mouse.event.movementY, @game.width/2, 260);
]