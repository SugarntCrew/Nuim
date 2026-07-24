package menus;

import ui.addgame.AddGameBoard;

class AddGameState extends Substate
{
    var bg:FlxSprite;
    var addGameBoard:AddGameBoard;

    public function new(_refCamera:FlxCamera)
    {
        super();
        camera = _refCamera;
    }

    override function create()
    {
        super.create();

        bg = new FlxSprite();
        bg.makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
        bg.alpha = 0;
        add(bg);

        FlxTween.tween(bg, {alpha: 0.45}, 0.9);

        addGameBoard = new AddGameBoard(0, 0, camera);
        addGameBoard.onAddGame = function()
        {
            goBack();
        }
        add(addGameBoard);
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if(FlxG.keys.justPressed.ESCAPE)
        {
            goBack();
        }
    }

    function goBack()
    {
        FlxTween.tween(bg, {alpha: 0}, 0.7);
        FlxTween.tween(addGameBoard, {alpha: 0}, 0.7, {onComplete: function(twn:FlxTween)
        {
            close();
        }});
    }
}