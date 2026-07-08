package menus;

class MainState extends State
{
    var colorBG:FlxSprite;
    var header:Header;

    override function create()
    {
        super.create();

        colorBG = new FlxSprite();
        colorBG.makeGraphic(FlxG.width, FlxG.height, 0xFFFFFFFF);
        add(colorBG);

        header = new Header(FlxG.width, 70);
        add(header);
    }
}