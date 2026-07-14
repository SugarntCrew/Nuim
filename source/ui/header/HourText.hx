package ui.header;

import backend.DateUtils;

class HourText extends FlxText
{
    public function new(x:Float = 0, y:Float = 0, fieldWidth:Int = 0, text:String = '', size:Int = 16)
    {
        super(x, y, fieldWidth, text, size);
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        text = DateUtils.formatTime(DateUtils.getCurrentTime());
    }
}