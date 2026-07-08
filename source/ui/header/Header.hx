package ui.header;

class Header extends FlxSpriteGroup
{
    public var headerBackground:FlxSprite;
    public var userAccountUI:UserAccountUI;
    public function new(width:Int, height:Int)
    {
        super();

        headerBackground = new FlxSprite();
        headerBackground.makeGraphic(width, height, 0xFFC9C9C9);
        add(headerBackground);

        userAccountUI = new UserAccountUI();
        userAccountUI.x = FlxG.width - userAccountUI.width;
        add(userAccountUI);
    }
}