angular.module('classe1914.constant').constant 'constant.games.shot',

    demo :

        images :
            bg                      :   '/games/img/game_shot/decor1test-nuitW.jpg'
            target                  :   '/games/img/game_shot/cible.png'
            shot                    :   '/games/img/game_shot/particles/shot.png'
            timeBar                 :   '/games/img/game_shot/timebar.png'
            timeContainer           :   '/games/img/game_shot/timebar-container.png'
            curtain                 :   '/games/img/game_common/curtain_black.png'

        spriteAtlas :
            shotgun :
                path                :   '/games/img/game_shot/sprites/shotgun.png'
                json                :   '/games/data/game_shot/lebel.json'

        spriteSheet :
            explosion :
                path                :   '/games/img/game_shot/sprites/explosion.png'
                width               :   36
                height              :   51
            playButton :
                path                :   '/games/img/game_common/sprites/playButton.png'
                width               :   193
                height              :   71

        audio :
            shot                    :   ['/games/sounds/game_shot/shot.mp3','sounds/game_shot/shot.ogg']
            break_target            :   ['/games/sounds/game_shot/ecrase_pot_yaourt.mp3','sounds/game_shot/ecrase_pot_yaourt.ogg']
