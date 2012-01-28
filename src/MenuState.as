package
{
	import org.flixel.*;

	public class MenuState extends FlxState
	{
		[Embed(source="../assets/mainMenuBackground.png")] private static var ImgBackground:Class;
		
		override public function create():void
		{
			var background:FlxSprite=new FlxSprite(0,0,ImgBackground);
			add(background);
			
			var t:FlxText;
			t = new FlxText(0,FlxG.height/2-20,FlxG.width,"Rebirth");
			t.color=0xFF000000;
			t.size = 32;
			t.alignment = "center";
			add(t);
			t = new FlxText(FlxG.width/2-100,FlxG.height-30,200,"Press any Key");
			t.size = 16;
			t.alignment = "center";
			t.color=0xFF000000;
			add(t);
			
			FlxG.mouse.hide();
		}

		override public function update():void
		{
			super.update();

			if(FlxG.mouse.justPressed())
				FlxG.switchState(new PlayState());
			
			if (FlxG.keys.any() ) {
				FlxG.switchState(new PlayState());
				
			}
		}
	}
}
