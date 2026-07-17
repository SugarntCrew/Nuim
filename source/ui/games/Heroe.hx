package ui.games;

import openfl.display.BitmapData;
import shaders.BlurShader;
import sys.FileSystem;

typedef HeroeParams = 
{
    var imagePath:String;
    var bitmapDataLoad:Bool;
    var apiPath:String;
}

class Heroe extends FlxSprite
{
    public var regenTime:Float = 0.5;
    public var alreadyRegen:Bool = false;
    public var alphaTween:FlxTween;
    public var posTween:FlxTween;
    public var blurShader:BlurShader;
    public var useApiPath:Bool = false;
    var currentHeroPath:String = null;
    
    public function new(x:Float, y:Float, params:HeroeParams, ?skipEntire:Bool = false)
    {
        super(x, y);

        regenImage(params, true, skipEntire);
        color = 0xFF929292;
        scrollFactor.set(0, 0);

        blurShader = new BlurShader();
        blurShader.lod.value = [0];
        blurShader.radius.value = [7];

        shader = blurShader;
    }

    public function regenImage(params:HeroeParams, ?skipOutTrans:Bool = false, ?skipEntire:Bool = false)
    {
        var targetPath = params?.apiPath;
        var bitmapDataLoad = true;
        if(!FileSystem.exists(targetPath)) 
        {
            targetPath = params?.imagePath;
            bitmapDataLoad = params?.bitmapDataLoad;
        }
        
        if (currentHeroPath == targetPath) return;
        currentHeroPath = targetPath;

        alreadyRegen = true;

        if(alphaTween != null) alphaTween.cancel();
        if(skipOutTrans)
        {
            generate(params, skipEntire);
        }
        else
        {
            alphaTween = FlxTween.tween(this, {alpha: 0}, 1, {ease: FlxEase.quadIn, onComplete: function(twn:FlxTween)
            {
                alphaTween = null;
                generate(params);
            }});
        }
    }

    public function onEnterGame(params:HeroeParams, duration:Float)
    {
        if(alphaTween != null) alphaTween.cancel();
        if(posTween != null) posTween.cancel();

        var targetPath = params?.apiPath;
        var bitmapDataLoad = true;
        if(!FileSystem.exists(targetPath)) 
        {
            targetPath = params?.imagePath;
            bitmapDataLoad = params?.bitmapDataLoad;
        }

        if(currentHeroPath != targetPath) 
        {
            currentHeroPath = targetPath;
            generate(params, true);
            alpha = 0;
        }


        alphaTween = FlxTween.tween(this, {alpha: 1}, duration, {ease: FlxEase.quartOut, onComplete: (_) -> alphaTween = null});
        FlxTween.tween(this, {x: targetX}, duration, {ease: FlxEase.quartOut});
    }

    function generate(params:HeroeParams, skipTrans:Bool = false)
    {
        if(!FileSystem.exists(params?.imagePath) && !FileSystem.exists(params?.apiPath)) 
        {
            trace('Tried to regenerate but ${params?.imagePath} or ${params?.apiPath} did not exist.');
            trace('Loading template >:)');
            //return;

            loadGraphic(Paths.image('games/heroes/template'));
        }
        else
        {
            var targetPath = params?.apiPath;
            var bitmapDataLoad = true;
            useApiPath = true;
            if(!FileSystem.exists(targetPath)) 
            {
                targetPath = params?.imagePath;
                bitmapDataLoad = params?.bitmapDataLoad;
                useApiPath = false;
            }
            loadGraphic(((bitmapDataLoad ?? false) ? BitmapData.fromFile(targetPath) : targetPath) ?? Paths.image('games/heroes/template'));
        }

        if(skipTrans)
        {
            fitToScreen();
            x = 0;
            scale.set(1.1, 1.1);

            if(useApiPath) setGraphicSize(FlxG.width * 1.1, FlxG.height * 1.1);
        }
        else
        {
            FlxTween.cancelTweensOf(this);
            
            fitToScreen();
            x = 0;
            scale.set(1.2, 1.2);

            alphaTween = FlxTween.tween(this, {alpha: 1}, 1, {ease: FlxEase.quartOut, onComplete: (_) -> alphaTween = null});
            if(useApiPath)
            {
                FlxTween.num(FlxG.width * 1.2, FlxG.width * 1.1, 1, {ease: FlxEase.quartOut, onComplete: startPosTween}, function(v:Float)
                {
                    fitToScreen(v, v / 1.7777777);
                });
            }
            else
            {
                FlxTween.tween(this, {"scale.x": 1.1, "scale.y": 1.1}, 1, {ease: FlxEase.quartOut, onComplete: startPosTween});
            }
        }
    }

    public function startPosTween(?twn:FlxTween)
    {
        if (posTween != null)
        {
            posTween.cancel();
            posTween = null;
        }

        posTween = FlxTween.tween(this, {x: targetX + 50}, 10, {ease: FlxEase.smoothStepInOut, type: PINGPONG, onComplete: (_) -> posTween = null});
    }

    public var targetX:Float = 0;
    public function fitToScreen(?customValueWidth:Float, ?customValueHeight:Float)
    {
        if(customValueWidth == null) customValueWidth = FlxG.width * 1.1;
        if(customValueHeight == null) customValueHeight = FlxG.height * 1.1;

        setGraphicSize(customValueWidth, customValueHeight);
        updateHitbox();
        x = 0;
        y = 0;
        x -= ((customValueWidth) - FlxG.width) / 2;
        y -= ((customValueHeight) - FlxG.height) / 2;
        targetX = x;
    }
}