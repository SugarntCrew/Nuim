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
            if(FlxG.mouse.justPressed)
            {
                onClick();
            }
        }
    }
    
    public function onClick()
    {
        if(onClickCallback != null) onClickCallback();
    }
}