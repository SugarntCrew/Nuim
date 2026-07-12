package backend;

class Paths
{
    private inline static var image_extension:String = '.png';

    public inline static function image(path:String):String
    {
        return 'assets/images/$path$image_extension';
    }
}