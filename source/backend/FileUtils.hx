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
        if(!FileSystem.exists(path)) 
        {
            trace('Could not analyse folder!');
            return [];
        }

        try 
        {
            var files = FileSystem.readDirectory(path);
            if(includeSubfolders)
            {
                for(file in files)
                {
                    var folderPath = Path.join([path, file]);
                    if(FileSystem.isDirectory(folderPath)) 
                    {
                        var directory = Path.addTrailingSlash(folderPath);
                        for(file in analyseFolder(directory, includeSubfolders))
                        {
                            files.push('$folderPath/$file');
                        }
                    }
                    else
                    {
                        #if debug trace('Detected file: $folderPath/$file'); #end
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