angular.module('classe1914.constant').constant 'constant.games.shot.demo',

    assets :
        images :
            bg                      :   '/games/shot/img/decor1test-nuitW.jpg'
            target                  :   '/games/shot/img/cible.png'
            shot                    :   '/games/shot/img/particles/shot.png'
            timeBar                 :   '/games/shot/img/timebar.png'
            timeContainer           :   '/games/shot/img/timebar-container.png'
            curtain                 :   '/games/common/img/curtain_black.png'

        spriteAtlas :
            shotgun :
                path                :   '/games/shot/img/sprites/shotgun.png'
                json                :   '/games/shot/data/lebel.json'

        spriteSheet :
            explosion :
                path                :   '/games/shot/img/sprites/explosion.png'
                width               :   36
                height              :   51
            playButton :
                path                :   '/games/common/img/sprites/playButton.png'
                width               :   193
                height              :   71

        audio :
            shot                    :   ['/games/shot/sound/shot.mp3','shot/sound/shot.ogg']
            break_target            :   ['/games/shot/sound/ecrase_pot_yaourt.mp3','/games/shot/sound/ecrase_pot_yaourt.ogg']
            ambiance                :   ['/games/interactive/sound/train_foule.mp3','shot/interactive/sound/train_foule.ogg']

    settings :
        world :
            width                   :   4000
            height                  :   1338

        audio :
            ambiance :
                loop                :   true
                volume              :   0.2
                fadeIn              :   1500
                fadeOut             :   1500
