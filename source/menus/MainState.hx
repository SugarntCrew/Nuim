package menus;

import ui.games.Grid;

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

        var numX:Int = 0;
        var numY:Int = 0;
        for(i in 0...GameGrid.games.length)
        {
            var grid = new Grid(0, 0, GameGrid.games[i].name);
            grid.x = 40 + (numX * (grid.gridPixelSize + 40));

            if(grid.x + grid.width > FlxG.width) 
            {
                trace('${grid.x + grid.width} is > than ${FlxG.width}');
                numX = 0;
                numY++;
            }

            grid.y = 70 + 60 + (numY * 480);
            grid.x = 40 + (numX * (grid.gridPixelSize + 40));
            add(grid);

            numX++;
        }

        header = new Header(FlxG.width, 70);
        add(header);
    }
}