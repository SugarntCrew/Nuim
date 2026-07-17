package backend;

import sys.FileSystem;

class FileUtils
{
    public static function getFilesCount(path:String):Int
    {
        return analyseFolder(path, true).length;
    }

    public static function analyseFolder(path:String, ?includeSubfolders:Bool = false):Array<String>
    {
        if(!FileSystem.exists(path)) return [];

        try 
        {
            var files = FileSystem.readDirectory(path);
            if(includeSubfolders)
            {
                for(file in files)
                {
                    if(FileSystem.isDirectory('$path/$file')) 
                    {
                        for(file in analyseFolder(path + file))
                        {
                            files.push(file);
                        }
                    }
                }
            }
            return files;
        }
        catch(exc)
        {
            trace('ERROR analysing folder. ($exc)');
            return [];
        }
    }
}