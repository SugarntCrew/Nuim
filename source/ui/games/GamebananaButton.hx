package ui.games;

class GamebananaButton extends FlxSprite implements IClickable
{
    private var data:GameData;
    private var refCamera:FlxCamera;

    public var onClickCallback:(data:GameData, ?customBehavior:Dynamic) -> Void;
    public var onHoverCallback:(data:GameData) -> Void;
    public var hoverCallback:(data:GameData) -> Void;
    public function new(x:Float, y:Float, _data:GameData, _refCamera:FlxCamera)
    {
        super(x, y);

        data = _data;
        refCamera = _refCamera;

        loadGraphic(Paths.image('ui/gameinfo/gb_icon'));
        alpha = 0.9;
    }

    private var _onHover:Bool = false;
    private var _onUnhover:Bool = false;
    public var angleSpeed:Float = 12;
    public var angleTarget:Float = 0;
    public var scaleSpeed:Float = 12;
    public var scaleTarget:Float = 1;
    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if(!active) return;
        
        var mult = FlxMath.lerp(angle, angleTarget, elapsed * angleSpeed);
        angle = mult;

        var mult2 = FlxMath.lerp(scale.x, scaleTarget, elapsed * scaleSpeed);
        scale.set(mult2, mult2);

        if(FlxG.mouse.overlaps(this, refCamera))
        {
            _onUnhover = true;
            if(_onHover) 
            {
                onHover();
                _onHover = false;
            }

            hover(true);
            if(FlxG.mouse.justPressed)
            {
                onClick(data);
            }
        }
        else
        {
            _onHover = true;
            if(_onUnhover) 
            {
                onUnhover();
                _onUnhover = false;
            }
            hover(false);
        }
    }

    var angleTargetTwn:FlxTween;
    public function onHover()
    {
        Mouse.cursor = BUTTON;

        FlxTween.cancelTweensOf(this);
        FlxTween.tween(this, {alpha: 1}, 0.15, {ease: FlxEase.quartOut});

        angleTargetTwn = FlxTween.num(-2, 2, 2.5, {ease: FlxEase.smoothStepInOut, type: PINGPONG}, function(v:Float)
        {
            angleTarget = v;
        });
        scaleTarget = 1.05;

        if(onHoverCallback != null) onHoverCallback(data);
    }

    public function hover(hover:Bool)
    {
        if(hoverCallback != null && hover) hoverCallback(data);
    }

    public function onUnhover()
    {
        Mouse.cursor = ARROW;

        FlxTween.cancelTweensOf(this);
        FlxTween.tween(this, {alpha: 0.9}, 0.15, {ease: FlxEase.quartOut});

        if(angleTargetTwn != null) angleTargetTwn.cancel();
        angleTarget = 0;
        scaleTarget = 1;
    }
    
    public function onClick(?customBehavior:Dynamic)
    {
        if(onClickCallback != null) onClickCallback(data, customBehavior);
    }
}