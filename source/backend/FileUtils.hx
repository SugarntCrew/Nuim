package backend;

import haxe.io.Path;
import sys.FileSystem;

class FileUtils
{
    public static function getFilesCount(path:String):Int
    {
        return analyseFolder(path, true).length;
    }

    public static function analyseFolder(path:String, ?includeSubfolders:Bool = false):Array<String>
    {
        var result = [];

        if (!FileSystem.exists(path))
            return result;

        for (entry in FileSystem.readDirectory(path))
        {
            var fullPath = Path.join([path, entry]);

            if (FileSystem.isDirectory(fullPath))
            {
                if (includeSubfolders)
                {
                    result = result.concat(analyseFolder(fullPath, true));
                }
            }
            else
            {
                result.push(fullPath);
            }
        }

        return result;
    }
}