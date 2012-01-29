package
{
	import org.flixel.*;
	
	public class SummaryState extends FlxState
	{
		[Embed(source="../assets/summaryBackground.png")] private static var ImgBackground:Class;
		
		private var currentLevel:Number=0;
		private var statsTracker : StatsTracker;
		
		public function SummaryState(levelIndex:Number, stats : StatsTracker):void
		{
				currentLevel=levelIndex;
				statsTracker = stats;
		}
		
		override public function create():void
		{
			var background:FlxSprite=new FlxSprite(0,0,ImgBackground);
			add(background);
			
			var t:FlxText;
			t = new FlxText(0,100,FlxG.width,"Summary");
			t.color=0xFF000000;
			t.size = 32;
			t.alignment = "center";
			add(t);
			t = new FlxText(400,200,400,"You completed the level using: ");
			t.size = 16;
			t.alignment = "left";
			t.color=0xFF000000;
			add(t);
			
			
			t = new FlxText(450,250,200, statsTracker.getValue("explosions") + " explosions");
			t.size = 16;
			t.alignment = "left";
			t.color=0xFF000000;
			add(t);
			
			t = new FlxText(450,290,200, statsTracker.getValue("trees") + " trees");
			t.size = 16;
			t.alignment = "left";
			t.color=0xFF000000;
			add(t);
			
			t = new FlxText(450,320,200, statsTracker.getValue("platforms") + " platforms");
			t.size = 16;
			t.alignment = "left";
			t.color=0xFF000000;
			add(t);
			
			t = new FlxText(450,360,200, statsTracker.getValue("spawn_points") + " spawn points");
			t.size = 16;
			t.alignment = "left";
			t.color=0xFF000000;
			add(t);
			
			var successString : String = "You failed to retrieve the soul gem";
			if ( statsTracker.getValue("pickups") > 0) {
				successString = "You retrieved the soul gem";
			}
			t = new FlxText(400,520,800, successString);
			t.size = 32;
			t.alignment = "left";
			t.color=0xFF000000;
			add(t);
			
			
			t = new FlxText(FlxG.width/2-100,600,200,"Press any Key");
			t.size = 16;
			t.alignment = "left";
			t.color=0xFF000000;
			add(t);
			
			FlxG.mouse.hide();
		}
		
		override public function update():void
		{
			super.update();
			
			if(FlxG.mouse.justPressed())
				FlxG.switchState(new PlayState(currentLevel));
			
			if (FlxG.keys.any() ) {
				FlxG.switchState(new PlayState(currentLevel));
				
			}
		}		
	}
}