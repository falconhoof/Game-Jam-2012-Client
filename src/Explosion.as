package
{
	import org.flixel.*;
	
	public class Explosion extends FlxSprite
	{
		public function Explosion(X:Number=0, Y:Number=0)
		{
			super(X, Y);
			//bounding box tweaks
			width = 150;
			height = 150;
			offset.x = 1;
			offset.y = 1;
		}
	}
}