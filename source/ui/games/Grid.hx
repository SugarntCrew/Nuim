package ui.games;

import flixel.math.FlxMath;
import sys.FileSystem;
import flixel.group.FlxSpriteGroup;

class Grid extends FlxSpriteGroup implements IClickable
{
    public var gridPixelSize:Int = 273;
    public var gridName:String = '';

    public var gridImage:FlxSprite;

    public function new(x:Float, y:Float, _gridName:String)
    {
        super(x, y);

        gridName = _gridName;

        gridImage = new FlxSprite();
        if(FileSystem.exists('assets/images/games/grids/$gridName'))
        {
            gridImage.loadGraphic(Paths.image('assets/images/games/grids/$gridName'));
            gridImage.setGraphicSize(gridPixelSize, gridPixelSize * 1.5);
        }
        else
        {
            gridImage.makeGraphic(gridPixelSize, Std.int(gridPixelSize * 1.5), 0xFF000000);
        }

        add(gridImage);
    }

    public var targetScale:Float = 1;
    public var scaleSpeed:Float = 10;
    override function update(elapsed:Float)
    {
        super.update(elapsed);

        var mult = FlxMath.lerp(gridImage.scale.x, targetScale, elapsed * scaleSpeed);
        gridImage.scale.set(mult, mult);

        if(FlxG.mouse.overlaps(gridImage))
        {
            hover(true);
            if(FlxG.mouse.justPressed)
            {
                onClick();
            }
        }
        else
        {
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
    
    public function onClick()
    {

    }
}