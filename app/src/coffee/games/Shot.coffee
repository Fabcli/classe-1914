angular.module('classe1914.game').factory 'Shot', [
    '$rootScope'
    'User'
    'Notification'
    ($rootScope, User, Notification)->
        new class Shot
                #-----------------------------------//
            create: ->
                @spacebar = @input.keyboard.addKey(Phaser.Keyboard.SPACEBAR)
                @b_key = @input.keyboard.addKey(Phaser.Keyboard.B)
                @z_key = @input.keyboard.addKey(Phaser.Keyboard.Z)
                @f_key = @input.keyboard.addKey(Phaser.Keyboard.F)
                @cursors = @input.keyboard.createCursorKeys()

                # Coordonnée du fusil
                @shotgunPosX = 960
                @shotgunPosY = 1080

                #On met le score à 0
                @score = 0
                @gameover = false #Le jeu n'est pas terminé
                @totalTargets = 22 #On définit le nombre de cibles
                @timerDuration = 10 #On définit le jeu à 30s
                @buildWorld() #On lance le fonction de création du monde
                @buildScore() #On lance la fonction de création du score
                @buildTimer() #On lance la fonction de création du timer
                @keyFullScreen() #On lance la fonction de création du lancement de plein écran (touche F)


            #Objets du DOM------
            buildWorld: ->
                @add.sprite 0, 0, "bg" #On ajoute l'image de fond
                @buildTargets() #Fonction de création des cibles
                @buildExplosion() #Fonction de création de l'anim d'explosion de la balle
                @buildShotgun() #Fonction d'ajout du fusil
                @activeShot() #Fonction qui active le tir (les commandes clic et barre d'espace)
                @cameraSettings() #Fonction de réglages de la caméra

            buildTargets: ->
                @targetGroup = @add.group() #On déclare le groupe composé des cibles
                @targetGroup.enableBody = true
                i = 0

                while i < @totalTargets
                    #targetX = Math.floor((@shotgunPosX/2) + Math.random() * (@world.width-(@shotgunPosX/2))) #Abscisses aux extremité du monde - 1/2 position du fusil
                    targetX = @rnd.realInRange(@shotgunPosX, @world.width-@shotgunPosX) #//Ordonnées entre 280 et 380. REM: Les deux méthodes pour x et y donne le même résultat.
                    targetY = @rnd.realInRange(@shotgunPosY-120, @shotgunPosY-20) #//Ordonnées entre 280 et 380. REM: Les deux méthodes pour x et y donne le même résultat.
                    t = @targetGroup.create(targetX, targetY, "target")
                    t.anchor.setTo 0.5, 0.5 #On centre le point d'ancrage des cibles
                    scale = @rnd.realInRange(0.2, 1.0) #On fait des tailles différentes (coeff mini, coeff max)
                    t.scale.x = t.scale.y = scale # On affecte ca aux hauteurs et largeurs
                    @physics.enable t, Phaser.Physics.ARCADE #Les comportements d'arcades
                    t.enableBody = true #On active le body à chaque cible
                    i++

            buildShotgun: ->
                @shotgun = @add.sprite(@shotgunPosX, @shotgunPosY, "shotgun") #On ajoute le fusil
                @shotgun.fixedToCamera = true #On le fixe à l'écran
                @shotgun.anchor.setTo 0.4, 0.8 #On l'ancre par rapport au centre bas
                @shotgun.animations.add "shotAnim", [ 0, 1, 2, 3, 0 ], 60, false #Ajoute l'animation et on ne la lit pas en boucle

            buildExplosion: ->
                @shotExplosion = @add.emitter(@shotgunPosX-11, @shotgunPosY-125, 100) #Ajoute l'emetteur des particules (x,y,nombre maximum de particules créées)
                @shotExplosion.fixedToCamera = true #On le fixe à l'écran
                #@shotExplosion.cameraOffset = new Phaser.Point(949,895) #On fixe le bug de Phaser 2.3.0 qui ne recopie pas les coordonnées apres avoir fixé à la caméra
                @shotExplosion.minParticleScale = 0.2 #Coeff miniùum de taille des particules
                @shotExplosion.maxParticleScale = 2 #Coeff maximum de taille des particules
                @shotExplosion.minParticleSpeed.setTo -100, 100 #Vélocité minimum
                @shotExplosion.maxParticleSpeed.setTo 100, -100 #Vélocité max
                @shotExplosion.makeParticles "shot" #On crêe les particules à partir de l'image 'shot'

            #Reglages de Caméra------
            cameraSettings: ->
                @camera.focusOnXY @world.centerX, @world.centerY #On centre la camera dans le monde

            keyFullScreen: ->
                @f_key.onDown.add @enterFullScreen, this #Passe en plein écran  lorsqu'on appuie sur la touche F

            enterFullScreen: ->
                @scale.startFullScreen()


            #Timer et score------
            buildScore: ->
                @scoreStyle =
                    font: "16px Courier"
                    fill: "#fff"
                    stroke: "#6a9f3a"
                    strokeThickness: 1
                    align: "center"

                @scoreText = @add.text(20, 12, "Score : " + @score, @scoreStyle)
                @scoreText.fixedToCamera = true #On le fixe à l'écran

            buildTimer: ->
                @timeContainer = @add.sprite(20, 70, "timeContainer") #On ajoute le conteneur de la timebar.
                @timeBar = @add.sprite(20, 70, "timeBar") #On ajoute le conteneur de la timebar.
                @timeBarWidth = @timeBar.width #On prend la taille initiale de la barre des temps
                #this.timeBar.width = 0;//On définit la barre des temps à 100% de sa taille
                @timeContainer.fixedToCamera = @timeBar.fixedToCamera = true #On les fixe à l'écran
                @timerLeft = @timerDuration #Le temps restant est égal au chrono de départ
                @timerText = @add.text(20, 40, "Chrono : " + @timerLeft + " s", @scoreStyle)
                @timerText.fixedToCamera = true #On le fixe à l'écran


            #-----------------------------------//
            update: ->
                if @gameover is false
                    @moveWorld() #Le déplacement dans le monde
                    @updateTimer() #On lance le timer
                    @collideTarget() #Fonction d'écoute de la collision tir-cible

            collideTarget: ->
                if @gameover is false
                    if @totalTargets > 0
                        @physics.arcade.overlap @targetGroup, @shotExplosion, @targetShot, null, @ #La fonction targetShot(this.targetGroup,this.shotExplosion) sera executée lorsque une des cibles appartenant au targetGroup sera en collision avec une particule de shotExplosion...
                    else
                        @point = @score + @timerLeft
                        @gameoverContain = "BRAVO \nTu as eu toutes les cibles.\n\nScore: " + @score + "\nDons un bonus temps: " + @timerLeft #On félicite le joueur et on lui attribue un bonus des secondes qu'il reste
                        @gameOver() #On lance la fonction gameOver

            activeShot: ->
                @input.onDown.add @shotAction, @ #Active la fonction d'action de tir au clic
                @spacebar.onDown.add @shotAction, @ #Active la fonction d'action de tir lorsqu'on appuie sur la barre d'espace

            shotAction: ->
                if @gameover is false
                    @shotgun.animations.play "shotAnim" #L'animation du fusil qui tire
                    @shotExplosion.start true, 10, null, 1 #Les particules de shoot (type explosion ou non, durêe de vie en ms, frequence, quantité, forceQuantity)
                    @shotSound = @add.audio("shot", 0.3) #On ajoute le son de shot avec 30% de volume
                    @shotSound.play() #On le lance

            moveWorld: ->
                if @gameover is false
                    if @cursors.left.isDown
                        @camera.x -= @cursors.left.duration * 0.1 #On déplace la camera en fonction de la durée d'appui sur la touche, ce sera la même chose pour toutes les touches
                    else @camera.x += @cursors.right.duration * 0.1  if @cursors.right.isDown
                    if @cursors.up.isDown
                        @camera.y -= @cursors.up.duration * 0.08
                    else @camera.y += @cursors.down.duration * 0.08  if @cursors.down.isDown

            targetShot: (target, shot) ->
                target.kill() #Détruit la cible "t"
                @targetShotSound = @add.audio("break_target", 0.8) #On ajoute le son de la cible touchée à 80% de volume
                @targetShotSound.play() #On le lance
                @totalTargets-- #Réduit le nombre de cibles
                @score++ #Augmente le score
                #@scoreText.text = "Score : " + @score

            updateTimer: ->
                if @gameover is false
                    if @timeBar.width > 0
                        elapsedSeconds = (@timerDuration - @time.totalElapsedSeconds()) #Le décompte des secondes du timer
                        @timerLeft = Math.round(elapsedSeconds)
                        @timeBar.width = @timeBarWidth * elapsedSeconds / @timerDuration #Réduit la taille de la timeBar
                        @timerText.text = "Chrono : " + @timerLeft + " s"
                    else
                        @point = @score - @totalTargets
                        @gameoverContain = "L'entrainement est terminé \nTu n'as plus de temps \n\nScore: " + @score + "\n\n Dont un malus cible: -" + @totalTargets
                        @gameOver()


            #-----------------------------------//
            gameOver: ->
                User.nextSequence()
                @gameover = true #On active la variable gameover qui empêche les actions du joueur
                #game.destroy()
                @gameoverCurtain = @add.sprite(@camera.x, @camera.y, "curtain") #On ajoute un rideau masquant le jeu
                @gameoverStyle =
                    font: "35px Arial"
                    fill: "#fff"
                    stroke: "#6a9f3a"
                    strokeThickness: 1
                    align: "center"
                gameoverTextPositionX = @camera.x + (@game.width / 2) #Position du texte centré en x
                gameoverTextPositionY = @camera.y + (@game.height / 3) #Position du texte au tiers en y
                @gameoverText = @add.text(gameoverTextPositionX, gameoverTextPositionY, @gameoverContain, @gameoverStyle) #On place le texte en fonction du type de fin
                @gameoverText.anchor.set 0.5 #On centre le texte

                Notification.error @gameoverContain
                # On ajoute les points au niveau du jeu global
                User.indicators.point += @point
                #User.indicators.point += @point
                # On lance la sequence suivante puis on detruit le jeu au bout de 1,5s
                setTimeout ( ->
                    @game.destroy() if @game?
                    User.nextSequence()
                ), 2000


            render: ->

                #@game.debug.text('Position de la cam => x: '+this.camera.x+',y: '+ this.camera.y, 140, 32);
                #@game.debug.text('Taille du text game over: ' +this.gameoverText.width, 140, 64);
                #@game.debug.text('Taille du monde: ' + this.world.width, 140, 64);

]