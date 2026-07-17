package menus;

import backend.BytesUtil;
import ui.gbdownload.GBDownloadBoard;
import ui.header.DateText;
import backend.DateUtils;
import flixel.ui.FlxBar;
import sys.thread.Thread;
import backend.Constants;
import sys.io.Process;
import ui.games.GamebananaButton;
import menus.ImagesDot.ImageDot;
import flixel.group.FlxGroup.FlxTypedGroup;
import sys.io.File;
import sys.FileSystem;
import backend.api.GamebananaAPI;
import ui.games.Button;
import ui.games.Heroe;

class GameInfoState extends Substate
{
    private var data:GameData;
    private var camReference:FlxCamera;

    public var hasGbLink:Bool = false;
    public var modId:String = '';
    public var imageNum:Int = 0;
    public var curSelectedImage:Int = 0;

    var heroe:Heroe;
    var backgroundGradient:FlxSprite;
    var background:FlxSprite;
    var line:FlxSprite;

    var titleText:FlxText;
    var gamebananaButton:GamebananaButton;
    var playButton:Button;

    public var downloadProgress:Float;
    public var gbDownloadBg:FlxSprite;
    public var gbDownloadBar:FlxBar;
    public var gbDownloadText:FlxText;

    var previewImage:FlxSprite;
    var previewImageDotsGrp:ImagesDot;
    var downloadProgressBG:FlxSprite;
    var downloadProgressText:FlxText;
    var downloadProgressBar:FlxBar;

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

    var gbDownloadBoard:GBDownloadBoard;

    var header:Header;
    var footer:Footer;

    public function new(_data:GameData, _camReference:FlxCamera)
    {
        super();

        data = _data;
        camReference = _camReference;
        hasGbLink = data.gamebanana_url != null;

        trace('GAMEBANANA LINK PRESENCE IS $hasGbLink');
    }

