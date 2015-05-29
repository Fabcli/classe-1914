angular.module('classe1914.constant').constant 'constant.games.interactive.train',

        assets :
            images :
                bg                      :   '/games/interactive/img/CH2_SE1_SC1_TP_PL1.jpg'

            audio :
                ambiance                  :   ['/games/interactive/sound/train_foule.mp3','shot/interactive/sound/train_foule.ogg']


        settings :
            world :
                width                   :   4000
                height                  :   1291

            navigation :
                horizontal              :   true
                vertical                :   false

            audio :
                ambiance :
                    loop                :   true
                    volume              :   0.05
                    fadeIn              :   1500
                    fadeOut             :   1500