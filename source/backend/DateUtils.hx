package backend;

class DateUtils
{
    public static function getCurrentDate()
    {
        return Date.now();
    }

    public static function getCurrentTime():Array<Int>
    {
        var date = getCurrentDate();

        var hour:Int = date.getHours();
        var minutes:Int = date.getMinutes();

        return [hour, minutes];
    }

    public static function formatTime(array:Array<Int>):String
    {
        var hour:String = Std.string(array[0]);
        var minutes:String = Std.string(array[1]);

        if(hour.length == 1)
        {
            hour = '0$hour';
        }

        if(minutes.length == 1)
        {
            minutes = '0$minutes';
        }

        return '$hour:$minutes';
    }
}