    var spacingFieldsY:Float = 25;
    override function create()
    {
        super.create();
        trace('Substate opened!');

        main = Thread.current();

        previewImage = new FlxSprite();

        var heroeParams:HeroeParams = {
            imagePath: Paths.image('games/heroes/${data.heroe_image}'),
            bitmapDataLoad: false,
            apiPath: Paths.gamebananaAPIimage('games/heroes/${GamebananaAPI.getModIdFromUrl(data.gamebanana_url)}_heroe')
        }
        heroe = new Heroe(0, 0, heroeParams, true);
        heroe?.fitToScreen();
        add(heroe);

        backgroundGradient = new FlxSprite(0, 140);
        backgroundGradient.loadGraphic(Paths.image('ui/gameinfo/gradient'));
        backgroundGradient.alpha = 0;
        add(backgroundGradient);

        FlxTween.tween(backgroundGradient, {alpha: 0.65}, 0.6, {ease: FlxEase.quartOut});

        background = new FlxSprite();
        background.makeGraphic(FlxG.width, FlxG.height * 2, 0xFF000000);
        background.y = backgroundGradient.y + backgroundGradient.height;
        background.alpha = 0;
        add(background);

        FlxTween.tween(background, {alpha: 0.65}, 0.6, {ease: FlxEase.quartOut});

        line = new FlxSprite();
        line.makeGraphic(FlxG.width - 80, 2, 0xFF636363);
        line.x = 20;
        line.y = background.y - 1;
        line.alpha = 0;
        add(line);

        titleText = new FlxText(0, 0, 0, data.name);
        titleText.setFormat(Paths.font('advent_pro'), 70, 0xFFFFFFFF, LEFT);
        titleText.x = line.x + 35;
        titleText.y = line.y - titleText.height - 5;
        titleText.alpha = 0;
        add(titleText);

        gamebananaButton = new GamebananaButton(0, 0, data, camReference);
        gamebananaButton.x = FlxG.width - gamebananaButton.width - 60 - 35;
        gamebananaButton.y = line.y - gamebananaButton.height - 5;
        gamebananaButton.visible = gamebananaButton.active = hasGbLink;
        gamebananaButton.alpha = 0;
        gamebananaButton.onClickCallback = function(data, ?customBehavior)
        {
            if(!hasGbLink) return;
            FlxG.openURL(data.gamebanana_url);
        }
        add(gamebananaButton);

        playButton = new Button(line.x + 35, line.y + 20, data, FlxG.cameras.list[FlxG.cameras.list.length - 1]);
        playButton.onHoverCallback = function(data)
        {
            FlxG.sound.play(Paths.sound('changeSfx'));
        }
        playButton.onClickCallback = function(data, ?customBehavior)
        {
            // NOTE: THIS ALSO HAS TO INCLUDE IF THE BUILD IS ALREADY DOWNLOADED TO SKIP THIS AND OPEN THE GAME EVEN THOUGH OF THE GAMEBANANA URL
            if(data.gamebanana_url != null)
            {
                gbDownloadBoard.active = true;
                gbDownloadBoard.show(0.9, function()
                {
                    playButton.active = false;
                    canScroll = false;
                });
            }
            else
            {
                var location:String = data.game_location;
                
                if(!FileSystem.exists(location)) return;

                trace(location);

                var path = location.substr(0, location.lastIndexOf("\\") == -1 ? location.lastIndexOf("/") : location.lastIndexOf("\\"));
                var exeName = location.substr((location.lastIndexOf("\\") == -1 ? location.lastIndexOf("/") : location.lastIndexOf("\\")) + 1, location.length);
                if(!StringTools.endsWith(exeName, '.exe')) exeName = location.substr((location.lastIndexOf("\\") == -1 ? location.lastIndexOf("/") : location.lastIndexOf("\\")) + 1, location.length);
                if(!StringTools.endsWith(exeName, '.exe')) return;

                trace(exeName);
                var appName = exeName.substr(0, exeName.length - 4);
                trace(appName);
                trace(path);

                Sys.setCwd(path);

                var process = new Process('start $appName');
                if(process.exitCode() == 0)
                {
                    trace('Reset path to launcher');
                    Sys.setCwd(Constants.LAUNCHER_PATH);
                }
                process.close();
            }
        }
        playButton.alpha = 0;
        // TODO: change image only if build does not exist
        if(data.gamebanana_url != null) playButton.playButton.loadGraphic(Paths.image('ui/gameinfo/downloadGame'));
        add(playButton);

        gbDownloadBg = new FlxSprite(playButton.x + playButton.width + 10, playButton.y + 4.5);
        gbDownloadBg.makeGraphic(620, 88, 0xFF000000);
        gbDownloadBg.alpha = 0.65;
        gbDownloadBg.visible = false;
        add(gbDownloadBg);

        gbDownloadBar = new FlxBar(gbDownloadBg.x + 10, 0, LEFT_TO_RIGHT, Std.int(gbDownloadBg.width - 20), 5, this, 'downloadProgress', 0, 1);
        gbDownloadBar.y = gbDownloadBg.y + gbDownloadBg.height - gbDownloadBar.height - 10;
        gbDownloadBar.createFilledBar(0xFFA1A1A1, 0xFFE9E9E9);
        gbDownloadBar.visible = false;
        add(gbDownloadBar);

        gbDownloadText = new FlxText(gbDownloadBg.x, 0, gbDownloadBg.width, '', 20);
        gbDownloadText.setFormat(Paths.font('advent_pro'), 25, 0xFFFFFFFF, CENTER);
        gbDownloadText.y = gbDownloadBg.y + 10;
        gbDownloadText.visible = false;
        add(gbDownloadText);

        previewImage.x = line.x + 35;
        previewImage.y = playButton.y + playButton.height + 30;
        previewImage.visible = false;
        add(previewImage);

        downloadProgressBG = new FlxSprite();
        downloadProgressBG.makeGraphic(800, 100, 0xFF000000);
        downloadProgressBG.alpha = 0;
        downloadProgressBG.visible = false;
        add(downloadProgressBG);

        downloadProgressText = new FlxText(0, 0, 750, 'Downloading metadata from GameBanana (0/?)', 25);
        downloadProgressText.setFormat(Paths.font('advent_pro'), 25, 0xFFFFFFFF, CENTER);
        downloadProgressText.y = playButton.y + playButton.height + 70;
        downloadProgressText.visible = false;
        downloadProgressText.alpha = 0;
        add(downloadProgressText);

        downloadProgressBar = new FlxBar(0, 0, LEFT_TO_RIGHT, 750, 10, this, 'imageNum', 0, 100, false);
        downloadProgressBar.y = downloadProgressText.y + downloadProgressText.height + 20;
        downloadProgressBar.createFilledBar(0xFFA1A1A1, 0xFFE9E9E9);
        downloadProgressBar.visible = false;
        downloadProgressBar.alpha = 0;
        add(downloadProgressBar);

        descriptionBackground = new FlxSprite();
        descriptionBackground.makeGraphic(800, FlxG.height, 0xFF000000);
        descriptionBackground.alpha = 0.56;
        descriptionBackground.x = FlxG.width - 60 - descriptionBackground.width - 20;
        descriptionBackground.y = line.y + 20;
        descriptionBackground.alpha = 0;
        add(descriptionBackground);

        var width:Float = descriptionBackground.x - (line.x + 35);
        downloadProgressText.x = line.x + 35 + width / 2 - downloadProgressText.width / 2;
        downloadProgressBar.x = line.x + 35 + width / 2 - downloadProgressBar.width / 2;
        downloadProgressBG.x = line.x + 35 + width / 2 - downloadProgressBG.width / 2;
        downloadProgressBar.alpha = 0;
        downloadProgressBG.y = downloadProgressText.y - 25;

        descriptionTitleText = new FlxText(descriptionBackground.x + 10, descriptionBackground.y + 10, descriptionBackground.width - 20, 'Description', 16);
        descriptionTitleText.setFormat(Paths.font('advent_pro'), 40, 0xFFFFFFFF, LEFT);
        descriptionTitleText.alpha = 0;
        add(descriptionTitleText);

        descriptionLine = new FlxSprite();
        descriptionLine.makeGraphic(Std.int(descriptionBackground.width - 20), 2, 0xFF636363);
        descriptionLine.x = descriptionBackground.x + 10;
        descriptionLine.y = descriptionTitleText.y + descriptionTitleText.height + 5;
        descriptionLine.alpha = 0;
        add(descriptionLine);

        descriptionText = new FlxText(descriptionBackground.x + 10, descriptionLine.y + 10, descriptionBackground.width - 20, data.description ?? 'No description provided.', 16);
        descriptionText.setFormat(Paths.font('advent_pro'), 25, 0xFFE7E7E7, LEFT);
        descriptionText.alpha = 0;
        add(descriptionText);

        companyTitleText = new FlxText(descriptionBackground.x + 10, descriptionText.y + descriptionText.height + spacingFieldsY, descriptionBackground.width - 20, 'Company', 16);
        companyTitleText.setFormat(Paths.font('advent_pro'), 40, 0xFFFFFFFF, LEFT);
        companyTitleText.alpha = 0;
        add(companyTitleText);

        companyLine = new FlxSprite();
        companyLine.makeGraphic(Std.int(descriptionBackground.width - 20), 2, 0xFF636363);
        companyLine.x = descriptionBackground.x + 10;
        companyLine.y = companyTitleText.y + companyTitleText.height + 5;
        companyLine.alpha = 0;
        add(companyLine);

        var companyTxt:String = 'Developed by ${data.developer ?? 'Unknown'}\nPublished by ${data.publisher ?? 'Unknown'}';
        companyText = new FlxText(descriptionBackground.x + 10, companyLine.y + 10, descriptionBackground.width - 20, companyTxt, 16);
        companyText.setFormat(Paths.font('advent_pro'), 25, 0xFFE7E7E7, LEFT);
        companyText.alpha = 0;
        add(companyText);

        genreTitleText = new FlxText(descriptionBackground.x + 10, companyText.y + companyText.height + spacingFieldsY, descriptionBackground.width - 20, 'Genre', 16);
        genreTitleText.setFormat(Paths.font('advent_pro'), 40, 0xFFFFFFFF, LEFT);
        genreTitleText.alpha = 0;
        add(genreTitleText);

        genreLine = new FlxSprite();
        genreLine.makeGraphic(Std.int(descriptionBackground.width - 20), 2, 0xFF636363);
        genreLine.x = descriptionBackground.x + 10;
        genreLine.y = genreTitleText.y + genreTitleText.height + 5;
        genreLine.alpha = 0;
        add(genreLine);

        genreText = new FlxText(descriptionBackground.x + 10, genreLine.y + 10, descriptionBackground.width - 20, data.genre ?? 'Unknown', 16);
        genreText.setFormat(Paths.font('advent_pro'), 25, 0xFFE7E7E7, LEFT);
        genreText.alpha = 0;
        add(genreText);

        releaseTitleText = new FlxText(descriptionBackground.x + 10, genreText.y + genreText.height + spacingFieldsY, descriptionBackground.width - 20, 'Release', 16);
        releaseTitleText.setFormat(Paths.font('advent_pro'), 40, 0xFFFFFFFF, LEFT);
        releaseTitleText.alpha = 0;
        add(releaseTitleText);

        releaseLine = new FlxSprite();
        releaseLine.makeGraphic(Std.int(descriptionBackground.width - 20), 2, 0xFF636363);
        releaseLine.x = descriptionBackground.x + 10;
        releaseLine.y = releaseTitleText.y + releaseTitleText.height + 5;
        releaseLine.alpha = 0;
        add(releaseLine);

        releaseText = new FlxText(descriptionBackground.x + 10, releaseLine.y + 10, descriptionBackground.width - 20, data.release ?? 'Unknown', 16);
        releaseText.setFormat(Paths.font('advent_pro'), 25, 0xFFE7E7E7, LEFT);
        releaseText.alpha = 0;
        add(releaseText);

        versionTitleText = new FlxText(descriptionBackground.x + 10, releaseText.y + releaseText.height + spacingFieldsY, descriptionBackground.width - 20, 'Version', 16);
        versionTitleText.setFormat(Paths.font('advent_pro'), 40, 0xFFFFFFFF, LEFT);
        versionTitleText.alpha = 0;
        add(versionTitleText);

        versionLine = new FlxSprite();
        versionLine.makeGraphic(Std.int(descriptionBackground.width - 20), 2, 0xFF636363);
        versionLine.x = descriptionBackground.x + 10;
        versionLine.y = versionTitleText.y + versionTitleText.height + 5;
        versionLine.alpha = 0;
        add(versionLine);

        versionText = new FlxText(descriptionBackground.x + 10, versionLine.y + 10, descriptionBackground.width - 20, data.version ?? 'Unknown', 16);
        versionText.setFormat(Paths.font('advent_pro'), 25, 0xFFE7E7E7, LEFT);
        versionText.alpha = 0;
        add(versionText);

        gbDownloadBoard = new GBDownloadBoard(0, 0, this, data);
        gbDownloadBoard.scrollFactor.set(0, 0);
        gbDownloadBoard.active = false;
        gbDownloadBoard.onHideCustomBehavior = function()
        {
            canScroll = true;
            playButton.active = true;
        }
        add(gbDownloadBoard);
        
        header = new Header();
        header.scrollFactor.set(0, 0);
        add(header);

        if(hasGbLink) 
        {
            requestModDataGamebanana([NAME, DESCRIPTION, SUBTITLE, VERSION, DATE_ADDED, DATE_MODIFIED, IMAGES, FILES, VIEWS, LIKES, POSTS]);
            installPortalImages();
        }
        else
        {
            uiTransition();
        }

        camera = FlxG.cameras.list[FlxG.cameras.list.length - 1];
    }
    
