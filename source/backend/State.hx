package backend;

import sys.thread.Thread;

class State extends FlxState
{
    override function update(elapsed:Float)
    {
        super.update(elapsed);

        // general controls n stuff
        if(FlxG.keys.justPressed.F11) toogleFullscreen();
    }

    function toogleFullscreen() 
    {
        FlxG.fullscreen = !FlxG.fullscreen;
        FlxG.mouse.visible = true;
    }
}