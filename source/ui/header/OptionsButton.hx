package ui.header;

class OptionsButton extends FlxSprite implements IClickable
{
    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);

        loadGraphic(Paths.image('ui/header/optionsButton'));
    }

    private var _onHover:Bool = false;
    private var _onUnhover:Bool = false;
    public var targetScale:Float = 1;
    public var scaleSpeed:Float = 10;
    override function update(elapsed:Float)
    {
        super.update(elapsed);

        var mult = FlxMath.lerp(scale.x, targetScale, elapsed * scaleSpeed);
        scale.set(mult, mult);

        if(FlxG.mouse.overlaps(this))
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
                onClick();
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
    }

    public function hover(hover:Bool)
    {
        targetScale = hover ? 1.05 : 1;
    }

    public function onUnhover()
    {
        Mouse.cursor = ARROW;
    }
    
    public function onClick(?customBehavior:Dynamic)
    {

    }
}