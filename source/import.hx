package source;

import backend.State;
import backend.Substate;
import backend.Paths;
import backend.GameGrid;

import ui.header.Header;
import ui.header.UserAccountUI;
import ui.footer.Footer;
import ui.games.Grid;

import ui.contracts.IClickable;

import menus.MainState;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.math.FlxMath;
import flixel.FlxCamera;

import openfl.display.Sprite;
import openfl.ui.Mouse;

using StringTools;