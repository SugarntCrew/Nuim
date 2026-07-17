package backend;

class DateUtils
{
    public static function getCurrentDateData()
    {
        return Date.now();
    }

    public static function getDayTime():String
    {
        var date = getCurrentDateData();
        var hour = date.getHours();
        
        if(hour >= 8 && hour <= 18)
        {
            return 'day';
        }
        else if((hour >= 19 && hour <= 20) || (hour >= 6 && hour <= 7))
        {
            return 'sunset';
        }
        else
        {
            return 'night';
        }
    }

    public static function getCurrentDate():Array<Int>
    {
        var date = getCurrentDateData();

        var day:Int = date.getDay();
        var dateNum:Int = date.getDate(); // this is the date number, not the entire date (e.g. -> **31** <- th January)
        var month:Int = date.getMonth();

        return [day, dateNum, month];
    }

    public static function formatDate(array:Array<Int>):String
    {
        var day:String = Std.string(array[0]);
        var dateNum:String = Std.string(array[1]);
        var month:String = Std.string(array[2]);

        return '${getShortenDay(day)}, ${getOrdinal(dateNum)} ${getMonthName(month)}';
    }

    static function getOrdinal(n:String):String 
    {
        var mod100 = Std.parseInt(n) % 100;
        if (mod100 >= 11 && mod100 <= 13) return n + "th";
    
        return switch (Std.parseInt(n) % 10) 
        {
            case 1: n + "st";
            case 2: n + "nd";
            case 3: n + "rd";
            default: n + "th";
        }
    }

    static function getShortenDay(day:String):String
    {
        return switch(Std.parseInt(day))
        {
            case 0: 'Sun';
            case 1: 'Mon';
            case 2: 'Tue';
            case 3: 'Wed';
            case 4: 'Thu';
            case 5: 'Fri';
            case 6: 'Sat';
            default: 'Unk.';
        }
    }

    static function getMonthName(month:String)
    {
        return switch(Std.parseInt(month))
        {
            case 0: 'January';
            case 1: 'February';
            case 2: 'March';
            case 3: 'April';
            case 4: 'May';
            case 5: 'June';
            case 6: 'July';
            case 7: 'August';
            case 8: 'September';
            case 9: 'October';
            case 10: 'November';
            case 11: 'December';
            default: 'Unknown';
        }
    }

    public static function getCurrentTime():Array<Int>
    {
        var date = getCurrentDateData();

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

    public static function convertMsToDate(ms:Float):Date
    {
        return Date.fromTime(ms * 1000);
    }
}