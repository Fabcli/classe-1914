angular.module('classe1914.config').config ['LightboxProvider', 'constant.settings', (LightboxProvider, settings) ->

    LightboxProvider.templateUrl = 'partials/lightbox.html'

    LightboxProvider.getImageUrl= (image) =>
        #TODO : warning for the future organisation of the medias
        image.url

    LightboxProvider.getImageCaption= (image) =>
        image.title

]
#EOF
