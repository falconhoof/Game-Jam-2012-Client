package
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	
	public class TutorialMessage extends FlxSprite
	{
		[Embed(source="../assets/ui_TutorialBubble.png")] protected var ImgTut:Class;
		
		public function TutorialMessage(X:Number=0, Y:Number=0)
		{
			super(X, Y);
			//loadGraphic(ImgTut,false,false,256,256);	
		}
		
		public function loadMessageImage(img:Class,X:Number=0, Y:Number=0):void
		{
			loadGraphic(img,false,false,128,128);
		}
	}
}