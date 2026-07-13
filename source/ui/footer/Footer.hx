package ui.footer;

class Footer extends FlxSpriteGroup
{
    public var addGameBackground:FlxSprite;
    public var addGameText:FlxText;
    public var footerBackground:FlxSprite;
    public function new(width:Int, height:Int)
    {
        super();

        addGameBackground = new FlxSprite();
        addGameBackground.loadGraphic(Paths.image('ui/footer/addGameBG'));
        addGameBackground.screenCenter(X);
        add(addGameBackground);

        addGameText = new FlxText();
        addGameText.setFormat(Paths.font('advent_pro'), 40, 0xFFFFFFFF, LEFT);
        addGameText.text = '+ Add Game';
        addGameText.screenCenter(X);
        addGameText.y += 40;
        add(addGameText);

        footerBackground = new FlxSprite();
        //footerBackground.makeGraphic(width, height, 0xFF646464);
        footerBackground.loadGraphic(Paths.image('ui/footer/bg'));
        add(footerBackground);
    }
}