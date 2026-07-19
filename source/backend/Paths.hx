package backend;

import backend.api.GamebananaAPI;
import sys.FileSystem;

class Paths
{
    private inline static var image_extension:String = '.png';
    private inline static var sound_extension:String = '.ogg';
    private inline static var font_extension:String = '.ttf';

    public inline static function image(path:String):String
    {
        if(!FileSystem.exists('assets/images/$path$image_extension')) #if debug trace('Did not found the image at path assets/images/$path$image_extension'); #else {}  #end
        return 'assets/images/$path$image_extension';
    }

    public inline static function gamebananaAPIimage(path:String):String
    {
        if(!FileSystem.exists('assets/images/$path.jpg')) #if debug trace('Did not found the image at path assets/images/$path.jpg'); #else {} #end
        return 'assets/images/$path.jpg';
    }

    public inline static function music(path:String):String
    {
        return 'assets/music/$path$sound_extension';
    }

    public inline static function sound(path:String):String
    {
        return 'assets/sounds/$path$sound_extension';
    }

    public inline static function font(path:String):String
    {
        return 'assets/fonts/$path$font_extension';
    }

    public inline static function gamebananaDownload(path:String, extension:String):String
    {
        return 'assets/data/builds/$path.$extension';
    }

    public inline static function exeBuild(data:Dynamic):String
    {
        var modId = GamebananaAPI.getModIdFromUrl(data.gamebanana_url);
        var buildFiles = FileUtils.analyseFolder('assets/data/builds/$modId/build', true);
        // trace(buildFiles);
        var exeFileLocation:String = '';
        for(file in buildFiles)
        {
            if(!file.endsWith('.exe')) continue;

            exeFileLocation = file;
            break;
        }

        if(exeFileLocation == '') 
        {
            trace('$exeFileLocation ¿?¿?¿?¿?¿?¿?¿');
            return null;
        }

        trace('$exeFileLocation');
        return '$exeFileLocation';
    }
}