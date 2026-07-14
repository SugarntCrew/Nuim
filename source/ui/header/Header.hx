package ui.header;

import backend.DateUtils;

class Header extends FlxSpriteGroup
{
    public var optionsBackground:FlxSprite;
    public var optionsButton:OptionsButton;

    public var headerBackground:FlxSprite;
    public var userAccountUI:UserAccountUI;
    public var dateTimeTxt:DateText;
    public function new()
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

        userAccountUI = new UserAccountUI(0, 0, 100, 100); // double height because we want a square with the same proportions as the bg height
        userAccountUI.x = FlxG.width - userAccountUI.width;
        userAccountUI.y = 123 / 2 - userAccountUI.height / 2;
        userAccountUI.onClickCallback = function()
        {
            trace('Clicked account icon');
        }
        add(userAccountUI);

        dateTimeTxt = new DateText();
        dateTimeTxt.text = DateUtils.formatTime(DateUtils.getCurrentTime());
        dateTimeTxt.setFormat(Paths.font('advent_pro'), 40, 0xFFFFFFFF, LEFT);
        dateTimeTxt.x = 1490;
        dateTimeTxt.y = 123 / 2 - dateTimeTxt.height / 2;
        add(dateTimeTxt);
    }
}