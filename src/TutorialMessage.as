package
{
	import org.flixel.FlxSprite;
	
	public class TutorialMessage extends FlxSprite
	{
		[Embed(source="../assets/destroyMessage.png")] protected var ImgTut:Class;
		
		public function TutorialMessage(X:Number=0, Y:Number=0)
		{
			super(X, Y);
			loadGraphic(ImgTut,true,true,128,64);
		}
		
		public function load(X:Number=0, Y:Number=0,img:Class):void
		{
			TutorialMessage(x,y);
			loadGraphic(img,true,true,128,64);
		}
	}
}