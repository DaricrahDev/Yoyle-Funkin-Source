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

typedef BioFile =
{
	var lore:Array<Array<String>>;
}

class CreditsState extends MusicBeatState {
	public var lores:Array<LoreShit> = [];
	public var bg:FlxSprite;
	public var board:FlxSprite;
	private var theguysGrp:FlxTypedGroup<TheGuys>;
	private var thedescripGrp:FlxTypedGroup<TheWords>;
	private static var curSelected:Int = 0;
	var r_arrow:FlxSprite;
	var l_arrow:FlxSprite;
	public static var loreLoresList:BioFile = getLoreFile("assets/data/credits.json");
	var epicLores:Array<Array<String>>;

    override public function create() {
        super.create();
		
		epicLores = loreLoresList.lore;

		bg = new FlxSprite().loadGraphic(Paths.image('creditbg', 'preload'));
		bg.antialiasing = true;
        
        add(bg);
		
		board = new FlxSprite().loadGraphic(Paths.image('creditboard', 'preload'));
		board.antialiasing = true;
        
        add(board);
		
		/*lores.push(new LoreShit("Zyro", "Zyro is the leader of the Blue Circles. He controls the first level of the castle.\n\nZyro is similar in personality to a Saturday morning cartoon villain. He's always plotting schemes to get rid of his enemies, most of which don't work. He's prone to getting irrationally upset over it.\n\nTowards his friends, he's very passionate and is great to hang out with! Theres no situation he cant make a little more lighthearted. In some ways, he's immature, always pointing out things that interest him and talking about them endlessly. It can be overbearing, but easy to get used to.", "Jannicide"));
		lores.push(new LoreShit("Rasher", "Rasher is the leader of the Purple Circles. He controls the second level of the castle.\n\nRasher is agressive and impulsive, and not afraid to speak his mind. He lets his emotions get the better of him much too often. Towards his enemies, hes an unstoppable force. Its best to keep out of his way.\n\nTowards his friends, he makes an effort to be friendlier. Eventually you'll come to find that he's a great listener and consoler! Just... dont play any card games with him or it'll end with the table flipped upside down.", "Jannicide"));
		lores.push(new LoreShit("Cilus", "Cilus is the leader of the Green Circles. He controls the third level of the castle.\n\nCilus is such a sweetheart! He loves talking to others. Although he can be melancholy at times, he always finds ways to have fun.\n\nTowards his friends, he'll do anything in his power to make them happy. He'll give them small things like candy, origami crafts, or a cool fun fact!", "Jannicide"));
		lores.push(new LoreShit("Lex", "Lex is the leader of the Red Circles. He controls the fourth level of the castle.\n\nLex is the definition of cold, but not cruel. He's silent, and only talks when it means something. Towards his enemies, he almost always succeeds in ridding of them due to his advanced strategic skills.\n\nTowards his friends, he still keeps his quiet nature, but is a lot less intimidating. He takes notes of what they like and orients his demeanor and conversation topics towards it. He becomes... almost selfless!", "Jannicide"));
		lores.push(new LoreShit("Iyak", "Iyak is the leader of the Gray Circles, but can command any other circles if needed. He controls the fifth level of the castle.\n\nIyak tries his best to be intimidating, but ends up looking goofy most of the time. His enemies would think otherwise, though.. He doesn't treat them too well.\n\nTowards his friends, he leans fully into his goofy side and becomes much like Zyro, but with more self control. He can be quite the teaser though, so beware of that!", "Jannicide"));
		lores.push(new LoreShit("Bruce", "Bruce is the main leader of the Cubes. He's part of a royal ''family'' who all have power over their kingdom.\n\nBruce is quite sarcastic. He's quick to point out when someone is doing something wrong. He's not very attentive to stranger's emotions, which is something he's trying to work on. Towards his enemies, he cranks these traits up by 300%.\n\nTowards his friends, he's a lot more attentive to them, but still occasionally throws out a playful insult. He'll always be there to give you a firm pat on the back or a quick pep talk.", "Jannicide"));*/

		for (i in 0...epicLores.length)
		{
			lores.push(new LoreShit(epicLores[i][0])); 
		}
		
		theguysGrp = new FlxTypedGroup<TheGuys>();
		add(theguysGrp);
		thedescripGrp = new FlxTypedGroup<TheWords>();
		add(thedescripGrp);
		
		for (i in 0...lores.length)
		{
			var theiconthing:TheGuys = new TheGuys(i*700, 0);
			var loretexx:TheWords = new TheWords();
			var foundfile:String = "";
			foundfile = lores[i].char;
			if (!Paths.fileExists('images/CreditChars/' + foundfile + '.png', IMAGE)) foundfile = 'unknown';
			
			theiconthing.loadGraphic(Paths.image('CreditChars/' + foundfile, 'preload'));
			loretexx.loadGraphic(Paths.image('CreditNames/' + foundfile, 'preload'));
			theiconthing.TargetX = i - 500;
			theguysGrp.add(theiconthing);
			theiconthing.scale.set(1, 1);
			theiconthing.antialiasing = true;
			loretexx.screenCenter(Y);
			loretexx.sprTracker = theiconthing;
			thedescripGrp.add(loretexx);
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
		
		if(lores.length > 1)
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
			curSelected = lores.length - 1;
		if (curSelected >= lores.length)
			curSelected = 0;
		var i = 0;
		for(item in theguysGrp.members) {
			item.TargetX = i - curSelected;
			i++;
		}
	}
	private static function getLoreFile(path:String):BioFile {
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

class LoreShit
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