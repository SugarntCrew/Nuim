package backend.api;

import sys.FileSystem;
import sys.io.File;
import haxe.Http;

class GamebananaAPI
{
    public static function saveImageFromURL(imageurl:String, fileName:String)
    {
        if(FileSystem.exists(Paths.image('cache/games/portal/$fileName'))) return;
        trace('Did not find ${Paths.image('cache/games/portal/$fileName')}. Downloading from GameBanana...');
        
        var http = new Http(imageurl);
        http.onBytes = function(bytes)
        {
            if(!FileSystem.exists('assets/images/cache/games/portal/')) FileSystem.createDirectory('assets/images/cache/games/portal/');

            File.saveBytes(Paths.image('cache/games/portal/$fileName'), bytes);
        }

        http.onError = function(error)
        {
            trace(error);
        }

        http.request(false);
    }
}