angular.module('classe1914.constant').constant 'constant.case',

    case :
        #initial settings for User.case
        data        :   no
        ready       :   no
        open        :   no
        # The archives id open in the case on a new game
        unlocked    :   []
        starred     :   []
        viewed      :   []
        thisChapter :   []
        # The choice for the menu
        menu        :   "all"
        archive     :
            open    :   no
            zoom    :   true
            id      :   {}
    notification :
        # The default message for new archive unlocked in case
        archive :   "Archive dans le jeu !"
        case    :   "Nouvelle archive débloquée dans la valise!"


