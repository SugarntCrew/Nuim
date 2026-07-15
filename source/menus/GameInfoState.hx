package menus;

import ui.games.PlayButton;
import ui.games.Heroe;

class GameInfoState extends Substate
{
    private var data:GameData;
    private var camReference:FlxCamera;
    var heroe:Heroe;
    var backgroundGradient:FlxSprite;
    var background:FlxSprite;
    var line:FlxSprite;

    var titleText:FlxText;
    var playButton:PlayButton;

    var descriptionBackground:FlxSprite;
    var descriptionTitleText:FlxText;
    var descriptionLine:FlxSprite;
    var descriptionText:FlxText;
    
    var companyTitleText:FlxText;
    var companyLine:FlxSprite;
    var companyText:FlxText;

    var genreTitleText:FlxText;
    var genreLine:FlxSprite;
    var genreText:FlxText;

    var releaseTitleText:FlxText;
    var releaseLine:FlxSprite;
    var releaseText:FlxText;

    var versionTitleText:FlxText;
    var versionLine:FlxSprite;
    var versionText:FlxText;

    var header:Header;
    var footer:Footer;

    public function new(_data:GameData, _camReference:FlxCamera)
    {
        super();

        data = _data;
        camReference = _camReference;
    }

    var spacingFieldsY:Float = 25;
    override function create()
    {
        trace('Substate opened!');

        heroe = new Heroe(0, 0, data.heroe_image, true);
        add(heroe);

        backgroundGradient = new FlxSprite(0, 140);
        backgroundGradient.loadGraphic(Paths.image('ui/gameinfo/gradient'));
        backgroundGradient.alpha = 0.65;
        add(backgroundGradient);

        background = new FlxSprite();
        background.makeGraphic(FlxG.width, FlxG.height * 2, 0xFF000000);
        background.y = backgroundGradient.y + backgroundGradient.height;
        background.alpha = 0.65;
        add(background);

        line = new FlxSprite();
        line.makeGraphic(FlxG.width - 80, 2, 0xFF636363);
        line.x = 20;
        line.y = background.y - 1;
        line.alpha = 0.7;
        add(line);

        titleText = new FlxText(0, 0, 0, data.name);
        titleText.setFormat(Paths.font('advent_pro'), 70, 0xFFFFFFFF, LEFT);
        titleText.x = line.x + 35;
        titleText.y = line.y - titleText.height - 5;
        add(titleText);

        playButton = new PlayButton(line.x + 35, line.y + 20, data, FlxG.cameras.list[FlxG.cameras.list.length - 1]);
        playButton.onHoverCallback = function(data)
        {
            FlxG.sound.play(Paths.sound('changeSfx'));
        }
        add(playButton);

        descriptionBackground = new FlxSprite();
        descriptionBackground.makeGraphic(800, FlxG.height, 0xFF000000);
        descriptionBackground.alpha = 0.56;
        descriptionBackground.x = FlxG.width - 60 - descriptionBackground.width - 20;
        descriptionBackground.y = line.y + 20;
        add(descriptionBackground);

        descriptionTitleText = new FlxText(descriptionBackground.x + 10, descriptionBackground.y + 10, descriptionBackground.width - 20, 'Description', 16);
        descriptionTitleText.setFormat(Paths.font('advent_pro'), 40, 0xFFFFFFFF, LEFT);
        add(descriptionTitleText);

        descriptionLine = new FlxSprite();
        descriptionLine.makeGraphic(Std.int(descriptionBackground.width - 20), 2, 0xFF636363);
        descriptionLine.x = descriptionBackground.x + 10;
        descriptionLine.y = descriptionTitleText.y + descriptionTitleText.height + 5;
        descriptionLine.alpha = 0.7;
        add(descriptionLine);

        descriptionText = new FlxText(descriptionBackground.x + 10, descriptionLine.y + 10, descriptionBackground.width - 20, data.description ?? 'No description provided.', 16);
        descriptionText.setFormat(Paths.font('advent_pro'), 25, 0xFFE7E7E7, LEFT);
        add(descriptionText);

        companyTitleText = new FlxText(descriptionBackground.x + 10, descriptionText.y + descriptionText.height + spacingFieldsY, descriptionBackground.width - 20, 'Company', 16);
        companyTitleText.setFormat(Paths.font('advent_pro'), 40, 0xFFFFFFFF, LEFT);
        add(companyTitleText);

        companyLine = new FlxSprite();
        companyLine.makeGraphic(Std.int(descriptionBackground.width - 20), 2, 0xFF636363);
        companyLine.x = descriptionBackground.x + 10;
        companyLine.y = companyTitleText.y + companyTitleText.height + 5;
        companyLine.alpha = 0.7;
        add(companyLine);

        var companyTxt:String = 'Developed by ${data.developer ?? 'Unknown'}\nPublished by ${data.publisher ?? 'Unknown'}';
        companyText = new FlxText(descriptionBackground.x + 10, companyLine.y + 10, descriptionBackground.width - 20, companyTxt, 16);
        companyText.setFormat(Paths.font('advent_pro'), 25, 0xFFE7E7E7, LEFT);
        add(companyText);

        genreTitleText = new FlxText(descriptionBackground.x + 10, companyText.y + companyText.height + spacingFieldsY, descriptionBackground.width - 20, 'Genre', 16);
        genreTitleText.setFormat(Paths.font('advent_pro'), 40, 0xFFFFFFFF, LEFT);
        add(genreTitleText);

        genreLine = new FlxSprite();
        genreLine.makeGraphic(Std.int(descriptionBackground.width - 20), 2, 0xFF636363);
        genreLine.x = descriptionBackground.x + 10;
        genreLine.y = genreTitleText.y + genreTitleText.height + 5;
        genreLine.alpha = 0.7;
        add(genreLine);

        genreText = new FlxText(descriptionBackground.x + 10, genreLine.y + 10, descriptionBackground.width - 20, data.genre ?? 'Unknown', 16);
        genreText.setFormat(Paths.font('advent_pro'), 25, 0xFFE7E7E7, LEFT);
        add(genreText);

        releaseTitleText = new FlxText(descriptionBackground.x + 10, genreText.y + genreText.height + spacingFieldsY, descriptionBackground.width - 20, 'Release', 16);
        releaseTitleText.setFormat(Paths.font('advent_pro'), 40, 0xFFFFFFFF, LEFT);
        add(releaseTitleText);

        releaseLine = new FlxSprite();
        releaseLine.makeGraphic(Std.int(descriptionBackground.width - 20), 2, 0xFF636363);
        releaseLine.x = descriptionBackground.x + 10;
        releaseLine.y = releaseTitleText.y + releaseTitleText.height + 5;
        releaseLine.alpha = 0.7;
        add(releaseLine);

        releaseText = new FlxText(descriptionBackground.x + 10, releaseLine.y + 10, descriptionBackground.width - 20, data.release ?? 'Unknown', 16);
        releaseText.setFormat(Paths.font('advent_pro'), 25, 0xFFE7E7E7, LEFT);
        add(releaseText);

        versionTitleText = new FlxText(descriptionBackground.x + 10, releaseText.y + releaseText.height + spacingFieldsY, descriptionBackground.width - 20, 'Version', 16);
        versionTitleText.setFormat(Paths.font('advent_pro'), 40, 0xFFFFFFFF, LEFT);
        add(versionTitleText);

        versionLine = new FlxSprite();
        versionLine.makeGraphic(Std.int(descriptionBackground.width - 20), 2, 0xFF636363);
        versionLine.x = descriptionBackground.x + 10;
        versionLine.y = versionTitleText.y + versionTitleText.height + 5;
        versionLine.alpha = 0.7;
        add(versionLine);

        versionText = new FlxText(descriptionBackground.x + 10, versionLine.y + 10, descriptionBackground.width - 20, data.version ?? 'Unknown', 16);
        versionText.setFormat(Paths.font('advent_pro'), 25, 0xFFE7E7E7, LEFT);
        add(versionText);
        
        header = new Header();
        header.scrollFactor.set(0, 0);
        add(header);

        camera = FlxG.cameras.list[FlxG.cameras.list.length - 1];
    }

    var targetScrollY:Float = 0;
    var scrollIntensity:Float = 40;
    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if(FlxG.keys.justPressed.ESCAPE)
        {
            goBackToMain();
        }        
        
        var mult = FlxMath.lerp(camReference.scroll.y, targetScrollY, elapsed * 12);
        camReference.scroll.set(0, mult);

        if(FlxG.mouse.wheel != 0)
        {
            if(FlxG.mouse.wheel > 0) 
            {
                targetScrollY += -scrollIntensity;
                if(targetScrollY < 0) 
                {
                    targetScrollY = 0;
                    //mainCam.scroll.set(0, targetScrollY);
                }
            }
            else if(FlxG.mouse.wheel < 0)
            {
                targetScrollY += scrollIntensity;
                if(targetScrollY > versionText.y + versionText.height - FlxG.camera.height + 10) 
                {
                    targetScrollY = versionText.y + versionText.height - FlxG.camera.height + 10;
                    //mainCam.scroll.set(0, targetScrollY);
                }
            }
        }
    }

    function goBackToMain()
    {
        trace('Going back to main!');
        FlxG.sound.play(Paths.sound('backSfx'));
        close();
    }
}