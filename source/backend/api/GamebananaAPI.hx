package backend.api;

import menus.GameInfoState;
import sys.thread.Thread;
import haxe.Json;
import sys.FileSystem;
import sys.io.File;
import haxe.Http;

enum GamebananaPropierties
{
    NAME;
    SUBTITLE;
    DESCRIPTION;
    VERSION;
    DATE_ADDED;
    DATE_MODIFIED;
    IMAGES;
    FILES;
    VIEWS;
    LIKES;
    POSTS;
}

class GamebananaAPI
{
    public static function saveImageFromURL(imageurl:String, modId:String, fileName:String)
    {
        if(FileSystem.exists(Paths.gamebananaAPIimage('cache/games/portal/$modId/$fileName'))) return;
        trace('Did not find ${Paths.gamebananaAPIimage('cache/games/portal/$modId/$fileName')}. Downloading from GameBanana...');
        
        var http = new Http(imageurl);
        http.onBytes = function(bytes)
        {
            if(!FileSystem.exists('assets/images/cache/games/portal/$modId')) FileSystem.createDirectory('assets/images/cache/games/portal/$modId');

            File.saveBytes(Paths.gamebananaAPIimage('cache/games/portal/$modId/$fileName'), bytes);
        }

        http.onError = function(error)
        {
            trace(error);
        }

        http.request(false);
    }

    public static function requestData(modUrl:String, propierties:Array<GamebananaPropierties>, callback:(data:Dynamic, modID:String)->Void)
    {
        var modId:String = modUrl.substr(modUrl.length - 6, modUrl.length);
        trace(modId);

        var strProp:String = '';
        for(num => prop in propierties)
        {
            switch(prop)
            {
                case NAME: strProp += '_sName';
                case SUBTITLE: strProp += '_sDescription';
                case DESCRIPTION: strProp += '_sText';
                case DATE_ADDED: strProp += '_tsDateAdded';
                case DATE_MODIFIED: strProp += '_tsDateModified';
                case IMAGES: strProp += '_aPreviewMedia';
                case FILES: strProp += '_aFiles';
                case VIEWS: strProp += '_nViewCount';
                case LIKES: strProp += '_nLikeCount';
                case POSTS: strProp += '_nPostCount';
                case VERSION: strProp += '_sVersion';
            }

            if(num < propierties.length - 1) strProp += ',';
        }

        var apiImagesLink:String = 'https://gamebanana.com/apiv11/Mod/$modId?_csvProperties=$strProp';
        trace(apiImagesLink);
        var http = new Http(apiImagesLink);
        http.onData = function(data)
        {
            var jsonRaw:Dynamic = Json.parse(data);
            callback(jsonRaw, modId);
        }

        http.request(false);
    }

    public static function fetchImages(modUrl:String, mainThread:Thread)
    {
        Thread.create(() -> {
            var localImageNum:Int = 0;
            requestData(modUrl, [IMAGES], function(apiData, id)
            {
                var images = apiData._aPreviewMedia._aImages;
                for(num => image in cast(images, Array<Dynamic>))
                {
                    var imageUrl = '${image._sBaseUrl}/${image._sFile}';
                    trace(imageUrl);
                    GamebananaAPI.saveImageFromURL(imageUrl, id, 'image$num');
                    localImageNum++;

                    mainThread?.sendMessage({
                        type: 'images_process',
                        imagesDownloaded: localImageNum,
                        imagesTotal: images.length
                    });
                }

                trace('Finished! Reloading images...');

                mainThread?.sendMessage({
                    type: 'images_ready',
                    modId: id,
                    imageNum: localImageNum
                });
            });
        });
    }

    public static function fetchData(modUrl:String, propierties:Array<GamebananaPropierties>, mainThread:Thread)
    {
        Thread.create(() -> {
            requestData(modUrl, propierties, function(apiData, id)
            {
                mainThread?.sendMessage({
                    type: 'metadata_ready',
                    modId: id,
                    name: apiData._sName,
                    subtitle: apiData._sDescription,
                    description: apiData._sText,
                    date_added: apiData._tsDateAdded,
                    date_modified: apiData._tsDateModified,
                    files: apiData._aFiles,
                    views: apiData._nViewCount,
                    likes: apiData._nLikeCount,
                    posts: apiData._nPostCount,
                    version: apiData._sVersion
                });
            });
        });
    }
}