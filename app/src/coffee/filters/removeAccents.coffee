#@ source https://gist.github.com/ccf698e7b71ba22f098a.git
angular.module("classe1914.filter").filter "removeAccents", ->
    (input)->
        console.log "input dans removeAccents AVANT : "+input
        accent = [
            # A, a
            /[\300-\306]/g
            /[\340-\346]/g
            # E, e
            /[\310-\313]/g
            /[\350-\353]/g
            # I, i
            /[\314-\317]/g
            /[\354-\357]/g
            # O, o
            /[\322-\330]/g
            /[\362-\370]/g
            # U, u
            /[\331-\334]/g
            /[\371-\374]/g
            # N, n
            /[\321]/g
            /[\361]/g
            # C, c
            /[\307]/g
            /[\347]/g
        ]

        noaccent = ['A','a','E','e','I','i','O','o','U','u','N','n','C','c']

        i = 0
        while i < accent.length
            input = input.replace(accent[i], noaccent[i])
            i++
        input
        console.log "input dans removeAccents AVANT : "+input

