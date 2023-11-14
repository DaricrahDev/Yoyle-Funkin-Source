package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxTiledSprite;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import sys.FileSystem;
import haxe.Json;
import haxe.format.JsonParser;
import sys.io.File;

typedef CreditFile =
{
	var credit:Array<Array<String>>;
}

class CreditsState extends MusicBeatState {
	public var credits:Array<CreditShit> = [];
	public var bg:FlxSprite;
	public var board:FlxSprite;
	private var theguysGrp:FlxTypedGroup<TheGuys>;
	private var thedescripGrp:FlxTypedGroup<TheWords>;
	private static var curSelected:Int = 0;
	var r_arrow:FlxSprite;
	var l_arrow:FlxSprite;
	public static var creditNamesList:CreditFile = getCreditFile("assets/data/credits.json");
	var epicCredits:Array<Array<String>>;

    override public function create() {
        super.create();
		
		epicCredits = creditNamesList.credit;

		bg = new FlxSprite().loadGraphic(Paths.image('creditbg', 'preload'));
		bg.antialiasing = true;
        
        add(bg);
		
		board = new FlxSprite().loadGraphic(Paths.image('creditboard', 'preload'));
		board.antialiasing = true;
        
        add(board);

		for (i in 0...epicCredits.length)
		{
			credits.push(new CreditShit(epicCredits[i][0])); 
		}
		
		theguysGrp = new FlxTypedGroup<TheGuys>();
		add(theguysGrp);
		thedescripGrp = new FlxTypedGroup<TheWords>();
		add(thedescripGrp);
		
		for (i in 0...credits.length)
		{
			var theiconthing:TheGuys = new TheGuys(i*700, 0);
			var credittexx:TheWords = new TheWords();
			var foundfile:String = "";
			foundfile = credits[i].char;
			if (!Paths.fileExists('images/CreditChars/' + foundfile + '.png', IMAGE)) foundfile = 'unknown';
			
			theiconthing.loadGraphic(Paths.image('CreditChars/' + foundfile, 'preload'));
			credittexx.loadGraphic(Paths.image('CreditNames/' + foundfile, 'preload'));
			theiconthing.TargetX = i - 500;
			theguysGrp.add(theiconthing);
			theiconthing.scale.set(1, 1);
			theiconthing.antialiasing = true;
			credittexx.screenCenter(Y);
			credittexx.sprTracker = theiconthing;
			thedescripGrp.add(credittexx);
		}
		changeSelection();
		
		r_arrow = new FlxSprite(1125, 335);
		r_arrow.frames = Paths.getSparrowAtlas('arrows', 'preload');
		r_arrow.animation.addByPrefix('normal', 'normal', 12, true);
		r_arrow.animation.addByPrefix('press', 'press', 16, false);
		r_arrow.setGraphicSize(Std.int(r_arrow.width * 1));
		r_arrow.alpha = 0.6;
		r_arrow.updateHitbox();
		r_arrow.antialiasing = true;
		r_arrow.animation.play('normal', true);
		add(r_arrow);

		l_arrow = new FlxSprite(25, 330);
		l_arrow.frames = Paths.getSparrowAtlas('arrows', 'preload');
		l_arrow.animation.addByPrefix('normal', 'normal', 12, true);
		l_arrow.animation.addByPrefix('press', 'press', 16, false);
		l_arrow.setGraphicSize(Std.int(l_arrow.width * 1));
		l_arrow.alpha = 0.6;
		l_arrow.flipX = true;
		l_arrow.updateHitbox();
		l_arrow.antialiasing = true;
		l_arrow.animation.play('normal', true);
		add(l_arrow);
    }
	
	var holdTime:Float = 0;
    override public function update(elapsed:Float) {
        super.update(elapsed);
		
		if(credits.length > 1)
		{
			if (controls.UI_LEFT_P)
			{
				changeSelection(-1);
				l_arrow.animation.play('press', false);
				l_arrow.animation.finishCallback = function (name:String) {
					l_arrow.animation.play('normal', true);
				};
				holdTime = 0;
			}
			if (controls.UI_RIGHT_P)
			{
				changeSelection(1);
				r_arrow.animation.play('press', false);
				r_arrow.animation.finishCallback = function (name:String) {
					r_arrow.animation.play('normal', true);
				};
				holdTime = 0;
			}
			if(controls.UI_LEFT_P || controls.UI_RIGHT_P)
			{
				var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
				holdTime += elapsed;
				var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

				if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
				{
					changeSelection((checkNewHold - checkLastHold));
				}
			}
			
		}
		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}
    }
	function changeSelection(change:Int = 0, playSound:Bool = true)
	{
		if(playSound) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = credits.length - 1;
		if (curSelected >= credits.length)
			curSelected = 0;
		var i = 0;
		for(item in theguysGrp.members) {
			item.TargetX = i - curSelected;
			i++;
		}
	}
	private static function getCreditFile(path:String):CreditFile {
		var rawJson:String = null;
		#if MODS_ALLOWED
		if(FileSystem.exists(path)) {
			rawJson = File.getContent(path);
		}
		#else
		if(OpenFlAssets.exists(path)) {
			rawJson = Assets.getText(path);
		}
		#end

		if(rawJson != null && rawJson.length > 0) {
			return cast Json.parse(rawJson);
		}
		return null;
	}
}

class CreditShit
{
	public var char:String = ""; // Character Name

	public function new(acter:String)
	{
		this.char = acter;
	}
}

class TheGuys extends FlxSprite
{

    public var TargetX:Int;

    public function new(?X:Float = 0, ?Y:Float = 0)
        {
            super(X, Y);
        }


    override function update(elapsed:Float) {
            x = FlxMath.lerp(x, (FlxMath.remapToRange(TargetX, 0, 1, 0, 1.3) * 1280), CoolUtil.boundTo(elapsed * 1, 1, 1));
            super.update(elapsed);
        } 

}

class TheWords extends FlxSprite
{
	public var sprTracker:FlxSprite;
	
	public function new()
	{
		super(0, 0);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (sprTracker != null)
			setPosition(sprTracker.x, this.y);
	}
}