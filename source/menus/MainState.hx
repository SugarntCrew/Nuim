package menus;

import ui.games.Heroe;

class MainState extends State
{
    // private (backend) vars
    var hasExited:Bool = false;
    var totalGameColumns:Float = 5;
    var totalGameRows:Float = 0;

    // visual vars
    var colorBG:FlxSprite;
    var board:FlxSprite;
    var boardBackground:FlxSprite;
    var heroeGradient:FlxSprite;
    var heroe:Heroe;
    var header:Header;
    var footer:Footer;

    var bgTransition:FlxSprite;

    var mainCam:FlxCamera;
    var hudCam:FlxCamera;

    override function create()
    {
        super.create();

        mainCam = new FlxCamera();
        add(mainCam);

        hudCam = new FlxCamera();
        hudCam.bgColor.alpha = 0;
        add(hudCam);

        FlxG.cameras.reset(mainCam);
        FlxG.cameras.add(hudCam, false);

        colorBG = new FlxSprite();
        colorBG.makeGraphic(FlxG.width, FlxG.height, 0xFFC9C9C9);
        colorBG.scrollFactor.set(0, 0);
        add(colorBG);

        heroe = new Heroe(0, 0, 'JFAKSDJGFASKLGJASKLGJASKLGJAKLSJGLKJASG');
        add(heroe);

        heroeGradient = new FlxSprite();
        heroeGradient.loadGraphic(Paths.image('ui/heroeGradient'));
        heroeGradient.screenCenter(X);
        heroeGradient.y = FlxG.height - heroeGradient.height;
        heroeGradient.blend = ADD;
        heroeGradient.scrollFactor.set(0, 0);
        add(heroeGradient);

        board = new FlxSprite();
        board.loadGraphic(Paths.image('ui/board'));
        board.screenCenter(X);
        board.y = 183;
        add(board);

        boardBackground = new FlxSprite();
        add(boardBackground);

        var numX:Int = 0;
        var numY:Int = -1;
        for(i in 0...GameGrid.games.length)
        {
            var grid = new Grid(0, 0, GameGrid.games[i]);
            grid.x = board.x + 40 + (numX * (grid.gridPixelSize + 40));

            if(i % totalGameColumns == 0) 
            {
                trace('${grid.x + grid.width} is > than ${FlxG.width}');
                numX = 0;
                numY++;

                totalGameRows++;
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

            grid.onHoverCallback = function(data)
            {
                timer = 0;
                heroe.alreadyRegen = false;
            }

            grid.hoverCallback = function(data)
            {
                trace(data);
                timer += FlxG.elapsed;
                if(timer > heroe.regenTime && !heroe.alreadyRegen)
                {
                    heroe.regenImage(data.heroe_image);
                }
            }

            add(grid);

            numX++;
        }
        
        boardBackground.makeGraphic(1572, Std.int(480 * totalGameRows) + 110, 0xFF000000);
        boardBackground.screenCenter(X);
        boardBackground.alpha = 0.45;
        boardBackground.y = board.y + board.height;

        header = new Header(FlxG.width, 70);
        header.cameras = [hudCam];
        add(header);

        footer = new Footer(FlxG.width, 70);
        footer.y = FlxG.height - footer.height;
        footer.cameras = [hudCam];
        add(footer);

        bgTransition = new FlxSprite();
        bgTransition.makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
        bgTransition.alpha = 0;
        add(bgTransition);
    }

    var timer:Float = 0;
    var targetScrollY:Float = 0;
    var offsetY:Float = -160;
    var scrollIntensity:Float = 20;
    override function update(elapsed:Float)
    {
        super.update(elapsed);

        var mult = FlxMath.lerp(mainCam.scroll.y, targetScrollY, elapsed * 12);
        mainCam.scroll.set(0, mult);

        if(FlxG.mouse.wheel != 0)
        {
            if(FlxG.mouse.wheel > 0) 
            {
                targetScrollY += -scrollIntensity;
                if(targetScrollY < 0) 
                {
                    targetScrollY = 0;
                    //mainCam.scroll.set(0, targetScrollY);
                }
            }
            else if(FlxG.mouse.wheel < 0)
            {
                targetScrollY += scrollIntensity;
                if(targetScrollY > 480 * (totalGameRows-1) + offsetY) 
                {
                    targetScrollY = 480 * (totalGameRows-1) + offsetY;
                    //mainCam.scroll.set(0, targetScrollY);
                }
            }
        }
    }
}