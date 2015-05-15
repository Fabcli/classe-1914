1. Noms des fichiers
=================

Les noms des fichiers json représentent les nom des parties, chapitre et scene :
*   Par exemple le fichier 2.3.4.json est le fichier décrivant la partie 2 ("LA GUERRE"), le chapitre 3 et la scene 4.
*   On peut avoir un fichier 2.3.4-1 et un fichier 2.3.4-2 si plusieurs possibilités existent




2. Partie
=========

Pour le fichier **1.json**, on aura simplement :
        
        {
            "title" : "AVANT-GUERRE" 
        }




3. Chapitre
===========

Pour le fichier **1.5.json**, on aura donc 
        
        {
            "title" : "La fête forraine" 
        }

pour afficher le titre "La fête forraine" ou
        
        {
            "title" : null
        }
        

si on ne veut pas afficher de titre au chapitre


4. Scène
========

| paramètres 	| notes                                                                         	|
|------------	|------------------------------------------------------------------------------:	|
| next_scene 	| peut être `null`mais nécessaire pour une scene sans sequence de type `choice` 	|
| decor      	| type, date, place, arrière plan, background_transition, soundtrack, result                    	|
| sequence   	|                                                                               	|


-> Les Paramètres
------------------

Il sont au nombre de 3 :

* next_scene
* decor
* sequence

### 1. next_scene

Le paramètre `next_scene` peut-être **null**, **une chaine** représentant une scène ("2.2.2" par exemple), **un objet avec une condition** sur une variable :
* la scène suivante sera défini en fonction d'une réponse ou du résultat d'un mini-jeu :
        
        "next_scene" : null
               
* la scène suivante sera la 2.2.2 :
        
        "next_scene" : "2.2.2"
        
* si la santé est positif ( >=50 ), aller à la scène 2.2.2 et si elle est négative, aller à la scene 2.2.1
     
        "next_scene" : 
		{
            "positif_health" : "2.2.2",
            "negatif_health" : "2.2.1"
       	 }

* utilisation dùn coefficient de chance :30 % de chance d'aller à la scène 2.2.2 et 70% de chance d'aller à la scene 2.2.1
     
        "next_scene" : [
		     {
          		"value" : "2.2.2",
          		"percentage" : 30
        	  },
		     {
                "value": "2.2.1,
                "percentage": 70
		     }
	    ]
    
### 2. decor #

#### 2.1. type #

On a trois possibilités de type de décor :
* `img`qui représente un fond d'écran avec une image fixe (png, jpeg ou gif) ou une image animéé (gif animé)
* `video_background` qui sera un background video
* `interactive` qui sera un plan interactif => **ATTENTION IL RESTE A DEFINIR SON FONCTIONNEMENT EN JSON** 

#### 2.2. date et place #

La date et le lieu de la scène qui s'affichera dans un encart à la manière des bd

#### 2.3. body #

Contient un lien vers le media, on donne le chemin du fichier
    
    /medias/partie1/illustrations/1.5.2.png 

ou 

    /medias/partie1/video/1.5.4.mp4

#### 2.4. background_transition #

Le type de transition pour le passage à l'ecran suivant

* `"fade"`ou `null, le null represente un cut

#### 2.5. transition_duration #

La durée de la transition se note de deux manières :
* En **chaîne**, soit `"transition_duration": "slow"`, soit `"transition_duration": "fast"`
* En **nombre** qui sera donné en milliseconde `"transition_duration": 1500

#### 2.6. soundtrack #

La musique d'ambiance, ou on donne  le chemin du fichier :
* `/medias/partie1/soundtrack/1.5.2.mp3`

#### 2.7. delay #

Le delai en seconde avant de lancer la sequence :
* `"delay": 12`

#### 2.8. result #

Les modification des variables au passage de cette scene
    
        "result": {
            "mood": 2
            "luck": -4
            "score": 12
        }

#### 2.9. case #

Les archives de la valise à ouvrir, sous forme de tableau :

        "case": [
            12,
            14
        ]



### 3. Séquences

