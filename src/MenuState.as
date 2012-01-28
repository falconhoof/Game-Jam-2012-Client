package
{
	import org.flixel.*;

	public class MenuState extends FlxState
	{
		override public function create():void
		{
			var t:FlxText;
			t = new FlxText(0,FlxG.height/2-20,FlxG.width,"Tilemap Demo");
			t.size = 32;
			t.alignment = "center";
			add(t);
			t = new FlxText(FlxG.width/2-100,FlxG.height-30,200,"Press any Key");
			t.size = 16;
			t.alignment = "center";
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
