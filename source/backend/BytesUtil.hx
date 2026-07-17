package backend;

class BytesUtil
{
    public static function bytesToMb(bytesAm:Int):Float
    {
        return bytesAm / 1000 / 1000;
    }
}