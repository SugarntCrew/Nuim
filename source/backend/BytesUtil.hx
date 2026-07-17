package backend;

class BytesUtil
{
    public static function formatBytes(b:Float):String
    {
        if(b > 1024000000) return FlxMath.roundDecimal(b / 1024000000, 2) + "GB";
        else if (b > 1024000) return FlxMath.roundDecimal(b / 1024000, 2) + "MB";
        else if (b > 1024) return FlxMath.roundDecimal(b / 1024, 0) + "kB";
        else return FlxMath.roundDecimal(b, 0) + "B";
    }
}