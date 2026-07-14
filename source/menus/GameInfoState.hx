package menus;

import ui.games.Heroe;

class GameInfoState extends Substate
{
    private var data:GameData;
    var heroe:Heroe;

    public function new(_data:GameData)
    {
        super();

        data = _data;
    }

    override function create()
    {
        trace('Substate opened!');

        heroe = new Heroe(0, 0, data.heroe_image, true);
        add(heroe);
        
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