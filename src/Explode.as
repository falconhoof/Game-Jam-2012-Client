package
{
	import org.flixel.*;
	
	public class Explode extends FlxSprite
	{
		[Embed(source="../assets/char_explode150.png")] protected var ImgExplode:Class;
		
		
		public function Explode(X:Number=0, Y:Number=0)
		{
			super(X, Y);
			loadGraphic(ImgExplode,true,true,150, 150);
			//this.alpha = 0.4;
			
			//bounding box tweaks
		//	width = 32;
		//	height = 128;
		//	offset.x = 1;
		//	offset.y = 1;
			
			//immovable = true;
			
			acceleration.y = 00;
			
			
			
			//animations
			addAnimation("grow", [0, 1, 2, 3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49], 24, false);	
			
			
			//add collisionalble canopy, add to groups in playState
			/*canopy =new FlxSprite(X+10,Y-5);
			canopy.width = 32;
			canopy.height = 5;
			canopy.immovable = true;
			(FlxG.state as PlayState).canopies.add(canopy);*/
			
		}
		
		public override function kill():void
		{
			//canopy.kill();
			super.kill();
		}
	}
}