package ui.games;

import shaders.BlurShader;
import sys.FileSystem;

class Heroe extends FlxSprite
{
    public var regenTime:Float = 0.5;
    public var alreadyRegen:Bool = false;
    public var alphaTween:FlxTween;
    public var blurShader:BlurShader;
    public var prevSpr:FlxSprite = null;
    public var nextSpr:FlxSprite = null;
    
    public function new(x:Float, y:Float, path:String, ?skipEntire:Bool = false)
    {
        super(x, y);

        prevSpr = new FlxSprite();
        nextSpr = new FlxSprite();

        regenImage(path, true, skipEntire);
        color = 0xFF929292;
        scrollFactor.set(0, 0);

        blurShader = new BlurShader();
        blurShader.lod.value = [0];
        blurShader.radius.value = [7];

        shader = blurShader;
    }

    public function regenImage(path:String, ?skipOutTrans:Bool = false, ?skipEntire:Bool = false)
    {
        nextSpr.loadGraphic(path);
        if(prevSpr.graphic == nextSpr.graphic) return; // lmao

        alreadyRegen = true;

        if(alphaTween != null) alphaTween.cancel();
        if(skipOutTrans)
        {
            generate(path, skipEntire);
        }
        else
        {
            alphaTween = FlxTween.tween(this, {alpha: 0}, 1, {ease: FlxEase.quadIn, onComplete: function(twn:FlxTween)
            {
                alphaTween = null;
                generate(path);
            }});
        }
    }

    public function onEnterGame(path:String, duration:Float)
    {
        if(alphaTween != null) alphaTween.cancel();

        nextSpr.loadGraphic(path);
        trace('${prevSpr.graphic} != ${nextSpr.graphic}');

        if(prevSpr.graphic != nextSpr.graphic) 
        {
            generate(path, true);
            alpha = 0;
        }


        alphaTween = FlxTween.tween(this, {alpha: 1}, duration, {ease: FlxEase.quartOut, onComplete: (_) -> alphaTween = null});
        FlxTween.tween(this, {x: 0}, duration, {ease: FlxEase.quartOut});
    }

    function generate(path:String, skipTrans:Bool = false)
    {
        if(!FileSystem.exists(path)) 
        {
            trace('Tried to regenerate but $path did not exist.');
            return;
        }

        loadGraphic(path);
        prevSpr.loadGraphic(path);
        nextSpr.loadGraphic(path);

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
}