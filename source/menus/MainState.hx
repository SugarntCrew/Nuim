package menus;

import ui.games.Grid;

class MainState extends State
{
    // private (backend) vars
    var hasExited:Bool = false;

    // visual vars
    var colorBG:FlxSprite;
    var header:Header;

    var bgTransition:FlxSprite;

    override function create()
    {
        super.create();

        colorBG = new FlxSprite();
        colorBG.makeGraphic(FlxG.width, FlxG.height, 0xFFC9C9C9);
        add(colorBG);

        var numX:Int = 0;
        var numY:Int = 0;
        for(i in 0...GameGrid.games.length)
        {
            var grid = new Grid(0, 0, GameGrid.games[i]);
            grid.x = 40 + (numX * (grid.gridPixelSize + 40));

            if(grid.x + grid.width > FlxG.width) 
            {
                trace('${grid.x + grid.width} is > than ${FlxG.width}');
                numX = 0;
                numY++;
            }

            grid.y = 70 + 60 + (numY * 480);
            grid.x = 40 + (numX * (grid.gridPixelSize + 40));

            grid.onClickCallback = function(data, ?behavior)
            {
                if(hasExited) return;
                hasExited = true;
                
                FlxTween.tween(FlxG.camera, {zoom: 1.3}, 0.65, {ease: FlxEase.quartIn});
                FlxTween.tween(bgTransition, {alpha: 1}, 0.65, {ease: FlxEase.quartIn, onComplete: function(twn:FlxTween)
                {
                    // TODO: Open substate with more info n metadata n cool stuff
                    FlxG.switchState(MainState.new);
                }});
            }

            add(grid);

            numX++;
        }

        header = new Header(FlxG.width, 70);
        add(header);

        bgTransition = new FlxSprite();
        bgTransition.makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
        bgTransition.alpha = 0;
        add(bgTransition);
    }
}