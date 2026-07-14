package ui.games;

import shaders.BlurShader;
import sys.FileSystem;

class Heroe extends FlxSprite
{
    public var regenTime:Float = 1;
    public var alreadyRegen:Bool = false;
    public var alphaTween:FlxTween;
    public var blurShader:BlurShader;
    public var prevPath:String = '';
    
    public function new(x:Float, y:Float, path:String)
    {
        super(x, y);

        regenImage(path, true);
        color = 0xFF929292;

        blurShader = new BlurShader();
        blurShader.lod.value = [0];
        blurShader.radius.value = [7];

        shader = blurShader;
    }

    public function regenImage(path:String, ?skipOutTrans:Bool = false)
    {
        if(prevPath == path) return; // lmao
        prevPath = path;

        alreadyRegen = true;

        if(alphaTween != null) alphaTween.cancel();
        if(skipOutTrans)
        {
            generate(path);
        }
        else
        {
            FlxTween.tween(this, {alpha: 0}, 1, {ease: FlxEase.quadIn, onComplete: function(twn:FlxTween)
            {
                generate(path);
            }});
        }
    }

    function generate(path:String)
    {
        var fullPath = Paths.image('games/heroes/$path');
        if(!FileSystem.exists(Paths.image('games/heroes/$path'))) 
        {
            trace('Tried to regenerate but $fullPath did not exist.');
            return;
        }

        loadGraphic(fullPath);

        FlxTween.cancelTweensOf(this);
        
        x = 0;
        scale.set(1.2, 1.2);

        alphaTween = FlxTween.tween(this, {alpha: 1}, 1, {ease: FlxEase.quartOut, onComplete: (_) -> alphaTween = null});
        FlxTween.tween(this, {"scale.x": 1.1, "scale.y": 1.1}, 1, {ease: FlxEase.quartOut});
        FlxTween.tween(this, {x: 50}, 10, {ease: FlxEase.smoothStepInOut, type: PINGPONG});
    }
}