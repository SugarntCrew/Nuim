package backend.api;

import haxe.io.Bytes;
import openfl.net.URLRequest;
import openfl.events.IOErrorEvent;
import openfl.events.Event;
import openfl.events.ProgressEvent;
import openfl.net.URLLoader;
import ui.games.Heroe.HeroeParams;
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

typedef HeroeDownloadParams =
{
    var download:Bool;
    var replace:Bool;
}

class GamebananaAPI
{
    public static function saveImageFromURL(imageurl:String, modId:String, path:String)
    {
        if(FileSystem.exists(Paths.gamebananaAPIimage(path))) return;
        trace('Did not find ${Paths.gamebananaAPIimage(path)}. Downloading from GameBanana...');
        
        var http = new Http(imageurl);
        http.onBytes = function(bytes)
        {
            if(!FileSystem.exists('assets/images/cache/games/portal/$modId')) FileSystem.createDirectory('assets/images/cache/games/portal/$modId');
            if(!FileSystem.exists('assets/images/games/heroes')) FileSystem.createDirectory('assets/images/games/heroes');

            File.saveBytes(Paths.gamebananaAPIimage(path), bytes);
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
        // trace(modId);

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
        //trace(apiImagesLink);
        var http = new Http(apiImagesLink);
        http.onData = function(data)
        {
            var jsonRaw:Dynamic = Json.parse(data);
            callback(jsonRaw, modId);
        }

        http.request(false);
    }

    public static function fetchImages(modUrl:String, mainThread:Thread, ?heroeDownloadParams:HeroeDownloadParams)
    {
        Thread.create(() -> {
            var localImageNum:Int = 0;
            var heroeUrl:String = '';
            var targetHeroeIndex:Int = 0;
            requestData(modUrl, [IMAGES], function(apiData, id)
            {
                var images = apiData._aPreviewMedia._aImages;
                for(num => image in cast(images, Array<Dynamic>))
                {
                    var imageUrl = '${image._sBaseUrl}/${image._sFile}';
                    //trace(imageUrl);
                    GamebananaAPI.saveImageFromURL(imageUrl, id, 'cache/games/portal/$id/image$num');
                    localImageNum++;

                    if(num == targetHeroeIndex) heroeUrl = imageUrl;

                    mainThread?.sendMessage({
                        type: 'images_process',
                        imagesDownloaded: localImageNum,
                        imagesTotal: images.length
                    });
                }

                if(heroeDownloadParams.download) 
                {
                    if(FileSystem.exists('assets/images/games/heroes/${id}_heroe') && !heroeDownloadParams.replace) return;

                    mainThread?.sendMessage({
                        type: 'heroe_download',
                        modId: id
                    });

                    GamebananaAPI.saveImageFromURL(heroeUrl, id, 'games/heroes/${id}_heroe');
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

    public static function getModIdFromUrl(modUrl:String):String
    {
        return modUrl.substr(modUrl.length - 6, modUrl.length);
    }

    public static function downloadGamebananaBuild(downloadUrl:String, path:String, onProgressCallback:(loaded:Float, total:Float)->Void, onCompleteCallback:(path:String)->Void)
    {
        //Thread.create(() -> {
            var loader:URLLoader = new URLLoader();
            loader.dataFormat = BINARY;

            loader.addEventListener(ProgressEvent.PROGRESS, function(e:ProgressEvent) 
            {
                if(onProgressCallback != null) onProgressCallback(e.bytesLoaded, e.bytesTotal);
                // trace('${e.bytesLoaded}/${e.bytesTotal}');
            });

            loader.addEventListener(Event.COMPLETE, function(e:Event)
            {
                trace('BUILD COMPLETEEE!!!');

                var data = loader.data;

                var index = path.lastIndexOf('/');
                var folderPath = path.substr(0, index);
                trace(path);
                trace(folderPath);
                if(!FileSystem.exists(folderPath)) FileSystem.createDirectory(folderPath);
                File.saveBytes(path, data);
                
                if(onCompleteCallback != null) onCompleteCallback(path);
            });

            loader.addEventListener(IOErrorEvent.IO_ERROR, function(e)
            {
                trace('Download failed! ${e.text}');
            });

            var request = new URLRequest(downloadUrl);
            loader.load(request);
        //});
    }
}