package
{
	import org.flixel.FlxSprite;
	
	public class Pickup extends FlxSprite
	{
		[Embed(source="../assets/pickUp.png")] protected var ImgPickup:Class;
		
		function Pickup(X:Number,Y:Number)
		{
			super(X,Y);
			loadGraphic(ImgPickup,true,true,16,16);
			addAnimation("pickup", [0,1,2,3,2,1], 24);
			play("pickup");
		}
	}
}