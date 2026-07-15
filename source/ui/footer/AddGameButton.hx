package ui.footer;

class AddGameButton extends FlxSpriteGroup implements IClickable
{
    private var refCamera:FlxCamera;

    public var addGameBG:FlxSprite;
    public var addGameText:FlxText;

    public var onClickCallback:(?customBehavior:Dynamic) -> Void;
    public var onHoverCallback:() -> Void;
    public var hoverCallback:() -> Void;
    public function new(x:Float = 0, y:Float = 0, _refCam:FlxCamera)
    {
        super(x, y);
        
        refCamera = _refCam;

        addGameBG = new FlxSprite();
        addGameBG.loadGraphic(Paths.image('ui/footer/addGameBG'));
        addGameBG.screenCenter(X);
        add(addGameBG);

        addGameText = new FlxText(0, 0, 0, '+ Add Game', 40);
        addGameText.setFormat(Paths.font('advent_pro'), 40, 0xFFFFFFFF, LEFT);
        addGameText.screenCenter(X);
        addGameText.y += 40;
        add(addGameText);
    }

    private var _onHover:Bool = false;
    private var _onUnhover:Bool = false;
    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if(FlxG.mouse.overlaps(addGameBG))
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

        if(onHoverCallback != null) onHoverCallback();
    }

    public function hover(hover:Bool)
    {
        if(hoverCallback != null && hover) hoverCallback();
    }

    public function onUnhover()
    {
        Mouse.cursor = ARROW;
    }
    
    public function onClick(?customBehavior:Dynamic)
    {
        if(onClickCallback != null) onClickCallback(customBehavior);
    }
}