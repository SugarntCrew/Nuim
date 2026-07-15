package ui.footer;

class Footer extends FlxSpriteGroup
{
    public var addGameButton:AddGameButton;
    public var footerBackground:FlxSprite;
    public function new(width:Int, height:Int, _refCam:FlxCamera)
    {
        super();

        camera = _refCam;

        addGameButton = new AddGameButton(0, 0, _refCam);
        add(addGameButton);

        footerBackground = new FlxSprite();
        //footerBackground.makeGraphic(width, height, 0xFF646464);
        footerBackground.loadGraphic(Paths.image('ui/footer/bg'));
        add(footerBackground);
    }
}