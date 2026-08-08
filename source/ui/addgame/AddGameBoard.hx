package ui.addgame;

import ui.games.Button;
import ui.footer.AddGameButton;
import flixel.util.FlxColor;

class AddGameBoard extends FlxSpriteGroup
{
    public var bg:FlxSprite;
    public var nameText:FlxText;
    public var nameInput:FlxUITextInput;
    public var descriptionText:FlxText;
    public var descriptionInput:FlxUITextInput;
    public var gamebananaUrlText:FlxText;
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

        nameText = new FlxText(0, 0, 350, 'Game Title');
        nameText.setFormat(Paths.font('advent_pro'), 22, 0xFFFFFFFF, LEFT);
        nameText.x = bg.x + 15;
        nameText.y = bg.y + 15;
        nameText.alpha = 0;
        add(nameText);

        FlxTween.tween(nameText, {alpha: 1}, 0.9, {ease: FlxEase.quartOut});

        nameInput = new FlxUITextInput(0, 0, 350, '');
        nameInput.tf.setFormat(Paths.font('advent_pro'), 22, 0xFF302D2D, LEFT);
        nameInput.focus = true;
        //nameInput.screenCenter(X);
        nameInput.x = bg.x + 15;
        nameInput.y = nameText.y + nameText.height + 15;
        nameInput.alpha = 0;
        add(nameInput);

        FlxTween.tween(nameInput, {alpha: 1}, 0.9, {ease: FlxEase.quartOut});

        descriptionText = new FlxText(0, 0, 350, 'Game Description');
        descriptionText.setFormat(Paths.font('advent_pro'), 22, 0xFFFFFFFF, LEFT);
        descriptionText.x = bg.x + 15;
        descriptionText.y = nameInput.y + nameInput.height + 15;
        descriptionText.alpha = 0;
        add(descriptionText);

        FlxTween.tween(descriptionText, {alpha: 1}, 0.9, {ease: FlxEase.quartOut});

        descriptionInput = new FlxUITextInput(0, 0, 350, '');
        descriptionInput.tf.setFormat(Paths.font('advent_pro'), 22, 0xFF302D2D, LEFT);
        descriptionInput.focus = true;
        descriptionInput.multiline = true;
        //descriptionInput.screenCenter(X);
        descriptionInput.x = bg.x + 15;
        descriptionInput.y = descriptionText.y + descriptionText.height + 15;
        descriptionInput.alpha = 0;
        add(descriptionInput);

        FlxTween.tween(descriptionInput, {alpha: 1}, 0.9, {ease: FlxEase.quartOut});

        gamebananaUrlText = new FlxText(0, 0, 350, 'Gamebanana URL');
        gamebananaUrlText.setFormat(Paths.font('advent_pro'), 22, 0xFFFFFFFF, LEFT);
        gamebananaUrlText.x = bg.x + 15;
        gamebananaUrlText.y = descriptionInput.y + descriptionInput.height + 15;
        gamebananaUrlText.alpha = 0;
        add(gamebananaUrlText);

        FlxTween.tween(gamebananaUrlText, {alpha: 1}, 0.9, {ease: FlxEase.quartOut});

        gamebananaUrlInput = new FlxUITextInput(0, 0, 550, '');
        gamebananaUrlInput.tf.setFormat(Paths.font('advent_pro'), 22, 0xFF302D2D, LEFT);
        gamebananaUrlInput.focus = true;
        //gamebananaUrlInput.screenCenter(X);
        gamebananaUrlInput.x = bg.x + 15;
        gamebananaUrlInput.y = gamebananaUrlText.y + gamebananaUrlText.height + 15;
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
                description: descriptionInput.text,
                url: gamebananaUrlInput.text
            }

            GameGrid.games.push(gameData);

            FlxG.save.flush();
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