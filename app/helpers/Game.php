<?php

namespace app\helpers;
use RedBean_Facade as R;

class Game {


    protected static $story ;

    public static function getStory($hero=NULL,$opening_dates=NULL) {
        /**
         * Return the story (character + chapter + scene + sub-scene).
         * If an opening_dates array is given, takes care about the returned chapters.
         * TODO:TO DELETE [GREG]
         */
        if (!isset(self::$story)) {
            $response = array();
            $chapters = glob('data/chapters/'.$hero.'/[0-9*].json', GLOB_BRACE);
            foreach ($chapters as $chapter_filename) {
                $chapter_number = basename($chapter_filename, ".json");
                $content        = file_get_contents($chapter_filename);
                $chapter        = json_decode($content, true);
                $opening_date   = isset($opening_dates[$chapter_number]) ? $opening_dates[$chapter_number] : null;
                // if there is an opening date, compare it with today : keep only opened chapters
                if(empty($opening_date) || strtotime(date('Y-m-d H:i:s')) >= strtotime($opening_date))  {
                    // retrieve scenes files for the current chapter
                    $scenes  = glob('data/chapters/'.$hero.'/'.$chapter_number.'.?*.json', GLOB_BRACE);
                    $chapter['id']           = $chapter_number; # add the id from filename
                    $chapter['opening_date'] = $opening_date; # add the opening_date from config into the chapter object
                    $chapter['scenes']       = array();
                    foreach ($scenes as $scene_filename) {
                        $content     = file_get_contents($scene_filename);
                        $scene       = json_decode($content, true);
                        $scene["id"] = implode(array_slice(explode(".", basename($scene_filename, ".json")), 1)); # add the id from filename
                        $chapter['scenes'][] = $scene;
                    }
                    $response[] = $chapter;
                }
            }
            self::$story = $response;

        }
        return self::$story;
    }

    public static function getIntro($opening_dates=NULL) {
        /**
         * Return the story (character + chapter + scene + sub-scene).
         * If an opening_dates array is given, takes care about the returned chapters
         */

        if (!isset($intro)) {
            $response = array();
            $chapters = glob('data/introduction/[0-9*].json', GLOB_BRACE);
            foreach ($chapters as $chapter_filename) {
                $chapter_number = basename($chapter_filename, ".json");
                $content        = file_get_contents($chapter_filename);
                $chapter        = json_decode($content, true);
                $opening_date   = isset($opening_dates[$chapter_number]) ? $opening_dates[$chapter_number] : null;
                // if there is an opening date, compare it with today : keep only opened chapters
                if(empty($opening_date) || strtotime(date('Y-m-d H:i:s')) >= strtotime($opening_date))  {
                    // retrieve scenes files for the current chapter
                    $scenes  = glob('data/introduction/'.$chapter_number.'.?*.json', GLOB_BRACE);
                    $chapter['id']           = $chapter_number; # add the id from filename
                    $chapter['opening_date'] = $opening_date; # add the opening_date from config into the chapter object
                    $chapter['scenes']       = array();
                    foreach ($scenes as $scene_filename) {
                        $content     = file_get_contents($scene_filename);
                        $scene       = json_decode($content, true);
                        $scene["id"] = implode(array_slice(explode(".", basename($scene_filename, ".json")), 1)); # add the id from filename
                        $chapter['scenes'][] = $scene;
                    }
                    $response[] = $chapter;
                }
            }
            $intro = $response;
        }
        return $intro;
    }

    public static function getStoryWithParts($opening_dates=NULL)  {
        /**
         * Return the story (part + chapter + scene + sequence).
         * TODO:add & hero parameter
         */
        if (!isset(self::$story)) {
            $response = array();
            $hero = 'louis';
            $parts = glob('data/chapters/'.$hero.'/[0-9*].json', GLOB_BRACE);
            foreach ($parts as $part_filename) {
                $part_number        = basename($part_filename, ".json");
                $content            = file_get_contents($part_filename);
                $part               = json_decode($content, true);
                $chapters           = glob('data/chapters/'.$hero.'/'.$part_number.'.[0-9*].json', GLOB_BRACE);
                $part['id']         = $part_number; # add the id from filename
                $part['chapters']   = array();
                foreach ($chapters as $chapter_filename) {
                    $chapter_number     = basename($chapter_filename, ".json");
                    $content            = file_get_contents($chapter_filename);
                    $chapter            = json_decode($content, true);
                    $scenes             = glob('chapters/' . $hero . '/' . $chapter_number . '.?*.json', GLOB_BRACE);
                    $chapter['id']      = implode(array_slice(explode(".", basename($chapter_filename, ".json")), 1)); # add the id from filename
                    $chapter['scenes']  = array();
                    foreach ($scenes as $scene_filename) {
                        $content             = file_get_contents($scene_filename);
                        $scene               = json_decode($content, true);
                        $scene["id"]         = implode(array_slice(explode(".", basename($scene_filename, ".json")), 2)); # add the id from filename
                        $chapter['scenes'][] = $scene;
                    }
                    $part['chapters'] []  = $chapter;
                }
                $response[] = $part;
            }
            self::$story = $response;
        }
        return self::$story;
    }

