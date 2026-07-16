package ui.games;

class PlayButton extends FlxSpriteGroup implements IClickable
{
    private var data:GameData;
    private var refCamera:FlxCamera;
    
    public var playButton:FlxSprite;
    public var playButtonBorder:FlxSprite;

    public var onClickCallback:(data:GameData, ?customBehavior:Dynamic) -> Void;
    public var onHoverCallback:(data:GameData) -> Void;
    public var hoverCallback:(data:GameData) -> Void;
    public function new(x:Float, y:Float, _data:GameData, _refCamera:FlxCamera)
    {
        super(x, y);

        data = _data;
        refCamera = _refCamera;

        playButton = new FlxSprite();
        playButton.loadGraphic(Paths.image('ui/gameinfo/playGame'));
        add(playButton);

        playButtonBorder = new FlxSprite();
        playButtonBorder.loadGraphic(Paths.image('ui/gameinfo/playGameBorder'));
        playButtonBorder.alpha = 0;
        add(playButtonBorder);
    }

    private var _onHover:Bool = false;
    private var _onUnhover:Bool = false;
    public var alphaTarget:Float = 0;
    override function update(elapsed:Float)
    {
        super.update(elapsed);

        FlxTween.cancelTweensOf(playButtonBorder);
        var mult = FlxMath.lerp(playButtonBorder.alpha, alphaTarget, elapsed * 14);
        playButtonBorder.alpha = mult;

        if(FlxG.mouse.overlaps(playButton, refCamera))
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

    public function onHover()
    {
        Mouse.cursor = BUTTON;

        //FlxTween.cancelTweensOf(playButtonBorder);
        //FlxTween.tween(playButtonBorder, {alpha: 1}, 0.15, {ease: FlxEase.quartOut});
        alphaTarget = 1;

        if(onHoverCallback != null) onHoverCallback(data);
    }

    public function hover(hover:Bool)
    {
        if(hoverCallback != null && hover) hoverCallback(data);
    }

    public function onUnhover()
    {
        Mouse.cursor = ARROW;

        //FlxTween.cancelTweensOf(playButtonBorder);
        //FlxTween.tween(playButtonBorder, {alpha: 0}, 0.15, {ease: FlxEase.quartOut});
        alphaTarget = 0;
    }
    
    public function onClick(?customBehavior:Dynamic)
    {
        if(onClickCallback != null) onClickCallback(data, customBehavior);
    }
}