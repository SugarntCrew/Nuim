package ui.games;

import flixel.text.FlxText;
import flixel.math.FlxMath;
import sys.FileSystem;
import flixel.group.FlxSpriteGroup;

class Grid extends FlxSpriteGroup implements IClickable
{
    public var gridPixelSize:Int = 273;
    public var data:GameData;
    public var gridName:String;
    public var gridImageName:String;

    public var gridImage:FlxSprite;
    public var gridText:FlxText;

    public var onClickCallback:(data:GameData, ?customBehavior:Dynamic) -> Void;

    public function new(x:Float, y:Float, _data:GameData)
    {
        super(x, y);

        data = _data;
        gridName = _data.name ?? '';
        gridImageName = _data.grid_image ?? 'FJASKLGJASKLGJASLKGJASKLGJASLKGJASKLGJASKLGJASGJASKGJALSKG'; //idk whatever

        gridImage = new FlxSprite();
        gridText = new FlxText(0, 0, 0, '');
        if(FileSystem.exists(Paths.image('games/grids/$gridImageName')))
        {
            trace('Game grid exists!');

            gridImage.loadGraphic(Paths.image('games/grids/$gridImageName'));
            gridImage.setGraphicSize(gridPixelSize, gridPixelSize * 1.5);

            gridText.visible = false;
        }
        else
        {
            trace('Game grid does not exist ($gridImageName)! Creating default grid for game $gridName...');

            gridImage.makeGraphic(gridPixelSize, Std.int(gridPixelSize * 1.5), 0xFF000000);

            gridText = new FlxText(0, 0, gridImage.width - 20, '');
            gridText.x += 10;
            gridText.y += gridImage.height / 2 - gridText.height / 2;
            gridText.text = gridName;
            gridText.setFormat(Paths.font('vcr'), 40, 0xFFFFFFFF, CENTER);
        }

        add(gridImage);
        add(gridText);
    }

    private var _onHover:Bool = false;
    private var _onUnhover:Bool = false;
    public var targetScale:Float = 1;
    public var scaleSpeed:Float = 10;
    override function update(elapsed:Float)
    {
        super.update(elapsed);

        var mult = FlxMath.lerp(scale.x, targetScale, elapsed * scaleSpeed);
        scale.set(mult, mult);

        if(FlxG.mouse.overlaps(gridImage))
        {
            _onUnhover = true;
            if(_onHover) 
            {
                onHover();
                _onHover = false;
            }

            hover(true);
            if(FlxG.mouse.justPressed)
            {
                onClick(data);
            }
        }
        else
        {
            _onHover = true;
            if(_onUnhover) 
            {
                onUnhover();
                _onUnhover = false;
            }
            hover(false);
        }
    }


    public function onHover()
    {

    }

    public function hover(hover:Bool)
    {
        targetScale = hover ? 1.05 : 1;
    }

    public function onUnhover()
    {

    }
    
    public function onClick(?customBehavior:Dynamic)
    {
        if(onClickCallback != null) onClickCallback(data, customBehavior);
    }
}