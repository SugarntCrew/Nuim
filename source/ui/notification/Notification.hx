package ui.notification;

import openfl.events.Event;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.Lib;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class Notification extends Sprite {
    public var onPress:Void -> Void;
    var bg:Sprite;
    var txtTitle:TextField;
    var txtInfo:TextField;

    public function new(sound:String, title:String, info:String) 
    {
        super();

        bg = new Sprite();
        bg.graphics.beginFill(0x000000, 0.65);
        bg.graphics.drawRect(0, 0, 20, 20);
        bg.graphics.endFill();
        bg.y = -500;
        addChild(bg);

        txtTitle = new TextField();
        txtTitle.defaultTextFormat = new TextFormat(Paths.font('advent_pro'), 40, FlxColor.WHITE, true, null, null, null, null, "left");
        txtTitle.text = title;
        txtTitle.autoSize = LEFT;
		txtTitle.multiline = true;
        //txtTitle.width = 0;
        txtTitle.y = -500;
        //txtTitle.border = true;
        addChild(txtTitle);

        txtInfo = new TextField();
        txtInfo.defaultTextFormat = new TextFormat(Paths.font('advent_pro'), 25, FlxColor.WHITE, true, null, null, null, null, "left");
        txtInfo.text = info;
        txtInfo.autoSize = LEFT;
		txtInfo.multiline = true;
        //txtInfo.width = 0;
        txtInfo.y = -500;
        //txtInfo.border = true;
        addChild(txtInfo);

        bg.width = 350;
        bg.height = Math.ceil(txtInfo.textHeight) * 2 + 30;
        FlxG.sound.play(Paths.sound(sound));

        txtTitle.x = bg.width / 2 - txtTitle.width / 2;
        txtInfo.x = bg.width / 2 - txtInfo.width / 2;
        //bg.x = (Lib.current.stage.stageWidth - bg.width) / 2;

        NotificationPopup.time.start(NotificationPopup.total);

        var targetY:Float = -25;
        FlxTween.tween(bg, {y: targetY + bg.height + 20}, 0.2, {ease: FlxEase.quartOut});
        FlxTween.tween(txtTitle, {y: targetY + bg.height + 20}, 0.2, {ease: FlxEase.quartOut});
        FlxTween.tween(txtInfo, {y: targetY + bg.height + (bg.height / 2 + 30)}, 0.2, {ease: FlxEase.quartOut, onComplete: function(t:FlxTween)
        {
            FlxTween.tween(bg, {y: targetY - bg.height}, 0.2, {ease: FlxEase.quartOut, startDelay: 1.5});
            FlxTween.tween(txtTitle, {y: targetY - bg.height}, 0.2, {ease: FlxEase.quartOut, startDelay: 1.5});
            FlxTween.tween(txtInfo, {y: targetY - bg.height + (bg.height / 2)}, 0.2, {ease: FlxEase.quartOut, startDelay: 1.5, onComplete: function(t:FlxTween){ removeChildren(); }});
        }});

        x = 25;
    }
}

class NotificationPopup extends Sprite
{
    var showing:Bool = false;
    var delayed:Bool = false;
    public function new() 
    {
        super();
        FlxG.stage.addEventListener(Event.RESIZE, onResize);
        FlxG.signals.postStateSwitch.add(onStateSwitch);
    }

    public static var time:FlxTimer = new FlxTimer();

    public static var enter:Float = 0.2;
    public static var display:Float = 1.7;
    public static var leave:Float = 1.9;
    public static var total:Float = 1.9;

    public static var lastScale:Float = 1;

    public function popUpNotification(sound:String, title:String, info:String)
    {
        // if(NotificationDownload.isShowing) return;
        
		lastScale = (FlxG.stage.stageHeight / FlxG.height);

        if (!showing)
        {
        var notif:Notification = new Notification(sound, title, info);
        addChild(notif);
        }
        else
        {
            new FlxTimer().start(1.5, function(tmr:FlxTimer)
                {
                    var notif:Notification = new Notification(sound, title, info);
                    addChild(notif);
                    delayed = true;
                });
        }
        showing = true;
        if (!delayed)
        new FlxTimer().start(1.75, function(tmr:FlxTimer) { showing = false; });
        else
        new FlxTimer().start(3.35, function(tmr:FlxTimer) { 
            showing = false;
            delayed = false;
         });
    }

    public function onStateSwitch()
    {
        if (!time.active)
            return;

        //var elapsedSec = time.elapsedTime / 1000;
        var elapsedSec = time.elapsedTime / 1000;
        trace(time.elapsedTime);
        if (elapsedSec < enter)
        {
            for (i in 0...numChildren)
            {
                var child = getChildAt(i);
                FlxTween.cancelTweensOf(child);
                FlxTween.tween(child, {y: (numChildren - 1 - i) * child.height}, 0.2, {ease: FlxEase.linear,
                    onComplete: function(tween:FlxTween)
                    {
                        FlxTween.cancelTweensOf(child);
                        FlxTween.tween(child, {y: (i + 1) * -child.height}, 0.2, {ease: FlxEase.linear, startDelay: display,
                            onComplete: function(tween:FlxTween)
                            {
                                cast(child, Notification).removeChildren();
                                removeChild(child);
                            }
                        });
                    }
                });
            }
        }
        else if (elapsedSec < display)
        {
            for (i in 0...numChildren)
            {
                var child = getChildAt(i);
                FlxTween.cancelTweensOf(child);
                FlxTween.tween(child, {y: (i + 1) * -child.height}, 0.2, {ease: FlxEase.linear, startDelay: display - (elapsedSec - enter),
                    onComplete: function(tween:FlxTween)
                    {
                        cast(child, Notification).removeChildren();
                        removeChild(child);
                    }
                });
            }
        }
        else if (elapsedSec < leave)
        {
            for (i in 0...numChildren)
            {
                var child = getChildAt(i);
                FlxTween.tween(child, {y: (i + 1) * -child.height}, 0.2, {ease: FlxEase.linear,
                    onComplete: function(tween:FlxTween)
                    {
                        cast(child, Notification).removeChildren();
                        removeChild(child);
                    }
                });
            }
        }
    }

    public function onResize(e:Event)
    {
		var mult = (FlxG.stage.stageHeight / FlxG.height);
		scaleX = mult;
		scaleY = mult;

		x = (mult / lastScale) * x;
		y = (mult / lastScale) * y;
		lastScale = mult;
        
        trace("X: " + x);
    }
}