    public static function computeContext($career){
        /**
         * Compute the context from the given career based on the initial context.
         */
        $context = array( // initial context
            "luck"        => 50,
            "health"      => 100,
            "mood"        => 50,
            "point"       => 0
        );


        $reached_scenes = json_decode($career["scenes"], true);
        $reached_scenes = array_splice($reached_scenes, 0, -1); //  remove last scene because we will do it again
        $choices        = json_decode($career["choices"], true);
        $hero        = json_decode($career["hero"], true);
        //$story          = Game::getStory($hero);
        foreach ($reached_scenes as $scene_id) {
            $scene = Game::getScene($hero,$scene_id);
            // loop over the sequence to compute context from events
            if (isset($scene["sequence"])) {
                foreach ($scene["sequence"] as $event) {
                    // check if there are conditions and if they are satisfied
                    $satisfied = true;
                    if (isset($event["result"]) && isset($event["condition"])) {
                        foreach ($event["condition"] as $key => $value) { // over all the conditions
                            // check from the context and break if conditions are not satisfied
                            $user_val = false;
                            if (isset($context[$key])) {
                                $user_val = $context[$key];
                            }

                            if ($user_val != $value) {
                                $satisfied = false;
                                break;
                            }
                        }
                    }
                    if (isset($event["result"]) && $satisfied) {
                        Game::updateContext($context, $event["result"]);
                    }
                }
            }
            // search if a choice was made for this scene and compute the new context
            if (isset($choices[$scene_id])) {
                $options = Game::getOptionsFromScene($scene);
                if (isset($options[$choices[$scene_id]]["result"])) {
                    Game::updateContext($context, $options[$choices[$scene_id]]["result"][0]);
                }
            }
        }
        return $context;
    }

    private static function updateContext(&$context, $update_to){
        /**
         * Update the $context with the given array $update_to.
         * $update_to looks to array("karma" => -5, "trust" => +10)
         * Respect the range of the given field. See $rules.
         */
        $rules = array(
            "luck"         => array(0, 100),
            "health"     => array(0, 100),
            "mood"       => array(0, 100),
            "point"      => array(0, 10000)
        );

        foreach ($update_to as $key => $value) {
            if (isset($context[$key]) && is_int($value)) {
                if (isset($rules[$key])) {
                    if ($value < 0) {
                        if (is_null($rules[$key][0])) {
                            $context[$key] = $context[$key] + $value;
                        } else {
                            $context[$key] = max($rules[$key][0], $context[$key] + $value);
                        }
                    } else {
                        if (is_null($rules[$key][1])) {
                            $context[$key] = $context[$key] + $value;
                        } else {
                            $context[$key] = min($rules[$key][1], $context[$key] + $value);
                        }
                    }
                } else {
                    $context[$key] += $value;
                }
            } else {
                $context[$key] = $value;
            }
        }
    }

    public static function findCareer($token) {
        /**
         * Return the career for the given token
         */
        $fields = "id, token, created, choices, scenes, hero";
        try {
            // Use the fields above to avoid 'SELECT *'
            $careerRow = R::$f->begin()
                ->select($fields)
                ->from('career')
                ->where('token = ?')
                ->limit(1)
                ->put($token)
                ->get('row');
            // First time try to access to the database:
            // we *must* select all columns
        } catch(\RedBean_Exception_SQL $ex) {
            return R::findOne("career", "token =?", array($token));
        }
        // Convert row values to RedBean's ojects
        $careerBeans = R::convertToBeans('career', array($careerRow) );
        // By default, the Career is null
        $career = NULL;
        // At least one career
        foreach($careerBeans as $bean) {
            $career = $bean;
        }

        return $career;
    }

    public static function getChapter($hero,$chapter_id) {
        /**
         * Return the chapter for the given id (ex: "4")
         */
        $story = Game::getStory($hero);
        foreach ($story as $chapter) {
            if ($chapter["id"] == (string)$chapter_id) return $chapter;
        }
    }

    public static function getScene($hero,$full_scene_id) {
        /**
         * Return the scene for the given id (ex: "4.scene_name")
         */
        $ids        = explode(".", $full_scene_id);
        $chapter_id = $ids[0];
        $scene_id   = $ids[1];
        $chapter    = Game::getChapter($hero,$chapter_id);
        foreach ($chapter['scenes'] as $scene) {
            if ($scene["id"] == $scene_id) return $scene;
        }
    }

    public static function getOptionsFromScene($scene) {
        /**
         * Return the list of option given a $scene object
         */
        foreach ($scene["sequence"] as $event) {
            if ($event["type"] == "choice") {
                return $event["options"];
            }
        }
    }
}


// EOF
