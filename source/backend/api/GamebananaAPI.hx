package backend.api;

import haxe.Json;
import sys.FileSystem;
import sys.io.File;
import haxe.Http;

enum GamebananaPropierties
{
    NAME;
    DESCRIPTION;
    IMAGES;
}

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

    public static function requestData(modUrl:String, propierties:Array<GamebananaPropierties>, callback:(Dynamic)->Void)
    {
        var modId:String = modUrl.substr(modUrl.length - 6, modUrl.length);
        trace(modId);

        var strProp:String = '';
        for(num => prop in propierties)
        {
            switch(prop)
            {
                case NAME: strProp += '_sName';
                case DESCRIPTION: strProp += '_sDescription';
                case IMAGES: strProp += '_aPreviewMedia';
            }

            if(num < propierties.length - 1) strProp += ',';
        }

        var apiImagesLink:String = 'https://gamebanana.com/apiv11/Mod/$modId?_csvProperties=$strProp';
        trace(apiImagesLink);
        var http = new Http(apiImagesLink);
        http.onData = function(data)
        {
            var jsonRaw:Dynamic = Json.parse(data);
            callback(jsonRaw);
        }

        http.request(false);
    }
}