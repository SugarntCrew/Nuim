package menus;

import ui.games.Grid;

class MainState extends State
{
    // private (backend) vars
    var hasExited:Bool = false;

    // visual vars
    var colorBG:FlxSprite;
    var board:FlxSprite;
    var header:Header;

    var bgTransition:FlxSprite;

    override function create()
    {
        super.create();

        colorBG = new FlxSprite();
        colorBG.makeGraphic(FlxG.width, FlxG.height, 0xFFC9C9C9);
        add(colorBG);

        board = new FlxSprite();
        board.loadGraphic(Paths.image('ui/board'));
        board.screenCenter(X);
        board.y = FlxG.height - board.height;
        add(board);

        var columns:Int = 5;
        var numX:Int = 0;
        var numY:Int = -1;
        for(i in 0...GameGrid.games.length)
        {
            var grid = new Grid(0, 0, GameGrid.games[i]);
            grid.x = board.x + 40 + (numX * (grid.gridPixelSize + 40));

            if(i % columns == 0) 
            {
                trace('${grid.x + grid.width} is > than ${FlxG.width}');
                numX = 0;
                numY++;
            }

            grid.y = board.y + 40 + (numY * 480);
            grid.x = board.x + 35 + (numX * (grid.gridPixelSize + 35));

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