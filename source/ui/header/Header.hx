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

        userAccountUI = new UserAccountUI(0, 0, height, height); // double height because we want a square with the same proportions as the bg height
        userAccountUI.x = FlxG.width - userAccountUI.width;
        userAccountUI.y = headerBackground.height / 2 - userAccountUI.height / 2;
        userAccountUI.onClickCallback = function()
        {
            trace('Clicked account icon');
        }
        add(userAccountUI);
    }
}