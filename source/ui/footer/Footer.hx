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

    override function update(elapsed:Float) 
    {
        super.update(elapsed);
        
        if(FlxG.mouse.overlaps(addGameButton, FlxG.cameras.list[FlxG.cameras.list.length-1]))
        {
            if(FlxG.mouse.justPressed)
            {
                trace('Open add game tab');
            }
        }
    }
}