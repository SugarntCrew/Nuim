package ui.header;

import backend.DateUtils;

class Header extends FlxSpriteGroup
{
    public var optionsBackground:FlxSprite;
    public var optionsButton:OptionsButton;

    public var headerBackground:FlxSprite;
    public var userAccountUI:UserAccountUI;
    public var hourTimeTxt:HourText;
    public var dateTimeTxt:DateText;
    public var dayTimeSpr:FlxSprite;
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

        dayTimeSpr = new FlxSprite();
        dayTimeSpr.loadGraphic(Paths.image('ui/header/daytime/${DateUtils.getDayTime()}'));
        add(dayTimeSpr);

        hourTimeTxt = new HourText(0, 0, 250);
        hourTimeTxt.text = DateUtils.formatTime(DateUtils.getCurrentTime());
        hourTimeTxt.setFormat(Paths.font('advent_pro'), 40, 0xFFFFFFFF, CENTER);
        hourTimeTxt.x = 1430;
        hourTimeTxt.y = 123 / 2 - hourTimeTxt.height / 2 - 15;
        add(hourTimeTxt);

        dateTimeTxt = new DateText(0, 0, 250);
        dateTimeTxt.text = DateUtils.formatDate(DateUtils.getCurrentDate());
        dateTimeTxt.setFormat(Paths.font('advent_pro'), 25, 0xFFEBEBEB, CENTER);
        dateTimeTxt.x = 1430;
        dateTimeTxt.y = hourTimeTxt.y + hourTimeTxt.height;
        add(dateTimeTxt);

        dayTimeSpr.x = hourTimeTxt.x - dayTimeSpr.width + 10;
        dayTimeSpr.y = 123 / 2 - dayTimeSpr.height / 2;
    }
}