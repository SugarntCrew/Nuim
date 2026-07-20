package ui.gbdownload;

import sys.thread.Thread;
import flixel.group.FlxGroup.FlxTypedGroup;
import haxe.Json;

class GBDownloadBoard extends FlxSpriteGroup
{
    public var onHideCustomBehavior:()->Void;
    public var onStartDownloadCallback:()->Void;
    public var isBoardOpen:Bool = false;
    public var filesData:Dynamic;
    public var parent:Dynamic;
    public var data:Dynamic;
    
    public var background:FlxSprite;
    public var boardBackground:FlxSprite;
    public var noBuildsAvaiableText:FlxText;
    public var buildFilesFieldGrp:FlxTypedGroup<GBDownloadField>;
    public function new(x:Float = 0, y:Float = 0, ?_stateParent:Dynamic, _data:Dynamic)
    {
        super(x, y);

        data = _data;

        if(_stateParent != null) parent = _stateParent; 

        background = new FlxSprite();
        background.makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
        background.alpha = 0;
        add(background);

        boardBackground = new FlxSprite();
        boardBackground.makeGraphic(1150, 850, 0xFF000000);
        boardBackground.alpha = 0;
        boardBackground.screenCenter();
        boardBackground.y += 60;
        add(boardBackground);

        noBuildsAvaiableText = new FlxText(0, 0, boardBackground.width - 20, 'There are no supported builds for this mod :(');
        noBuildsAvaiableText.x += 10;
        noBuildsAvaiableText.setFormat(Paths.font('advent_pro'), 25, 0xFFE7E7E7, LEFT);
        noBuildsAvaiableText.visible = false;
        add(noBuildsAvaiableText);

        buildFilesFieldGrp = new FlxTypedGroup<GBDownloadField>();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if(!active) return;
    }

    public function show(duration:Float, ?customBehaviour:()->Void)
    {
        isBoardOpen = true;
        if(customBehaviour != null) customBehaviour();

        FlxTween.cancelTweensOf(background);
        FlxTween.cancelTweensOf(boardBackground);

        FlxTween.tween(background, {alpha: 0.2}, duration, {ease: FlxEase.quartOut});
        FlxTween.tween(boardBackground, {alpha: 0.5}, duration, {ease: FlxEase.quartOut});
        for(obj in buildFilesFieldGrp)
        {
            obj.alpha = 0;
            FlxTween.cancelTweensOf(obj);
            FlxTween.tween(obj, {alpha: 1}, duration, {ease: FlxEase.quartOut});
        }
    }
    
    public function hide(duration:Float, ?customBehaviour:()->Void)
    {
        isBoardOpen = false;
        if(onHideCustomBehavior != null) onHideCustomBehavior();
        if(customBehaviour != null) customBehaviour();

        active = false;

        FlxTween.cancelTweensOf(background);
        FlxTween.cancelTweensOf(boardBackground);

        FlxTween.tween(background, {alpha: 0}, duration, {ease: FlxEase.quartOut});
        FlxTween.tween(boardBackground, {alpha: 0}, duration, {ease: FlxEase.quartOut});
        for(obj in buildFilesFieldGrp)
        {
            FlxTween.cancelTweensOf(obj);
            FlxTween.tween(obj, {alpha: 0}, duration, {ease: FlxEase.quartOut});
        }
    }

    public function refresh(_filesData:Dynamic, _mainThread:Thread)
    {
        buildFilesFieldGrp.forEach(function(obj) obj.destroy());
        buildFilesFieldGrp.clear();
        
        // trace(_filesData);
        filesData = _filesData;

        var num:Int = 0;
        for(file in cast(filesData, Array<Dynamic>))
        {
            var field = new GBDownloadField(boardBackground.x + 20, 0, boardBackground.width - 40, 140, file, data, this, _mainThread);
            if(!field.isSupportedBuild(file)) 
            {
                field.isSupported = false;
                continue;
            }
            field.y = boardBackground.y + 20 + (num * (field.height + 10));
            field.alpha = 0;
            field.onStartDownloadCallback = function()
            {
                if(onStartDownloadCallback != null) onStartDownloadCallback();
            }
            add(field);
            buildFilesFieldGrp.add(field);

            num++;
        }

        noBuildsAvaiableText.visible = !hasSupportedFieldBuilds();
    }

    function hasSupportedFieldBuilds():Bool
    {
        for(field in buildFilesFieldGrp)
        {
            if(field.isSupported) return true;
        }
        return false;
    }
}