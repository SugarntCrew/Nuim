package menus;

class GameInfoState extends Substate
{
    override function create()
    {
        trace('Substate opened!');

        camera = FlxG.cameras.list[FlxG.cameras.list.length - 1];
    }

    override function update(elapsed:Float)
    {
        if(FlxG.keys.justPressed.ESCAPE)
        {
            goBackToMain();
        }
    }

    function goBackToMain()
    {
        trace('Going back to main!');
        close();
    }
}