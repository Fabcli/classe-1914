# @source http://stackoverflow.com/questions/11873570/angularjs-for-loop-with-numbers-ranges
angular.module("classe1914.filter").filter "range", ->
    (input, total) ->
        total = parseInt(total)
        i = 0
        while i < total
            input.push i++
        input