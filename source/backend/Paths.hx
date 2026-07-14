package backend;

class Paths
{
    private inline static var image_extension:String = '.png';
    private inline static var sound_extension:String = '.ogg';
    private inline static var font_extension:String = '.ttf';

    public inline static function image(path:String):String
    {
        return 'assets/images/$path$image_extension';
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