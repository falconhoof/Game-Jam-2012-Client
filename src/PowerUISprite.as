package
{
	import org.flixel.FlxSprite;
	
	public class PowerUISprite extends FlxSprite
	{
		function PowerUISprite(X:Number=0,Y:Number=0)
		{
			super(X,Y);
			addAnimation("Play",[0,1,2,3],15,false);
			addAnimation("Idle",[3],15,false);
		}
		
		
		function Play():void
		{
			//15 FPS
			visible=true;
			play("Play");
		}
		
		function Stop():void
		{
			
		}
	}
}