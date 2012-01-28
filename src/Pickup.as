package
{
	import org.flixel.FlxSprite;
	
	public class Pickup extends FlxSprite
	{
		[Embed(source="../assets/pickUp.png")] protected var ImgSpaceman:Class;
		
		function Pickup(X:Number,Y:Number)
		{
			super(X,Y);
		}
	}
}