package menus;

import ui.games.PlayButton;
import ui.games.Heroe;

class GameInfoState extends Substate
{
    private var data:GameData;
    private var camReference:FlxCamera;
    var heroe:Heroe;
    var backgroundGradient:FlxSprite;
    var background:FlxSprite;
    var line:FlxSprite;

    var titleText:FlxText;
    var playButton:PlayButton;

    var header:Header;
    var footer:Footer;

    public function new(_data:GameData, _camReference:FlxCamera)
    {
        super();

        data = _data;
        camReference = _camReference;
    }

    override function create()
    {
        trace('Substate opened!');

        heroe = new Heroe(0, 0, data.heroe_image, true);
        add(heroe);

        backgroundGradient = new FlxSprite(0, 140);
        backgroundGradient.loadGraphic(Paths.image('ui/gameinfo/gradient'));
        backgroundGradient.alpha = 0.65;
        add(backgroundGradient);

        background = new FlxSprite();
        background.makeGraphic(FlxG.width, FlxG.height * 2, 0xFF000000);
        background.y = backgroundGradient.y + backgroundGradient.height;
        background.alpha = 0.65;
        add(background);

        line = new FlxSprite();
        line.makeGraphic(FlxG.width - 80, 2, 0xFF636363);
        line.x = 20;
        line.y = background.y - 1;
        line.alpha = 0.7;
        add(line);

        titleText = new FlxText(0, 0, 0, data.name);
        titleText.setFormat(Paths.font('advent_pro'), 70, 0xFFFFFFFF, LEFT);
        titleText.x = line.x + 20;
        titleText.y = line.y - titleText.height - 5;
        add(titleText);

        playButton = new PlayButton(line.x + 20, line.y + 20, data, FlxG.cameras.list[FlxG.cameras.list.length - 1]);
        playButton.onHoverCallback = function(data)
        {
            FlxG.sound.play(Paths.sound('changeSfx'));
        }
        add(playButton);
        
        header = new Header();
        header.scrollFactor.set(0, 0);
        add(header);

        camera = FlxG.cameras.list[FlxG.cameras.list.length - 1];
    }

    var targetScrollY:Float = 0;
    var scrollIntensity:Float = 40;
    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if(FlxG.keys.justPressed.ESCAPE)
        {
            goBackToMain();
        }        
        
        var mult = FlxMath.lerp(camReference.scroll.y, targetScrollY, elapsed * 12);
        camReference.scroll.set(0, mult);

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
                if(targetScrollY > 480) 
                {
                    targetScrollY = 480;
                    //mainCam.scroll.set(0, targetScrollY);
                }
            }
        }
    }

    function goBackToMain()
    {
        trace('Going back to main!');
        FlxG.sound.play(Paths.sound('backSfx'));
        close();
    }
}