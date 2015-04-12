angular.module("classe1914.filter").filter "crescentOrder", ->
    (array)->
        array.sort(@compareNumber)

        compareNumber: (a, b) =>
            a - b

# EOF