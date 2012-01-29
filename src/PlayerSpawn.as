package
{
	import org.flixel.*;
	
	public class PlayerSpawn extends FlxSprite
	{
		
		[Embed(source="../assets/char_SpawnIN.png")] protected var ImgSpawn:Class;
		
		
		public function PlayerSpawn(X:Number=0, Y:Number=0)
		{
			super(X, Y);
			loadGraphic(ImgSpawn,true,true,128, 128);
			addAnimation("spawn", [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,30,31], 18);
		}
	}
}