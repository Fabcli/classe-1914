angular.module('classe1914.service').service 'ThirdParty', ['$http', '$window', ($http, $window) ->
    new class ThirdParty
        constructor: ($http, $window) ->
            @url = "http://classe-1914.gregdesplaces.com/"

        shareOnFacebook: (url=@url, title, excerpt)=>
            feedUrl = "
                https://www.facebook.com/dialog/feed?app_id=1109731455720216&redirect_uri=#{url}"
            shareUrlNew="https://www.facebook.com/dialog/share?app_id=1109731455720216&display=popup&href=#{url}&redirect_uri=#{url}"
            shareUrl = "https://www.facebook.com/sharer/sharer.php?u=#{url}&display=popup&caption=#{title}&description=#{excerpt}"
            $window.open shareUrl, "shareOnFacebook","status=no, scrollbars=no, menubar=no, width=670, height=370"
            yes # https://github.com/angular/angular.js/issues/4853#issuecomment-28491586

        shareOnTwitter: (url=@url)=>
            tweet = "Test share on twitter ? {URL} #classe-1914"
            tweet = tweet.replace "{URL}", @url
            tweet = encodeURIComponent tweet
            shareUrl = "https://twitter.com/share?&text=#{tweet}&url=&"
            $window.open shareUrl, "shareOnTwitter","menubar=no, status=no, scrollbars=no, menubar=no, width=550, height=380"
            yes # https://github.com/angular/angular.js/issues/4853#issuecomment-28491586

]