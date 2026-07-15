package backend;

import sys.FileSystem;

class Paths
{
    private inline static var image_extension:String = '.png';
    private inline static var sound_extension:String = '.ogg';
    private inline static var font_extension:String = '.ttf';

    public inline static function image(path:String):String
    {
        if(!FileSystem.exists('assets/images/$path$image_extension')) trace('Did not found the image at path assets/images/$path$image_extension');
        return 'assets/images/$path$image_extension';
    }

    public inline static function gamebananaAPIimage(path:String):String
    {
        if(!FileSystem.exists('assets/images/$path.jpg')) trace('Did not found the image at path assets/images/$path.jpg');
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
}