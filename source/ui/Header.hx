package ui;

class Header extends FlxSpriteGroup
{
    public var headerBackground:FlxSprite;
    public function new(width:Int, height:Int)
    {
        super();

        headerBackground = new FlxSprite();
        headerBackground.makeGraphic(width, height, 0xFFC9C9C9);
        add(headerBackground);
    }
}