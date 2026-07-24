package ui.addgame;

import ui.games.Button;
import ui.footer.AddGameButton;
import flixel.util.FlxColor;

class AddGameBoard extends FlxSpriteGroup
{
    public var bg:FlxSprite;
    public var nameInput:FlxUITextInput;
    public var gamebananaUrlInput:FlxUITextInput;
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

        nameInput = new FlxUITextInput(0, 0, 350, '');
        nameInput.tf.setFormat(Paths.font('advent_pro'), 22, 0xFF302D2D, LEFT);
        nameInput.focus = true;
        //nameInput.screenCenter(X);
        nameInput.x = bg.x + 15;
        nameInput.y = bg.y + 15;
        nameInput.alpha = 0;
        add(nameInput);

        FlxTween.tween(nameInput, {alpha: 1}, 0.9, {ease: FlxEase.quartOut});

        gamebananaUrlInput = new FlxUITextInput(0, 0, 550, '');
        gamebananaUrlInput.tf.setFormat(Paths.font('advent_pro'), 22, 0xFF302D2D, LEFT);
        gamebananaUrlInput.focus = true;
        //gamebananaUrlInput.screenCenter(X);
        gamebananaUrlInput.x = bg.x + 15;
        gamebananaUrlInput.y = nameInput.y + nameInput.height + 15;
        gamebananaUrlInput.alpha = 0;
        add(gamebananaUrlInput);

        FlxTween.tween(gamebananaUrlInput, {alpha: 1}, 0.9, {ease: FlxEase.quartOut});

        addGameButton = new Button(0, bg.y + bg.height - 130, null, _refCam);
        addGameButton.screenCenter(X);
        addGameButton.onHoverCallback = function(data)
        {
            FlxG.sound.play(Paths.sound('changeSfx'));
        }
        addGameButton.onClickCallback = function(data, ?customBehavior)
        {
            var gameData:GameData = {
                name: nameInput.text,
                game_location: 'whatever',
                url: gamebananaUrlInput.text
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

        if(gamebananaUrlInput != null)
        {
            if(gamebananaUrlInput.text != '' && !StringTools.startsWith(gamebananaUrlInput.text, 'https://gamebanana.com/mods/')) gamebananaUrlInput.fieldBorderColor = FlxColor.RED;
            else gamebananaUrlInput.fieldBorderColor = FlxColor.BLACK;
        }
    }
}