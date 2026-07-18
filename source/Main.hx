package;

import ui.notification.Notification.NotificationPopup;

class Main extends Sprite
{
    public var game = {
        width: 1920,
        height: 1080,
        initialState: MainState,
        fps: 60,
        skipSplash: true
    }

	public static var notificationPopup:NotificationPopup;

	public function new()
	{
		super();
        
        // FlxG.mouse.useSystemCursor = true;
        FlxSprite.defaultAntialiasing = true;

        var game = new FlxGame(game.width, game.height, game.initialState, game.fps, game.fps, game.skipSplash);
		addChild(game);
        
        FlxG.autoPause = false;

		notificationPopup = new NotificationPopup();
		addChild(notificationPopup);
	}
}