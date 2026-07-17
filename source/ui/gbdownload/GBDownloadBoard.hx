package ui.gbdownload;

class GBDownloadBoard extends FlxSpriteGroup
{
    public var onHideCustomBehavior:()->Void;
    public var isBoardOpen:Bool = false;
    
    public var background:FlxSprite;
    public var boardBackground:FlxSprite;
    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);

        background = new FlxSprite();
        background.makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
        background.alpha = 0;
        add(background);

        boardBackground = new FlxSprite();
        boardBackground.makeGraphic(1150, 850, 0xFF000000);
        boardBackground.alpha = 0;
        boardBackground.screenCenter();
        boardBackground.y += 60;
        add(boardBackground);
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if(!active) return;
    }

    public function show(duration:Float, ?customBehaviour:()->Void)
    {
        isBoardOpen = true;
        if(customBehaviour != null) customBehaviour();
        FlxTween.tween(background, {alpha: 0.6}, duration, {ease: FlxEase.quartOut});
        FlxTween.tween(boardBackground, {alpha: 0.7}, duration, {ease: FlxEase.quartOut});
    }
    
    public function hide(duration:Float, ?customBehaviour:()->Void)
    {
        isBoardOpen = false;
        if(onHideCustomBehavior != null) onHideCustomBehavior();
        if(customBehaviour != null) customBehaviour();

        active = false;
        FlxTween.tween(background, {alpha: 0}, duration, {ease: FlxEase.quartOut});
        FlxTween.tween(boardBackground, {alpha: 0}, duration, {ease: FlxEase.quartOut});
    }
}