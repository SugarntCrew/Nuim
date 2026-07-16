package ui.games;

import openfl.display.BitmapData;
import shaders.BlurShader;
import sys.FileSystem;

typedef HeroeParams = 
{
    var imagePath:String;
    var bitmapDataLoad:Bool;
}

class Heroe extends FlxSprite
{
    public var regenTime:Float = 0.5;
    public var alreadyRegen:Bool = false;
    public var alphaTween:FlxTween;
    public var blurShader:BlurShader;
    public var prevSpr:FlxSprite = null;
    public var nextSpr:FlxSprite = null;
    
    public function new(x:Float, y:Float, params:HeroeParams, ?skipEntire:Bool = false)
    {
        super(x, y);

        prevSpr = new FlxSprite();
        nextSpr = new FlxSprite();

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
        nextSpr.loadGraphic(((params?.bitmapDataLoad ?? false) ? BitmapData.fromFile(params?.imagePath) : params?.imagePath) ?? Paths.image('games/heroes/template'));
        if(prevSpr.graphic == nextSpr.graphic) return; // lmao

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

        nextSpr.loadGraphic(params.bitmapDataLoad ? BitmapData.fromFile(params.imagePath) : params.imagePath);
        trace('${prevSpr.graphic} != ${nextSpr.graphic}');

        if(prevSpr.graphic != nextSpr.graphic) 
        {
            generate(params, true);
            alpha = 0;
        }


        alphaTween = FlxTween.tween(this, {alpha: 1}, duration, {ease: FlxEase.quartOut, onComplete: (_) -> alphaTween = null});
        FlxTween.tween(this, {x: 0}, duration, {ease: FlxEase.quartOut});
    }

    function generate(params:HeroeParams, skipTrans:Bool = false)
    {
        if(!FileSystem.exists(params.imagePath)) 
        {
            trace('Tried to regenerate but ${params.imagePath} did not exist.');
            return;
        }

        loadGraphic(params.bitmapDataLoad ? BitmapData.fromFile(params.imagePath) : params.imagePath);
        prevSpr.loadGraphic(params.bitmapDataLoad ? BitmapData.fromFile(params.imagePath) : params.imagePath);
        nextSpr.loadGraphic(params.bitmapDataLoad ? BitmapData.fromFile(params.imagePath) : params.imagePath);

        if(skipTrans)
        {
            x = 0;
            scale.set(1.1, 1.1);
        }
        else
        {
            FlxTween.cancelTweensOf(this);
            
            x = 0;
            scale.set(1.2, 1.2);

            alphaTween = FlxTween.tween(this, {alpha: 1}, 1, {ease: FlxEase.quartOut, onComplete: (_) -> alphaTween = null});
            FlxTween.tween(this, {"scale.x": 1.1, "scale.y": 1.1}, 1, {ease: FlxEase.quartOut});
            FlxTween.tween(this, {x: 50}, 10, {ease: FlxEase.smoothStepInOut, type: PINGPONG});
        }
    }

    public function fitToScreen()
    {
        setGraphicSize(FlxG.width * 1.1, FlxG.height * 1.1);
        updateHitbox();
        x = 0;
        y = 0;
        x -= ((FlxG.width * 1.1) - FlxG.width) / 2;
        y -= ((FlxG.height * 1.1) - FlxG.height) / 2;
    }
}