    function uiTransition(transIn:Bool = true, ?finishCallback:(twn:FlxTween)->Void)
    {
        var duration:Float = 0.6;
        if(transIn)
        {
            FlxTween.tween(line, {alpha: 0.7}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(titleText, {alpha: 1}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(gamebananaButton, {alpha: 1}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(playButton, {alpha: 1}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(downloadProgressBG, {alpha: 0.7}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(downloadProgressText, {alpha: 1}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(downloadProgressBar, {alpha: 1}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(descriptionTitleText, {alpha: 1}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(descriptionLine, {alpha: 0.7}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(descriptionText, {alpha: 1}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(companyTitleText, {alpha: 1}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(companyLine, {alpha: 0.7}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(companyText, {alpha: 1}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(genreTitleText, {alpha: 1}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(genreLine, {alpha: 0.7}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(genreText, {alpha: 1}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(releaseTitleText, {alpha: 1}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(releaseLine, {alpha: 0.7}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(releaseText, {alpha: 1}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(versionTitleText, {alpha: 1}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(versionLine, {alpha: 0.7}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(versionText, {alpha: 1}, duration, {ease: FlxEase.quadOut, onComplete: finishCallback ?? function(twn:FlxTween) {}});

            FlxTween.tween(gbDownloadBg, {alpha: 0.7}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(gbDownloadBar, {alpha: 1}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(gbDownloadText, {alpha: 1}, duration, {ease: FlxEase.quadOut});
        }
        else
        {
            FlxTween.tween(line, {alpha: 0}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(titleText, {alpha: 0}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(gamebananaButton, {alpha: 0}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(playButton, {alpha: 0}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(downloadProgressBG, {alpha: 0}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(downloadProgressText, {alpha: 0}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(downloadProgressBar, {alpha: 0}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(descriptionTitleText, {alpha: 0}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(descriptionLine, {alpha: 0}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(descriptionText, {alpha: 0}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(companyTitleText, {alpha: 0}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(companyLine, {alpha: 0}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(companyText, {alpha: 0}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(genreTitleText, {alpha: 0}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(genreLine, {alpha: 0}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(genreText, {alpha: 0}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(releaseTitleText, {alpha: 0}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(releaseLine, {alpha: 0}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(releaseText, {alpha: 0}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(versionTitleText, {alpha: 0}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(versionLine, {alpha: 0}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(versionText, {alpha: 0}, duration, {ease: FlxEase.quadOut, onComplete: finishCallback ?? function(twn:FlxTween) {}});

            FlxTween.tween(previewImage, {alpha: 0}, duration, {ease: FlxEase.quartOut});
            FlxTween.tween(gbDownloadBg, {alpha: 0}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(gbDownloadBar, {alpha: 0}, duration, {ease: FlxEase.quadOut});
            FlxTween.tween(gbDownloadText, {alpha: 0}, duration, {ease: FlxEase.quadOut});

            FlxTween.tween(backgroundGradient, {alpha: 0}, 0.6, {ease: FlxEase.quartOut});
            FlxTween.tween(background, {alpha: 0}, 0.6, {ease: FlxEase.quartOut});
        }
    }

    var targetScrollY:Float = 0;
    var scrollIntensity:Float = 40;
    var canScroll:Bool = true;
    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if(FlxG.keys.justPressed.ESCAPE)
        {
            if(gbDownloadBoard.isBoardOpen) gbDownloadBoard.hide(0.7);
            else goBackToMain();
        }

        if(FlxG.keys.justPressed.LEFT)
        {
            changeImageSelect(-1);
        }

        if(FlxG.keys.justPressed.RIGHT)
        {
            changeImageSelect(1);
        }
        
        var mult = FlxMath.lerp(camReference.scroll.y, targetScrollY, elapsed * 12);
        camReference.scroll.set(0, mult);

        if(FlxG.mouse.wheel != 0)
        {
            if(!canScroll) return;

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

        // async stuff
        var msg = Thread.readMessage(false);
        while(msg != null)
        {
            if(!subAlive) break;
            switch(msg.type)
            {
                case 'metadata_ready':

                    trace(msg.modId, msg.name, msg.description);

                    titleText.text = msg.name ?? data.name;
                    descriptionText.text = msg.description ?? (data.description ?? 'No description provided.');
                    versionText.text = (msg.version == '' ? 'Unknown' : msg.version) ?? (data.version ?? 'Unknown');
                    
                    var releaseDate = msg.date_added ?? (data.release ?? 'Unknown');
                    if(releaseDate != null)
                    {
                        trace('Release date is $releaseDate');
                        var convertRelease = DateUtils.convertMsToDate(Std.parseFloat(releaseDate));
                        trace('Release date converted is ${convertRelease}');
                        var releaseYear = convertRelease.getFullYear();
                        trace('Year = $releaseYear');

                        releaseText.text = '$releaseYear';
                    }

                    gbDownloadBoard.refresh(msg.files, main);

                    var heroeParams:HeroeParams = {
                        imagePath: Paths.gamebananaAPIimage('cache/games/portal/${msg.modId}/image0'),
                        bitmapDataLoad: true,
                        apiPath: Paths.gamebananaAPIimage('cache/games/portal/${msg.modId}/image0')
                    }
                    heroe?.regenImage(heroeParams, true, true);
                    heroe?.fitToScreen();
                    relocateHud();
                    uiTransition();

                case 'heroe_download':

                    downloadProgressBar.visible = false;
                    downloadProgressText.text = 'Downloading heroe (${msg.modId})';

                case 'images_ready':
                    modId = msg.modId;
                    imageNum = msg.imageNum;

                    previewImage.visible = true;
                    changeImageSelect();

                    previewImageDotsGrp = new ImagesDot(0, 0, imageNum, curSelectedImage);
                    previewImageDotsGrp.x = previewImage.x + previewImage.width / 2 - previewImageDotsGrp.width / 2;
                    previewImageDotsGrp.y = previewImage.y + previewImage.height + 20;
                    add(previewImageDotsGrp);
                    
                    remove(gbDownloadBoard, false);
                    insert(members.length, gbDownloadBoard);

                    remove(header, false);
                    insert(members.length, header);

                    downloadProgressBar.visible = false;
                    downloadProgressText.visible = false;
                    downloadProgressBG.visible = false;
                    
                    var heroeParams:HeroeParams = {
                        imagePath: Paths.gamebananaAPIimage('cache/games/portal/${msg.modId}/image0'),
                        bitmapDataLoad: true,
                        apiPath: Paths.gamebananaAPIimage('games/heroes/${msg.modId}_heroe')
                    }
                    heroe?.regenImage(heroeParams, true, true);
                    heroe?.fitToScreen();
                case 'images_process':
                    downloadProgressBar.visible = true;
                    downloadProgressText.visible = true;
                    downloadProgressBG.visible = true;

                    downloadProgressBar.setRange(0, Std.parseInt(msg.imagesTotal));
                    imageNum = msg.imagesDownloaded;

                    downloadProgressText.text = 'Downloading images from GameBanana (${msg.imagesDownloaded}/${msg.imagesTotal})';
                case 'build_download_progress':
                    var loaded = msg.loaded;
                    var total = msg.total;
                    var progress = msg.progress;

                    gbDownloadBg.visible = true;
                    gbDownloadBar.visible = true;
                    gbDownloadText.visible = true;

                    var textLoaded = '${BytesUtil.formatBytes(loaded)}';
                    var textTotal = '${BytesUtil.formatBytes(total)}';
                    gbDownloadText.text = '$textLoaded / $textTotal';
                    downloadProgress = progress;
                case 'build_download_success':
                    gbDownloadBg.visible = false;
                    gbDownloadBar.visible = false;
                    gbDownloadText.visible = false;
                case 'readzip_progress':
                    trace("Reading readzip_progress");

                    gbDownloadBg.visible = true;
                    gbDownloadBar.visible = false;
                    gbDownloadText.visible = true;

                    gbDownloadText.text = 'Reading zip... (${msg.loaded} entries)';
                case 'unzip_progress':
                    trace("Reading unzip_progress");

                    var loaded = msg.loaded;
                    var total = msg.total;
                    var progress = msg.progress;
                    var writtenBytes = msg.writtenBytes;

                    gbDownloadBg.visible = true;
                    gbDownloadBar.visible = true;
                    gbDownloadText.visible = true;

                    gbDownloadText.text = 'Unzipping ${BytesUtil.formatBytes(writtenBytes)} ($loaded/$total entries unzipped)';
                    downloadProgress = progress;

                case 'unzip_complete':
                    trace("Reading unzip_complete");
                    gbDownloadBg.visible = false;
                    gbDownloadBar.visible = false;
                    gbDownloadText.visible = false;
                default:
            }

            msg = Thread.readMessage(false);
        }
    }

    function changeImageSelect(change:Int = 0)
    {
        if(!hasGbLink || imageNum <= 0) return;

        if(change != 0) FlxG.sound.play(Paths.sound('changeSfx'));
        
        curSelectedImage = FlxMath.wrap(curSelectedImage + change, 0, imageNum - 1);
        reloadImages('image$curSelectedImage');

        FlxTween.cancelTweensOf(previewImage);

        if(change != 0 && previewImage != null)
        {
            previewImage.x += change > 0 ? 10 : -10;
            FlxTween.tween(previewImage, {x: previewImage.x + (change > 0 ? -10 : 10)}, 0.5, {ease: FlxEase.quartOut});
        } 

        if(previewImageDotsGrp != null)
        {
            for(obj in previewImageDotsGrp.members)
            {
                var castedObj = cast(obj, ImageDot);
                castedObj.dotSelected = curSelectedImage == obj.ID;
            }
        }
    }

    function goBackToMain()
    {
        trace('Going back to main!');
        FlxG.sound.play(Paths.sound('backSfx'));
        //close();

        uiTransition(false, function(twn:FlxTween) { close(); });
    }

    var main:Thread;
    function installPortalImages()
    {
        var downloadParams:HeroeDownloadParams = {
            download: true,
            replace: false
        }
        GamebananaAPI.fetchImages(data.gamebanana_url, main, downloadParams);

        /*
        Thread.create(() -> {
            var localImageNum:Int = 0;
            GamebananaAPI.requestData(data.gamebanana_url, [IMAGES], function(apiData, id)
            {
                // trace(apiData);
                var images = apiData._aPreviewMedia._aImages;
                for(num => image in cast(images, Array<Dynamic>))
                {
                    var imageUrl = '${image._sBaseUrl}/${image._sFile}';
                    trace(imageUrl);
                    GamebananaAPI.saveImageFromURL(imageUrl, id, 'image$num');
                    localImageNum++;

                    if(subAlive)
                    {
                        main.sendMessage({
                            type: 'images_process',
                            imagesDownloaded: localImageNum,
                            imagesTotal: images.length
                        });
                    }
                }

                trace('Finished! Reloading images...');
                if(subAlive)
                {
                    main.sendMessage({
                        type: 'images_ready',
                        modId: id,
                        imageNum: localImageNum
                    });
                }
                //reloadImages('image$curSelectedImage');
            });
        });
        */
    }

    function requestModDataGamebanana(propierties:Array<GamebananaPropierties>)
    {
        /*
        Thread.create(() -> {
            GamebananaAPI.requestData(data.gamebanana_url, propierties, function(apiData, id)
            {
                main.sendMessage({
                    type: 'metadata_ready',
                    modId: id,
                    name: apiData._sName,
                    description: apiData._sDescription
                });
            });
        });
        */

        GamebananaAPI.fetchData(data.gamebanana_url, propierties, main);
    }

    function reloadImages(image:String)
    {
        trace('Reloading images...');

        var path = Paths.gamebananaAPIimage('cache/games/portal/$modId/$image');
        previewImage.loadGraphic(openfl.display.BitmapData.fromFile(path));
        previewImage.setGraphicSize(750);
        if(previewImage.height > 425) previewImage.setGraphicSize(0, 421);
        previewImage.updateHitbox();

        var width:Float = descriptionBackground.x - (line.x + 35);
        previewImage.x = line.x + 35 + width / 2 - previewImage.width / 2;
    }

    var subAlive:Bool = true;
    override function destroy()
    {
        subAlive = false;
        super.destroy();
    }

    function relocateHud()
    {
        // description
        descriptionLine.y = descriptionTitleText.y + descriptionTitleText.height + 5;
        descriptionText.y = descriptionLine.y + 10;

        // company
        companyTitleText.y = descriptionText.y + descriptionText.height + spacingFieldsY;
        companyLine.y = companyTitleText.y + companyTitleText.height + 5;
        companyText.y = companyLine.y + 10;

        // genre
        genreTitleText.y = companyText.y + companyText.height + spacingFieldsY;
        genreLine.y = genreTitleText.y + genreTitleText.height + 5;
        genreText.y = genreLine.y + 10;

        // release
        releaseTitleText.y = genreText.y + genreText.height + spacingFieldsY;
        releaseLine.y = releaseTitleText.y + releaseTitleText.height + 5;
        releaseText.y = releaseLine.y + 10;

        // version
        versionTitleText.y = releaseText.y + releaseText.height + spacingFieldsY;
        versionLine.y = versionTitleText.y + versionTitleText.height + 5;
        versionText.y = versionLine.y + 10;

        // preview image (keeps centered in the available space)
        if(previewImage != null)
        {
            var width:Float = descriptionBackground.x - (line.x + 35);
            previewImage.x = line.x + 35 + width / 2 - previewImage.width / 2;
        }

        // image dots
        if(previewImageDotsGrp != null)
        {
            previewImageDotsGrp.x = previewImage.x + previewImage.width / 2 - previewImageDotsGrp.width / 2;
            previewImageDotsGrp.y = previewImage.y + previewImage.height + 20;
        }

        // download progress
        var width:Float = descriptionBackground.x - (line.x + 35);

        downloadProgressText.x = line.x + 35 + width / 2 - downloadProgressText.width / 2;
        downloadProgressBar.x = line.x + 35 + width / 2 - downloadProgressBar.width / 2;
        downloadProgressBG.x = line.x + 35 + width / 2 - downloadProgressBG.width / 2;

        downloadProgressText.y = playButton.y + playButton.height + 70;
        downloadProgressBar.y = downloadProgressText.y + downloadProgressText.height + 20;
        downloadProgressBG.y = downloadProgressText.y - 25;
    }
}