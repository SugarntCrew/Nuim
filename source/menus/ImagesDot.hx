package menus;

class ImagesDot extends FlxSpriteGroup
{
    public function new(x:Float, y:Float, dotsAmount:Int, initialDot:Int)
    {
        super(x, y);

        for(i in 0...dotsAmount)
        {
            var dot = new ImageDot();
            dot.x += (25 * i);
            dot.ID = i;
            add(dot);
        }
    }
}

class ImageDot extends FlxSprite
{
    public var dotSelected:Bool = false;
    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);

        loadGraphic(Paths.image('ui/gameinfo/dot'));
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        var mult = FlxMath.lerp(alpha, dotSelected ? 1 : 0.4, elapsed * 10);
        alpha = mult;
    }
}