package ui.header;

class UserAccountUI extends FlxSprite implements IClickable
{
    public var onClickCallback:Void->Void;

    public var scaleOffset:Float = 0.85;
    public function new(x:Float = 0, y:Float = 0, width:Int, height:Int)
    {
        super(x, y);

        makeGraphic(width, height, 0xFF000000); // temp !!
        setGraphicSize(width * scaleOffset, height * scaleOffset);
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if(FlxG.mouse.overlaps(this))
        {
            hover(true);
            if(FlxG.mouse.justPressed)
            {
                onClick();
            }
        }
        else
        {
            hover(true);
        }
    }
    
    public function onHover()
    {

    }

    public function hover(hover:Bool)
    {

    }
    
    public function onUnhover()
    {

    }
    
    public function onClick(?customBehavior:Dynamic)
    {
        if(onClickCallback != null) onClickCallback();
    }
}