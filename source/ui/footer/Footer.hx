package ui.footer;

import menus.AddGameState;
import backend.Constants;

class Footer extends FlxSpriteGroup
{
    public var addGameButton:AddGameButton;
    public var footerBackground:FlxSprite;
    public function new(width:Int, height:Int, _refCam:FlxCamera)
    {
        super();

        camera = _refCam;

        addGameButton = new AddGameButton(0, 0, _refCam);
        addGameButton.onClickCallback = function(?customBehavior)
        {
                trace('Open add game tab');

                Constants.closeSubstateTrans = ADDGAME;
                MainState.instance.hasExited = true;

                var addGameState = new AddGameState(_refCam);
                MainState.instance.openSubState(addGameState);
        }
        add(addGameButton);

        footerBackground = new FlxSprite();
        //footerBackground.makeGraphic(width, height, 0xFF646464);
        footerBackground.loadGraphic(Paths.image('ui/footer/bg'));
        add(footerBackground);
    }

    override function update(elapsed:Float) 
    {
        super.update(elapsed);

    }
}