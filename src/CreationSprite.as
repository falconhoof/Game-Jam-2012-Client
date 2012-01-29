package
{
	import org.flixel.*;
	
	public class CreationSprite extends FlxSprite
	{
		
		[Embed(source="../assets/Char_CreatePlatform.png")] protected var ImgCreate:Class;
		
		
		public function CreationSprite(X:Number=0, Y:Number=0, SimpleGraphic:Class=null)
		{
			super(X, Y);
			loadGraphic(ImgCreate,true,true,160, 128);
			addAnimation("create", [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14], 24, false);
			
		}
	}
}