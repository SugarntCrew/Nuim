package ui.gbdownload;

import backend.Constants;
import sys.thread.Thread;
import backend.FileUtils;
import backend.ZipUtils;
import menus.GameInfoState;
import backend.api.GamebananaAPI;
import backend.BytesUtil;
import ui.games.Button;
import backend.DateUtils;
import haxe.Json;

class GBDownloadField extends FlxSpriteGroup
{
    public var data:Dynamic;
    public var fileData:Dynamic;
    public var downloadUrl:String = '';
    public var downloadButton:Button;
    public var parent:GBDownloadBoard;
    public var mainThread:Thread;
    public var isSupported:Bool = true;

    public var bg:FlxSprite;
    public var fileNameTxt:FlxText;
    public var dateText:FlxText;
    public var bytesText:FlxText;

    public function new(x:Float, y:Float, width:Float, height:Float, _fileData:Dynamic, _data:Dynamic, _parent:GBDownloadBoard, _mainThread:Thread)
    {
        super(x, y);

        mainThread = _mainThread;

        parent = _parent;
        data = _data;
        fileData = _fileData;
        downloadUrl = fileData._sDownloadUrl;
        
        bg = new FlxSprite();
        bg.makeGraphic(Std.int(width), Std.int(height), 0xFF000000);
        bg.alpha = 0.7;
        add(bg);

        fileNameTxt = new FlxText(0, 0, 0, fileData._sFile ?? 'No title');
        fileNameTxt.setFormat(Paths.font('advent_pro'), 25, 0xFFFFFFFF, LEFT);
        fileNameTxt.x += 10;
        fileNameTxt.y += 10;
        add(fileNameTxt);

        var datetxt:String = '- ${DateUtils.convertMsToDate(Std.parseFloat(fileData._tsDateAdded) ?? 0)}';
        dateText = new FlxText(0, 0, 0, datetxt ?? 'Unknown date.', 20);
        dateText.setFormat(Paths.font('advent_pro'), 18, 0xFF979797, LEFT);
        dateText.x += 10 + fileNameTxt.width + 10;
        dateText.y += 10 + fileNameTxt.height / 2 - dateText.height / 2;
        add(dateText);

        var bytetext = '- ${BytesUtil.formatBytes(fileData._nFilesize)}';
        bytesText = new FlxText(0, 0, 0, bytetext ?? '0 bytes', 20);
        bytesText.setFormat(Paths.font('advent_pro'), 18, 0xFF979797, LEFT);
        bytesText.x += 10 + fileNameTxt.width + 10 + dateText.width + 10;
        bytesText.y += 10 + fileNameTxt.height / 2 - dateText.height / 2;
        add(bytesText);

        downloadButton = new Button(0, 0, null, FlxG.cameras.list[FlxG.cameras.list.length - 1 ]);
        downloadButton.playButton.loadGraphic(Paths.image('ui/gameinfo/downloadGame'));
        downloadButton.scale.set(0.6, 0.6);
        downloadButton.updateHitbox();
        downloadButton.playButton.updateHitbox();
        downloadButton.playButtonBorder.updateHitbox();
        downloadButton.x += 10;
        downloadButton.y += 10 + fileNameTxt.height + 10; 
        downloadButton.onHoverCallback = function(data)
        {
            FlxG.sound.play(Paths.sound('changeSfx'));
        }
        downloadButton.onClickCallback = function(_data, ?customBehavior)
        {
            // download stuff
            parent.hide(0.9);
            @:privateAccess
            {
                var index = fileData._sFile.lastIndexOf('.');
                var extension = fileData._sFile.substr(index, fileData._sFile.length);
                trace(extension);

                GamebananaAPI.downloadGamebananaBuild(data, downloadUrl, Paths.gamebananaDownload('${GamebananaAPI.getModIdFromUrl(data.gamebanana_url)}/build', extension), onProgress, onComplete);
            }
        }
        add(downloadButton);
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
    }

    function onProgress(id:String, loaded:Float, total:Float)
    {
        mainThread.sendMessage({
            type: 'build_download_progress',
            modId: id,
            loaded: loaded,
            total: total,
            progress: loaded / total
        });
    }

    function onComplete(id:String, path:String)
    {
        mainThread.sendMessage({
            type: 'build_download_success',
            modId: id
        });

        if(StringTools.endsWith(path, 'zip'))
        {
            ZipUtils.unZip(path, 
            function(loaded) // read
            {
                trace("Sending readzip_progress");

                mainThread.sendMessage({
                    type: 'readzip_progress',
                    modId: id,
                    loaded: loaded,
                });
            },
            function(loaded, total, writtenBytes) // unzip
            {
                trace("Sending unzip_progress");

                mainThread.sendMessage({
                    type: 'unzip_progress',
                    modId: id,
                    loaded: loaded,
                    total: total,
                    progress: loaded / total,
                    writtenBytes: writtenBytes
                });
            },
            function() // complete
            {
                trace("Sending unzip_complete");

                mainThread.sendMessage({
                    type: 'unzip_complete',
                    modId: id
                });
            });
        }
    }

    public function isSupportedBuild(?fileData:Dynamic):Bool
    {
        var index = fileData._sFile.lastIndexOf('.');
        var extension = fileData._sFile.substr(index, fileData._sFile.length);
        trace('is $extension supported?');
        for(name in Constants.supportedBuildExtensions)
        {
            if(name == extension) return true;
        }
        return false;
    }
}