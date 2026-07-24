package ui.addgame;

import ui.games.Button;
import ui.footer.AddGameButton;
import flixel.util.FlxColor;

class AddGameBoard extends FlxSpriteGroup
{
    public var bg:FlxSprite;
    public var gamebananaUrl:FlxUITextInput;
    public var addGameButton:Button;

    public var onAddGame:()->Void;

    public function new(x:Float = 0, y:Float = 0, _refCam:FlxCamera)
    {
        super(x, y);

        bg = new FlxSprite();
        bg.makeGraphic(1150, 850, 0xFF000000);
        bg.alpha = 0;
        bg.screenCenter();
        add(bg);

        FlxTween.tween(bg, {alpha: 0.8}, 0.9, {ease: FlxEase.quartOut});

        gamebananaUrl = new FlxUITextInput(0, 0, 550, '');
        gamebananaUrl.tf.setFormat(Paths.font('advent_pro'), 22, 0xFF302D2D, LEFT);
        gamebananaUrl.focus = true;
        //gamebananaUrl.screenCenter(X);
        gamebananaUrl.x = bg.x + 15;
        gamebananaUrl.y = bg.y + 15;
        gamebananaUrl.alpha = 0;
        add(gamebananaUrl);

        FlxTween.tween(gamebananaUrl, {alpha: 1}, 0.9, {ease: FlxEase.quartOut});

        addGameButton = new Button(0, bg.y + bg.height - 130, null, _refCam);
        addGameButton.screenCenter(X);
        addGameButton.onHoverCallback = function(data)
        {
            FlxG.sound.play(Paths.sound('changeSfx'));
        }
        addGameButton.onClickCallback = function(data, ?customBehavior)
        {
            var gameData:GameData = {
                name: 'Whatever',
                game_location: 'whatever',
                url: gamebananaUrl.text
            }

            GameGrid.games.push(gameData);
            if(onAddGame != null) onAddGame();
        }
        addGameButton.alpha = 0;
        addGameButton.playButton.loadGraphic(Paths.image('ui/gameinfo/addGame'));
        add(addGameButton);

        FlxTween.tween(addGameButton, {alpha: 1}, 0.9, {ease: FlxEase.quartOut});
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if(gamebananaUrl != null)
        {
            if(gamebananaUrl.text != '' && !StringTools.startsWith(gamebananaUrl.text, 'https://gamebanana.com/mods/')) gamebananaUrl.fieldBorderColor = FlxColor.RED;
            else gamebananaUrl.fieldBorderColor = FlxColor.BLACK;
        }
    }
}