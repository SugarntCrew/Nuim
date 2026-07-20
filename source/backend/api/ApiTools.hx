package backend.api;

enum TargetApi
{
    GAMEBANANA;
}

class ApiTools
{
    public static function getTargetApiWithUrl(url:Null<String>):TargetApi
    {
        if(url == null) return null;

        if(StringTools.startsWith(url, 'https://gamebanana.com')) return GAMEBANANA;
        return null;
    }
}