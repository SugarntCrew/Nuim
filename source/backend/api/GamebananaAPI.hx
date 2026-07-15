package backend.api;

import sys.FileSystem;
import sys.io.File;
import haxe.Http;

class GamebananaAPI
{
    public static function saveImageFromURL(url:String, fileName:String)
    {
        if(FileSystem.exists(Paths.image('cache/games/portal/$fileName'))) return;
        
        var http = new Http(url);
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