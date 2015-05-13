angular.module('classe1914.config').config ['$sceDelegateProvider', ($sceDelegateProvider)->
    $sceDelegateProvider.resourceUrlWhitelist ['self', 'https://vimeo.com/**', 'https://*.vimeo.com/**', 'https://player.vimeo.com/video/**']
]
# Protection about URLs used for sourcing Angular templates => https://docs.angularjs.org/api/ng/provider/$sceDelegateProvider
