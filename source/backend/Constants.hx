package backend;

enum CloseSubstateTrans
{
    ADDGAME;
    GAMEINFO;
}

class Constants
{
    public static var LAUNCHER_PATH:String = Sys.getCwd();
    public static var supportedBuildExtensions:Array<String> = ['.zip'];
    public static var closeSubstateTrans:CloseSubstateTrans = GAMEINFO;
}