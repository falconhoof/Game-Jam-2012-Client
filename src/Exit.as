package
{
	import org.flixel.FlxSprite;
	
	public class Exit extends FlxSprite
	{
		[Embed(source="../assets/main_ExitFlag.png")] private static var ImgExit:Class;
		
		function Exit(X:Number=0, Y:Number=0)
		{
			super(X,Y,null);
			loadGraphic(ImgExit,false,false,64,128);
		}
	}
}