Un évenement (appelé aussi "plan") peut être bloquant ou pas. Il est bloquant s'il nécessite d'être terminé pour enchainer sur l'évenement suivant de la séquence.
* Chaque évenement peut avoir **un paramètre "condition"**. Dans ce cas là, le plan ne s'affiche que si la condition est remplie : 

        "condition": {"personnal_parameter_1":true, "personnal_parameter_3: true}
    
  Ici `personnal_parameter_1` __ET__ `personnal_parameter_3` doivent être vrais pour afficher le plan en question.
    
* Chaque évenement peut avoir **un paramètre "result"**. Ce dictionnaire permet d'incrémenter ou décrémenter les variables `health`, `luck`, `mood` et `score`. On peut aussi y ajouter des conditions du genre `personnal_parameter_2`


##### 3.1. Les types de sequences et leurs attributs

* Les deux types qui vont définir lès scenes suivantes sont `choice` et `game` sìl n'y en a pas, le paramètre `ext_scene` doit être précisée à la racine du json
* Comme le type `interactive` induit des aller-retour sur les sènes, il faut que je le definisse plus tard.


| types            |  bouton next à la fin | bloquant | paramètres                                                                              |
|:---------------- |:---------------------:|:--------:|----------------------------------------------------------------------------------------:|
| dialogue         |                     ✓ |        ✓ | header, delay, body, character, result, condition, archive, case                        |
| narrative        |                     ✓ |        ✓ | body, delay, result, condition, archive, case                                           |
| voixoff          |                     ✕ |        ✓ | delay, body, character, result, condition, archive, case                                |
| game             |                     ✕ |        x | body, delay, result, options(list), condition, archive, case                            |
| interactive      |                     ✕ |        ✓ | __A PRECISER__                                                                          |
| video            |                     ✓ |        ✓ | body, delay, result, condition, case                                                    |
| video_background |                     ✓ |        ✓ | body, delay, result, condition, case, button_next                                                    |
| notification     |                     ✓ |        ✓ | body, delay, header, sound, result, condition, archive, case                            |
| new_background   |                     ✕ |        ✕ | body, type,  delay, transition, transition_duration result, condition, archive, case    |
| choice           |                     ✕ |        ✓ | body, delay, result, default_option, options(list), condition, archive, case            |

* Si `choice` ou `game` n'est pas spécifié, le paramètre `next_scene` doit être renseigné dans l'objet `scene`.
* Tous les types ont une option archives possibles avec :
    * `archive_button` qui donnera le texte de la zone de notification pour ouvrir les archives
    * archive_params` qui contient un tableau de cette forme :
   
              "archive_button": "Voir les archives",
              "archive_params" : [
                  {
                      "url": "/medias/chap1/archives/archive1.jpg",
                      "cote": "archive1"
                  },
                  {
                      "url": "/medias/chap1/archives/archive2.jpg",
                      "cote": "archive2"
                  }
              ]
        

##### 3.1.1. Les encarts type bulle 

###### -> dialogue

Le `dialogue` sera un texte affiché avec :
   * un bouton next,
   * un `delay`en seconde,
   * le nom du personnage qui cause => `character`,
   * le texte a dire => `body`,
   * Optionnel:
      * `header` est une sorte de didascalie du genre (en rougissant),
      * `result` qui inluence les variables,
      * `condition` pour que le dialogue s'affiche,
      * `case` a debloquer

###### -> narrative

Les plans `narrative`  sont identiques aux dialogues sans le character` !

###### -> notification

Une notification sera un texte affiché sous forme de bulle ou d'encart à une place différente des dialogues et des narration :

   * un bouton next/skip,
   * un `delay`en seconde,
   * le nom du personnage qui cause => `character,
   * le texte a dire => `body`,
   * Optionnel:
      * `header` est une sorte de didascalie du genre (en rougissant),
      * `result` qui inluence les variables,
      * `condition` pour que le dialogue s'affiche,
      * `case` a debloquer

###### -> voixoff

La voix off sera un lecteur audio avec :
   
   * le `delay`en seconde qui fera passer à l'evenement suivant,
   * le nom du personnage qui cause => `character,
   * le chemin du fichier mp3 => `body`,
   * Optionnel:
      * `result` qui inluencera les variables,
      * `condition` pour que le dialogue s'affiche,
      * `case` a debloquer
      * `archive` => `true` ou `false` pour afficher une lightbox avec des documents d'archives

##### 3.1.2 Le type new_background

Le nouveau background ressemble au type de decor defini précedemment  :

   * un `"body"` qui donne le lien vers le media,
   * un `"type"` soit `"image"`, `"video"`, `"interactive"`
   * une `transition` => `"fade"`ou `null`
   * une `transition_duration
   * un `"delay"`en seconde,
   * Optionnel:
      * `result` qui inluence les variables,
      * `condition` pour que le new_background s'affiche,
      * `archives` a débloquer

#### 3.2. Les types choice & game

##### 3.2.1 Le type choice

Le `choice` s'affiche au centre du jeu et a comme option :
    
   * un `"default_option"` qui donne l'option activée après l'écoulement du delai,
   * un `"delay"`en seconde,
   * une list d' `options` avec
      * un `header` qui sera la proposition à afficher => `"choix 1"` ou `"choix 2"
      *  `next_scene`
      * Optionnel:
          * `result` qui inluence les variables,
          * `condition` pour que le choix s'affiche,
          * `archives` a débloquer
    
##### 3.2.1 Le type game

Le `game` s'affiche au plein écran et offre un jeu :
    
   * un `"body"` qui donne le nom de la fonction javascript sous cette forme > `"body": "NomDuJeu()"
   * une list d' `options` avec
      * un `header` qui sera le resultat du jeu => `true`ou `false` pour la c-victoire ou la defaite
      * `next_scene`
      * Optionnel:
          * `result` qui inluence les variables,
          * `archives` a débloquer




5. Exemple
==========

Pour éditer les fichier json, vous pouvez utiliser cet editeur dédié plus soutenu depuis 2011 : [This link](http://mac.softpedia.com/get/Development/Editors/Jason.shtml#download)Jason ou un éditeur de texte gratuit type [This link](http://www.barebones.com/products/textwrangler/TextWrangler) ou [This link](http://brackets.io)Bracket.
J'ai aussi trouvé un éditeur plutot bien fait sur mac à environ 6€ et avec une demo de 30 jours [This link](http://www.cocoajsoneditor.com) Cocoa JSON

        {
          "next_scene" : null,
          "decor" : [
            {
              "type" : "img",
              "body" : "/medias/partie1/illustrations/1.5.2.png",
              "background_transition" : "fade",
              "transition_duration" : "fast",
              "soundtrack" : "/medias/partie1/soundtrack/1.5.2.mp3",
              "delay" : 12,
              "archives" : []
            }
          ],
          "sequence" : [
            {
              "type" : "dialog",
              "character" : "Pierre",
              "body" : "T'as de beau yeux, tu sais ?",
              "header" : true,
              "delay" : 12,
              "archive_button": "Voir les archives de fou",
              "archive_params" : [
                {
                    "url": "/medias/chap1/archives/archive1.jpg",
                    "cote": "archive1"
                },
                {
                    "url": "/medias/chap1/archives/archive2.jpg",
                    "cote": "archive2"
                }
              ]
            },
            {
              "type" : "dialog",
              "character" : "Michèle M",
              "body" : "Embrassez-moi",
              "header" : true,
              "delay" : 13,
              "result" : {
                "mood" : 22
              }
            },
            {
              "condition" : "personal_parameter_1",
              "type" : "new_background",
              "body" : "/medias/partie1/illustrations/1.5.3-1.png",
              "background_transition" : "fade",
              "transition_duration" : 800
            },
            {
              "type" : "choice",
              "body" : "Faites un choix",
              "character" : "Pierre",
              "header" : "Pierre",
              "delay" : 15,
              "sound" : "/medias/partie1/sound/cat.mp3",
              "next_button" : true,
              "result" : {
                "personnal_parameter" : true,
                "luck" : -2,
                "health" : 5,
                "mood" : -2
              },
              "default_option" : 2,
              "options" : [
                {
                  "header" : "Oui",
                  "next_scene" : "1.5.3",
                  "archives" : [
                    12,
                    21
                  ],
                  "result" : {
                    "personal_parameter_2" : true,
                    "luck" : 3,
                    "health" : -2,
                    "mood" : 5
                  }
                },
                {
                  "header" : "Non",
                  "next_scene" : "1.5.4",
                  "activated_archives" : [
                    13
                  ],
                  "result" : {
                    "personal_parameter_3" : true,
                    "luck" : -3,
                    "health" : 2,
                    "mood" : 1
                  }
                }
              ]
            }
          ]
        }
