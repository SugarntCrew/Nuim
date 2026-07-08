package ui.header;

class UserAccountUI extends FlxSprite implements IClickable
{
    public var scaleOffset:Float = 0.85;
    public function new(x:Float = 0, y:Float = 0, width:Int, height:Int)
    {
        super(x, y);

        makeGraphic(width, height, 0xFF000000); // temp !!
        setGraphicSize(width * scaleOffset, height * scaleOffset);
    }
    
    public function onClick()
    {
        
    }
}