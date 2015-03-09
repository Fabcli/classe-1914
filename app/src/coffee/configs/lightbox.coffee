angular.module('classe1914.config').config ['LightboxProvider', 'constant.settings', (LightboxProvider, settings) ->

    LightboxProvider.templateUrl = 'partials/lightbox.html'

    LightboxProvider.getImageUrl= (image) =>
      settings.mediaUrl + image.url
]
#EOF
