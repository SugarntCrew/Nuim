package ui.header;

class Header extends FlxSpriteGroup
{
    public var optionsBackground:FlxSprite;
    public var optionsButton:OptionsButton;

    public var headerBackground:FlxSprite;
    public var userAccountUI:UserAccountUI;
    public function new(width:Int, height:Int)
    {
        super();

        optionsBackground = new FlxSprite();
        optionsBackground.loadGraphic(Paths.image('ui/header/optionsBG'));
        add(optionsBackground);

        optionsButton = new OptionsButton();
        optionsButton.x += optionsBackground.width / 2 - optionsButton.width / 2;
        optionsButton.y += 58 + ((optionsBackground.height-58) / 2) - optionsButton.height / 2;
        add(optionsButton);

        headerBackground = new FlxSprite();
        //headerBackground.makeGraphic(width, height, 0xFF646464);
        headerBackground.loadGraphic(Paths.image('ui/header/bg'));
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