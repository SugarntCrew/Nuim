package ui.gbdownload;

import menus.GameInfoState;
import backend.api.GamebananaAPI;
import backend.BytesUtil;
import ui.games.Button;
import backend.DateUtils;
import haxe.Json;

class GBDownloadField extends FlxSpriteGroup
{
    public var fileData:Dynamic;
    public var downloadUrl:String = '';
    public var downloadButton:Button;
    public var parent:GBDownloadBoard;

    public var bg:FlxSprite;
    public var fileNameTxt:FlxText;
    public var dateText:FlxText;
    public var bytesText:FlxText;

    public function new(x:Float, y:Float, width:Float, height:Float, _fileData:Dynamic, _parent:GBDownloadBoard)
    {
        super(x, y);

        parent = _parent;
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
        downloadButton.onClickCallback = function(data, ?customBehavior)
        {
            // download stuff
            parent.hide(0.9);
            @:privateAccess
            {
                GamebananaAPI.downloadGamebananaBuild(downloadUrl, Paths.gamebananaDownload(GameInfoState.instance != null ? '${GamebananaAPI.getModIdFromUrl(GameInfoState.instance.data.gamebanana_url)}/build' : 'build', 'zip'), onProgress, onComplete);
            }
        }
        add(downloadButton);
    }

    function onProgress(loaded:Float, total:Float)
    {
        if(GameInfoState.instance == null) return;

        GameInfoState.instance.gbDownloadBg.visible = true;
        GameInfoState.instance.gbDownloadBar.visible = true;
        GameInfoState.instance.gbDownloadText.visible = true;

        var textLoaded = '${BytesUtil.formatBytes(loaded)}';
        var textTotal = '${BytesUtil.formatBytes(total)}';
        GameInfoState.instance.gbDownloadText.text = '$textLoaded / $textTotal';
        GameInfoState.instance.downloadProgress = loaded / total;
    }

    function onComplete()
    {
        if(GameInfoState.instance == null) return;

        GameInfoState.instance.gbDownloadBg.visible = false;
        GameInfoState.instance.gbDownloadBar.visible = false;
        GameInfoState.instance.gbDownloadText.visible = false;
    }
}